//
//  MGUCarouselView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselView.h"
#import "MGUCarouselDiffableDataSource.h"
#import "MGUCarouselView_Internal.h"

/* MGUCarouselView_Internal.h 에 존재한다.
@interface MGUCarouselView ()
 ...
@end
*/

@implementation MGUCarouselView
@dynamic isScrollEnabled;
@dynamic bounces;
@dynamic alwaysBounceHorizontal;
@dynamic alwaysBounceVertical;
@dynamic isTracking;           // readonly
@dynamic scrollOffset;         // readonly
@dynamic centermostIndexPath;  // readonly
@dynamic isPossiblyRotating;   // readonly 불필요할듯.
@dynamic automaticDistance;    // readonly
@dynamic automaticSize;        // readonly
@dynamic rubberEffect;         // readonly : cover flow 2에서 사용한다.
@dynamic numberOfItems;   // readonly
@dynamic numberOfSections;   // readonly

+ (NSUInteger)automaticDistance {
    return 0;
}

+ (CGSize)automaticSize {
    return (CGSize){0.0, 0.0};
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
    }
    return self;
}

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow != nil) {
        [self startTimer];
    } else {
        [self cancelTimer];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    self.collectionView.frame = self.contentView.bounds;
}

#if TARGET_INTERFACE_BUILDER // 인터페이스 빌더로 확인만 하는 용. runtime에서 실행되지 않는다.
- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.frame = self.bounds;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont boldSystemFontOfSize:25.0f];
//    label.text = @"MGUCarouselView";
    
    //! 글자의 스트로크 색도 존재하고 글자 자체의 색도 존재하게 만들 경우.
    //! https://developer.apple.com/library/archive/qa/qa1531/_index.html#//apple_ref/doc/uid/DTS40007490
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary <NSAttributedStringKey, id>*unitAttributes =
     @{ NSFontAttributeName            : [UIFont boldSystemFontOfSize:50.0f], // Define the font
        NSForegroundColorAttributeName : UIColor.redColor,  // Define fill color
        NSStrokeColorAttributeName     : UIColor.blueColor,
        NSStrokeWidthAttributeName     : @(-5.0), // 글자 크기의 백분율로 지정된다. 내부를 orangeColor로 채우고 stroke를 바깥에 채우려면 음수로 한다.
        NSBackgroundColorAttributeName : UIColor.grayColor, // Paint the background
        NSParagraphStyleAttributeName  : paragraphStyle }.mutableCopy;


    label.attributedText = [[NSMutableAttributedString alloc] initWithString:@"MGUCarouselView"
                                                                  attributes:unitAttributes];
    
    [self.contentView addSubview:label];
}
#endif


#pragma mark - 생성 & 소멸
static void CommonInit(MGUCarouselView *self) {
    self->_currentIndex = 0;
    self->_volumeType = MGUCarouselVolumeTypeFinite;
    self->_itemSize = [MGUCarouselView automaticSize]; //automaticSize;
    self->_decelerationDistance = 1;
    self->_interitemSpacing = 0.0f;
    self->_scrollDirection = MGUCarouselScrollDirectionHorizontal;
    self->_automaticSlidingInterval = 0.0;
    self->_removesInfiniteLoopForSingleItem = NO;
    self->_dequeingSection = 0;
    
    // Content View
    self->_contentView = [UIView new];
    self.contentView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.contentView];
    
    // UICollectionView
    self->_collectionViewLayout = [MGUCarouselLayout new];
    self->_collectionView = [[MGUCarouselCollectionView alloc] initWithFrame:CGRectZero
                                                        collectionViewLayout:self.collectionViewLayout];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.collectionView];
    // 프로그래머틱하게 스크롤을 변경 시에 애니메이팅 후에, 컴플리션이 필요성이 존재하여 만들었다.
    self->_displayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                              easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                   progressBlock:nil
                                                 completionBlock:nil];
}


#pragma mark - 세터 & 게터
- (NSInteger)numberOfSections {
    MGUCarouselDiffableDataSource *dataSource = (MGUCarouselDiffableDataSource *)self.collectionView.dataSource;
    return dataSource.snapshot.numberOfSections;
}

