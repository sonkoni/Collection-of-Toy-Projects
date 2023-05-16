//
//  MGUButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUButton.h"

@interface CAAnimation (MGUButton)
- (void)basicSetupWithDuration:(CGFloat)duration;
@end
@implementation CAAnimation (MGUButton)
- (void)basicSetupWithDuration:(CGFloat)duration {
    self.duration            = duration;
    self.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.removedOnCompletion = NO;
    self.fillMode            = kCAFillModeForwards;
}
@end

@interface MGUButton ()
@property (nonatomic, weak, nullable) NSTimer *continuousPressTimer; //! NSTimer는 target을 강한참조하므로, weak 사용.
@property (nonatomic, strong) CALayer *rippleLayer;
@property (nonatomic, strong) MGUButtonConfiguration *config;
@property (nonatomic, strong, nullable) UIImage *mainImage;
@property (nonatomic, strong, nullable) UIImage *alternativeImage;
@property (nonatomic, strong) dispatch_group_t dispatchGroup;
@end

@implementation MGUButton

- (void)dealloc {
    [self cancelContinousPressIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame configuration:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rippleLayer.frame = self.layer.bounds;
    
    if (self.isRippleCircle == YES) {
        self.rippleLayer.cornerRadius = MIN(self.layer.bounds.size.width, self.layer.bounds.size.height) / 2.0;
    } else {
        self.rippleLayer.cornerRadius = 0.0f;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateButtonAppearance];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self updateButtonAppearance];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateButtonAppearance];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL begins = [super beginTrackingWithTouch:touch withEvent:event];

    if ((self.continuousPressIsPossible == YES) && (begins == YES)) {
        [self beginContinuousPressDelayed];
    }
    
    if (self.breadEffect == YES) {
        [self expandAnimation];
//        [self expandButton:YES];
    } else if (self.shrinkEffect == YES) {
        [self shrinkAnimation];
    }
    
    return begins;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.continuousPressIsPossible == YES) {
        [self cancelContinousPressIfNeeded];
    }
    
    if (self.breadEffect == YES) {
        [self inverseExpandAnimation];
//        [self expandButton:NO];
    } else if (self.shrinkEffect == YES) {
        [self inverseShrinkAnimation];
    }
}


#pragma mark - 생성 & 소멸
+ (instancetype)buttonWithConfiguration:(MGUButtonConfiguration * _Nullable)configuration {
    return [[MGUButton alloc] initWithFrame:CGRectZero configuration:configuration];
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(MGUButtonConfiguration * _Nullable)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
        if (configuration != nil) {
            _config = configuration;
            [self.config applyConfigurationOnMGUButton:self];
        }
    }
    return self;
}

static void CommonInit(MGUButton *self) {
    self->_dispatchGroup = dispatch_group_create();
    self->_cornerRadius = 1.0f;
    self->_breadEffect = NO;
    self->_shrinkEffect = NO;
    self->_isRippleCircle = YES;
    
    self->_buttonBackgroundColor = UIColor.whiteColor;                // Enable - Normal
    self->_buttonContentsColor   = UIColor.blackColor;                // Enable - Normal
    self->_highlightedButtonBackgroundColor = UIColor.grayColor;      // Enable - Highlighted
    self->_highlightedButtonContentsColor   = UIColor.lightGrayColor; // Enable - Highlighted
    self->_selectedButtonBackgroundColor    = UIColor.clearColor;      // Enable - Selected
    self->_selectedButtonContentsColor      = UIColor.blackColor;      // Enable - Selected
    
    self->_disabledButtonBackgroundColor    = UIColor.darkGrayColor;  // Disabled
    self->_disabledButtonContentsColor      = UIColor.blackColor;     // Disabled
    self->_buttonShadowColor = UIColor.clearColor;                    // Shadow
    self->_borderColor       = UIColor.clearColor;                    // border
    
    self->_rippleLayer = [CALayer layer];
    self.rippleLayer.opacity = 0.0;
    self->_rippleColor = [UIColor.grayColor colorWithAlphaComponent:0.2]; // _breadEffect, _shrinkEffect에 사용될 색깔.
    self.rippleLayer.backgroundColor = self.rippleColor.CGColor;
    [self.layer addSublayer:self.rippleLayer];
    self.rippleLayer.frame = self.layer.bounds;
    
    self->_continuousPressIsPossible = NO; // 백버튼의 경우 YES로 설정할 것이다.
    self->_continuousPressRepeatTimeInterval = 0.15f;
    self->_continuousPressDelay = 0.3f;
    
    self.layer.shadowOffset  = CGSizeMake(0, 1.0f);
    self.layer.shadowRadius  = 0.0f;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowColor   = self->_buttonShadowColor.CGColor;
    self.layer.cornerRadius  = self->_cornerRadius;
    self.layer.borderWidth   = 0.5f;
    self.layer.borderColor   = self->_borderColor.CGColor;
}


