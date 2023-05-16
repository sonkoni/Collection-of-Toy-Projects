//
//  MGACarouselView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGACarouselView.h"
#import "MGACarouselLayout.h"
#import "MGACarouselScrollView.h"
#import "NSScrollView+Extension.h"
#import "NSView+Extension.h"
#import "NSCollectionViewDiffableDataSource+Extension.h"

@interface MGACarouselView () <MGACarouselScrollViewDelegate, NSCollectionViewDelegate>

@property (nonatomic, strong) MGACarouselLayout *collectionViewLayout;
@property (nonatomic, strong) MGACarouselScrollView *scrollView;
@property (nonatomic, strong, readwrite) NSCollectionView *collectionView;
@property (nonatomic, assign, readwrite) MGACarouselVolumeType volumeType;
@property (nonatomic, strong) NSView *contentView;
@property (nonatomic, weak, nullable) NSTimer *timer; /// NSTimer는 등록시 target을 strong으로 잡으므로 weak로 써주자.
@property (nonatomic, assign, readonly) NSInteger numberOfItems; // @dynamic
@property (nonatomic, assign, readonly) NSInteger numberOfSections; // @dynamic
@property (nonatomic, assign) NSInteger dequeingSection; // MGUCarouselView는 오직 하나의 섹션만 갖는다. data source에 index만 전달한다.
@property (nonatomic, strong, readonly) NSIndexPath *centermostIndexPath;
@property (nonatomic, assign, readonly) BOOL isPossiblyRotating;    // 불필요할듯.
@property (nonatomic, strong, nullable) NSIndexPath *possibleTargetingIndexPath; // - collectionView:didSelectItemAtIndexPath: 설정됨.
@property (nonatomic, assign) BOOL panScene; // rubber effect를 위해 존재함.
@property (nonatomic, strong) MGEDisplayLink *displayLink; // 기존 - scrollToItemAtIndex:animated:의 컴플리션의 필요성 때문에 만들었다.

@property (nonatomic, assign, readonly) CGPoint maxOffset; // minOffset은 (0.0, 0.0)
@property (nonatomic, assign, readonly) BOOL isInsideLimitOffset; // 현재 offset이 min max 사이에 존재하는지
@end

@implementation MGACarouselView
@dynamic isScrollEnabled;
@dynamic horizontalScrollElasticity;
@dynamic verticalScrollElasticity;
@dynamic isTracking;           // readonly
@dynamic scrollOffset;         // readonly
@dynamic centermostIndexPath;  // readonly
@dynamic isPossiblyRotating;   // readonly 불필요할듯.
@dynamic automaticDistance;    // readonly
@dynamic automaticSize;        // readonly
@dynamic rubberEffect;         // readonly : cover flow 2에서 사용한다.
@dynamic numberOfItems;   // readonly
@dynamic numberOfSections;   // readonly
@dynamic maxOffset;   // readonly
@dynamic isInsideLimitOffset;   // readonly

+ (NSUInteger)automaticDistance {
    return 0;
}

+ (CGSize)automaticSize {
    return (CGSize){0.0, 0.0};
}

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.displayLink = nil;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
//        self.allowedTouchTypes = NSTouchTypeMaskDirect|NSTouchTypeMaskIndirect;
    }
    return self;
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    [super viewWillMoveToWindow:newWindow];
    if (newWindow != nil) {
        [self startTimer];
    } else {
        [self cancelTimer];
    }
}

- (void)layout {
    [super layout];
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.scrollView.frame = self.contentView.bounds;
}

/* 필요성을 모르겠다.
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis {
    return YES;
}
- (BOOL)wantsForwardedScrollEventsForAxis:(NSEventGestureAxis)axis {
    return YES;
}
- (void)touchesBeganWithEvent:(NSEvent *)event {
    [super touchesBeganWithEvent:event];
}
- (void)beginGestureWithEvent:(NSEvent *)event {
    [super beginGestureWithEvent:event];
}
*/

//- (void)touchesBeganWithEvent:(NSEvent *)event {
//    NSLog(@"touchesBeganWithEvent:!!!!");
//    return;
//    [super touchesBeganWithEvent:event];
//}
//
//- (NSView *)hitTest:(NSPoint)point {
//    return nil;
//}

