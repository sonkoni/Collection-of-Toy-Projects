//
//  MGACarouselScrollView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
@import GraphicsKit;
#import "MGACarouselScrollView.h"
#import "NSEvent+Extension.h"
#import "MGACarouselScrollViewDeceleratingController.h"
#import "MGACarouselView.h"
#import "MGACarouselView_Internal.h"

@interface MGACarouselScrollView ()
//! 2개를 따로 만들어준 이유는 손가락으로 굴러가는 도중에 프로그램모드로 애니메이팅한 후에 제스처의 잔류가 남아 있을 수 있으므로
//! 명시적으로 제스처 시작점에서 다시 설정하라는 의도이다.
@property (nonatomic, assign) BOOL gestureMode; // 유저와 상호작용
@property (nonatomic, assign) BOOL programMode; // 유저와 상호작용이 아닌 progrmatically하게 이동(animate YES Or NO)
@property (nonatomic, assign) NSEventPhase currentPhase; // 손가락붙어 있을 때 담당하는 Detecting
@property (nonatomic, assign) NSEventPhase currentMomentumPhase; // 손가락이 띄어지면 담당하는 Detecting
@property (nonatomic, assign) NSEventPhase previousPhase;
@property (nonatomic, assign) NSEventPhase previousMomentumPhase;
@property (nonatomic, assign) BOOL decelerating; // 롤링(손가락 때고 굴러감) 신이 발생하고 아직 끝나지 않았음을 의미함.
// 롤링이 발생하고 빠르게 제스처가 꺼어들면 scrollWheel:에서 메서드가 생략되는 일이 발생한다. 따라서 표지자가 필요하다.

@property (nonatomic, strong) MGACarouselScrollViewDeceleratingController *deceleratingController;
@property (nonatomic, strong) MGEDisplayLink *cleanupDisplayLink;
@property (nonatomic, copy, nullable) void (^touchUpCompletionBlock)(void); // 중간에 날라가면, 그냥 무시한다.

// @dynamic
@property (nonatomic, weak, readonly) MGACarouselView *carouselView;
@property (nonatomic, readonly) NSCollectionView *collectionView;
@property (nonatomic, readonly) NSCollectionViewLayout *collectionViewLayout;
@property (nonatomic, readonly) MGACarouselScrollDirection carouselScrollDirection;
@end

@implementation MGACarouselScrollView
@dynamic tracking;
@dynamic carouselView;
@dynamic collectionView;
@dynamic collectionViewLayout;
@dynamic carouselScrollDirection;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_deceleratingController invalidate];
    [_cleanupDisplayLink invalidate];
    _deceleratingController = nil;
    _cleanupDisplayLink = nil;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)scrollWheel:(NSEvent *)event {
    _currentEvent = event;
    if (_scrollEnabled == NO) { return; }
    self.previousPhase = self.currentPhase;
    self.previousMomentumPhase = self.currentMomentumPhase;
    self.currentPhase = event.phase;
    self.currentMomentumPhase = event.momentumPhase;
    if (self.currentPhase == NSEventPhaseBegan ||
        self.currentPhase == NSEventPhaseMayBegin) {
        _programMode = NO; // 상대를 끌 수만 있다. 킬 수 는 없다.
        _gestureMode = YES;
        _decelerating = NO;
        self.touchUpCompletionBlock = nil;
        if (self.currentPhase == NSEventPhaseBegan) {
            [self invalidate];
        }
    }
    
    if (self.currentMomentumPhase == NSEventPhaseBegan) {
        _gestureMode = NO;
        _decelerating = YES;
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
            [self.scrollViewDelegate scrollViewWillBeginDecelerating:self];
        }
        [self deceleratingCleanupAction];
        
    } else if (self.currentPhase == NSEventPhaseMayBegin) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewMayBeginScrolling:)]) {
            [self.scrollViewDelegate scrollViewMayBeginScrolling:self];
        }
    } else if (self.currentPhase == NSEventPhaseCancelled) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewCancelledScrolling:)]) {
            [self.scrollViewDelegate scrollViewCancelledScrolling:self];
        }
        [self calmCleanupAction];
    }
    if (_gestureMode == NO) {
        [self.nextResponder scrollWheel:event];
    } else {
        [super scrollWheel:event];
    }
    //
    // 발동 거는 단계 NSEventPhaseMayBegin : NSEventPhaseNone => 메서드 안쳐준다. cancel할 수도 있다.
    // 시작하는 단계 NSEventPhaseBegan : NSEventPhaseNone => scrollViewWillBeginScrolling: & scrollViewDidScroll:
    // 손가락이 붙어있는 상태에서 변화하고 있다면 => NSEventPhaseChanged : NSEventPhaseNone => scrollViewDidScroll:
    // 손가락이 때어지고 미끄러지면 => NSEventPhaseNone : NSEventPhaseChanged => scrollViewDidScroll:
    // 멈춤 단계 NSEventPhaseNone : NSEventPhaseEnded => scrollViewDidEndScrolling:
    // NSLog(@"--> [%@ : %@]", eventPhase, eventMomentumPhase);
}