- (NSInteger)numberOfItems { // 섹션 한개만 봤을 때 : 사용자가 인식하는 아이템의 갯수
    MGUCarouselDiffableDataSource *dataSource = (MGUCarouselDiffableDataSource *)self.collectionView.dataSource;
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

- (void)setVolumeType:(MGUCarouselVolumeType)volumeType {
    _volumeType = volumeType;
//    if (volumeType == MGUCarouselVolumeTypeFiniteWrap &&
//        [self.dataSource respondsToSelector:@selector(carouselView:viewForSupplementaryElementOfKind:atIndex:)] == NO) {
//        NSCAssert(FALSE, @"MGUCarouselVolumeTypeFiniteWrap 모드는 carouselView:viewForSupplementaryElementOfKind:atIndex: 구현하라.");
//    }
//    self.collectionViewLayout.needsReprepare = YES;
//    [self.collectionView reloadData];
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setTransformer:(MGUCarouselTransformer *)transformer {
    _transformer = transformer;
    self.transformer.carouselView = self;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setScrollDirection:(MGUCarouselScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self.collectionViewLayout forceInvalidate];
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled {
    self.collectionView.scrollEnabled = isScrollEnabled;
}

- (BOOL)isScrollEnabled {
    return self.collectionView.isScrollEnabled;
}

- (void)setBounces:(BOOL)bounces {
    self.collectionView.bounces = bounces;
}

- (BOOL)bounces {
    return self.collectionView.bounces;
}

- (void)setAlwaysBounceHorizontal:(BOOL)alwaysBounceHorizontal {
    self.collectionView.alwaysBounceHorizontal = alwaysBounceHorizontal;
}

- (BOOL)alwaysBounceHorizontal {
    return self.collectionView.alwaysBounceHorizontal;
}

- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical {
    self.collectionView.alwaysBounceVertical = alwaysBounceVertical;
}

- (BOOL)alwaysBounceVertical {
    return self.collectionView.alwaysBounceVertical;
}

- (void)setRemovesInfiniteLoopForSingleItem:(BOOL)removesInfiniteLoopForSingleItem {
    _removesInfiniteLoopForSingleItem = removesInfiniteLoopForSingleItem;
    MGUCarouselDiffableDataSource *diffableDataSource = (MGUCarouselDiffableDataSource *)(self.collectionView.dataSource);
    if (@available(iOS 15, *)) {
        [diffableDataSource applySnapshotUsingReloadData:diffableDataSource.snapshot];
    } else {
        NSDiffableDataSourceSnapshot *snapshot = diffableDataSource.snapshot;
        [snapshot reloadSectionsWithIdentifiers:snapshot.sectionIdentifiers];
        [diffableDataSource applySnapshot:snapshot animatingDifferences:NO];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView {
    _backgroundView = backgroundView;
    if (backgroundView != nil) {
        if (backgroundView.superview != nil) {
            [backgroundView removeFromSuperview];
        }
        [self insertSubview:_backgroundView atIndex:0];
        [self setNeedsLayout];
    }
}

- (BOOL)isTracking {
    return self.collectionView.isTracking;
}

- (CGFloat)scrollOffset { //! scrollingFloatingCurrentIndex - 이 이름이 더 어울린다.
    CGFloat contentOffset = MAX(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    CGFloat scrollOffset = (contentOffset / self.collectionViewLayout.itemSpacing); //! itemSpacing 개념 주의!
    return fmod(scrollOffset, (CGFloat)(self.numberOfItems)); // 실수의 나머지 연산 : ex) fmod(+5.1, +3.0) = 2.1
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
    CGFloat maxOffset, contentOffset;
    if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        maxOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
        contentOffset = self.collectionView.contentOffset.x;
    } else {
        maxOffset = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
        contentOffset = self.collectionView.contentOffset.y;
    }
    
    if (contentOffset <= 0.0 || contentOffset >= maxOffset) {
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
    if (self.numberOfItems <= 0 || CGSizeEqualToSize(self.collectionView.contentSize, CGSizeZero)) {
        return [NSIndexPath indexPathForItem:0 inSection:0];
    }
    
    NSArray <NSIndexPath *>*sortedIndexPaths =
    [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^(NSIndexPath * object1, NSIndexPath * object2) {
        CGRect leftFrame = [self.collectionViewLayout frameForItemAtIndexPath:object1];
        CGRect rightFrame = [self.collectionViewLayout frameForItemAtIndexPath:object2];
        CGFloat leftCenter;
        CGFloat rightCenter;
        CGFloat ruler;
        
        if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
            leftCenter = CGRectGetMidX(leftFrame);
            rightCenter = CGRectGetMidX(rightFrame);
            ruler = CGRectGetMidX(self.collectionView.bounds);
        } else {
            leftCenter = CGRectGetMidY(leftFrame);
            rightCenter = CGRectGetMidY(rightFrame);
            ruler = CGRectGetMidY(self.collectionView.bounds);
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
    [self.collectionView setContentOffset:contentOffset animated:YES];
}


#pragma mark -  <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:shouldHighlightItemAtIndex:)] == NO) {
        return YES;
    } else {
        return [self.delegate carouselView:self shouldHighlightItemAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didHighlightItemAtIndex:)] == NO) {
        return;
    } else {
        [self.delegate carouselView:self didHighlightItemAtIndex:indexPath.item];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:shouldSelectItemAtIndex:)] == NO) {
        return YES;
    } else {
        return [self.delegate carouselView:self shouldSelectItemAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)] == NO) {
        return;
    } else {
        self.possibleTargetingIndexPath = indexPath;
        [self.delegate carouselView:self didSelectItemAtIndex:indexPath.item]; // 보통 여기에서 - scrollToItemAtIndex:animated: 호출함
        self.possibleTargetingIndexPath = nil; // - scrollToItemAtIndex:animated:에서 사용된 후, nil 처리
    }
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(MGUCarouselCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:willDisplayCell:forItemAtIndex:)] == YES) {
        NSInteger numberOfItems = self.numberOfItems; // 섹션 한개만 봤을 때. 즉, 사용자가 인식하는 아이템의 갯수
        if (numberOfItems == 0) { return; }
        NSInteger index = indexPath.item % numberOfItems;
        [self.delegate carouselView:self willDisplayCell:cell forItemAtIndex:index];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:willDisplaySupplementaryView:forElementKind:atIndex:)] == YES) {
        NSInteger numberOfItems = self.numberOfItems; // 섹션 한개만 봤을 때. 즉, 사용자가 인식하는 아이템의 갯수
        if (numberOfItems == 0) { return; }
        NSInteger index = indexPath.item % numberOfItems;
        [self.delegate carouselView:self willDisplaySupplementaryView:view forElementKind:elementKind atIndex:index];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(MGUCarouselCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didEndDisplayingCell:forItemAtIndex:)] == YES) {
        [self.delegate carouselView:self didEndDisplayingCell:cell forItemAtIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView
didEndDisplayingSupplementaryView:(UICollectionReusableView *)view
      forElementOfKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(carouselView:didEndDisplayingSupplementaryView:forElementOfKind:atIndex:)] == YES) {
        [self.delegate carouselView:self didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndex:indexPath.item];
    }
}


