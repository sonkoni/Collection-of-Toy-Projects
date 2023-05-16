//
//  MMKeyboardButton.m
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUNumKeyboardButton.h"

@interface MGUNumKeyboardButton ()
@property (nonatomic, weak, nullable) NSTimer *continuousPressTimer; // NSTimer는 target을 강한참조하므로, 순환참조를 피하기 위해 weak를 사용한다.
@property (nonatomic, assign) NSTimeInterval continuousPressRepeatTimeInterval;
@end

@implementation MGUNumKeyboardButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)dealloc {
    [self cancelContinousPressIfNeeded];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateButtonAppearance];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self updateButtonAppearance];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL begins = [super beginTrackingWithTouch:touch withEvent:event];
    
    if ((self.continuousPressIsPossible == YES) && (begins == YES)) {
        [self beginContinuousPressDelayed];
    }
    
    return begins;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    if (self.continuousPressIsPossible == YES) {
        [self cancelContinousPressIfNeeded];
    }
}

//! highlighted 가 이동하는 효과를 제대로 적용하기 위해.
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray <UIGestureRecognizer *>*gestureRecognizers = touch.gestureRecognizers;
    for (UIPanGestureRecognizer *gestureRecognizer in gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
            event.type == UIEventTypeTouches) { // 취소의 원인이 다른 터치라는 뜻.
            UIView *gestureRecognizerView = gestureRecognizer.view;
            CGRect relativeRect = [self convertRect:self.bounds toView:gestureRecognizerView];
            if (CGRectContainsRect(gestureRecognizerView.bounds, relativeRect) == YES) {
                return;
            }
        }
    }
    
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - 생성 & 소멸
static void CommonInit(MGUNumKeyboardButton *self) {
    self->_buttonBackgroundColor = [UIColor whiteColor];                // Enable - Normal
    self->_buttonContentsColor   = [UIColor blackColor];                // Enable - Normal
    self->_highlightedButtonBackgroundColor = [UIColor grayColor];      // Enable - Highlighted
    self->_highlightedButtonContentsColor   = [UIColor lightGrayColor]; // Enable - Highlighted
    self->_disabledButtonBackgroundColor    = [UIColor darkGrayColor];  // Disabled
    self->_disabledButtonContentsColor      = [UIColor blackColor];     // Disabled
    self->_buttonShadowColor = [UIColor blackColor];                    // Shadow
    self->_borderColor       = [UIColor redColor];                      // border
    
    self->_usesRoundedCorners  = NO;
    self->_continuousPressIsPossible = NO; // 백버튼의 경우 YES로 설정할 것이다.
    self->_continuousPressRepeatTimeInterval = 0.15;
    
    self.layer.shadowOffset  = CGSizeMake(0, 1.0);
    self.layer.shadowRadius  = 0.0;
    self.layer.shadowOpacity = 0.0;
    self.layer.cornerRadius  = 0.0;
    self.layer.borderWidth   = 0.0;
}


#pragma mark - 세터 & 게터
- (void)setUsesRoundedCorners:(BOOL)usesRoundedCorners {
    _usesRoundedCorners = usesRoundedCorners;
    //self.layer.cornerRadius  = (_usesRoundedCorners) ? 4.0 : 0.0;
    self.layer.cornerRadius  = (_usesRoundedCorners) ? 7.0 : 0.0;
    self.layer.shadowOpacity = (_usesRoundedCorners) ? 1.0 : 0.0;
    self.layer.borderWidth   = (_usesRoundedCorners) ? 0.5 : 0.0;
}


#pragma mark - 컨트롤
- (void)updateButtonAppearance {
    if (self.isEnabled == NO) {
        self.backgroundColor     = self.disabledButtonBackgroundColor;
        self.imageView.tintColor = self.disabledButtonContentsColor;
        self.tintColor = self.imageView.tintColor;
    } else {
        if (self.isHighlighted || self.isSelected) {
            self.backgroundColor     = self.highlightedButtonBackgroundColor;
            self.imageView.tintColor = self.highlightedButtonContentsColor;
            self.tintColor = self.imageView.tintColor;
        } else {
            self.backgroundColor     = self.buttonBackgroundColor;
            self.imageView.tintColor = self.buttonContentsColor;
            self.tintColor = self.imageView.tintColor;
        }
    }
    
    self.layer.shadowColor = self.buttonShadowColor.CGColor;
    self.layer.borderColor = self.borderColor.CGColor;
    
    [self setTitleColor:self.buttonContentsColor forState:UIControlStateNormal];
    [self setTitleColor:self.highlightedButtonContentsColor forState:UIControlStateSelected];
    [self setTitleColor:self.highlightedButtonContentsColor forState:UIControlStateHighlighted];
    [self setTitleColor:self.disabledButtonContentsColor forState:UIControlStateDisabled];
}


#pragma mark - long press repeatable
- (void)beginContinuousPressDelayed {
    [self performSelector:@selector(triggerTimer)
               withObject:nil
               afterDelay:self.continuousPressRepeatTimeInterval * 2.0f];
}

- (void)cancelContinousPressIfNeeded {
    [NSObject cancelPreviousPerformRequestsWithTarget:self // 시작되지 않았다면 취소가 될 것이다.
                                             selector:@selector(triggerTimer)
                                               object:nil];

    if (self.continuousPressTimer != nil) { // 시작했다면, 타이머를 죽여버릴 것이다.
        [self.continuousPressTimer invalidate];
        self.continuousPressTimer = nil;
    }
}

- (void)triggerTimer {
    if (self.isTracking == YES) {
        //! 왠지 + timerWithTimeInterval:target:selector:userInfo:repeats: 이걸 쓰는게 나을듯. 아래의 메서드는 timer 부착까지 포함된듯.
        self.continuousPressTimer = [NSTimer scheduledTimerWithTimeInterval:self.continuousPressRepeatTimeInterval
                                                                     target:self
                                                                   selector:@selector(notifyContinuousPressRepeatedly:)
                                                                   userInfo:nil
                                                                    repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.continuousPressTimer forMode:NSRunLoopCommonModes];
        self.continuousPressTimer.tolerance = 0.1; // 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
    }
}

- (void)notifyContinuousPressRepeatedly:(NSTimer *)timer {
    if (self.isTracking == NO) {
        [self cancelContinousPressIfNeeded];
    } else {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
//
// - performSelector:withObject:afterDelay: 와 + cancelPreviousPerformRequestsWithTarget:selector:object: 는 짝을 이룬다.
// 실행과 취소에 해당한다. 위키 참고하라.
//
