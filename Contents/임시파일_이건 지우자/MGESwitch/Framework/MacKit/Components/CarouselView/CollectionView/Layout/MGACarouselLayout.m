//
//  MGACarouselLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGACarouselLayout.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"
#import "NSScrollView+Extension.h"

@interface MGACarouselLayout ()
@property (nonatomic, assign, readonly) MGACarouselScrollDirection carouselScrollDirection; // @dynamic
@property (nonatomic, assign) CGSize scrollViewSize; // 디폴트 CGSizeZero 액자의 크기
@property (nonatomic, assign) NSInteger numberOfSections; // 디폴트 1
@property (nonatomic, assign) NSInteger numberOfItems; // 디폴트 0
@property (nonatomic, assign) CGFloat actualInteritemSpacing; // 디폴트 0.0
@property (nonatomic, assign) CGSize actualItemSize; // 디폴트 CGSizeZero
@property (nonatomic, strong, nullable, readonly) MGACarouselView *carouselView; // @dynamic

//! insert, delete, move, reload 애니메이션에서 엄한 애니메이션이 같이 실행되므로 적절하게 고르기 위해 만들었다.
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*deleteIndexPaths;
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*insertIndexPaths;
@end

@implementation MGACarouselLayout
@dynamic carouselView;
@dynamic carouselScrollDirection;

+ (Class)layoutAttributesClass {
    return [MGACarouselCellLayoutAttributes class];
}


#pragma mark - 여기서 부터는 instance 메서드
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                  object:nil];
}

//! Getting the Collection View Information
// - (NSCollectionView *)collectionView {}

- (NSSize)collectionViewContentSize {
    return self.contentSize; // NSScrollView의 contenSize와는 다르다
}

- (void)prepareLayout {
    if (self.collectionView == nil || self.carouselView == nil) {
        return;
    }
    
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    if (self.needsReprepare == NO && CGSizeEqualToSize(self.scrollViewSize, scrollView.frame.size)) {
        return;
    }
    
    self.needsReprepare = NO;
    self.scrollViewSize = scrollView.frame.size;

    // Calculate basic parameters/variables
    NSCollectionViewDiffableDataSource *dataSource = self.collectionView.dataSource;
    NSDiffableDataSourceSnapshot *snapshot = dataSource.snapshot;
    self.numberOfSections = snapshot.numberOfSections;
    self.numberOfItems = (snapshot.numberOfSections == 0)? 0 : (snapshot.numberOfItems / snapshot.numberOfSections);
    
    CGSize size = self.carouselView.itemSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        self.actualItemSize = scrollView.frame.size;
    } else {
        self.actualItemSize = size;
    }
    
    if (self.carouselView.transformer != nil) {
        self.actualInteritemSpacing = [self.carouselView.transformer proposedInteritemSpacing];
    } else {
        self.actualInteritemSpacing = self.carouselView.interitemSpacing;
    }
    
    self.leadingSpacing = (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) ?
    (scrollView.frame.size.width - self.actualItemSize.width) * 0.5 :
    (scrollView.frame.size.height - self.actualItemSize.height) * 0.5;
    
    self.itemSpacing =
    (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal ? self.actualItemSize.width : self.actualItemSize.height)
    +
    self.actualInteritemSpacing;

    // contentSize 계산 및 캐시하여, 매번 계산하지 않게한다.
    NSInteger numberOfItems = self.numberOfItems * self.numberOfSections;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        CGFloat contentSizeWidth = self.leadingSpacing * 2; // Leading & trailing spacing
        contentSizeWidth += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeWidth += numberOfItems * self.actualItemSize.width; // Item sizes
        self.contentSize = CGSizeMake(contentSizeWidth, scrollView.frame.size.height);
    } else {
        CGFloat contentSizeHeight = self.leadingSpacing * 2; // Leading & trailing spacing
        contentSizeHeight += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeHeight += numberOfItems * self.actualItemSize.height; // Item sizes
        self.contentSize = CGSizeMake(scrollView.frame.size.width, contentSizeHeight);
    }
    
    [self adjustCollectionViewBounds];
}