#pragma mark -  <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCurrentIndex];
    if (scrollView.isTracking == YES) { // 손가락이 닿았을 때에만 호출한다.
        [self moveInfiniteOffsetWithScrollView:scrollView]; // 무한 모드에서만 작동한다.
    }
    if ([self.delegate respondsToSelector:@selector(carouselViewDidScroll:)] == YES) {
        [self.delegate carouselViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _panScene = YES;
    [self moveInfiniteOffsetWithScrollView:scrollView]; // 시작 시점에서 한번 잡아주자. 불필요할 수도 있지만. 한번 해주자.
    if ([self.delegate respondsToSelector:@selector(carouselViewWillBeginDragging:)] == YES) {
        [self.delegate carouselViewWillBeginDragging:self];
    }
    
    [self.transformer carouselViewWillBeginDragging:self]; // coverFlow rubberEffect에서 offset 정보를 확인하고 싶다.
    
    if (self.automaticSlidingInterval > 0.0) {
        [self cancelTimer];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView // 손가락이 떨어질 때, 앞으로 멈춰질 오프셋을 예측하여 알려준다.
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger numberOfItems = self.numberOfItems;
    if (numberOfItems == 0) { return; }
    if (CGPointEqualToPoint(velocity, CGPointZero) == NO) {
        _panScene = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(carouselViewWillEndDragging:targetIndex:)] == YES) {
        CGFloat contentOffset = (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) ?
        (*targetContentOffset).x : (*targetContentOffset).y;
        NSInteger targetItem = lround(contentOffset / self.collectionViewLayout.itemSpacing);
        [self.delegate carouselViewWillEndDragging:self targetIndex:targetItem % numberOfItems];
        // 이 객체를 사용하는 객체가 자신의 페이지 번호를 갱신하는데, 사용할 수 있다.
    }

    if (self.automaticSlidingInterval > 0) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(carouselViewDidEndDragging:willDecelerate:)] == YES) {
        [self.delegate carouselViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(carouselViewWillBeginDecelerating:)] == YES) {
        [self.delegate carouselViewWillBeginDecelerating:self];
    }
}