/* 이 부분의 쓰임세와 타당성을 검증하지 못했다.
- (void)beginGestureWithEvent:(NSEvent *)event {
    [super beginGestureWithEvent:event];
}

- (BOOL)wantsForwardedScrollEventsForAxis:(NSEventGestureAxis)axis {
    return YES;
}

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis {
    return YES;
}

- (void)scrollClipView:(NSClipView *)clipView toPoint:(NSPoint)point {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.contentView setBoundsOrigin:point];
    [CATransaction commit];
    [super scrollClipView:clipView toPoint:point];
}
*/

// self.allowedTouchTypes = NSTouchTypeMaskDirect|NSTouchTypeMaskIndirect; 를 해야 받을 수 있다.
// 그런데, 불규칙적으로 호출이 안된다. cash 때문인지 아닌지도 모르겠다.
- (void)touchesBeganWithEvent:(NSEvent *)event {
    [super touchesBeganWithEvent:event];
    __weak __typeof(self) weakSelf = self;
    if (_decelerating == YES && [self isInsideLimitOffset] == YES) {
        _decelerating = NO;
        [self invalidate];
        [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:YES];
        _touchUpCompletionBlock = ^{
            [weakSelf calmCleanupAction];
        };
    }
    /*
    NSInteger nTouches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self].count;
    if (self.currentEvent.momentumPhase == NSEventPhaseChanged && nTouches == 1) {
        _remainCleanUp = YES;
    }
     */
    //
    // 스크롤링으로 굴러가는 도중에 한 손가락으로 멈추면 후 처리할 방법이 없으므로 이렇게 Detecting 한다.
}

- (void)touchesMovedWithEvent:(NSEvent *)event {
    [super touchesMovedWithEvent:event];
}

//! 그리고 Key Window가 아닐 때, 스크롤을 굴릴 수가 있고, 그 때, 손가락으로 멈추면 이 메서드가 호출되지 않는다.
//! [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:YES];를 받는 쪽이
//! NSApp.isActive를 검사해서 NO이면 천천히 멈추게 해야한다.
- (void)touchesEndedWithEvent:(NSEvent *)event {
    [super touchesEndedWithEvent:event];
    if (self.touchUpCompletionBlock != nil) {
        self.touchUpCompletionBlock();
        self.touchUpCompletionBlock = nil;
    }
}

- (void)touchesCancelledWithEvent:(NSEvent *)event {
    [super touchesCancelledWithEvent:event];
}

