//
//  MGUFlowLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUFlowView.h"
#import "MGUFlowLayout.h"
#import "MGUFlowCellLayoutAttributes.h"
#import "MGUFlowSupplementaryViewLayoutAttributes.h" // 사용하지 않을 것이다.
#import "MGUFlowDecorationViewLayoutAttributes.h" // 사용하지 않을 것이다.
#import "MGUFlowDiffableDataSource.h"

@interface MGUFlowLayout ()

@property (nonatomic, assign) CGSize collectionViewSize; // 디폴트 CGSizeZero
@property (nonatomic, assign) NSInteger numberOfSections; // 디폴트 1
@property (nonatomic, assign) NSInteger numberOfItems; // 디폴트 0
@property (nonatomic, assign) CGFloat actualInteritemSpacing; // 디폴트 0.0
@property (nonatomic, assign) CGSize actualItemSize; // 디폴트 CGSizeZero
@property (nonatomic, assign) BOOL reversed; // 디폴트 NO;
@property (nonatomic, strong, nullable, readonly) MGUFlowView *flowView; // self.collectionView.superview.superview @dynamic

//! insert, delete, move, reload 애니메이션에서 엄한 애니메이션이 같이 실행되므로 적절하게 고르기 위해 만들었다.
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*deleteIndexPaths;
@property (nonatomic, strong, nullable) NSMutableArray <NSIndexPath *>*insertIndexPaths;
@end

@implementation MGUFlowLayout
@dynamic flowView;

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

//! Providing Layout Attributes
+ (Class)layoutAttributesClass {
    return [MGUFlowCellLayoutAttributes class];
}

- (void)prepareLayout {
    if (self.collectionView == nil || self.flowView == nil) {
        return;
    }
    
    if (self.needsReprepare == NO && CGSizeEqualToSize(self.collectionViewSize, self.collectionView.frame.size)) {
        return;
    }
    
    self.needsReprepare = NO;
    self.collectionViewSize = self.collectionView.frame.size;

    // Calculate basic parameters/variables
    MGUFlowDiffableDataSource *dataSource = self.collectionView.dataSource;
    NSDiffableDataSourceSnapshot *snapshot = dataSource.snapshot;
    self.numberOfSections = snapshot.numberOfSections;
    self.numberOfItems = (self.numberOfSections == 0) ? 0 : (snapshot.numberOfItems / snapshot.numberOfSections);
//    self.numberOfItems = [snapshot numberOfItemsInSection:@(0)];
//    self.numberOfSections = [self.flowView numberOfSectionsInCollectionView:self.collectionView];
//    self.numberOfItems = [self.flowView collectionView:self.collectionView numberOfItemsInSection:0];
    
    
    CGSize size = self.flowView.itemSize;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        self.actualItemSize = self.collectionView.frame.size;
    } else {
        self.actualItemSize = size;
    }
    
    if (self.flowView.transformer != nil) {
        self.actualInteritemSpacing = [self.flowView.transformer proposedInteritemSpacing];
        // 아래 셋은 self.flowView.interitemSpacing과 동일하다.
        // MGUFlowTransformerTypeCrossFading
        // MGUFlowTransformerTypeZoomOut
        // MGUFlowTransformerTypeDepth
    } else {
        self.actualInteritemSpacing = self.flowView.interitemSpacing;
    }
    
    self.scrollDirection = self.flowView.scrollDirection;
    
    //! FIXME: 이것도 actualInteritemSpacing 처럼 나누어서 만들어야한다.
    self.actualLeadingSpacing  = self.flowView.leadingSpacing;