#pragma mark - 생성 & 소멸
static void CommonInit(MGACarouselView *self) {
    self.wantsLayer = YES;
    self->_scrollView = [MGACarouselScrollView new];
    self->_collectionView = [NSCollectionView new];
    self->_collectionViewLayout = [MGACarouselLayout new];
    self.collectionView.collectionViewLayout = self.collectionViewLayout;
    self.scrollView.documentView = self.collectionView;
    self.scrollView.documentView.frame = self.scrollView.contentView.bounds;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = YES;
    self.collectionView.autoresizingMask = NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin;
    self.collectionView.selectable = YES;
    self.collectionView.allowsEmptySelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.wantsLayer = YES;
    self.scrollView.scrollViewDelegate = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColors = @[[NSColor clearColor]];

    self->_currentIndex = 0;
    self->_volumeType = MGACarouselVolumeTypeFinite;
    self->_itemSize = [MGACarouselView automaticSize]; //automaticSize;
    self->_decelerationDistance = 1;
    self->_interitemSpacing = 0.0f;
    self->_scrollDirection = MGACarouselScrollDirectionHorizontal;
    self->_automaticSlidingInterval = 0.0;
    self->_removesInfiniteLoopForSingleItem = NO;
    self->_dequeingSection = 0;
    
    // Content View
    self->_contentView = [NSView new];
    [self addSubview:self.contentView];
    
    // UICollectionView
    [self.contentView addSubview:self.scrollView];
    
    // 프로그래머틱하게 스크롤을 변경 시에 애니메이팅 후에, 컴플리션이 필요성이 존재하여 만들었다.
    self->_displayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                              easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                   progressBlock:nil
                                                 completionBlock:nil];
}


#pragma mark - 세터 & 게터
- (NSInteger)numberOfSections {
    MGACarouselDiffableDataSource *dataSource = (MGACarouselDiffableDataSource *)self.collectionView.dataSource;
    return dataSource.snapshot.numberOfSections;
}

- (NSInteger)numberOfItems {
    MGACarouselDiffableDataSource *dataSource = (MGACarouselDiffableDataSource *)self.collectionView.dataSource;
    NSDiffableDataSourceSnapshot *snapshot = dataSource.snapshot;
    return (snapshot.numberOfSections == 0)? 0 : (snapshot.numberOfItems / snapshot.numberOfSections);
}