//! 스와이프로 스크롤이 돌다가 멈출때
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(carouselViewDidEndDecelerating:)] == YES) {
        [self.delegate carouselViewDidEndDecelerating:self];
    }
    _panScene = NO;
}

//! - setContentOffset:animated:(YES only) 및 - scrollRectToVisible:animated:(YES only) 메서드의 구현이 끝날 때 호출. YES only!
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(carouselViewDidEndScrollAnimation:)] == YES) {
        [self.delegate carouselViewDidEndScrollAnimation:self];
    }
    [self moveInfiniteOffsetWithScrollView:self.collectionView];
}


#pragma mark - Public method
- (void)updateCurrentIndex {
    NSInteger numberOfItems = self.numberOfItems;
    if (!self.isPossiblyRotating && numberOfItems > 0) { // 그냥 무조건 들어올듯하다.
        // 누군가 KVO를 사용하는 경우. currentIndex가 바뀌었음을 알려준다.
        NSInteger currentIndex = lround(self.scrollOffset) % numberOfItems; // 반올림. (나눗셈은 크게 의미 없을듯. 이미 했음.)
        if (currentIndex != self.currentIndex) {
            self.currentIndex = currentIndex;
        }
    } else if (numberOfItems == 0 && self.currentIndex != 0) {
        self.currentIndex = 0;
    }
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)elementKind {
    [self.collectionViewLayout registerClass:viewClass forDecorationViewOfKind:elementKind];
}

- (void)registerNib:(UINib *)nib forDecorationViewOfKind:(NSString *)elementKind {
    [self.collectionViewLayout registerNib:nib forDecorationViewOfKind:elementKind];
}

//! data source의 - carouselView:cellForItemAtIndex:메서드에서 호출한다.
- (__kindof MGUCarouselCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                             atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:self.dequeingSection];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[MGUCarouselCell class]] == NO) {
        NSCAssert(NO, @"Cell 클래스는 반드시 MGUCarouselCell의 서브 클래스여야한다.");
    }
    
    return (MGUCarouselCell *)cell;
}