//    self.leadingSpacing = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
//    (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5 :
//    (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;\
    
    self.reversed = self.flowView.reversed;
    
    self.itemSpacing =
    (self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? self.actualItemSize.width : self.actualItemSize.height)
    +
    self.actualInteritemSpacing;

    // contentSize 계산 및 캐시하여, 매번 계산하지 않게한다.
    NSInteger numberOfItems = self.numberOfItems * self.numberOfSections;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat contentSizeWidth = self.actualLeadingSpacing * 2.0; // Leading & trailing spacing
        contentSizeWidth += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeWidth += numberOfItems * self.actualItemSize.width; // Item sizes
        //! reverse를 위해서 최소한 collectionView 의 크기만큼은 확보한다.
        contentSizeWidth = MAX(contentSizeWidth, self.collectionView.frame.size.width);
        self.contentSize = CGSizeMake(contentSizeWidth, self.collectionView.frame.size.height);
        
        //! paging을 위해서는 추가적인 size가 필요할 가능성이 높다.
        if (contentSizeWidth != self.collectionView.frame.size.width) {
            CGFloat maxOffset = contentSizeWidth - self.collectionView.frame.size.width;
            CGFloat itemSpacing = self.itemSpacing;
            if ([self.flowView.transformer isKindOfClass:[MGUFlowFoldTransformer class]] == YES) {
                itemSpacing = itemSpacing * 2.0; // 두 칸씩 멈춘다.
            }
            CGFloat remainder = fmod(maxOffset, itemSpacing);
            if (remainder > FLT_EPSILON) { // 보정하라.
                CGFloat additionalMargin = itemSpacing - remainder;
                self.contentSize = CGSizeMake(self.contentSize.width + additionalMargin, self.contentSize.height);
            }
        }
    } else {
        CGFloat contentSizeHeight = self.actualLeadingSpacing * 2; // Leading & trailing spacing
        contentSizeHeight += (numberOfItems - 1) * self.actualInteritemSpacing; // Interitem spacing
        contentSizeHeight += numberOfItems * self.actualItemSize.height; // Item sizes
        contentSizeHeight = MAX(contentSizeHeight, self.collectionView.frame.size.height);
        self.contentSize = CGSizeMake(self.collectionView.frame.size.width, contentSizeHeight);
        
        //! paging을 위해서는 추가적인 size가 필요할 가능성이 높다.
        if (contentSizeHeight != self.collectionView.frame.size.height) {
            CGFloat maxOffset = contentSizeHeight - self.collectionView.frame.size.height;
            CGFloat itemSpacing = self.itemSpacing;
            if ([self.flowView.transformer isKindOfClass:[MGUFlowFoldTransformer class]] == YES) {
                itemSpacing = itemSpacing * 2.0; // 두 칸씩 멈춘다.
            }
            CGFloat remainder = fmod(maxOffset, itemSpacing);
            if (remainder > FLT_EPSILON) { // 보정하라.
//                CGFloat additionalMargin = itemSpacing - remainder;
                CGFloat additionalMargin = itemSpacing - remainder;
                self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + additionalMargin);
            }
        }
    }
    
    [self adjustCollectionViewBounds];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *>*layoutAttributes = [NSMutableArray array];
    //! self.numberOfItems == 0 이면 터질 수 있다.
    if (self.itemSpacing <= 0 || self.numberOfItems < 1 || CGRectIsEmpty(rect) || rect.size.width < 0.0 || rect.size.height < 0.0) { // 음수가 들어올 수 있다.
        return layoutAttributes;
    }
    
    //! FIXME: 이건 지워도 될듯.
    //! eyePosition 에 따라 더 많은 아이템이 보여질 수 있으므로, rect를 크게 잡는다.