- (void)setAutomaticSlidingInterval:(CGFloat)automaticSlidingInterval {
    _automaticSlidingInterval = automaticSlidingInterval;
    [self cancelTimer];
    
    if (self.automaticSlidingInterval > 0) {
        [self startTimer];
    }
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setVolumeType:(MGACarouselVolumeType)volumeType {
    _volumeType = volumeType;
//    if (volumeType == MGRCarouselVolumeTypeFiniteWrap &&
//        [self.dataSource respondsToSelector:@selector(carouselView:viewForSupplementaryElementOfKind:atIndex:)] == NO) {
//        NSCAssert(FALSE, @"MGRCarouselVolumeTypeFiniteWrap 모드는 carouselView:viewForSupplementaryElementOfKind:atIndex: 구현하라.");
//    }
//    self.collectionViewLayout.needsReprepare = YES;
//    [self.collectionView reloadData];
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setTransformer:(MGACarouselTransformer *)transformer {
    _transformer = transformer;
    self.transformer.carouselView = self;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setScrollDirection:(MGACarouselScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    self.scrollView.scrollEnabled = isScrollEnabled;
}

- (BOOL)isScrollEnabled {
    return self.scrollView.isScrollEnabled;
}

- (void)setHorizontalScrollElasticity:(NSScrollElasticity)horizontalScrollElasticity {
    self.scrollView.horizontalScrollElasticity = horizontalScrollElasticity;
}

- (void)setVerticalScrollElasticity:(NSScrollElasticity)verticalScrollElasticity {
    self.scrollView.verticalScrollElasticity = verticalScrollElasticity;
}

- (NSScrollElasticity)verticalScrollElasticity {
    return self.scrollView.verticalScrollElasticity;
}

- (NSScrollElasticity)horizontalScrollElasticity {
    return self.scrollView.horizontalScrollElasticity;
}

- (void)setRemovesInfiniteLoopForSingleItem:(BOOL)removesInfiniteLoopForSingleItem {
    _removesInfiniteLoopForSingleItem = removesInfiniteLoopForSingleItem;
    MGACarouselDiffableDataSource *diffableDataSource = (MGACarouselDiffableDataSource *)(self.collectionView.dataSource);
    [diffableDataSource mgrApplySnapshotUsingReloadData:diffableDataSource.snapshot];
}

- (void)setBackgroundView:(NSView *)backgroundView {
    _backgroundView = backgroundView;
    if (backgroundView != nil) {
        if (backgroundView.superview != nil) {
            [backgroundView removeFromSuperview];
        }
        [self mgrInsertSubview:_backgroundView atIndex:0];
        [self setNeedsLayout:YES];
    }
}

- (BOOL)isTracking {
    return self.scrollView.isTracking;
}

// 내부에서만 쓰인다.
- (CGFloat)scrollOffset { //! scrollingFloatingCurrentIndex - 이 이름이 더 어울린다.
    CGFloat contentOffset = MAX(self.scrollView.mgrContentOffset.x, self.scrollView.mgrContentOffset.y);
    CGFloat scrollOffset = (contentOffset / self.collectionViewLayout.itemSpacing); //! itemSpacing 개념 주의!
    if (self.volumeType == MGACarouselVolumeTypeInfinite) {
        return fmod(scrollOffset, (CGFloat)(self.numberOfItems)); // 실수의 나머지 연산 : ex) fmod(+5.1, +3.0) = 2.1
    } else {
        return scrollOffset;
    }
    //
    // 첫 번째 아이템에 멈춰있을 때(첫 번째 아이템이 중간)에는 0.0, 두 번째 아이템에 멈춰있을 때(두 번째 아이템이 중간)에는 1.0
    // fmod모드는 무한에 대응하기 위하 코드이다. 유한 아이템의 인덱스로 표현한다.
}

- (void)setCurrentIndex:(NSInteger)currentIndex { //! 외부에서 readonly로 만들어져있으며, KVO 이용을 원할 수 있으므로 세터를 만들었다.
    _currentIndex = currentIndex;
    //
    // 만약 세터를 원하지 않는다면 다음과 같은 형식을 이용하면되지만, 실수로 빠뜨릴 가능성이 존재하므로, 세터를 만드는 것이 더 나을 것으로 사료된다.
    //[self willChangeValueForKey:@"currentIndex"]; // Observer에게 값이 변경되기 시작한 것을 알린다.
    //_currentIndex = currentIndex;                 // readonly이므로.
    //[self didChangeValueForKey:@"currentIndex"];  // Observer에게 값의 변경이 끝난 것을 알린다.
}

- (BOOL)rubberEffect { //! lock wood iCarousel coverFlow2 처럼 버티는 효과가 가능한 상태를 알려준다.
    if ([self isInsideLimitOffset] == NO) {
        return NO;
    } else {
        return _panScene;
    }
}

// MARK: -  private 세터 & 게터
- (BOOL)isPossiblyRotating { // 불필요한 것으로 예상된다. 무조건 NO되는 것으로 가정하는 것이 좋을듯.
    if (self.contentView.layer.animationKeys == nil) {
        return NO;
    }
    
    NSArray <NSString *>*rotationAnimationKeys = @[@"position", @"bounds.origin", @"bounds.size"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", rotationAnimationKeys];
    if ([self.contentView.layer.animationKeys filteredArrayUsingPredicate:predicate].count > 0) {
        return YES;
    } else {
        return NO;
    }
    //
    // 실제로, layer.animationKeys는 [layer addAnimation:animation forKey:@"jooto"]; 의 jooto에 해당한다. 아무래도 잘못 사용한듯.
}

- (NSIndexPath *)centermostIndexPath { // 지금 눈에 보이는 셀 중에서 가장 중앙에 가까운 cell의 indexPath를 반환한다.
    if (self.numberOfItems <= 0 || CGSizeEqualToSize(self.scrollView.mgrContentSize, CGSizeZero)) {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    NSArray <NSIndexPath *>*indexPathsForVisibleItems = self.collectionView.indexPathsForVisibleItems.allObjects;
    NSArray <NSIndexPath *>*sortedIndexPaths =
    [indexPathsForVisibleItems sortedArrayUsingComparator:^(NSIndexPath * object1, NSIndexPath * object2) {
        CGRect leftFrame = [self.collectionViewLayout frameForItemAtIndexPath:object1];
        CGRect rightFrame = [self.collectionViewLayout frameForItemAtIndexPath:object2];
        CGFloat leftCenter;
        CGFloat rightCenter;
        CGFloat ruler;
        if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
            leftCenter = CGRectGetMidX(leftFrame);
            rightCenter = CGRectGetMidX(rightFrame);
            ruler = CGRectGetMidX(self.scrollView.clipViewBounds);
        } else {
            leftCenter = CGRectGetMidY(leftFrame);
            rightCenter = CGRectGetMidY(rightFrame);
            ruler = CGRectGetMidY(self.scrollView.clipViewBounds);
        }
        
        if (ABS(ruler-leftCenter) < ABS(ruler-rightCenter)) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSIndexPath *indexPath = sortedIndexPaths.firstObject;
    
    if (indexPath != (id)[NSNull null]) {
        return indexPath;
    }
    
    return [NSIndexPath indexPathForItem:0 inSection:0];
}

- (CGPoint)maxOffset {
    if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
        CGFloat maxOffsetX = self.scrollView.mgrContentSize.width - self.scrollView.frame.size.width;
        return CGPointMake(maxOffsetX, 0.0);
    } else {
        CGFloat maxOffsetY = self.scrollView.mgrContentSize.height - self.scrollView.frame.size.height;
        return CGPointMake(0.0, maxOffsetY);
    }
}

- (BOOL)isInsideLimitOffset {
    CGPoint offset = self.scrollView.mgrContentOffset;
    CGPoint maxOffset = self.maxOffset;
    if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
        if (offset.x < 0.0 || offset.x > maxOffset.x) {
            return NO;
        }
    } else if (offset.y < 0.0 || offset.y > maxOffset.y) {
        return NO;
    }
    return YES;
}


#pragma mark - Automatic Timer 컨트롤
- (void)startTimer {
    if (self.automaticSlidingInterval <= 0 || self.timer != nil) {
        return;
    }
    //! 왠지 + timerWithTimeInterval:target:selector:userInfo:repeats: 이걸 쓰는게 나을듯. 아래의 메서드는 timer 부착까지 포함된듯.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)self.automaticSlidingInterval
                                                  target:self
                                                selector:@selector(flipNextSender:)
                                                userInfo:nil
                                                 repeats:YES];
    
    //! 타이머를 현재 런루프에서 NSRunLoopCommonModes로 실행하게 하면, 사용자 인터렉션에 의해서 타이머가 방해받지 않는다.
    //! 기본적으로 NSTimer 는 NSRunLoop에서 작동하게 되어있고, 자동으로 Main Thread NSRunLoop이다.
    //! 따라서 currentRunLoop로 변경해야한다.
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // NSDefaultRunLoopMode, NSRunLoopCommonModes, NSEventTrackingRunLoopMode, NSModalPanelRunLoopMode, UITrackingRunLoopMode
    
    //! 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
    self.timer.tolerance = 0.1;
}

- (void)cancelTimer {
    if (self.timer == nil) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)flipNextSender:(NSTimer *)sender {
    NSInteger numberOfItems = self.numberOfItems;
    if (self.superview == nil || self.window == nil || numberOfItems <= 0 || self.isTracking == YES) {
        return;
    }
    
    NSIndexPath *indexPath = self.centermostIndexPath;
    NSInteger section = (self.numberOfSections > 1) ? (indexPath.section + (indexPath.item + 1) / numberOfItems) : 0;
    NSInteger item = (indexPath.item + 1) % numberOfItems;
    
    CGPoint contentOffset = [self.collectionViewLayout contentOffsetFor:[NSIndexPath indexPathForItem:item inSection:section]];
    
    CGPoint currentContentOffset = self.scrollView.mgrContentOffset;
    [self.displayLink invalidate];
    __weak __typeof(self) weakSelf = self;
    self.displayLink.progressBlock = ^(CGFloat progress) {
        [weakSelf.scrollView setContentOffset:MGELerpPoint(progress, currentContentOffset, contentOffset)
                                     animated:NO
                                   completion:nil];
    };
    self.displayLink.completionBlock = ^{
        [weakSelf scrollViewDidEndScrollingAnimation:weakSelf.scrollView];
    };
    self.displayLink.animationDuration = 0.2;
    [self.displayLink startAnimationWithStartProgress:0.0];
    //
    // [self.scrollView setContentOffset:contentOffset animated:YES completion:^{}];
}


#pragma mark -  <NSCollectionViewDelegate>
- (NSSet <NSIndexPath *>*)collectionView:(NSCollectionView *)collectionView
           shouldChangeItemsAtIndexPaths:(NSSet <NSIndexPath *>*)indexPaths
                        toHighlightState:(NSCollectionViewItemHighlightState)highlightState {
    if ([self.delegate respondsToSelector:@selector(carouselView:shouldChangeItemsAtIndexPaths:toHighlightState:)] == NO) {
        return indexPaths;
    } else {
        return [self.delegate carouselView:self shouldChangeItemsAtIndexPaths:indexPaths toHighlightState:highlightState];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
didChangeItemsAtIndexPaths:(NSSet <NSIndexPath *>*)indexPaths
      toHighlightState:(NSCollectionViewItemHighlightState)highlightState {
    if ([self.delegate respondsToSelector:@selector(carouselView:didChangeItemsAtIndexSet:toHighlightState:)] == NO) {
        return;
    } else {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSIndexPath *indexPath in indexPaths) {
            [indexSet addIndex:indexPath.item];
        }
        [self.delegate carouselView:self didChangeItemsAtIndexSet:indexSet toHighlightState:highlightState];
    }
}

- (NSSet <NSIndexPath *>*)collectionView:(NSCollectionView *)collectionView
           shouldSelectItemsAtIndexPaths:(NSSet <NSIndexPath *>*)indexPaths {
    
    if ([self.delegate respondsToSelector:@selector(carouselView:shouldSelectItemsAtIndexPaths:)] == NO) {
        return indexPaths;
    } else {
        return [self.delegate carouselView:self shouldSelectItemsAtIndexPaths:indexPaths];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
didSelectItemsAtIndexPaths:(NSSet <NSIndexPath *>*)indexPaths {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemsAtIndexSet:)] == NO) {
        return;
    } else {
        self.possibleTargetingIndexPath = indexPaths.anyObject;
        
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (NSIndexPath *indexPath in indexPaths) {
            [indexSet addIndex:indexPath.item];
        }
        [self.delegate carouselView:self didSelectItemsAtIndexSet:indexSet];  // 보통 여기에서 - scrollToItemAtIndex:animated: 호출함
        self.possibleTargetingIndexPath = nil; // - scrollToItemAtIndex:animated:에서 사용된 후, nil 처리
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
       willDisplayItem:(NSCollectionViewItem *)item
forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:willDisplayItem:forRepresentedObjectAtIndex:)] == YES) {
        NSInteger numberOfItems = self.numberOfItems; // 섹션 한개만 봤을 때. 즉, 사용자가 인식하는 아이템의 갯수
        if (numberOfItems == 0) { return; }
        NSInteger index = indexPath.item % numberOfItems;
        [self.delegate carouselView:self willDisplayItem:item forRepresentedObjectAtIndex:index];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
willDisplaySupplementaryView:(NSView *)view
        forElementKind:(NSCollectionViewSupplementaryElementKind)elementKind
           atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:willDisplaySupplementaryView:forElementKind:atIndex:)] == YES) {
        NSInteger numberOfItems = self.numberOfItems; // 섹션 한개만 봤을 때. 즉, 사용자가 인식하는 아이템의 갯수
        if (numberOfItems == 0) { return; }
        NSInteger index = indexPath.item % numberOfItems;
        [self.delegate carouselView:self willDisplaySupplementaryView:view forElementKind:elementKind atIndex:index];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
  didEndDisplayingItem:(NSCollectionViewItem *)item
forRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didEndDisplayingItem:forRepresentedObjectAtIndex:)] == YES) {
        [self.delegate carouselView:self didEndDisplayingItem:item forRepresentedObjectAtIndex:indexPath.item];
    }
}

