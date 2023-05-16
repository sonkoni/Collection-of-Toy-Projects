//
//  MGUCarouselLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUCarouselLayout.h"
#import "MGUCarouselCellLayoutAttributes.h"
#import "MGUCarouselSupplementaryViewLayoutAttributes.h" // 사용하지 않을 것이다.
#import "MGUCarouselDecorationViewLayoutAttributes.h" // 사용하지 않을 것이다.
#import "MGUCarouselDiffableDataSource.h"

@interface MGUCarouselLayout ()

@property (nonatomic, assign) CGSize collectionViewSize; // 디폴트 CGSizeZero
@property (nonatomic, assign) NSInteger numberOfSections; // 디폴트 1
@property (nonatomic, assign) NSInteger numberOfItems; // 디폴트 0
@property (nonatomic, assign) CGFloat actualInteritemSpacing; // 디폴트 0.0
@property (nonatomic, assign) CGSize actualItemSize; // 디폴트 CGSizeZero
@property (nonatomic, strong, nullable, readonly) MGUCarouselView *carouselView; // self.collectionView.superview.superview @dynamic

//! insert, delete, move, reload 애니메이션에서 엄한 애니메이션이 같이 실행되므로 적절하게 고르기 위해 만들었다.
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*deleteIndexPaths;
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*insertIndexPaths;
@end

@implementation MGUCarouselLayout
@dynamic carouselView;