//    if (self.flowView.transformer.type == MGUFlowTransformerTypeLockWoodSpecial) {
//        CGFloat percent = 1.0 / self.flowView.transformer.minimumScale;
//        rect = MGRRectPercent(rect, percent, percent);
//    }
    
    //! 위의 식 안해도 바로 아래 식 정도면 편하게 사용할 수 있을듯.
    rect = CGRectInset(rect, -(rect.size.width / 2.0), -(rect.size.height / 2.0));

    CGRect rectN = CGRectIntersection(rect, (CGRect){CGPointZero, self.contentSize});
    if (CGRectIsEmpty(rectN)) {
        return layoutAttributes;
    }

    // 특정 rect의 start position 및 index 계산
    NSInteger numberOfItemsBefore = 0;
    CGFloat startPosition = 0.0;
    CGFloat lastPosition = 0.0;
    if (self.reversed == NO) {
        numberOfItemsBefore = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
        MAX((NSInteger)((CGRectGetMinX(rectN) - self.actualLeadingSpacing) / self.itemSpacing) , 0) :
        MAX((NSInteger)((CGRectGetMinY(rectN) - self.actualLeadingSpacing) / self.itemSpacing) , 0);
        
        startPosition = self.actualLeadingSpacing + (numberOfItemsBefore * self.itemSpacing);
        
        lastPosition = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
        MIN(CGRectGetMaxX(rectN), self.contentSize.width - self.actualItemSize.width - self.actualLeadingSpacing) :
        MIN(CGRectGetMaxY(rectN), self.contentSize.height - self.actualItemSize.height - self.actualLeadingSpacing);
        
    } else {
        numberOfItemsBefore = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
        MAX((NSInteger)((self.contentSize.width - CGRectGetMaxX(rectN) - self.actualLeadingSpacing) / self.itemSpacing) , 0) :
        MAX((NSInteger)((self.contentSize.height - CGRectGetMaxY(rectN) - self.actualLeadingSpacing) / self.itemSpacing) , 0);

        startPosition = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
        self.contentSize.width - self.actualLeadingSpacing - (numberOfItemsBefore * self.itemSpacing) - self.actualItemSize.width : self.contentSize.height - self.actualLeadingSpacing - (numberOfItemsBefore * self.itemSpacing) - self.actualItemSize.height;
        
        lastPosition = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ?
        MAX(CGRectGetMinX(rectN) - self.actualItemSize.width, self.actualLeadingSpacing) :
        MAX(CGRectGetMinY(rectN)- self.actualItemSize.height, self.actualLeadingSpacing);
    }
    
    NSInteger startIndex = numberOfItemsBefore;
    
    // layout attributes 생성
    NSInteger itemIndex = startIndex; // 모든 섹션을 다 합쳐서 섹션이 1개라고 했을 때의 인덱스가 됨.
    CGFloat currentPosition = startPosition;
    
    // https://stackoverflow.com/a/10335601/2398107
    // 위키 : Api:C/Types/Numeric limits    Project:Swift/숫자 관련
    // origin이 maxPosition을 초과할 때까지 반복한다.
    // while ( origin - maxPosition <= FLT_EPSILON ) { ... } 으로 해도 무방할 듯. 해보니 무방하다.