- (void)collectionView:(NSCollectionView *)collectionView
didEndDisplayingSupplementaryView:(NSView *)view
      forElementOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
           atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didEndDisplayingSupplementaryView:forElementOfKind:atIndex:)] == YES) {
        [self.delegate carouselView:self
  didEndDisplayingSupplementaryView:view
                   forElementOfKind:elementKind
                            atIndex:indexPath.item];
    }
}


#pragma mark -  <MGACarouselScrollViewDelegate>
- (void)scrollViewDidScroll:(MGACarouselScrollView *)scrollView {
    [self updateCurrentIndex];
    if (scrollView.isTracking == YES) { // 손가락이 닿았을 때에만 호출한다.
        [self moveInfiniteOffsetWithScrollView:scrollView]; // 무한 모드에서만 작동한다.
    }
    if ([self.delegate respondsToSelector:@selector(carouselViewDidScroll:)] == YES) {
        [self.delegate carouselViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginScrolling:(MGACarouselScrollView *)scrollView {
    _panScene = YES;
    [self moveInfiniteOffsetWithScrollView:scrollView]; // 시작 시점에서 한번 잡아주자. 불필요할 수도 있지만. 한번 해주자.
    if ([self.delegate respondsToSelector:@selector(carouselViewWillBeginScrolling:)] == YES) {
        [self.delegate carouselViewWillBeginScrolling:self];
    }
    [self.transformer carouselViewWillBeginDragging:self]; // coverFlow rubberEffect에서 offset 정보를 확인하고 싶다.
    if (self.automaticSlidingInterval > 0.0) {
        [self cancelTimer];
    }
}

- (void)scrollViewDidEndScrolling:(MGACarouselScrollView *)scrollView rollingStop:(BOOL)rollingStop {
    if (rollingStop == YES) { // 스와이프 스크롤링 하다가 멈출 때. 자연스럽게 멈출 때. OR 도는 도중에 강제로 손가락으로 멈출 때.
        _panScene = NO;
        if (NSApp.isActive == NO) { // MGAScrollView 에서 Touch End 메서드가 발동이 되지 않으므로 여기서 해결해야함.
        }
    } else { // 손 땐 곳에서 멈춰버렸다.
//        [self _calmCleanupAction:scrollView];
    }
    if ([self.delegate respondsToSelector:@selector(carouselViewDidEndScrolling:rollingStop:)] == YES) {
        [self.delegate carouselViewDidEndScrolling:self rollingStop:rollingStop];
    }
}

- (void)scrollViewWillBeginDecelerating:(MGACarouselScrollView *)scrollView {
    _panScene = NO;
    if ([self.delegate respondsToSelector:@selector(carouselViewWillBeginDecelerating:)] == YES) {
        [self.delegate carouselViewWillBeginDecelerating:self];
    }
//    if ([self.delegate respondsToSelector:@selector(carouselViewWillEndDragging:targetIndex:)] == YES) {
//        CGFloat contentOffset = (self.scrollDirection == MGRCarouselScrollDirectionHorizontal) ?
//        (*targetContentOffset).x : (*targetContentOffset).y;
//        NSInteger targetItem = lround(contentOffset / self.collectionViewLayout.itemSpacing);
//        [self.delegate carouselViewWillEndDragging:self targetIndex:targetItem % self.numberOfItems];
//        // 이 객체를 사용하는 객체가 자신의 페이지 번호를 갱신하는데, 사용할 수 있다.
//    }
    if (self.automaticSlidingInterval > 0) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(MGACarouselScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(carouselViewDidEndScrollingAnimation:)] == YES) {
        [self.delegate carouselViewDidEndScrollingAnimation:self];
    }
    [self moveInfiniteOffsetWithScrollView:scrollView];
}

- (void)scrollViewMayBeginScrolling:(MGACarouselScrollView *)scrollView {
    // 굴러가고 있는데 두 손가락으로 멈추면 들어온다.
    // 한 손가락으로 멈추면은 해결할 방법이 없다.
}

- (void)scrollViewCancelledScrolling:(MGACarouselScrollView *)scrollView {
//    [self _calmCleanupAction:scrollView];
}


#pragma mark - Public method
- (void)initialRefreshWithCompletion:(void(^)(void))completionBlock async:(BOOL)async {
    CGPoint currentOffset = self.scrollView.mgrContentOffset;
    CGPoint offset = currentOffset;
    if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
        offset.x = currentOffset.x + 1.0;
    } else {
        offset.y = currentOffset.y + 1.0;
    }
    __weak __typeof(self) weakSelf = self;
    void (^voidBlock)(void) = ^{
        [self.scrollView setContentOffset:offset animated:NO completion:^{
            [weakSelf.scrollView setContentOffset:currentOffset animated:NO completion:completionBlock];
        }];
    };
    if (async == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{ voidBlock(); });
    } else {
        voidBlock();
    }
}