#pragma mark - 세터 & 게터
//! IB에서 보여지는 것을 염두해두고 만들었다.
- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    _buttonBackgroundColor = buttonBackgroundColor;
    self.backgroundColor = buttonBackgroundColor;
}

- (void)setButtonShadowColor:(UIColor *)buttonShadowColor {
    _buttonShadowColor = buttonShadowColor;
    self.layer.shadowColor = buttonShadowColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setButtonContentsColor:(UIColor *)buttonContentsColor {
    _buttonContentsColor = buttonContentsColor;
    [self setTitleColor:buttonContentsColor forState:UIControlStateNormal];
    self.imageView.tintColor = buttonContentsColor;
    self.tintColor = buttonContentsColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setButtonTitleLabelFont:(UIFont *)buttonTitleLabelFont {
    _buttonTitleLabelFont = buttonTitleLabelFont;
    self.titleLabel.font = buttonTitleLabelFont;
}

- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    self.rippleLayer.backgroundColor = rippleColor.CGColor;
}

- (void)setIsRippleCircle:(BOOL)isRippleCircle {
    _isRippleCircle = isRippleCircle;
    if (isRippleCircle == YES) {
        self.rippleLayer.cornerRadius = MIN(self.layer.bounds.size.width, self.layer.bounds.size.height) / 2.0;
    } else {
        self.rippleLayer.cornerRadius = 0.0f;
    }
}

- (MGUButtonConfiguration *)config {
    if (_config == nil) {
        _config = [MGUButtonConfiguration defaultConfiguration];
    }
    
    return _config;
}


#pragma mark - 컨트롤
- (void)updateButtonAppearance {
    if (self.isEnabled == NO) {
        self.backgroundColor     = self.disabledButtonBackgroundColor;
        self.imageView.tintColor = self.disabledButtonContentsColor;
        self.tintColor = self.imageView.tintColor;
    } else {
        if (self.isHighlighted) {
            self.backgroundColor     = self.highlightedButtonBackgroundColor;
            self.imageView.tintColor = self.highlightedButtonContentsColor;
            self.tintColor = self.imageView.tintColor;
        } else if (self.isSelected) {
            self.backgroundColor     = self.selectedButtonBackgroundColor;
            self.imageView.tintColor = self.selectedButtonContentsColor;
            self.tintColor = self.imageView.tintColor;
        } else {
            self.backgroundColor     = self.buttonBackgroundColor;
            self.imageView.tintColor = self.buttonContentsColor;
            self.tintColor = self.imageView.tintColor;
        }
    }
        
    [self setTitleColor:self.buttonContentsColor forState:UIControlStateNormal];
    [self setTitleColor:self.selectedButtonContentsColor forState:UIControlStateSelected];
    [self setTitleColor:self.highlightedButtonContentsColor forState:UIControlStateHighlighted];
    [self setTitleColor:self.disabledButtonContentsColor forState:UIControlStateDisabled];
}

- (void)expandAnimation {
    dispatch_group_enter(self.dispatchGroup);
    dispatch_group_enter(self.dispatchGroup);
    
    CFTimeInterval duration = 0.2f;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [expandAnimation basicSetupWithDuration:duration];
    [opacityAnimation basicSetupWithDuration:duration];
    
    expandAnimation.fromValue = @(1.0);
    expandAnimation.toValue = @(1.15);
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue   = @(1.0);
    
    if (self.layer.presentationLayer) {
        self.layer.transform = self.layer.presentationLayer.transform;
        expandAnimation.fromValue = @(self.layer.presentationLayer.transform.m11);
    }
    self.rippleLayer.opacity = 0.0;

    [CATransaction setCompletionBlock:^{
        dispatch_group_leave(self.dispatchGroup);
    }];
    [self.layer addAnimation:expandAnimation forKey:@"ExpandAnimationKey"];
    [self.rippleLayer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        [self realInverseExpandAnimation];
    });
}