//    while ( origin - maxPosition <= MAX(100.0 * DBL_EPSILON * ABS(origin + maxPosition), DBL_TRUE_MIN) ) {
    if (self.reversed == YES) {
        currentPosition = - currentPosition;
        lastPosition = - lastPosition;
    }
    while ( currentPosition - lastPosition <= FLT_EPSILON ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex % self.numberOfItems
                                                     inSection:itemIndex / self.numberOfItems]; // 정확한 인덱스 찾기.
        if (self.flowView.volumeType != MGUFlowVolumeTypeInfinite && indexPath.section > 0) { // 유한인데, 섹션을 초과하면 그만 둬야한다.
            break;
        }
        MGUFlowCellLayoutAttributes *attributes =
        (MGUFlowCellLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath]; // frame만 설정함.
        [layoutAttributes addObject:attributes];
        
        // wrap 처리보자.
        if (self.flowView.volumeType == MGUFlowVolumeTypeFiniteWrap) {
            if (indexPath.item == 0) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGUFlowCellLayoutAttributes *attributes =
                (MGUFlowCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
            if (indexPath.item == self.numberOfItems - 1) {
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
                MGUFlowCellLayoutAttributes *attributes =
                (MGUFlowCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
        
        itemIndex = itemIndex + 1;
        currentPosition = currentPosition + self.itemSpacing;
    }
    
    //! wrap 이 아닌. 또다른 Supplementary View가 존재한다면, 처리하자.
    MGUFlowDiffableDataSource *dataSource = self.collectionView.dataSource;
    if ([dataSource isKindOfClass:[MGUFlowDiffableDataSource class]] == NO) {
        NSCAssert(FALSE, @"MGUFlowDiffableDataSource 객체가 아니다.");
    } else if (dataSource.elementOfKinds != nil && dataSource.elementOfKinds.count > 0) {
        NSInteger firstSection = [layoutAttributes firstObject].indexPath.section;
        NSInteger lastSection = 0;
        if (self.flowView.volumeType != MGUFlowVolumeTypeFiniteWrap) {
            lastSection = [layoutAttributes lastObject].indexPath.section;
        } else {
            lastSection = layoutAttributes[(layoutAttributes.count - 1) - 2].indexPath.section;
        }
        
        for (NSInteger section = firstSection; section <= lastSection; section++) {
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:section];
            for (NSString *elementOfKind in dataSource.elementOfKinds) {
                MGUFlowCellLayoutAttributes *attributes =
                (MGUFlowCellLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementOfKind
                                                                                        atIndexPath:path];
                [layoutAttributes addObject:attributes];
            }
        }
    }
    
    return layoutAttributes;
}

- (__kindof UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGUFlowCellLayoutAttributes *attributes = [MGUFlowCellLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.indexPath = indexPath;
    CGRect frame = [self frameForItemAtIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.center = center;
    attributes.size = self.actualItemSize;  // 즉, 여기까지는 프레임 설정.
    [self applyTransformTo:attributes with:self.flowView.transformer]; // transformer nil이면 그냥 나온다.
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    MGUFlowCellLayoutAttributes *attributes = [MGUFlowCellLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind
                                                                                                        withIndexPath:indexPath];
    attributes.indexPath = indexPath; // 이거 의미가 없는 것 같다.
    CGRect frame = [self frameForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    attributes.center = center;
    attributes.size = self.actualItemSize;  // 즉, 여기까지는 프레임 설정.
    [self applyTransformTo:attributes with:self.flowView.transformer]; // transformer nil이면 그냥 나온다.
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
    // reverse 가 존재하므로 target offset이 음수가 나올 수 있다.
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.collectionViewContentSize.width <= self.collectionView.bounds.size.width) {
            return CGPointMake(0.0, proposedContentOffset.y);
        } else {
            proposedContentOffset.x = MAX(proposedContentOffset.x, 0.0); // reverse 에서의 문제를 해결한다.
            //! offset을 잘 정해줘야한다. 접히는 것일 때는 잘 접히게.
            CGFloat boundedOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
            proposedContentOffset.x = [self calculateTargetOffsetBy:proposedContentOffset.x
                                                      boundedOffset:boundedOffset
                                              withScrollingVelocity:0.0];
        }
    } else {
        if (self.collectionViewContentSize.height <= self.collectionView.bounds.size.height) {
            return CGPointMake(proposedContentOffset.x, 0.0);
        } else {
            proposedContentOffset.y = MAX(proposedContentOffset.y, 0.0); // reverse 에서의 문제를 해결한다.
            //! offset을 잘 정해줘야한다. 접히는 것일 때는 잘 접히게.
            CGFloat boundedOffset = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
            proposedContentOffset.y = [self calculateTargetOffsetBy:proposedContentOffset.y
                                                      boundedOffset:boundedOffset
                                              withScrollingVelocity:0.0];
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
    if (self.collectionView == nil || self.flowView == nil) {
        return proposedContentOffset;
    }
    
    CGFloat proposedContentOffsetX;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        proposedContentOffsetX = proposedContentOffset.x;
    } else {
        //CGFloat boundedOffset = self.collectionView.contentSize.width - self.itemSpacing;
        CGFloat boundedOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
        proposedContentOffsetX = [self calculateTargetOffsetBy:proposedContentOffset.x
                                                 boundedOffset:boundedOffset
                                         withScrollingVelocity:velocity.x];
    }
    
    CGFloat proposedContentOffsetY;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        proposedContentOffsetY = proposedContentOffset.y;
    } else {
//        CGFloat boundedOffset = self.collectionView.contentSize.height - self.itemSpacing;
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
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
     [super prepareForCollectionViewUpdates:updateItems];
     self.deleteIndexPaths = [NSMutableArray array];
     self.insertIndexPaths = [NSMutableArray array];

     for (UICollectionViewUpdateItem *update in updateItems) {
         if (update.updateAction == UICollectionUpdateActionDelete) {
             [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
         } else if (update.updateAction == UICollectionUpdateActionInsert) {
             [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
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
static void CommonInit(MGUFlowLayout *self) {
    self->_contentSize = CGSizeZero;
    self->_actualLeadingSpacing = 0.0;
    self->_itemSpacing = 0.0f;
    self->_needsReprepare = YES;
    self->_collectionViewSize = CGSizeZero;
    self->_scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self->_numberOfSections = 1;
    self->_numberOfItems = 0;
    self->_actualInteritemSpacing = 0.0f;
    self->_actualItemSize = CGSizeZero;
    self->_reversed = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


#pragma mark - 세터 & 게터
- (MGUFlowView *)flowView {
    return (MGUFlowView *)self.collectionView.superview.superview;
}

- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    self.collectionView.contentSize = contentSize;
}


#pragma mark - 컨트롤
//! Public 컨트롤
- (CGPoint)contentOffsetFor:(NSIndexPath *)indexPath { // 해당 index path를 0 번 인덱스로 옮기면 offset은 어떻게 변하는가. => 불가능한 offset도 나온다.
    CGPoint origin = [self frameForItemAtIndexPath:indexPath].origin;
    if (self.collectionView == nil) {
        return origin;
    }
    
    CGFloat contentOffsetX = 0.0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
    } else { // horizontal
        // 0 번째 origin을 빼주는 것이다.
//        contentOffsetX = origin.x - (self.collectionView.frame.size.width * 0.5 - self.actualItemSize.width * 0.5);
        contentOffsetX = origin.x - (self.actualLeadingSpacing);
        if (self.reversed == YES) {
//            contentOffsetX = origin.x - (self.contentSize.width - self.actualItemSize.width - self.actualLeadingSpacing);
            
            contentOffsetX = origin.x - (self.collectionView.frame.size.width - self.actualItemSize.width - self.actualLeadingSpacing);
            
        }
    }
    
    CGFloat contentOffsetY = 0.0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
    } else { // vertical
        contentOffsetY = origin.y - (self.actualLeadingSpacing);
        if (self.reversed == YES) {
            //! FIXME: 무엇이 맞는가?? 아랫이 맞는듯.
//            contentOffsetY = origin.y - (self.contentSize.height - self.actualItemSize.height - self.actualLeadingSpacing);
            contentOffsetY = origin.y - (self.collectionView.frame.size.height - self.actualItemSize.height - self.actualLeadingSpacing);
        }

    }
    
    return CGPointMake(contentOffsetX, contentOffsetY);
}

//! 처리되었음.
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfItems = self.numberOfItems * indexPath.section + indexPath.item;
    
    CGFloat originX;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        originX = (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        originX = self.actualLeadingSpacing + numberOfItems * self.itemSpacing;
        if (self.reversed == YES) {
            originX = self.contentSize.width - self.actualItemSize.width - originX;
        }
    }
    
    CGFloat originY;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        originY = (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;
    } else {
        originY = self.actualLeadingSpacing + numberOfItems * self.itemSpacing;
        if (self.reversed == YES) {
            originY = self.contentSize.height - self.actualItemSize.height - originY;
        }
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
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        originX = (self.collectionView.frame.size.width - self.actualItemSize.width) * 0.5;
    } else {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            originX =  self.actualLeadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            originX =  self.actualLeadingSpacing + numberOfItems * self.itemSpacing + (self.itemSpacing * self.numberOfItems);
        } else {
            //! 일반적인 경우는 그냥 첫 번째 아이템 위치를 준다.
            originX =  self.actualLeadingSpacing + (numberOfItems * self.itemSpacing);
            if (self.reversed == YES) {
                originX = self.contentSize.width - self.actualItemSize.width - originX;
            }
            
        }
    }
    
    CGFloat originY;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        originY = (self.collectionView.frame.size.height - self.actualItemSize.height) * 0.5;
    } else {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            originY =  self.actualLeadingSpacing + (numberOfItems * self.itemSpacing) - self.itemSpacing;
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            originY =  self.actualLeadingSpacing + numberOfItems * self.itemSpacing + (self.itemSpacing * self.numberOfItems);
        } else {
            //! 일반적인 경우는 그냥 첫 번째 아이템 위치를 준다.
            originY =  self.actualLeadingSpacing + (numberOfItems * self.itemSpacing);
            if (self.reversed == YES) {
                originY = self.contentSize.height - self.actualItemSize.height - originY;
            }
            
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
    if (CGSizeEqualToSize(self.flowView.itemSize, CGSizeZero)) {
        [self adjustCollectionViewBounds];
    }
}

- (void)applyTransformTo:(MGUFlowCellLayoutAttributes *)attributes
                    with:(MGUFlowTransformer * _Nullable)transformer {
    if (self.collectionView == nil || transformer == nil) {
        return;
    }
    //! 기준 점이 0이고 컨텐츠 쪽으로 들어가면 양수이다.
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.reversed == NO) {
            CGFloat standard = CGRectGetMinX(self.collectionView.bounds) + self.actualLeadingSpacing + (self.actualItemSize.width / 2.0);
            attributes.position = (attributes.center.x - standard) / self.itemSpacing;
        } else {
            CGFloat standard = CGRectGetMaxX(self.collectionView.bounds) - self.actualLeadingSpacing - (self.actualItemSize.width / 2.0);
            attributes.position = (standard - attributes.center.x ) / self.itemSpacing;
        }
    } else { // vertical
        if (self.reversed == NO) {
            CGFloat standard = CGRectGetMinY(self.collectionView.bounds) + self.actualLeadingSpacing + (self.actualItemSize.height / 2.0);
            attributes.position = (attributes.center.y - standard) / self.itemSpacing;
        } else {
            CGFloat standard = CGRectGetMaxY(self.collectionView.bounds) - self.actualLeadingSpacing - (self.actualItemSize.height / 2.0);
            attributes.position = (standard - attributes.center.y ) / self.itemSpacing;
        }
    }
    
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        CGFloat ruler = CGRectGetMidX(self.collectionView.bounds);
//        attributes.position = (attributes.center.x - ruler) / self.itemSpacing; // 화면 중앙에서 어느 위치에 있느가를 의미함.
//    } else { // vertical
//        CGFloat ruler = CGRectGetMidY(self.collectionView.bounds);
//        attributes.position = (attributes.center.y - ruler) / self.itemSpacing;
//    }
    
    
    //! ordering을 위해 인덱싱한다. 가운데의 인덱스 번호가 self.numberOfItems 에 해당하는 번호를 갖는다. 오른쪽으로 갈수록 번호가 줄어든다.
    //! 즉 왼쪽과 오른쪽이 겹치면, 왼쪽이 보일 것이다. 그러나 zoomOut빼고는 모두 다시 설정한다. - applyTransformTo: 메서드에서
    /// attributes.zIndex = (NSInteger)(self.numberOfItems - attributes.position); // 양수는 버림, 음수는 올림이된다. 일반적으로 화면에는 양수만 등장
    
    [transformer applyTransformTo:attributes];
}

- (void)adjustCollectionViewBounds { // 무한일때 바운드를 바꾸는듯.
    if (self.collectionView == nil || self.flowView == nil) {
        return;
    }
    
    NSInteger currentIndex = self.flowView.currentIndex;
    // currentIndex = MIN(MAX(0, currentIndex), self.numberOfItems - 1); // <- 왠지 넣어야 될 것 같은데. 두고보자.
    NSInteger inSection = (self.flowView.volumeType == MGUFlowVolumeTypeInfinite)? self.numberOfSections / 2 : 0;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:inSection];

    CGPoint contentOffset = [self contentOffsetFor:newIndexPath];
    CGRect newBounds = (CGRect){contentOffset, self.collectionView.frame.size};
    
    
    //! FIXME: reverse 일때, 발생하는 문제를 해결하기 힘들다. 우선 이걸로 땜빵하자.
    if (self.reversed == YES && self.flowView.isTracking == YES) {
        return;
    }
    self.collectionView.bounds = newBounds; // 이걸 꺼버려도 문제가 발생한다.
}

- (CGFloat)calculateTargetOffsetBy:(CGFloat)proposedOffset
                     boundedOffset:(CGFloat)boundedOffset
             withScrollingVelocity:(CGFloat)velocity { // CGPoint 에서 CGFloat으로 바꿨다. 원본에서는 CGPoint의 .x만 사용했음.
    
    CGFloat targetOffset;
    if (self.flowView.decelerationDistance == [MGUFlowView automaticDistance]) {
        CGFloat itemSpacing = self.itemSpacing;
        if ([self.flowView.transformer isKindOfClass:[MGUFlowFoldTransformer class]] == YES) {
            itemSpacing = itemSpacing * 2.0; // 두 칸씩 멈춘다.
        }
        if (ABS(velocity) >= 0.3) {
            if (self.reversed == NO) {
                CGFloat vector = (velocity >= 0) ? 1.0 : -1.0;
                targetOffset = round(proposedOffset/itemSpacing+0.35*vector) * itemSpacing; // Ceil by 0.15, rather than 0.5
            } else {
                CGFloat vector = (velocity >= 0) ? 1.0 : -1.0;
                CGFloat margin = fmod(boundedOffset, itemSpacing);
                targetOffset = round((proposedOffset - margin)/itemSpacing+0.35*vector) * itemSpacing; // Ceil by 0.15, rather than 0.5
                targetOffset = targetOffset + margin;
            }
        } else {
            if (self.reversed == NO) {
                targetOffset = round(proposedOffset/itemSpacing) * itemSpacing;
            } else {
                CGFloat margin = fmod(boundedOffset, itemSpacing);
                targetOffset = round((proposedOffset - margin)/itemSpacing) * itemSpacing;
                
                targetOffset = targetOffset + margin;
            }
        }
    } else {
        NSCAssert(FALSE, @"좆도 여기 안만들었다.");
        NSUInteger extraDistance = MAX(self.flowView.decelerationDistance - 1, 0);
        CGFloat contentOffset =
        (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.collectionView.contentOffset.x : self.collectionView.contentOffset.y;
        
        if (velocity >= 0.3 && velocity <= DBL_MAX) {
            targetOffset = ceil(contentOffset / self.itemSpacing + extraDistance) * self.itemSpacing;
        } else if (velocity >= -DBL_MAX && velocity <= -0.3) {
            targetOffset = floor(contentOffset / self.itemSpacing - extraDistance) * self.itemSpacing;
        } else {
            targetOffset = round(proposedOffset / self.itemSpacing) * self.itemSpacing;
        }
    }
    
    targetOffset = MIN(boundedOffset, MAX(0, targetOffset));
    
//    if (targetOffset == boundedOffset && self.reversed == NO) {
//    } else if (targetOffset == 0.0 && self.reversed == YES) {}
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