- (void)updateCurrentIndex {
    NSInteger numberOfItems = self.numberOfItems;
    if (!self.isPossiblyRotating && numberOfItems > 0) { // 그냥 무조건 들어올듯하다.
        // 누군가 KVO를 사용하는 경우. currentIndex가 바뀌었음을 알려준다.
        NSInteger currentIndex = lround(self.scrollOffset);
        if (self.volumeType == MGACarouselVolumeTypeInfinite) {
            currentIndex = currentIndex % numberOfItems; // 반올림. (나눗셈은 크게 의미 없을듯. 이미 했음.)
        } else {
            currentIndex = MIN(MAX(0, currentIndex), numberOfItems-1);
        }
        if (currentIndex != self.currentIndex) {
            self.currentIndex = currentIndex;
        }
    } else if (numberOfItems == 0 && self.currentIndex != 0) {
        self.currentIndex = 0;
    }
}

- (void)registerClass:(Class)itemClass forItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    [self.collectionView registerClass:itemClass forItemWithIdentifier:identifier];
}

- (void)registerNib:(NSNib *)nib forItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    [self.collectionView registerNib:nib forItemWithIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass
forSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)kind
       withIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:kind withIdentifier:identifier];
}

- (void)registerNib:(NSNib *)nib
forSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)kind
     withIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind withIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind {
    [self.collectionView.collectionViewLayout registerClass:viewClass forDecorationViewOfKind:elementKind];
}

