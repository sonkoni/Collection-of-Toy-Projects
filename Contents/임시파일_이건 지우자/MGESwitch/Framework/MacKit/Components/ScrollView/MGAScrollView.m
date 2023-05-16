//
//  MGAScrollView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAScrollView.h"
#import "NSScrollView+Extension.h"
#import "NSEvent+Extension.h"
#import <QuartzCore/QuartzCore.h>

@interface MGAScrollView ()
//! 2개를 따로 만들어준 이유는 손가락으로 굴러가는 도중에 프로그램모드로 애니메이팅한 후에 제스처의 잔류가 남아 있을 수 있으므로
//! 명시적으로 제스처 시작점에서 다시 설정하라는 의도이다.
@property (nonatomic, assign) BOOL gestureMode; // 유저와 상호작용
@property (nonatomic, assign) BOOL programMode; // 유저와 상호작용이 아닌 progrmatically하게 이동(animate YES Or NO)
@property (nonatomic, assign) NSEventPhase currentPhase; // 손가락붙어 있을 때 담당하는 Detecting
@property (nonatomic, assign) NSEventPhase currentMomentumPhase; // 손가락이 띄어지면 담당하는 Detecting
@property (nonatomic, assign) NSEventPhase previousPhase;
@property (nonatomic, assign) NSEventPhase previousMomentumPhase;
@property (nonatomic, assign) BOOL remainMomentum; // 롤링(손가락 때고 굴러감) 신이 발생하고 아직 끝나지 않았음을 의미함.
// 롤링이 발생하고 빠르게 제스처가 꺼어들면 scrollWheel:에서 메서드가 생략되는 일이 발생한다. 따라서 표지자가 필요하다.
@property (nonatomic, assign) BOOL remainCleanUp; // 굴러가는 도중에 한 손가락으로 멈추면 손가락을 땠을 때, 정리를 하지 못한다.
@end

@implementation MGAScrollView
@dynamic tracking;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        _remainCleanUp = NO;
    }
    
    if (_gestureMode == NO) { return; } // setContentOffset:animated:completion: 에서 끌 수 있다.
    if (self.currentMomentumPhase == NSEventPhaseBegan) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
            [self.scrollViewDelegate scrollViewWillBeginDecelerating:self];
        }
        _remainMomentum = YES;
    } else if (self.currentPhase == NSEventPhaseMayBegin) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewMayBeginScrolling:)]) {
            [self.scrollViewDelegate scrollViewMayBeginScrolling:self];
        }
    } else if (self.currentPhase == NSEventPhaseCancelled) {
        if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewCancelledScrolling:)]) {
            [self.scrollViewDelegate scrollViewCancelledScrolling:self];
        }
    }

    [super scrollWheel:event];
    //
    // 발동 거는 단계 NSEventPhaseMayBegin : NSEventPhaseNone => 메서드 안쳐준다. cancel할 수도 있다.
    // 시작하는 단계 NSEventPhaseBegan : NSEventPhaseNone => scrollViewWillBeginScrolling: & scrollViewDidScroll:
    // 손가락이 붙어있는 상태에서 변화하고 있다면 => NSEventPhaseChanged : NSEventPhaseNone => scrollViewDidScroll:
    // 손가락이 때어지고 미끄러지면 => NSEventPhaseNone : NSEventPhaseChanged => scrollViewDidScroll:
    // 멈춤 단계 NSEventPhaseNone : NSEventPhaseEnded => scrollViewDidEndScrolling:
    // NSLog(@"--> [%@ : %@]", eventPhase, eventMomentumPhase);
}

/* 이 부분의 쓰임세와 타당성을 검증하지 못했다.
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
 
- (void)scrollClipView:(NSClipView *)clipView toPoint:(NSPoint)point {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.contentView setBoundsOrigin:point];
    [CATransaction commit];
    [super scrollClipView:clipView toPoint:point];
}

- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis {
    return YES;
}
- (BOOL)wantsForwardedScrollEventsForAxis:(NSEventGestureAxis)axis {
    return YES;
}

*/
// self.allowedTouchTypes = NSTouchTypeMaskDirect|NSTouchTypeMaskIndirect; 를 해야 받을 수 있다.
// 그런데, 불규칙적으로 호출이 안된다. cash 때문인지 아닌지도 모르겠다.
- (void)touchesBeganWithEvent:(NSEvent *)event {
    [super touchesBeganWithEvent:event];
    NSInteger nTouches = [event touchesMatchingPhase:NSTouchPhaseTouching inView:self].count;
    if (self.currentEvent.momentumPhase == NSEventPhaseChanged && nTouches == 1) {
        _remainCleanUp = YES;
    } else {
        // _remainCleanUp = NO; <- 여기는 안하는게 좋을듯. 종료도 안됬는데, 연달아 칠 수도 있다.
        // 굴러가는 도중에 손가락으로 따닥(손가락 두 개) 빠르게 치고 올리면 이렇게 될 수 있다.
    }
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
    if (_remainCleanUp == YES) {
        _remainCleanUp = NO;
        [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:NO];
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
        _remainCleanUp = NO;
    }
    //
    // 압력을 감지한다. Touch가 아닌 클릭(딥하게 누르는 것)은 cell을 선택한 것으로 인식되므로 후 처리가 필요없다.
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGAScrollView *self) {
    self.wantsLayer = YES;
    self.layer.masksToBounds = NO;
    self.hasHorizontalScroller = NO; // 이걸로 안가려짐
    self.hasVerticalScroller = NO; // 이걸로 안가려짐
    self.hasVerticalRuler = NO;
    self.hasHorizontalRuler = NO;
    self.drawsBackground = NO;
    self.backgroundColor = [NSColor clearColor];
    self.borderType = NSNoBorder;
    self.contentView.automaticallyAdjustsContentInsets = NO;
    self.contentView.contentInsets = NSEdgeInsetsZero;
    
    self->_scrollEnabled = YES;
    self->_gestureMode = NO;
    self->_programMode = NO;
    self->_remainMomentum = NO;
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


#pragma mark - Actions
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
    if (self.scrollViewDelegate &&
        [self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrolling:rollingStop:)]) {
        if (self.currentPhase == NSEventPhaseEnded && self.currentMomentumPhase == NSEventPhaseNone) {
            [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:NO];
        } else if (self.currentPhase == NSEventPhaseNone && self.currentMomentumPhase == NSEventPhaseEnded) {
            [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:YES];
            _remainMomentum = NO;
            //
            // 손가락을 때고나서 어느 굴러가는 상황이 발생했다가 멈췄다. 자연스럽게 멈추든. 강제로 손가락으로 멈추든 구분할 수 없다.
        } else if (_remainMomentum == YES) {
            [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:YES];
            _remainMomentum = NO;
        } else {
            [self.scrollViewDelegate scrollViewDidEndScrolling:self rollingStop:NO];
        }
    }
}

- (void)clipViewBoundsChanged:(NSNotification *)notification {
    if (_programMode == YES) { // programatically하게 이동할때도 scrollViewDidScroll:를 때려줘야한다.
        [self scrollViewDidScroll:notification];
    }
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