- (__kindof MGUCarouselCell *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                 withReuseIdentifier:(NSString *)identifier
                                                            forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:self.dequeingSection];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                                                         withReuseIdentifier:identifier
                                                                                forIndexPath:indexPath];
    if ([cell isKindOfClass:[MGUCarouselCell class]] == NO) {
        NSCAssert(NO, @"Cell 클래스는 반드시 MGUCarouselCell의 서브 클래스여야한다.");
    }
    return (__kindof MGUCarouselCell *)cell;
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated { //! 잘 사용하지 않을듯. <- 버그 비슷한게 존재함.
    [self validationTestForIndex:index];
    
    NSIndexPath *indexPath;
    if (self.possibleTargetingIndexPath != nil && self.possibleTargetingIndexPath.item == index) {
        indexPath = self.possibleTargetingIndexPath;
    } else {
        indexPath = [self nearbyIndexPathFor:index];
    }
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
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
    [self.collectionView deselectItemAtIndexPath:indexPath animated:animated];
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
        [weakSelf moveInfiniteOffsetWithScrollView:self.collectionView];
    };

    if (animated == YES && completionBlock != nil) {
        CGPoint currentContentOffset = self.collectionView.contentOffset;
        self.displayLink.progressBlock = ^(CGFloat progress) {
            [weakSelf.collectionView setContentOffset:MGELerpPoint(progress, currentContentOffset, contentOffset)
                                             animated:NO];
        };
        self.displayLink.completionBlock = newCompletionBlock;
        self.displayLink.animationDuration = duration;
        [self.displayLink startAnimationWithStartProgress:0.0];
    } else if (animated == YES) { // animated == YES && completionBlock == nil
        [self.collectionView setContentOffset:contentOffset animated:YES];
        // animated == YES이므로 scrollViewDidEndScrollingAnimation:을 호출할 것이다. 거기에서 잡아주자.
    } else { // animated == NO : completionBlock 은 nil 일수도 있고 아닐 수도 있다.
        [self.collectionView setContentOffset:contentOffset animated:NO];
        newCompletionBlock();
    }
    //
    // 스크롤에서는 - scrollToItemAtIndexPath:atScrollPosition:animated: 메서드는 가급적 사용을 자제하고,
    // - setContentOffset:animated:를 사용하는 것이 좋다.
}

- (NSInteger)indexForCell:(MGUCarouselCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath == nil) {
        return NSNotFound;
    }
    
    return indexPath.item;
}

- (MGUCarouselCell * _Nullable)cellForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (MGUCarouselCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}

- (NSArray <__kindof MGUCarouselCell *>*)visibleCells {
    return self.collectionView.visibleCells;
}

- (NSArray<NSNumber *> *)indexesForVisibleItems {
    NSArray<NSIndexPath *> *indexPathsForVisibleItems = [self.collectionView indexPathsForVisibleItems];
    NSMutableArray<NSNumber *> *indexesForVisibleItems = [NSMutableArray arrayWithCapacity:indexPathsForVisibleItems.count];
    for (NSIndexPath *indexPath in indexPathsForVisibleItems) {
        [indexesForVisibleItems addObject:@(indexPath.item)];
    }
    return indexesForVisibleItems.copy;
}

- (MGUCarouselCell *_Nullable)supplementaryViewForElementKind:(NSString *)elementKind
                                                       atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (MGUCarouselCell *)[self.collectionView supplementaryViewForElementKind:elementKind atIndexPath:indexPath];
}

- (NSArray<__kindof MGUCarouselCell *> *)visibleSupplementaryViewsOfKind:(NSString *)elementKind {
    return (NSArray<__kindof MGUCarouselCell *> *)[self.collectionView visibleSupplementaryViewsOfKind:elementKind];
}

// NSInteger를 감싸는 NSNumber
- (NSArray <NSNumber *>*)indexesForVisibleSupplementaryElementsOfKind:(NSString *)elementKind {
    NSArray <NSIndexPath *>*indexPathsForVisibleSupplementaryElements =
    [self.collectionView indexPathsForVisibleSupplementaryElementsOfKind:elementKind];
    
    NSMutableArray<NSNumber *> *indexesForVisibleSupplementaryElements =
    [NSMutableArray arrayWithCapacity:indexPathsForVisibleSupplementaryElements.count];
    
    for (NSIndexPath *indexPath in indexPathsForVisibleSupplementaryElements) {
        [indexesForVisibleSupplementaryElements addObject:@(indexPath.item)];
    }
    return indexesForVisibleSupplementaryElements.copy;
}