- (void)inverseExpandAnimation {
    dispatch_group_leave(self.dispatchGroup);
    return;
}

- (void)realInverseExpandAnimation {
    CFTimeInterval duration = 0.2f;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [expandAnimation basicSetupWithDuration:duration];
    [opacityAnimation basicSetupWithDuration:duration];

    self.layer.transform = self.layer.presentationLayer.transform; // 항상 1.15
    self.rippleLayer.opacity = self.rippleLayer.presentationLayer.opacity;  // 항상 1.0
    expandAnimation.fromValue = @(1.15);
    expandAnimation.toValue = @(1.0);
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue   = @(0.0);
    
    [CATransaction setCompletionBlock:^{
        
    }];
    [self.layer addAnimation:expandAnimation forKey:@"ExpandAnimationKey"];
    [self.rippleLayer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)shrinkAnimation {
    dispatch_group_enter(self.dispatchGroup);
    dispatch_group_enter(self.dispatchGroup);
    
    CFTimeInterval duration = 0.2f;

    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [shrinkAnimation basicSetupWithDuration:duration];
    [opacityAnimation basicSetupWithDuration:duration];
    
    shrinkAnimation.fromValue = @(1.0);
    shrinkAnimation.toValue = @(0.85);
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue   = @(1.0);
    if (self.layer.presentationLayer) {
        self.layer.transform = self.layer.presentationLayer.transform;
        shrinkAnimation.fromValue = @(self.layer.presentationLayer.transform.m11);
    }
    self.rippleLayer.opacity = 0.0;
    
    [CATransaction setCompletionBlock:^{
        dispatch_group_leave(self.dispatchGroup);
    }];
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    [self.rippleLayer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        [self realInverseShrinkAnimation];
    });
}

- (void)inverseShrinkAnimation {
    dispatch_group_leave(self.dispatchGroup);
    return;
}