- (NSArray <__kindof NSCollectionViewLayoutAttributes *>*)layoutAttributesForElementsInRect:(NSRect)rect {
    NSMutableArray <NSCollectionViewLayoutAttributes *>*layoutAttributes = [NSMutableArray array];
    if (self.itemSpacing <= 0 || self.numberOfItems < 1 || CGRectIsEmpty(rect) || rect.size.width < 0.0 || rect.size.height < 0.0) { // 음수가 들어올 수 있다.
        return layoutAttributes;
    }
    
    //! eyePosition 에 따라 더 많은 아이템이 보여질 수 있으므로, rect를 크게 잡는다.
    if (self.carouselView.transformer.type == MGACarouselTransformerTypeLockWoodSpecial) {
        CGFloat percent = 1.0 / self.carouselView.transformer.minimumScale;
        rect = MGERectPercent(rect, percent, percent);
    }

    CGRect rectN = CGRectIntersection(rect, (CGRect){CGPointZero, self.contentSize});
    if (CGRectIsEmpty(rectN)) {
        return layoutAttributes;
    }

    // 특정 rect의 start position 및 index 계산
    NSInteger numberOfItemsBefore = (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) ?
    MAX((NSInteger)((CGRectGetMinX(rectN) - self.leadingSpacing) / self.itemSpacing) , 0) :
    MAX((NSInteger)((CGRectGetMinY(rectN) - self.leadingSpacing) / self.itemSpacing) , 0);
    
    CGFloat startPosition = self.leadingSpacing + (numberOfItemsBefore * self.itemSpacing);
    NSInteger startIndex = numberOfItemsBefore;
    
    // layout attributes 생성
    NSInteger itemIndex = startIndex; // 모든 섹션을 다 합쳐서 섹션이 1개라고 했을 때의 인덱스가 됨.
    CGFloat origin = startPosition;
    
    CGFloat maxPosition = (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) ?
    MIN(CGRectGetMaxX(rectN), self.contentSize.width - self.actualItemSize.width - self.leadingSpacing) :
    MIN(CGRectGetMaxY(rectN), self.contentSize.height - self.actualItemSize.height - self.leadingSpacing);
    
    // NSLog(@"maxPosition %f", maxPosition); // 1469.500000
    
    // https://stackoverflow.com/a/10335601/2398107
    // 위키 : Api:C/Types/Numeric limits    Project:Swift/숫자 관련
    // origin이 maxPosition을 초과할 때까지 반복한다.
    // while ( origin - maxPosition <= FLT_EPSILON ) { ... } 으로 해도 무방할 듯. 해보니 무방하다.
    
    while ( origin - maxPosition <= MAX(100.0 * DBL_EPSILON * ABS(origin + maxPosition), DBL_TRUE_MIN) ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex % self.numberOfItems
                                                     inSection:itemIndex / self.numberOfItems]; // 정확한 인덱스 찾기.
        if (self.carouselView.volumeType != MGACarouselVolumeTypeInfinite && indexPath.section > 0) { // 유한인데, 섹션을 초과하면 그만 둬야한다.
            break;
        }
        
        MGACarouselCellLayoutAttributes *attributes =
        (MGACarouselCellLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath]; // frame만 설정함.
        if ([attributes isVisibleOnCollectionView:self.collectionView] == YES &&
            attributes.alpha > 0.0) {
            [layoutAttributes addObject:attributes];
        }
        
        // wrap 처리보자.
        if (self.carouselView.volumeType == MGACarouselVolumeTypeFiniteWrap) {
            if (indexPath.item == 0) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGACarouselCellLayoutAttributes *attributes =
                (MGACarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:NSCollectionElementKindSectionHeader
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
            if (indexPath.item == self.numberOfItems - 1) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGACarouselCellLayoutAttributes *attributes =
                (MGACarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:NSCollectionElementKindSectionFooter
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
        
        itemIndex = itemIndex + 1;
        origin = origin + self.itemSpacing;
    }
    
    //! wrap 이 아닌. 또다른 Supplementary View가 존재한다면, 처리하자.
    MGACarouselDiffableDataSource *dataSource = self.collectionView.dataSource;
    if ([dataSource isKindOfClass:[MGACarouselDiffableDataSource class]] == NO) {
        NSCAssert(FALSE, @"MGACarouselDiffableDataSource 객체가 아니다.");
    } else if (dataSource.elementOfKinds != nil && dataSource.elementOfKinds.count > 0) {
        NSInteger firstSection = [layoutAttributes firstObject].indexPath.section;
        NSInteger lastSection = 0;
        if (self.carouselView.volumeType != MGACarouselVolumeTypeFiniteWrap) {
            lastSection = [layoutAttributes lastObject].indexPath.section;
        } else {
            lastSection = layoutAttributes[(layoutAttributes.count - 1) - 2].indexPath.section;
        }
        
        for (NSInteger section = firstSection; section <= lastSection; section++) {
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:section];
            for (NSString *elementOfKind in dataSource.elementOfKinds) {
                MGACarouselCellLayoutAttributes *attributes =
                (MGACarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementOfKind
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
    }

    return layoutAttributes;

}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGACarouselCellLayoutAttributes *attributes = [MGACarouselCellLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
    attributes.indexPath = indexPath;
    CGRect frame = [self frameForItemAtIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.mgrCenter = center;
    attributes.size = self.actualItemSize;  // 즉, 여기까지는 프레임 설정.
    [self applyTransformTo:attributes with:self.carouselView.transformer]; // transformer nil이면 그냥 나온다.
    return attributes;
}


- (NSCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    
    MGACarouselCellLayoutAttributes *attributes = [MGACarouselCellLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                                                withIndexPath:indexPath];
    attributes.indexPath = indexPath; // 이거 의미가 없는 것 같다.
    CGRect frame = [self frameForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.mgrCenter = center;
    attributes.size = self.actualItemSize;  // 즉, 여기까지는 프레임 설정.
    [self applyTransformTo:attributes with:self.carouselView.transformer]; // transformer nil이면 그냥 나온다.
    return attributes;
    //
//    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
    
}

/**
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind
                                                                  atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:PagingIndicatorKind] == YES) {
        return self.indicatorLayoutAttributes;
    } else if ([elementKind isEqualToString:PagingBorderKind] == YES) {
        return self.borderLayoutAttributes;
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}
*/

//! insert, delete, move 들어옴. 또한 이 프로젝트에서는 회전 및 다른 type으로 변경 시에도 들어온다.
- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset {
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        if (self.collectionViewContentSize.width <= scrollView.bounds.size.width) {
            return CGPointMake(0.0, proposedContentOffset.y);
        }
    } else {
        if (self.collectionViewContentSize.height <= scrollView.bounds.size.height) {
            return CGPointMake(proposedContentOffset.x, 0.0);
        }
    }
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset]; // 반환값은 proposedContentOffset이다.
    //
    // 아이템이 두 개 남았을 때, 제일 마지막으로 옮겨진 상태에서 마지막을 지우면 약간 끊기는 문제가 발생한다. 이를 해결하기 위한 코드이다.
    // https://stackoverflow.com/questions/20948356/animating-contentoffset-changes-in-a-uicollectionview-on-deleteitemsatindexpaths
    // coverflow에서 테스트 해보면 바로 알 수 있다.
    // Apple 버그 인 것으로 사료된다.
}

- (NSPoint)targetContentOffsetForProposedContentOffset:(NSPoint)proposedContentOffset
                                 withScrollingVelocity:(NSPoint)velocity {
    if (self.collectionView == nil || self.carouselView == nil) {
        return proposedContentOffset;
    }
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    CGFloat proposedContentOffsetX;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionVertical) {
        proposedContentOffsetX = proposedContentOffset.x;
    } else {
        CGFloat boundedOffset = scrollView.mgrContentSize.width - scrollView.frame.size.width;
        proposedContentOffsetX = [self calculateTargetOffsetBy:proposedContentOffset.x
                                                 boundedOffset:boundedOffset
                                         withScrollingVelocity:velocity.x];
    }

    CGFloat proposedContentOffsetY;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        proposedContentOffsetY = proposedContentOffset.y;
    } else {
        CGFloat boundedOffset = scrollView.mgrContentSize.height - scrollView.frame.size.height;
        proposedContentOffsetY = [self calculateTargetOffsetBy:proposedContentOffset.y
                                                 boundedOffset:boundedOffset
                                         withScrollingVelocity:velocity.y];
    }
    return CGPointMake(proposedContentOffsetX, proposedContentOffsetY);
}

//! Responding to Collection View Updates
// - (NSArray<NSIndexPath *> *)indexPathsToInsertForSupplementaryViewOfKind:(NSString *)elementKind {}
// - (NSArray<NSIndexPath *> *)indexPathsToInsertForDecorationViewOfKind:(NSString *)elementKind {}
// - (NSArray<NSIndexPath *> *)indexPathsToDeleteForSupplementaryViewOfKind:(NSString *)elementKind {}
// - (NSArray<NSIndexPath *> *)indexPathsToDeleteForDecorationViewOfKind:(NSString *)elementKind {}
// - (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position {}

// https://www.objc.io/issues/12-animations/collectionview-animations/
- (void)prepareForCollectionViewUpdates:(NSArray<NSCollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
//    self.moveIndexPaths = [NSMutableArray array];
    for (NSCollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == NSCollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        } else if (update.updateAction == NSCollectionUpdateActionInsert) {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        } else if (update.updateAction == NSCollectionUpdateActionMove) {
//             [self.moveIndexPaths addObject:update.indexPathBeforeUpdate];
//             [self.moveIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
//
//    typedef NS_ENUM(NSInteger, NSCollectionUpdateAction) {
//        NSCollectionUpdateActionInsert,
//        NSCollectionUpdateActionDelete,
//        NSCollectionUpdateActionReload,
//        NSCollectionUpdateActionMove,
//        NSCollectionUpdateActionNone
//    };
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
//    self.moveIndexPaths = nil;
}

- (NSCollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if (self.deleteIndexPaths == nil || self.insertIndexPaths == nil) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([self.collectionView.indexPathsForVisibleItems containsObject:itemIndexPath] == YES) {
            return [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath]; // 회전시 반드시 필요하다.
        }
    }

    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

- (NSCollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                                                                        atIndexPath:(NSIndexPath *)elementIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSSet <NSIndexPath *>*indexPathsToInsert = [self indexPathsToInsertForSupplementaryViewOfKind:elementKind];
    NSSet <NSIndexPath *>*indexPathsToDelete = [self indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([[self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind] containsObject:elementIndexPath] == YES) {
            return [self.collectionView layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (NSCollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSCollectionViewDecorationElementKind)elementKind
                                                                                     atIndexPath:(NSIndexPath *)decorationIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSSet <NSIndexPath *>*indexPathsToInsert = [self indexPathsToInsertForDecorationViewOfKind:elementKind];
    NSSet <NSIndexPath *>*indexPathsToDelete = [self indexPathsToDeleteForDecorationViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        return [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath]; // 회전시 반드시 필요하다.
    }
    return [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if (self.deleteIndexPaths == nil || self.insertIndexPaths == nil) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([self.collectionView.indexPathsForVisibleItems containsObject:itemIndexPath] == YES) {
            return [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

//! 위와 같이 self.deleteIndexPaths, self.insertIndexPaths를 잡아야하는지는 모르겠다.
- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSSet <NSIndexPath *>*indexPathsToInsert = [self indexPathsToInsertForSupplementaryViewOfKind:elementKind];
    NSSet <NSIndexPath *>*indexPathsToDelete = [self indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if (elementKind != nil &&
            [[self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind] containsObject:elementIndexPath] == YES) {
            return [self.collectionView layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (NSCollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSCollectionViewDecorationElementKind)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSSet <NSIndexPath *>*indexPathsToInsert = [self indexPathsToInsertForDecorationViewOfKind:elementKind];
    NSSet <NSIndexPath *>*indexPathsToDelete = [self indexPathsToDeleteForDecorationViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        return [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath]; // 회전시 반드시 필요하다.
    }
    return [super finalLayoutAttributesForDisappearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

//! Invalidating the Layout
// - (void)invalidateLayout {}
// - (void)invalidateLayoutWithContext:(NSCollectionViewLayoutInvalidationContext *)context {}
// + (Class)invalidationContextClass {}
// - (NSCollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(NSRect)newBounds {}
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(NSCollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(NSCollectionViewLayoutAttributes *)originalAttributes {}
// - (NSCollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(NSCollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(NSCollectionViewLayoutAttributes *)originalAttributes {}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds {
    return YES;
}

//! Coordinating Animated Changes
// - (void)prepareForAnimatedBoundsChange:(NSRect)oldBounds {}
// - (void)finalizeAnimatedBoundsChange {}

//! Transitioning Between Layouts
// - (void)prepareForTransitionFromLayout:(NSCollectionViewLayout *)oldLayout {}
// - (void)prepareForTransitionToLayout:(NSCollectionViewLayout *)newLayout {}
// - (void)finalizeLayoutTransition {}

//! Registering Decoration Views
// - (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind {}
// - (void)registerNib:(NSNib *)nib forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind {}


#pragma mark - 생성 & 소멸
static void CommonInit(MGACarouselLayout *self) {
    self->_contentSize = CGSizeZero;
    self->_leadingSpacing = 0.0f;
    self->_itemSpacing = 0.0f;
    self->_needsReprepare = YES;
    self->_scrollViewSize = CGSizeZero;
    self->_numberOfSections = 1;
    self->_numberOfItems = 0;
    self->_actualInteritemSpacing = 0.0f;
    self->_actualItemSize = CGSizeZero;
    //! FIXME: ~~~~
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deviceOrientationDidChange:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
}


#pragma mark - 세터 & 게터
- (MGACarouselView *)carouselView {
    return (MGACarouselView *)self.collectionView.enclosingScrollView.superview.superview;
}

- (MGACarouselScrollDirection)carouselScrollDirection {
    return self.carouselView.scrollDirection;
}

// https://stackoverflow.com/questions/38016263/nscollectionview-custom-layout-enable-scrolling
// #1  0x000000019be21a04 in -[NSCollectionView _resizeToFitContentAndClipView] ()
// Private으로 이것을 호출하므로 이렇게 해야한다.
- (NSCollectionViewScrollDirection)scrollDirection {
    if (self.carouselView.scrollDirection == MGACarouselScrollDirectionHorizontal) {
        return NSCollectionViewScrollDirectionHorizontal;
    } else {
        return NSCollectionViewScrollDirectionVertical;
    }
}


#pragma mark - 컨트롤
//! Public 컨트롤
- (CGPoint)contentOffsetFor:(NSIndexPath *)indexPath {
    CGPoint origin = [self frameForItemAtIndexPath:indexPath].origin;
    if (self.collectionView == nil) {
        return origin;
    }
    
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    
    CGFloat contentOffsetX = 0.0;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionVertical) {
    } else { // horizontal
        contentOffsetX = origin.x - (scrollView.frame.size.width * 0.5 - self.actualItemSize.width * 0.5);
    }
    
    CGFloat contentOffsetY = 0.0;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
    } else { // vertical
        contentOffsetY = origin.y - (scrollView.frame.size.height * 0.5 - self.actualItemSize.height * 0.5);
    }
    
    return CGPointMake(contentOffsetX, contentOffsetY);
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = self.numberOfItems * indexPath.section + indexPath.item;
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    CGFloat originX;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionVertical) {
        originX = (scrollView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        originX =  self.leadingSpacing + numberOfItems * self.itemSpacing;
    }
    
    CGFloat originY;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        originY = (scrollView.frame.size.height - self.actualItemSize.height) * 0.5;
    } else {
        originY = self.leadingSpacing + numberOfItems * self.itemSpacing;
    }
    
    CGPoint origin = CGPointMake(originX, originY);
    CGRect frame = (CGRect){origin, self.actualItemSize};
    return frame;
}

//! indexPath는 사실 의미가 없다. 유한 모드에서만 사용할 것이고 indexPath 0-0만 들어오기 때문이다.
- (CGRect)frameForSupplementaryViewOfKind:(NSString *)elementKind
                              atIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = self.numberOfItems * indexPath.section + indexPath.item; // 내 아이템 앞에 총 몇개가 존재하는가.
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    CGFloat originX;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionVertical) {
        originX = (scrollView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        if ([elementKind isEqualToString:NSCollectionElementKindSectionHeader]) {
            originX =  self.leadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:NSCollectionElementKindSectionFooter]) {
            originX =  self.leadingSpacing + numberOfItems * self.itemSpacing + (self.itemSpacing * self.numberOfItems);
        } else {
            //! 일반적인 경우는 그냥 첫 번째 아이템 위치를 준다.
            originX =  self.leadingSpacing + (numberOfItems * self.itemSpacing);
        }
    }
    
    CGFloat originY;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        originY = (scrollView.frame.size.height - self.actualItemSize.height) * 0.5;
    } else {
        if ([elementKind isEqualToString:NSCollectionElementKindSectionHeader]) {
            originY =  self.leadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:NSCollectionElementKindSectionFooter]) {
            originY =  self.leadingSpacing + numberOfItems * self.itemSpacing + (self.itemSpacing * self.numberOfItems);
        } else {
            //! 일반적인 경우는 그냥 첫 번째 아이템 위치를 준다.
            originY =  self.leadingSpacing + (numberOfItems * self.itemSpacing);
        }
    }
    
    CGPoint origin = CGPointMake(originX, originY);
    CGRect frame = (CGRect){origin, self.actualItemSize};
    return frame;
}

- (void)forceInvalidate {
    self.needsReprepare = YES;
    [self invalidateLayout];
}


//! Private 컨트롤
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    if (CGSizeEqualToSize(self.carouselView.itemSize, CGSizeZero)) {
        [self adjustCollectionViewBounds];
    }
}

- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes
                    with:(MGACarouselTransformer * _Nullable)transformer {
    if (self.collectionView == nil || transformer == nil) {
        attributes.dumyFrame = CGRectMake(0.0, 0.0, attributes.size.width, attributes.size.height);
        attributes.dumyTransform = CATransform3DIdentity;
        return;
    }
    
    NSClipView *clipView = self.collectionView.enclosingScrollView.contentView;
    if (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        CGFloat ruler = CGRectGetMidX(clipView.bounds);
        attributes.position = (attributes.mgrCenter.x - ruler) / self.itemSpacing; // 화면 중앙에서 어느 위치에 있느가를 의미함.
    } else { // vertical
        CGFloat ruler = CGRectGetMidY(clipView.bounds);
        attributes.position = (attributes.mgrCenter.y - ruler) / self.itemSpacing;
    }
    
    //! ordering을 위해 인덱싱한다. 가운데의 인덱스 번호가 self.numberOfItems 에 해당하는 번호를 갖는다. 오른쪽으로 갈수록 번호가 줄어든다.
    //! 즉 왼쪽과 오른쪽이 겹치면, 왼쪽이 보일 것이다. 그러나 zoomOut빼고는 모두 다시 설정한다. - applyTransformTo: 메서드에서
    attributes.zIndex = (NSInteger)(self.numberOfItems - attributes.position); // 양수는 버림, 음수는 올림이된다. 일반적으로 화면에는 양수만 등장
    
    [transformer applyTransformTo:attributes];
}

- (void)adjustCollectionViewBounds { // 무한일때 바운드를 바꾸는듯.
    if (self.collectionView == nil || self.carouselView == nil) {
        return;
    }
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    NSInteger currentIndex = self.carouselView.currentIndex;
    currentIndex = MIN(MAX(0, currentIndex), self.numberOfItems - 1); // currentIndex 삭제하면서 안맞을 수 있다.
    NSInteger inSection = (self.carouselView.volumeType == MGACarouselVolumeTypeInfinite)? self.numberOfSections / 2 : 0;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:inSection];
    CGPoint contentOffset = [self contentOffsetFor:newIndexPath];
    [scrollView setMgrContentOffset:contentOffset]; // bounds 설정으로 대신해서는 안된다.
    // https://stackoverflow.com/questions/5834056/how-i-set-the-default-position-of-a-nsscroll-view
}

- (CGFloat)calculateTargetOffsetBy:(CGFloat)proposedOffset
                     boundedOffset:(CGFloat)boundedOffset
             withScrollingVelocity:(CGFloat)velocity { // CGPoint 에서 CGFloat으로 바꿨다. 원본에서는 CGPoint의 .x만 사용했음.
    NSScrollView *scrollView = self.collectionView.enclosingScrollView;
    CGPoint scrollViewContentOffset = [scrollView mgrContentOffset];
    
    CGFloat targetOffset;
    if (self.carouselView.decelerationDistance == [MGACarouselView automaticDistance]) {
        if (ABS(velocity) >= 0.3) {
            CGFloat vector = (velocity >= 0) ? 1.0 : -1.0;
            targetOffset = round(proposedOffset/self.itemSpacing+0.35*vector) * self.itemSpacing; // Ceil by 0.15, rather than 0.5
        } else {
            targetOffset = round(proposedOffset/self.itemSpacing) * self.itemSpacing;
        }
    } else {
        NSUInteger extraDistance = MAX(self.carouselView.decelerationDistance - 1, 0);
        CGFloat contentOffset =
        (self.carouselScrollDirection == MGACarouselScrollDirectionHorizontal) ? scrollViewContentOffset.x : scrollViewContentOffset.y;
        
        if (velocity >= 0.3 && velocity <= DBL_MAX) {
            targetOffset = ceil(contentOffset / self.itemSpacing + extraDistance) * self.itemSpacing;
        } else if (velocity >= -DBL_MAX && velocity <= -0.3) {
            targetOffset = floor(contentOffset / self.itemSpacing - extraDistance) * self.itemSpacing;
        } else {
            targetOffset = round(proposedOffset / self.itemSpacing) * self.itemSpacing;
        }
    }
    return MIN(MAX(0.0, targetOffset), boundedOffset);
}

@end