// - layoutAttributesForItemAtIndexPath: 연결
- (__kindof MGUCarouselCellLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (__kindof MGUCarouselCellLayoutAttributes *)[self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
}

//- layoutAttributesForSupplementaryElementOfKind:atIndexPath: 연결. 이 프로젝트에서는 MGUCarouselSupplementaryViewLayoutAttributes를 사용하지 않는다.
- (__kindof MGUCarouselCellLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind
                                                                                    atIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self nearbyIndexPathFor:index];
    return (__kindof MGUCarouselCellLayoutAttributes *)[self.collectionView layoutAttributesForSupplementaryElementOfKind:kind
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
- (void)moveInfiniteOffsetWithScrollView:(UIScrollView *)scrollView {
    if (self.volumeType == MGUCarouselVolumeTypeInfinite) {
        NSInteger itemCount = self.numberOfItems;
        NSInteger sectionCount = self.numberOfSections;
        NSInteger realItemCount = itemCount * sectionCount;
        CGFloat maxOffset, contentOffset;
        if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
            maxOffset = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
            contentOffset = self.collectionView.contentOffset.x;
        } else {
            maxOffset = self.collectionView.contentSize.height - self.collectionView.frame.size.height;
            contentOffset = self.collectionView.contentOffset.y;
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
                
                if (self.scrollDirection == MGUCarouselScrollDirectionHorizontal) {
                    self.collectionView.contentOffset = CGPointMake(contentOffset, self.collectionView.contentOffset.y);
                } else {
                    self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, contentOffset);
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

/*
#pragma mark - FIXME: 지울 것이다.
- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths // 섹션 처리를 0 이 아닐 때에는 어떻게 할까? 이것은 아직 모르겠다.
                       animated:(BOOL)animated
                     dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
                     completion:(void(^_Nullable)(void))completionBlock {
    if (dataUpdateBlock == nil) {
        NSCAssert(FALSE, @"dataUpdateBlock 인수는 nil이 어서는 안된다.");
        return;
    }
    
    void (^batchUpdates)(void) = ^void(void) {
        [self.collectionView performBatchUpdates:^{
            self.collectionViewLayout.needsReprepare = YES;
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
            dataUpdateBlock();
        } completion:^(BOOL finished) {
            [self updateCurrentIndex];
            if (completionBlock != nil) {
                completionBlock();
            }
        }];
    };
    
    if (animated == YES) {
        batchUpdates();
    } else {
        [UIView performWithoutAnimation:^{
            batchUpdates();
        }];
    }
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths // - deleteItemsAtIndexPaths: 호출
                       animated:(BOOL)animated
                     dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
                     completion:(void(^_Nullable)(void))completionBlock {
    if (dataUpdateBlock == nil) {
        NSCAssert(FALSE, @"dataUpdateBlock 인수는 nil이 어서는 안된다.");
        return;
    }
    
    void (^batchUpdates)(void) = ^void(void) {
        dataUpdateBlock();
        [self.collectionView deleteItemsAtIndexPaths:indexPaths]; //! <- 여기에서 에러 메시지 발생한다. 막을 방법이 없다.
        [self.collectionView performBatchUpdates:^{
            self.collectionViewLayout.needsReprepare = YES;
            [self.collectionView reloadData];
            //! FIXME: 테스트 코드.
//            self.collectionViewLayout.needsReprepare = YES;
//            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
//            dataUpdateBlock();
        } completion:^(BOOL finished) {
            //! delete하는 행위는 - scrollViewDidScroll:를 호출하지 않으므로, 마지막 index를 지웠다면, currentIndex를 수정해야한다.
            [self updateCurrentIndex];
            if (completionBlock != nil) {
                completionBlock();
            }
        }];
    };
    
    if (animated == YES) {
        batchUpdates();
    } else {
        [UIView performWithoutAnimation:^{
            batchUpdates();
        }];
    }
    //
    // 에러 로그가 발생하기는 하지만, 이 방식이 제거시 contentOffset이 변할때, Frame이 안깨진다.
    // https://stackoverflow.com/questions/20948356/animating-contentoffset-changes-in-a-uicollectionview-on-deleteitemsatindexpaths
    // 원래식. 애플이 이렇게 하라고 했는데, delete 하면서 offset이 변하면 문제가 애니메이션이 끊긴다. 어쩔수 로그 메시지를 감수하고 위의 메서드를 사용.
//    void (^batchUpdates)(void) = ^void(void) {
//        [self.collectionView performBatchUpdates:^{
//            self.collectionViewLayout.needsReprepare = YES;
//            [self.collectionView deleteItemsAtIndexPaths:indexPaths];
//            dataUpdateBlock();
//        } completion:^(BOOL finished) { ... }];
//    };

}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath                // - moveItemAtIndexPath:toIndexPath: 호출
                toIndexPath:(NSIndexPath *)newIndexPath
                   animated:(BOOL)animated
                 dataUpdate:(void(^_Nonnull)(void))dataUpdateBlock
                 completion:(void(^_Nullable)(void))completionBlock {
    if (dataUpdateBlock == nil) {
        NSCAssert(FALSE, @"dataUpdateBlock 인수는 nil이 어서는 안된다.");
        return;
    }
    
    void (^batchUpdates)(void) = ^void(void) {
        [self.collectionView performBatchUpdates:^{
            self.collectionViewLayout.needsReprepare = YES;
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            dataUpdateBlock();
        } completion:^(BOOL finished) {
            [self updateCurrentIndex];
            if (completionBlock != nil) {
                completionBlock();
            }
        }];
    };

    if (animated == YES) {
        batchUpdates();
    } else {
        [UIView performWithoutAnimation:^{
            batchUpdates();
        }];
    }
}
 */

//- (void)reloadData {
//    self.collectionViewLayout.needsReprepare = YES;
//    [self.collectionView reloadData];
//}

//#pragma mark -  <UICollectionViewDataSource>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    if (self.dataSource == nil) {
//        self.numberOfSections = 0;
//        return 0; // 0이 맞는 것 같다. 그렇지만, 아래에서 걸르므로 크게 상관없을 것 같다.
//    }
//
//    self.numberOfItems = [self.dataSource numberOfItemsInCarouselView:self];
//
//    //! 이렇게 하는 것이 나을듯.
//    if (self.numberOfItems <= 0 ||
//        (self.volumeType != MGUCarouselVolumeTypeInfinite) ) { // 유한
//        self.numberOfSections = 1;
//        return 1; // 원본 코드는 return 0; 였다. 그런데, 삭제 시, 문제가 발생하므로 이렇게 하겠다.
//    }
//
//    self.numberOfSections = (self.numberOfItems > 1 || !self.removesInfiniteLoopForSingleItem) ? INT16_MAX/self.numberOfItems : 1;
//    return self.numberOfSections;
//    //
//    // INT16_MAX == 32767
//    // 무한으로 돌아갈때. 총 아이템의 갯수가 32767가 되게 섹션을 만든다. 즉, 순수아이템 갯수 * self.numberOfSections < 32767 개
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.numberOfItems;
//}
//
//- (MGUCarouselCell *)collectionView:(UICollectionView *)collectionView
//             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = indexPath.item;
//    self.dequeingSection = indexPath.section;
//    MGUCarouselCell *cell = [self.dataSource carouselView:self cellForItemAtIndex:index];
//    return cell;
//}
//
////! 이 메서드에서 nil을 반환하면 안된다. 구현했는데 안보이게 하고 싶다면 hidden 또는 alpha
////! - layoutAttributesForElementsInRect:에서 representedElementCategory가 UICollectionElementCategorySupplementaryView인 UICollectionViewLayoutAttributes를 호출하면 이게 발동된다. 따라서 wrap를 구현하지 않았을 경우에는 그 메서드에서 SupplementaryView에 대한 LayoutAttributes를 담아서는 안된다.
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath {
//    NSInteger index = indexPath.item;
//    self.dequeingSection = indexPath.section;
//    MGUCarouselCell *cell;
//    if ([self.dataSource respondsToSelector:@selector(carouselView:viewForSupplementaryElementOfKind:atIndex:)] == YES) {
//        cell = [self.dataSource carouselView:self viewForSupplementaryElementOfKind:kind atIndex:index];
//        if (cell != nil) {
//            cell.userInteractionEnabled = NO;
//            if ([kind isEqualToString:UICollectionElementKindSectionHeader] || [kind isEqualToString:UICollectionElementKindSectionFooter]) {
//                if (self.volumeType == MGUCarouselVolumeTypeFiniteWrap) {
//                    cell.hidden = NO;
//                } else {
//                    cell.hidden = YES;
//                }
//            }
//            return cell;
//        }
//    }
//
//    NSCAssert(FALSE, @"등록하지 않았다면 호출해서 되서는 안된다.");
//    return cell;
//
//}