- (void)registerNib:(NSNib *)nib forDecorationViewOfKind:(NSCollectionViewDecorationElementKind)elementKind {
    [self.collectionView.collectionViewLayout registerNib:nib forDecorationViewOfKind:elementKind];
}

- (__kindof NSCollectionViewItem *)makeItemWithIdentifier:(NSUserInterfaceItemIdentifier)identifier
                                                 forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:self.dequeingSection];
    NSCollectionViewItem *item = [self.collectionView makeItemWithIdentifier:identifier forIndexPath:indexPath];
    //! FIXME: 이거 수정 필요.
    // if ([item isKindOfClass:[MGACarouselCell class]] == NO) {
    //     NSCAssert(NO, @"Cell 클래스는 반드시 MGRCarouselCell의 서브 클래스여야한다.");
    // }
    return item;
}

- (__kindof NSView *)makeSupplementaryViewOfKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                  withIdentifier:(NSUserInterfaceItemIdentifier)identifier
                                        forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:self.dequeingSection];
    NSView *view = [self.collectionView makeSupplementaryViewOfKind:elementKind
                                                     withIdentifier:identifier
                                                       forIndexPath:indexPath];
    //! FIXME: 이거 수정 필요.
//    if ([indexPath isKindOfClass:[MGACarouselCell class]] == NO) {
//        NSCAssert(NO, @"Cell 클래스는 반드시 MGRCarouselCell의 서브 클래스여야한다.");
//    }
    return view;
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated { //! 잘 사용하지 않을듯. <- 버그 비슷한게 존재함.
    [self validationTestForIndex:index];
    
    NSIndexPath *indexPath;
    if (self.possibleTargetingIndexPath != nil && self.possibleTargetingIndexPath.item == index) {
        indexPath = self.possibleTargetingIndexPath;
    } else {
        indexPath = [self nearbyIndexPathFor:index];
    }
    
    [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath]
                                  scrollPosition:NSCollectionViewScrollPositionNone];
    //
    // collectionView에서는 셀렉션과 스크롤을 명백하게 구분하는게 좋을듯하다. scrollPosition:은 None으로 하는 것이 좋을듯 하다.
}

- (void)deselectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self validationTestForIndex:index];
    
    NSIndexPath *indexPath;
    if (self.possibleTargetingIndexPath != nil && self.possibleTargetingIndexPath.item == index) {
        indexPath = self.possibleTargetingIndexPath;
    } else {
        indexPath = [self nearbyIndexPathFor:index];
    }
    
    [self.collectionView deselectItemsAtIndexPaths:[NSSet setWithObject:indexPath]];
}