- (void)pressureChangeWithEvent:(NSEvent *)event {
    [super pressureChangeWithEvent:event];
    NSCollectionView *collectionView = self.documentView;
    CGPoint point = [event mgrLocationInView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:point];
    if (indexPath != nil) { // 셀을 세게 눌렀다면 취소해야지
        self.touchUpCompletionBlock = nil;
    }
    //
    // 압력을 감지한다. Touch가 아닌 클릭(딥하게 누르는 것)은 cell을 선택한 것으로 인식되므로 후 처리가 필요없다.
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGACarouselScrollView *self) {
    self.wantsLayer = YES;
    self.layer.masksToBounds = NO;
    self.hasHorizontalScroller = NO; // 이걸로 안가려짐
    self.hasVerticalScroller = NO; // 이걸로 안가려짐
    self.hasVerticalRuler = NO;
    self.hasHorizontalRuler = NO;
    self.drawsBackground = NO;
    self.backgroundColor = [NSColor clearColor];
    self.borderType = NSNoBorder;
    self.automaticallyAdjustsContentInsets = NO;
    self.contentInsets = NSEdgeInsetsZero;
    self.contentView.automaticallyAdjustsContentInsets = NO;
    self.contentView.contentInsets = NSEdgeInsetsZero;
    
    //! NSScrollView
    //    scrollView.automaticallyAdjustsContentInsets
    //    scrollView.contentInsets.
        
    //    scrollView.scrollerInsets
    
    //! NSClipView
    //    scrollView.automaticallyAdjustsContentInsets
    //    scrollView.contentInsets.
        
    //! NSView
    //    scrollView.alignmentRectInsets
    //    scrollView.additionalSafeAreaInsets
    //    scrollView.safeAreaInsets
    
    self->_scrollEnabled = YES;
    self->_gestureMode = NO;
    self->_programMode = NO;
    self->_decelerating = NO;
    self->_currentPhase = NSEventPhaseNone;
    self->_currentMomentumPhase = NSEventPhaseNone;
    self->_previousPhase = NSEventPhaseNone;
    self->_previousMomentumPhase = NSEventPhaseNone;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(scrollViewDidScroll:)
               name:NSScrollViewDidLiveScrollNotification // user-initiated
             object:self];
    [nc addObserver:self
           selector:@selector(scrollViewWillBeginScrolling:)
               name:NSScrollViewWillStartLiveScrollNotification // user-initiated
             object:self];
    [nc addObserver:self
           selector:@selector(scrollViewDidEndScrolling:)
               name:NSScrollViewDidEndLiveScrollNotification // user-initiated
             object:self];
    //! programatically 하게 이동했을 때, 이것으로 scrollViewDidScroll:을 Detect 해야한다.
    //! size change도 감지 해버리므로 setContentOffset:animated:completion: 에 한정해서 사용해야한다.
    self.contentView.postsBoundsChangedNotifications = YES; // 디폴트가 YES 이고 이거 변경하면 버그 발생함.
    [nc addObserver:self
           selector:@selector(clipViewBoundsChanged:)
               name:NSViewBoundsDidChangeNotification
             object:self.contentView];
    
    // 굴러가는 도중에 한 손가락으로 잡으면 손가락을 땠을 때, 뒷 처리를 못한다. 이걸 잡기 위해.
    // https://rymc.io/blog/2018/swipeable-nscollectionview/
    self.allowedTouchTypes = NSTouchTypeMaskDirect|NSTouchTypeMaskIndirect;
    self.wantsRestingTouches = YES;  // for thumb

    self->_cleanupDisplayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                                     easingFunctionType:MGEEasingFunctionTypeEaseOutSine
                                                          progressBlock:nil
                                                        completionBlock:nil];
    self->_deceleratingController = [MGACarouselScrollViewDeceleratingController new];
    self.deceleratingController.scrollView = self;
}


#pragma mark - 세터 & 게터
- (BOOL)isTracking {
    if (self.currentPhase == NSEventPhaseBegan ||
        self.currentPhase == NSEventPhaseChanged) {
        return YES;
    } else {
        return NO;
    }
}

- (MGACarouselView *)carouselView {
    return (MGACarouselView *)self.scrollViewDelegate;
}

- (NSCollectionView *)collectionView {
    return (NSCollectionView *)self.documentView;
}

- (NSCollectionViewLayout *)collectionViewLayout {
    return self.collectionView.collectionViewLayout;
}