+ (Class)layoutAttributesClass {
    return [MGUCarouselCellLayoutAttributes class];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

//! Getting the Collection View Information
// - (UICollectionView *)collectionView {}
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (void)prepareLayout {
    if (self.collectionView == nil || self.carouselView == nil) {
        return;
    }
    
    if (self.needsReprepare == NO && CGSizeEqualToSize(self.collectionViewSize, self.collectionView.frame.size)) {
        return;
    }
    
    self.needsReprepare = NO;
    self.collectionViewSize = self.collectionView.frame.size;

    // Calculate basic parameters/variables
    MGUCarouselDiffableDataSource *dataSource = self.collectionView.dataSource;
    NSDiffableDataSourceSnapshot *snapshot = dataSource.snapshot;
    self.numberOfSections = snapshot.numberOfSections;
    self.numberOfItems = (snapshot.numberOfSections == 0)? 0 : (snapshot.numberOfItems / snapshot.numberOfSections);
//    self.numberOfSections = [self.carouselView numberOfSectionsInCollectionView:self.collectionView];
//    self.numberOfItems = [self.carouselView collectionView:self.collectionView numberOfItemsInSection:0];
    
    
    CGSize size = self.carouselView.itemSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        self.actualItemSize = self.collectionView.frame.size;
    } else {
        self.actualItemSize = size;
    }
    
    if (self.carouselView.transformer != nil) {
        self.actualInteritemSpacing = [self.carouselView.transformer proposedInteritemSpacing];
        // 아래 셋은 self.carouselView.interitemSpacing과 동일하다.
        // MGUCarouselTransformerTypeCrossFading
        // MGUCarouselTransformerTypeZoomOut
        // MGUCarouselTransformerTypeDepth
    } else {
        self.actualInteritemSpacing = self.carouselView.interitemSpacing;
    }
    
    self.scrollDirection = self.carouselView.scrollDirection;
    
    self.leadingSpacing = (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) ?
    (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5 :
    (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;
    
    self.itemSpacing =
    (self.scrollDirection == MGUCarouselScrollDirectionHorizontal ? self.actualItemSize.width : self.actualItemSize.height)
    +
    self.actualInteritemSpacing;

    // contentSize 계산 및 캐시하여, 매번 계산하지 않게한다.
    NSInteger numberOfItems = self.numberOfItems * self.numberOfSections;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        CGFloat contentSizeWidth = self.leadingSpacing * 2; // Leading & trailing spacing
        contentSizeWidth += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeWidth += numberOfItems * self.actualItemSize.width; // Item sizes
        self.contentSize = CGSizeMake(contentSizeWidth, self.collectionView.frame.size.height);
    } else {
        CGFloat contentSizeHeight = self.leadingSpacing * 2; // Leading & trailing spacing
        contentSizeHeight += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeHeight += numberOfItems * self.actualItemSize.height; // Item sizes
        self.contentSize = CGSizeMake(self.collectionView.frame.size.width, contentSizeHeight);
    }
    
    [self adjustCollectionViewBounds];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *>*layoutAttributes = [NSMutableArray array];
    
    if (self.itemSpacing <= 0 || self.numberOfItems < 1 || CGRectIsEmpty(rect) || rect.size.width < 0.0 || rect.size.height < 0.0) { // 음수가 들어올 수 있다.
        return layoutAttributes;
    }
    
    //! eyePosition 에 따라 더 많은 아이템이 보여질 수 있으므로, rect를 크게 잡는다.
    if (self.carouselView.transformer.type == MGUCarouselTransformerTypeLockWoodSpecial) {
        CGFloat percent = 1.0 / self.carouselView.transformer.minimumScale;
        rect = MGERectPercent(rect, percent, percent);
    }

    CGRect rectN = CGRectIntersection(rect, (CGRect){CGPointZero, self.contentSize});
    if (CGRectIsEmpty(rectN)) {
        return layoutAttributes;
    }

    // 특정 rect의 start position 및 index 계산
    NSInteger numberOfItemsBefore = (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) ?
    MAX((NSInteger)((CGRectGetMinX(rectN) - self.leadingSpacing) / self.itemSpacing) , 0) :
    MAX((NSInteger)((CGRectGetMinY(rectN) - self.leadingSpacing) / self.itemSpacing) , 0);
    
    CGFloat startPosition = self.leadingSpacing + (numberOfItemsBefore * self.itemSpacing);
    NSInteger startIndex = numberOfItemsBefore;
    
    // layout attributes 생성
    NSInteger itemIndex = startIndex; // 모든 섹션을 다 합쳐서 섹션이 1개라고 했을 때의 인덱스가 됨.
    CGFloat origin = startPosition;
    
    CGFloat maxPosition = (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) ?
    MIN(CGRectGetMaxX(rectN), self.contentSize.width - self.actualItemSize.width - self.leadingSpacing) :
    MIN(CGRectGetMaxY(rectN), self.contentSize.height - self.actualItemSize.height - self.leadingSpacing);
    
    // https://stackoverflow.com/a/10335601/2398107
    // 위키 : Api:C/Types/Numeric limits    Project:Swift/숫자 관련
    // origin이 maxPosition을 초과할 때까지 반복한다.
    // while ( origin - maxPosition <= FLT_EPSILON ) { ... } 으로 해도 무방할 듯. 해보니 무방하다.
    while ( origin - maxPosition <= MAX(100.0 * DBL_EPSILON * ABS(origin + maxPosition), DBL_TRUE_MIN) ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex % self.numberOfItems
                                                     inSection:itemIndex / self.numberOfItems]; // 정확한 인덱스 찾기.
        if (self.carouselView.volumeType != MGUCarouselVolumeTypeInfinite && indexPath.section > 0) { // 유한인데, 섹션을 초과하면 그만 둬야한다.
            break;
        }
        
        MGUCarouselCellLayoutAttributes *attributes =
        (MGUCarouselCellLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath]; // frame만 설정함.
        [layoutAttributes addObject:attributes];
        
        // wrap 처리보자.
        if (self.carouselView.volumeType == MGUCarouselVolumeTypeFiniteWrap) {
            if (indexPath.item == 0) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGUCarouselCellLayoutAttributes *attributes =
                (MGUCarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
            if (indexPath.item == self.numberOfItems - 1) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGUCarouselCellLayoutAttributes *attributes =
                (MGUCarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
        
        itemIndex = itemIndex + 1;
        origin = origin + self.itemSpacing;
    }
    
    //! wrap 이 아닌. 또다른 Supplementary View가 존재한다면, 처리하자.
    MGUCarouselDiffableDataSource *dataSource = self.collectionView.dataSource;
    if ([dataSource isKindOfClass:[MGUCarouselDiffableDataSource class]] == NO) {
        NSCAssert(FALSE, @"MGUCarouselDiffableDataSource 객체가 아니다.");
    } else if (dataSource.elementOfKinds != nil && dataSource.elementOfKinds.count > 0) {
        NSInteger firstSection = [layoutAttributes firstObject].indexPath.section;
        NSInteger lastSection = 0;
        if (self.carouselView.volumeType != MGUCarouselVolumeTypeFiniteWrap) {
            lastSection = [layoutAttributes lastObject].indexPath.section;
        } else {
            lastSection = layoutAttributes[(layoutAttributes.count - 1) - 2].indexPath.section;
        }
        
        for (NSInteger section = firstSection; section <= lastSection; section++) {
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:section];
            for (NSString *elementOfKind in dataSource.elementOfKinds) {
                MGUCarouselCellLayoutAttributes *attributes =
                (MGUCarouselCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementOfKind
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
    }

    return layoutAttributes;
}

- (__kindof UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGUCarouselCellLayoutAttributes *attributes = [MGUCarouselCellLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.indexPath = indexPath;
    CGRect frame = [self frameForItemAtIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.center = center;
    attributes.size = self.actualItemSize;  // 즉, 여기까지는 프레임 설정.
    [self applyTransformTo:attributes with:self.carouselView.transformer]; // transformer nil이면 그냥 나온다.
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    MGUCarouselCellLayoutAttributes *attributes = [MGUCarouselCellLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                                                withIndexPath:indexPath];
    attributes.indexPath = indexPath; // 이거 의미가 없는 것 같다.
    CGRect frame = [self frameForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.center = center;
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
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        if (self.collectionViewContentSize.width <= self.collectionView.bounds.size.width) {
            return CGPointMake(0.0, proposedContentOffset.y);
        }
    } else {
        if (self.collectionViewContentSize.height <= self.collectionView.bounds.size.height) {
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    if (self.collectionView == nil || self.carouselView == nil) {
        return proposedContentOffset;
    }
    
    CGFloat proposedContentOffsetX;
    if (self.scrollDirection == MGUCarouselScrollDirectionVertical) {
        proposedContentOffsetX = proposedContentOffset.x;
    } else {
//        CGFloat boundedOffset = self.collectionView.contentSize.width - self.itemSpacing; // 잘못한듯
        CGFloat boundedOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
        proposedContentOffsetX = [self calculateTargetOffsetBy:proposedContentOffset.x
                                                 boundedOffset:boundedOffset
                                         withScrollingVelocity:velocity.x];
    }
    
    CGFloat proposedContentOffsetY;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        proposedContentOffsetY = proposedContentOffset.y;
    } else {
//        CGFloat boundedOffset = self.collectionView.contentSize.height - self.itemSpacing; // 잘못한듯
        CGFloat boundedOffset = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
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
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
//    self.moveIndexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        } else if (update.updateAction == UICollectionUpdateActionInsert) {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        } else if (update.updateAction == UICollectionUpdateActionMove) {
//             [self.moveIndexPaths addObject:update.indexPathBeforeUpdate];
//             [self.moveIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
//
//     typedef NS_ENUM(NSInteger, UICollectionUpdateAction) {
//         UICollectionUpdateActionInsert,
//         UICollectionUpdateActionDelete,
//         UICollectionUpdateActionReload,
//         UICollectionUpdateActionMove,
//         UICollectionUpdateActionNone
//     };
 }

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
//    self.moveIndexPaths = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if (self.deleteIndexPaths == nil || self.insertIndexPaths == nil) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([self.collectionView.indexPathsForVisibleItems containsObject:itemIndexPath] == YES) {
            return [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind
                                                                                        atIndexPath:(NSIndexPath *)elementIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSArray<NSIndexPath *> *indexPathsToInsert = [self indexPathsToInsertForSupplementaryViewOfKind:elementKind];
    NSArray<NSIndexPath *> *indexPathsToDelete = [self indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([[self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind] containsObject:elementIndexPath] == YES) {
            return [self.collectionView layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind
                                                                                     atIndexPath:(NSIndexPath *)decorationIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSArray<NSIndexPath *> *indexPathsToInsert = [self indexPathsToInsertForDecorationViewOfKind:elementKind];
    NSArray<NSIndexPath *> *indexPathsToDelete = [self indexPathsToDeleteForDecorationViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        return [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath]; // 회전시 반드시 필요하다.
    }
    return [super initialLayoutAttributesForAppearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if (self.deleteIndexPaths == nil || self.insertIndexPaths == nil) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([self.collectionView.indexPathsForVisibleItems containsObject:itemIndexPath] == YES) {
            return [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

//! 위와 같이 self.deleteIndexPaths, self.insertIndexPaths를 잡아야하는지는 모르겠다.
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind
                                                                                         atIndexPath:(NSIndexPath *)elementIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSArray<NSIndexPath *> *indexPathsToInsert = [self indexPathsToInsertForSupplementaryViewOfKind:elementKind];
    NSArray<NSIndexPath *> *indexPathsToDelete = [self indexPathsToDeleteForSupplementaryViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        if ([[self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind] containsObject:elementIndexPath] == YES) {
            return [self.collectionView layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath]; // 회전시 반드시 필요하다.
        }
    }
    return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingDecorationElementOfKind:(NSString *)elementKind
                                                                                      atIndexPath:(NSIndexPath *)decorationIndexPath {
    //! 이렇게 하는지 모르겠다. self.deleteIndexPaths, self.insertIndexPaths를 잡으면 안되니깐 대신 이렇게 잡았다.
    NSArray<NSIndexPath *> *indexPathsToInsert = [self indexPathsToInsertForDecorationViewOfKind:elementKind];
    NSArray<NSIndexPath *> *indexPathsToDelete = [self indexPathsToDeleteForDecorationViewOfKind:elementKind];
    if (indexPathsToInsert.count == 0 || indexPathsToDelete.count == 0) { //! 회전, 스크롤방향, 타입이 바뀔때 호출 (애니메이션)
        return [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath]; // 회전시 반드시 필요하다.
    }
    return [super finalLayoutAttributesForDisappearingDecorationElementOfKind:elementKind atIndexPath:decorationIndexPath];
}

//! Invalidating the Layout
// - (void)invalidateLayout {}
// - (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {}
// + (Class)invalidationContextClass {}
// - (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {}
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes
//                                    withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {}
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes
//                                                                        withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {}
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths
//                                                                           withTargetPosition:(CGPoint)targetPosition
//                                                                           previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths
//                                                                             previousPosition:(CGPoint)previousPosition;
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
//                                                                                                    previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths
//                                                                                                     movementCancelled:(BOOL)movementCancelled {}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//! Coordinating Animated Changes
// - (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds {}
// - (void)finalizeAnimatedBoundsChange {}

//! Transitioning Between Layouts
// - (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout {}
// - (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout {}
// - (void)finalizeLayoutTransition {}

//! Registering Decoration Views
// - (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)elementKind {}
// - (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)elementKind {}

//! Supporting Right-To-Left Layouts
// - (UIUserInterfaceLayoutDirection)developmentLayoutDirection {}
// - (BOOL)flipsHorizontallyInOppositeLayoutDirection {}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUCarouselLayout *self) {
    self->_contentSize = CGSizeZero;
    self->_leadingSpacing = 0.0f;
    self->_itemSpacing = 0.0f;
    self->_needsReprepare = YES;
    self->_collectionViewSize = CGSizeZero;
    self->_scrollDirection = MGUCarouselScrollDirectionHorizontal;
    self->_numberOfSections = 1;
    self->_numberOfItems = 0;
    self->_actualInteritemSpacing = 0.0f;
    self->_actualItemSize = CGSizeZero;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


#pragma mark - 세터 & 게터
- (MGUCarouselView *)carouselView {
    return (MGUCarouselView *)self.collectionView.superview.superview;
}


#pragma mark - 컨트롤
//! Public 컨트롤
- (CGPoint)contentOffsetFor:(NSIndexPath *)indexPath {
    CGPoint origin = [self frameForItemAtIndexPath:indexPath].origin;
    if (self.collectionView == nil) {
        return origin;
    }
    
    CGFloat contentOffsetX = 0.0f;
    if (self.scrollDirection == MGUCarouselScrollDirectionVertical) {
    } else { // horizontal
        contentOffsetX = origin.x - (self.collectionView.frame.size.width * 0.5 - self.actualItemSize.width * 0.5);
    }
    
    CGFloat contentOffsetY = 0.0f;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
    } else { // vertical
        contentOffsetY = origin.y - (self.collectionView.frame.size.height * 0.5 - self.actualItemSize.height * 0.5);
    }
    
    return CGPointMake(contentOffsetX, contentOffsetY);
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = self.numberOfItems * indexPath.section + indexPath.item;
    
    CGFloat originX;
    if (self.scrollDirection == MGUCarouselScrollDirectionVertical) {
        originX = (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        originX =  self.leadingSpacing + numberOfItems * self.itemSpacing;
    }
    
    CGFloat originY;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        originY = (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;
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
    
    CGFloat originX;
    if (self.scrollDirection == MGUCarouselScrollDirectionVertical) {
        originX = (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            originX =  self.leadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            originX =  self.leadingSpacing + numberOfItems * self.itemSpacing + (self.itemSpacing * self.numberOfItems);
        } else {
            //! 일반적인 경우는 그냥 첫 번째 아이템 위치를 준다.
            originX =  self.leadingSpacing + (numberOfItems * self.itemSpacing);
        }
    }
    
    CGFloat originY;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        originY = (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;
    } else {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            originY =  self.leadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
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

- (void)applyTransformTo:(MGUCarouselCellLayoutAttributes *)attributes
                    with:(MGUCarouselTransformer * _Nullable)transformer {
    if (self.collectionView == nil || transformer == nil) {
        return;
    }
    
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        CGFloat ruler = CGRectGetMidX(self.collectionView.bounds);
        attributes.position = (attributes.center.x - ruler) / self.itemSpacing; // 화면 중앙에서 어느 위치에 있느가를 의미함.
    } else { // vertical
        CGFloat ruler = CGRectGetMidY(self.collectionView.bounds);
        attributes.position = (attributes.center.y - ruler) / self.itemSpacing;
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
    
    NSInteger currentIndex = self.carouselView.currentIndex;
    currentIndex = MIN(MAX(0, currentIndex), self.numberOfItems - 1); // currentIndex 삭제하면서 안맞을 수 있다.
    NSInteger inSection = (self.carouselView.volumeType == MGUCarouselVolumeTypeInfinite)? self.numberOfSections / 2 : 0;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:inSection];
    CGPoint contentOffset = [self contentOffsetFor:newIndexPath];
    CGRect newBounds = (CGRect){contentOffset, self.collectionView.frame.size};
    self.collectionView.bounds = newBounds;
}

- (CGFloat)calculateTargetOffsetBy:(CGFloat)proposedOffset
                     boundedOffset:(CGFloat)boundedOffset
             withScrollingVelocity:(CGFloat)velocity { // CGPoint 에서 CGFloat으로 바꿨다. 원본에서는 CGPoint의 .x만 사용했음.
    
    CGFloat targetOffset;
    if (self.carouselView.decelerationDistance == [MGUCarouselView automaticDistance]) {
        if (ABS(velocity) >= 0.3) {
            CGFloat vector = (velocity >= 0) ? 1.0 : -1.0;
            targetOffset = round(proposedOffset/self.itemSpacing+0.35*vector) * self.itemSpacing; // Ceil by 0.15, rather than 0.5
        } else {
            targetOffset = round(proposedOffset/self.itemSpacing) * self.itemSpacing;
        }
    } else {
        NSUInteger extraDistance = MAX(self.carouselView.decelerationDistance - 1, 0);
        CGFloat contentOffset =
        (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) ? self.collectionView.contentOffset.x : self.collectionView.contentOffset.y;
        
        if (velocity >= 0.3 && velocity <= DBL_MAX) {
            targetOffset = ceil(contentOffset / self.itemSpacing + extraDistance) * self.itemSpacing;
        } else if (velocity >= -DBL_MAX && velocity <= -0.3) {
            targetOffset = floor(contentOffset / self.itemSpacing - extraDistance) * self.itemSpacing;
        } else {
            targetOffset = round(proposedOffset / self.itemSpacing) * self.itemSpacing;
        }
    }
    
    targetOffset = MAX(0, targetOffset);
    targetOffset = MIN(boundedOffset, targetOffset);
    return targetOffset;
}
@end

//if (velocity >= 0.3 && velocity <= DBL_MAX) {
//    targetOffset = ceil(self.collectionView.contentOffset.x/self.itemSpacing + extraDistance) * self.itemSpacing;
//} else if (velocity >= -DBL_MAX && velocity <= -0.3) {
//    targetOffset = floor(self.collectionView.contentOffset.x/self.itemSpacing-extraDistance) * self.itemSpacing;
//} else {
//    targetOffset = round(proposedOffset / self.itemSpacing) * self.itemSpacing;
//}