- (void)scrollToItemAtIndex:(NSInteger)index
                   animated:(BOOL)animated
                   duration:(CFTimeInterval)duration
                 completion:(void(^_Nullable)(void))completionBlock {
    __weak __typeof(self) weakSelf = self;
    [self validationTestForIndex:index];
    NSIndexPath *indexPath;
    if (self.possibleTargetingIndexPath != nil && self.possibleTargetingIndexPath.item == index) {
        indexPath = self.possibleTargetingIndexPath; // 손가락 탭. 정확히 탭한 인덱스로 이동해야한다.
    } else {
        indexPath = [self nearbyIndexPathFor:index];
    }
    _panScene = NO;
    CGPoint contentOffset = [self.collectionViewLayout contentOffsetFor:indexPath];
    
    
    void (^newCompletionBlock)(void) = ^{
        if (completionBlock != nil) {
            completionBlock();
        }
        [weakSelf scrollViewDidEndScrollingAnimation:weakSelf.scrollView];
    };

    if (animated == YES && completionBlock != nil) {
        CGPoint currentContentOffset = self.scrollView.mgrContentOffset;
        self.displayLink.progressBlock = ^(CGFloat progress) {
            [weakSelf.scrollView setContentOffset:MGELerpPoint(progress, currentContentOffset, contentOffset)
                                         animated:NO
                                       completion:nil];
        };
        self.displayLink.completionBlock = newCompletionBlock;
        self.displayLink.animationDuration = duration;
        [self.displayLink startAnimationWithStartProgress:0.0];
    } else if (animated == YES) { // animated == YES && completionBlock == nil
        NSCAssert(FALSE, @"이거 사용하지 말자. 바로 위에 거 사용하는게 더 낫다");
        [self.scrollView setContentOffset:contentOffset animated:YES completion:nil];
        // animated == YES이므로 scrollViewDidEndScrollingAnimation:을 호출할 것이다. 거기에서 잡아주자.
    } else { // animated == NO : completionBlock 은 nil 일수도 있고 아닐 수도 있다.
        [self.scrollView setContentOffset:contentOffset animated:NO completion:nil];
        newCompletionBlock();
    }
    //
    // 스크롤에서는 - scrollToItemAtIndexPath:atScrollPosition:animated: 메서드는 가급적 사용을 자제하고,
    // - setContentOffset:animated:를 사용하는 것이 좋다.
}

- (NSInteger)indexForCell:(NSCollectionViewItem *)item {
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
    if (indexPath == nil) {
        return NSNotFound;
    }
    
    return indexPath.item;
}

- (NSCollectionViewItem *)cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return [self.collectionView itemAtIndexPath:indexPath];
}

- (NSArray <__kindof NSCollectionViewItem *>*)visibleItems {
    return self.collectionView.visibleItems;
}

- (NSArray <NSNumber *>*)indexesForVisibleItems {
    NSArray<NSIndexPath *> *indexPathsForVisibleItems =
        [self.collectionView indexPathsForVisibleItems].allObjects;
    NSMutableArray<NSNumber *> *indexesForVisibleItems = [NSMutableArray arrayWithCapacity:indexPathsForVisibleItems.count];
    for (NSIndexPath *indexPath in indexPathsForVisibleItems) {
        [indexesForVisibleItems addObject:@(indexPath.item)];
    }
    return indexesForVisibleItems.copy;
}

- (NSView <NSCollectionViewElement>*)supplementaryViewForElementKind:(NSCollectionViewSupplementaryElementKind)elementKind
                                                             atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return [self.collectionView supplementaryViewForElementKind:elementKind atIndexPath:indexPath];
}

- (NSArray <NSView <NSCollectionViewElement>*> *)visibleSupplementaryViewsOfKind:(NSCollectionViewSupplementaryElementKind)elementKind {
    return [self.collectionView visibleSupplementaryViewsOfKind:elementKind];
}

// NSInteger를 감싸는 NSNumber
- (NSArray <NSNumber *>*)indexesForVisibleSupplementaryElementsOfKind:(NSCollectionViewSupplementaryElementKind)elementKind {
    
    NSArray <NSIndexPath *>*indexPathsForVisibleSupplementaryElements =
    [self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind].allObjects;
    
    NSMutableArray<NSNumber *> *indexesForVisibleSupplementaryElements =
    [NSMutableArray arrayWithCapacity:indexPathsForVisibleSupplementaryElements.count];
    
    for (NSIndexPath *indexPath in indexPathsForVisibleSupplementaryElements) {
        [indexesForVisibleSupplementaryElements addObject:@(indexPath.item)];
    }
    return indexesForVisibleSupplementaryElements.copy;
}