- (MGACarouselScrollDirection)carouselScrollDirection {
    return self.carouselView.scrollDirection;
}


#pragma mark - Actions - NSNotification
- (void)scrollViewWillBeginScrolling:(NSNotification *)notification {
    if (self.scrollViewDelegate &&
        [self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginScrolling:)]) {
        [self.scrollViewDelegate scrollViewWillBeginScrolling:self];
    }
}

- (void)scrollViewDidScroll:(NSNotification *)notification {
    if (self.scrollViewDelegate &&
        [self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndScrolling:(NSNotification *)notification {
    if (_decelerating == NO) { // 스와이프 스크롤링 (손가락이 때어지고 굴러가는 것) 없이 그냥 멈춤.
        [self calmCleanupAction];
    }
}

- (void)clipViewBoundsChanged:(NSNotification *)notification {
    if (_programMode == YES) { // programatically하게 이동할때도 scrollViewDidScroll:를 때려줘야한다.
        [self scrollViewDidScroll:notification];
    }
}


#pragma mark - Actions
- (void)calmCleanupAction {
    __weak __typeof(self) weakSelf = self;
    [self.cleanupDisplayLink invalidate];
    CGPoint contentOffset = self.mgrContentOffset;
    CGPoint targetOffset =
    [self.collectionViewLayout targetContentOffsetForProposedContentOffset:contentOffset
                                                               withScrollingVelocity:CGPointZero];
    if (CGPointEqualToPoint(contentOffset, targetOffset) == NO) {
        self.cleanupDisplayLink.animationDuration = 0.2;
        self.cleanupDisplayLink.progressBlock = ^(CGFloat progress) {
            CGPoint offset = MGELerpPoint(progress, contentOffset, targetOffset);
            [weakSelf setMgrContentOffset:offset];
        };
        self.cleanupDisplayLink.completionBlock = ^{
            [weakSelf.scrollViewDelegate scrollViewDidEndScrolling:weakSelf rollingStop:NO];
        };
        [self.cleanupDisplayLink startAnimationWithStartProgress:0.0];
    }
}

- (void)deceleratingCleanupAction {
    __weak __typeof(self) weakSelf = self;
    CGFloat scrollingDelta = 0.0;
    CGPoint velocity = CGPointZero;
    MGACarouselScrollDirection carouselScrollDirection = self.carouselScrollDirection;
    if (carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        scrollingDelta = self.currentEvent.scrollingDeltaX;
        velocity.x = - scrollingDelta;
    } else {
        scrollingDelta = self.currentEvent.scrollingDeltaY;
        velocity.y = - scrollingDelta;
    }
    
    [self.deceleratingController invalidate];
    self.deceleratingController.startVelocity = scrollingDelta;
    CGFloat distance = self.deceleratingController.distance;
    CGPoint currentOffset = self.mgrContentOffset;
    CGPoint targetOffset = currentOffset;
    
    if (scrollingDelta >= 0.0) { // backward : offset이 감소함.
        distance = -distance;
    }
    
    if (carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        targetOffset.x = targetOffset.x + distance;
        if (targetOffset.x < 0.0 || targetOffset.x > self.mgrMaxOffset.x) {
            self.deceleratingController.overFlow = YES;
        } else {
            self.deceleratingController.overFlow = NO;
        }
    } else {
        targetOffset.y = targetOffset.y + distance;
        if (targetOffset.y < 0.0 || targetOffset.y > self.mgrMaxOffset.y) {
            self.deceleratingController.overFlow = YES;
        } else {
            self.deceleratingController.overFlow = NO;
        }
    }
    
    if (self.deceleratingController.overFlow == NO ||
        self.carouselView.decelerationDistance != [MGACarouselView automaticDistance]) {
        // velocity 값은 정확하지는 않다. 방향만 잡으면되고 일정한 값 이상이면 된다.
        targetOffset =
        [self.collectionViewLayout targetContentOffsetForProposedContentOffset:targetOffset
                                                         withScrollingVelocity:velocity];
        if (carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
            self.deceleratingController.targetDistance = ABS(targetOffset.x - currentOffset.x);
        } else {
            self.deceleratingController.targetDistance = ABS(targetOffset.y - currentOffset.y);
        }
    }
    
    self.deceleratingController.completionBlock = ^{ weakSelf.decelerating = NO; };
    [self.deceleratingController beginScrollWithStartOffset:currentOffset endOffset:targetOffset];
}

- (void)invalidate {
    [self.cleanupDisplayLink invalidate];
    [self.deceleratingController invalidate];
}

- (BOOL)isInsideLimitOffset { // 현재 오프셋이 한계를 초과했는지 여부. 한계를 초과했으면 NO
    CGPoint offset = self.mgrContentOffset;
    CGPoint maxOffset = self.mgrMaxOffset;
    MGACarouselScrollDirection carouselScrollDirection = self.carouselScrollDirection;
    if (carouselScrollDirection == MGACarouselScrollDirectionHorizontal) {
        if (offset.x < 0.0 || offset.x > maxOffset.x) {
            return NO;
        }
    } else if (offset.y < 0.0 || offset.y > maxOffset.y) {
        return NO;
    }
    return YES;
}


#pragma mark - NSScrollView+Extension
- (void)setContentOffset:(CGPoint)contentOffset
                animated:(BOOL)animated
              completion:(void (^)(void))completion {
    _gestureMode = NO; // 상대를 끌 수만 있다. 킬 수 는 없다.
    _programMode = YES;
    __weak __typeof(self) weakSelf = self;
    void (^newCompletionBlock)(void) = ^{
        if (completion) { completion(); }
        if (animated == YES &&
            weakSelf.scrollViewDelegate &&
            [weakSelf.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
            [weakSelf.scrollViewDelegate scrollViewDidEndScrollingAnimation:weakSelf];
        }
        weakSelf.programMode = NO;
        //! 유저 제스처 Event가 끝이 나지 않을 수 있다. 유저 제스처가 다시 시작하려고 할때. _gestureMode를 거기서 켜준다.
    };
    [super setContentOffset:contentOffset animated:animated completion:newCompletionBlock];
}


#pragma mark - DEBUG Helper
__unused static NSString * debug(NSEventPhase phase) {
    if (phase == NSEventPhaseNone) {
        return @"NSEventPhaseNone";
    } else if (phase == NSEventPhaseBegan) {
        return @"NSEventPhaseBegan";
    } else if (phase == NSEventPhaseStationary) {
        return @"NSEventPhaseStationary";
    } else if (phase == NSEventPhaseChanged) {
        return @"NSEventPhaseChanged";
    } else if (phase == NSEventPhaseEnded) {
        return @"NSEventPhaseEnded";
    } else if (phase == NSEventPhaseCancelled) {
        return @"NSEventPhaseCancelled";
    } else if (phase == NSEventPhaseMayBegin) {
        return @"NSEventPhaseMayBegin";
    } else {
        return @"혼합. 사실은 NS_OPTIONS";
    }
}
@end

/* iOS 비교
 //! 손가락 대서 시작
 // - scrollViewWillBeginDragging:


 //! 손가락 땔때. - 여기서 끝날 수도 있고 그렇지 않을 수도 있다.
 // - scrollViewWillEndDragging:withVelocity:targetContentOffset:
 // - scrollViewDidEndDragging:willDecelerate: 두 번째 인수로 여기에서 더 굴러가면 YES를 넣어준다.


 //! 손가락 때서 굴러 갈대. 굴러가면 아래의 두 개가 추가로 실행된다.
 //! 스와이프 롤링 영역.
 // - scrollViewWillBeginDecelerating:
 // - scrollViewDidEndDecelerating:


 //!-- 다 알거나 불필요한 것.
 // - scrollViewDidScroll:
 // - scrollViewShouldScrollToTop:
 // - scrollViewDidScrollToTop:
 
 */