- (void)realInverseShrinkAnimation {
    CFTimeInterval duration = 0.2f;
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [shrinkAnimation basicSetupWithDuration:duration];
    [opacityAnimation basicSetupWithDuration:duration];

    self.layer.transform = self.layer.presentationLayer.transform; // 항상 0.85
    self.rippleLayer.opacity = self.rippleLayer.presentationLayer.opacity;  // 항상 1.0
    shrinkAnimation.fromValue = @(0.85);
    shrinkAnimation.toValue = @(1.0);
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue   = @(0.0);
    
    [CATransaction setCompletionBlock:^{
        
    }];
    
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    [self.rippleLayer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)switchMainImage {
    [self setImage:self.mainImage forState:UIControlStateNormal];
}

- (void)switchAlternativeImage {
    [self setImage:self.alternativeImage forState:UIControlStateNormal];
}


#pragma mark - long press repeatable
- (void)beginContinuousPressDelayed {
    [self performSelector:@selector(triggerTimer)
               withObject:nil
               afterDelay:self.continuousPressDelay];
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
        //! + scheduledTimerWithTimeInterval:target:selector:userInfo:repeats: 메서드는 timer 부착까지 포함됨.
        self.continuousPressTimer = [NSTimer timerWithTimeInterval:self.continuousPressRepeatTimeInterval
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


#pragma mark -  심플 액션. - 잘 사용안할 것 같아서, 외부에서 조정하게 만들었다.
- (void)pulse {
    CAKeyframeAnimation *pulseAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    pulseAnimation.duration        = 0.5f;
    pulseAnimation.removedOnCompletion = NO;       // default 는 YES이다.
    pulseAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준다.
    pulseAnimation.calculationMode = kCAAnimationPaced;
    pulseAnimation.values   = @[@(1.0f), @(1.05), @(0.975), @(1.0)];
    
    [CATransaction setCompletionBlock:^{}];
    
    [self.layer addAnimation:pulseAnimation forKey:@"PulseAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    self.layer.transform = CATransform3DIdentity;
    [CATransaction commit];
    //
    //pulseAnimation.calculationMode = kCAAnimationLinear;
    //pulseAnimation.keyTimes = @[@(0.0), @(0.5), @(0.75), @(1.0)];
    //pulseAnimation.values   = @[@(1.0f), @(1.05), @(1.0), @(0.95), @(1.0)];
}
- (void)flash {
    CABasicAnimation *flashAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashAnimation.fromValue = @(1.0);
    flashAnimation.toValue = @(0.2);
    flashAnimation.autoreverses = YES;
    flashAnimation.repeatCount = 1;
    flashAnimation.removedOnCompletion = YES;
    flashAnimation.fillMode = kCAFillModeBackwards;
    flashAnimation.duration = 0.25;
    flashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [CATransaction setCompletionBlock:^{}];
    
    [self.layer addAnimation:flashAnimation forKey:@"FlashAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    self.layer.opacity = 1.0;
    [CATransaction commit];
}
- (void)shake {
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.fromValue = [NSNumber numberWithFloat:(-5.0)];
    shakeAnimation.toValue = [NSNumber numberWithFloat:(5.0)];
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = 2;
    shakeAnimation.duration = 0.05;
    shakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [CATransaction setCompletionBlock:^{
        //NSLog(@"컴플리션!");
    }];
    
    [self.layer addAnimation:shakeAnimation forKey:@"ShakeAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [CATransaction commit];
}
- (void)glowON {
    UIColor *color = self.currentTitleColor;
    self.titleLabel.layer.shadowColor = [color CGColor];
    self.titleLabel.layer.shadowRadius = 5.0f;
    self.titleLabel.layer.shadowOpacity = .9;
    self.titleLabel.layer.shadowOffset = CGSizeZero;
}
- (void)glowOFF {
    UIColor *color = self.currentTitleColor;
    self.titleLabel.layer.shadowColor = [color CGColor];
    self.titleLabel.layer.shadowRadius = 5.0f;
    self.titleLabel.layer.shadowOpacity = 0.0;
    self.titleLabel.layer.shadowOffset = CGSizeZero;
}
@end

/*
   UIImageSymbolConfiguration *playPause =
   [UIImageSymbolConfiguration configurationWithPointSize:26.5
                                                   weight:UIImageSymbolWeightBold
                                                    scale:UIImageSymbolScaleLarge];
   
   UIImageSymbolConfiguration *backwardForward =
   [UIImageSymbolConfiguration configurationWithPointSize:17.0
                                                   weight:UIImageSymbolWeightBold
                                                    scale:UIImageSymbolScaleLarge];
   
   UIImage *play = [UIImage systemImageNamed:@"play.fill" withConfiguration:playPause];
   UIImage *backward = [UIImage systemImageNamed:@"backward.fill" withConfiguration:backwardForward];
   UIImage *forward = [UIImage systemImageNamed:@"forward.fill" withConfiguration:backwardForward];
   
   [self.button1 setImage:play forState:UIControlStateNormal];
   [self.button2 setImage:backward forState:UIControlStateNormal];
   [self.button3 setImage:forward forState:UIControlStateNormal];

   self.button1.tintColor = UIColor.blackColor;
   self.button2.tintColor = UIColor.blackColor;
   self.button3.tintColor = UIColor.blackColor;
*/
//    pulse
//    CASpringAnimation *pulseAnimation = [CASpringAnimation animationWithKeyPath:@"transform.scale.xy"];
//    pulseAnimation.fromValue = @(1.0);
//    pulseAnimation.toValue = @(1.05);
//    pulseAnimation.autoreverses = YES;
//    pulseAnimation.repeatCount = 1;
//    pulseAnimation.initialVelocity = 0.5;
//    //pulseAnimation.damping = 5.0;
//    pulseAnimation.damping = 0.7;
//    pulseAnimation.duration = pulseAnimation.settlingDuration; //! <- Api:Core Animation/CASpringAnimation/settlingDuration
//    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//
//    [CATransaction setCompletionBlock:^{}];
//
//    [self.layer addAnimation:pulseAnimation forKey:@"PulseAnimationKey"];
//
//    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
//    [CATransaction setDisableActions:YES];
//    self.layer.transform = CATransform3DIdentity;
//    [CATransaction commit];

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    
//    UITouch *touch   = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    
//    [CATransaction setDisableActions:YES];
//    self.rippleLayer.position = location;
//    [self startRippleAnimation];
//}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    
//    UITouch *touch   = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    
//    [CATransaction setDisableActions:YES];
//    self.rippleLayer.position = location;
//}
//
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    [self stopRippleAnimation];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
//    [self stopRippleAnimation];
//}