// - layoutAttributesForItemAtIndexPath: 연결
- (__kindof MGACarouselCellLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (__kindof MGACarouselCellLayoutAttributes *)[self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
}

//- layoutAttributesForSupplementaryElementOfKind:atIndexPath: 연결. 이 프로젝트에서는 MGRCarouselSupplementaryViewLayoutAttributes를 사용하지 않는다.
- (__kindof MGACarouselCellLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                                                                    atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (__kindof MGACarouselCellLayoutAttributes *)[self.collectionView layoutAttributesForSupplementaryElementOfKind:kind
                                                                                                              atIndexPath:indexPath];
}

#pragma mark - private
- (NSIndexPath *)nearbyIndexPathFor:(NSInteger)index { // 내부적으로 다중 섹션이므로 정확한 섹션을 잡기 위해.
    NSInteger currentIndex = self.currentIndex;
    NSInteger currentSection = self.centermostIndexPath.section;
    
    if (self.numberOfSections == 1) { // 유한 일때
        return [NSIndexPath indexPathForItem:index inSection:0];
    }
    
    if (currentIndex == index) { // 이동하려는 인덱스가 현재 인덱스와 동일할때.
        return [NSIndexPath indexPathForItem:index inSection:currentSection];
    }
    
    NSInteger currentSectionDistance = ABS(index - currentIndex);
    if (index > currentIndex) { // 원하는 인덱스가 현재 섹션에서 오른쪽에 있다면 왼쪽 섹션을 고려해봐야한다.
        NSInteger backwardSectionDistance = currentIndex + (self.numberOfItems - index);
        if (currentSectionDistance > backwardSectionDistance) {
            return [NSIndexPath indexPathForItem:index inSection:currentSection - 1];
        }
    } else {
        NSInteger forwardSectionDistance = index + (self.numberOfItems - currentIndex);
        if (currentSectionDistance > forwardSectionDistance) {
            return [NSIndexPath indexPathForItem:index inSection:currentSection + 1];
        }
    }
    
    return [NSIndexPath indexPathForItem:index inSection:currentSection];
    //
    // 다음과 같은 public 메서드에서 사용된다.
    // - selectItemAtIndex:animated:
    // - deselectItemAtIndex:animated:
    // - scrollToItemAtIndex:animated:
    // - cellForItemAtIndex:
}

// 무한 일때만, 오프셋 조정을 위해. 손가락이 때어지는 순간에는 Target Offset이 계산되기 때문에 offset을 이동하지 말자.
// scrollViewDidScroll: 에서는 crollView.isTracking == YES(손가락이 붙어 있을 때에만) 호출된다.
// 애니메이팅하게 특정 셀렉션으로 옮겨지는 상황에서도 발동한다.
- (void)moveInfiniteOffsetWithScrollView:(MGACarouselScrollView *)scrollView {
    if (self.volumeType == MGACarouselVolumeTypeInfinite) {
        NSInteger itemCount = self.numberOfItems;
        NSInteger sectionCount = self.numberOfSections;
        NSInteger realItemCount = itemCount * sectionCount;
        CGFloat maxOffset, contentOffset;
        if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
            maxOffset = self.maxOffset.x;
            contentOffset = scrollView.mgrContentOffset.x;
        } else {
            maxOffset = self.maxOffset.y;
            contentOffset = scrollView.mgrContentOffset.y;
        }
        
        if (maxOffset >= 0.0) { // 회전시에 maxOffset이 음수가 나온다. contentSize가 바로 반영되지 못하여. 무시하는 것이 좋다.
            CGFloat unitOffset = maxOffset / (realItemCount - 1);
            CGFloat minChangeOffset = ((realItemCount / 3) * unitOffset) - unitOffset; // 가운데 섹션의 첫 번째 셀 왼쪽 셀
            CGFloat maxChangeOffset = ((realItemCount / 3) * 2.0) * unitOffset; // 가운데 섹션의 마지막 셀 오른쪽 셀
            if (minChangeOffset > contentOffset || maxChangeOffset < contentOffset) {
                if (minChangeOffset > contentOffset) {
                    do {
                        contentOffset = contentOffset + (unitOffset * self.numberOfItems);
                    } while (contentOffset < maxChangeOffset);
                    contentOffset = contentOffset - (unitOffset * self.numberOfItems);
                } else if (maxChangeOffset < contentOffset) {
                    do {
                        contentOffset = contentOffset - (unitOffset * self.numberOfItems);
                    } while (contentOffset > minChangeOffset);
                    contentOffset = contentOffset + (unitOffset * self.numberOfItems);
                }
                if (minChangeOffset > contentOffset || maxChangeOffset < contentOffset) {
                    NSCAssert(FALSE, @"범위를 넓게 잡아야한다.");
                }
                if (self.scrollDirection == MGACarouselScrollDirectionHorizontal) {
                    scrollView.mgrContentOffset = CGPointMake(contentOffset, scrollView.mgrContentOffset.y);
                } else {
                    scrollView.mgrContentOffset = CGPointMake(scrollView.mgrContentOffset.x, contentOffset);
                }
            }
        }
    }
}


// MARK: - Simple Log Helper
- (void)validationTestForIndex:(NSInteger)index {
//    if (self.numberOfSections == 0) { // 아직 설정이 안되어 있을 수도 있다. 안되어 있다면 설정해주자.
//        [self numberOfSectionsInCollectionView:self.collectionView];
//    }
    if (index >= self.numberOfItems) {
        if (self.numberOfItems == 0 && index == 0 ) {
            //! 이건 그냥 봐준다.
        } else {
            NSCAssert(FALSE, @"index %ld 는 [0...%ld]의 범위에서 벗어났다.", (long)index, (long)self.numberOfItems-1);
        }
    }
}
@end
