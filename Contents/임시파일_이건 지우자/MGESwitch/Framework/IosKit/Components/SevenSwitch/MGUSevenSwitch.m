//
//  MGUSevenSwitch.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSevenSwitch.h"
#import "MGUSevenKnobView.h"
#import "UIFeedbackGenerator+Extension.h"

NSNotificationName const MGUSevenSwitchStateChangedNotification = @"MGUSevenSwitchStateChangedNotification";

static void basicSettingForCAAnimation(CAAnimation * animation);

@interface MGUSevenSwitch ()
@property (nonatomic, assign) CGRect previousRect;

//! 손잡이에 해당하는 동그란 뷰이다.
@property (nonatomic, strong) MGUSevenKnobView *knobView;
@property (nonatomic, strong) UIImageView *knobImageView;
@property (nonatomic, strong) UIImageView *onImageView;
@property (nonatomic, strong) UIImageView *offImageView;
@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) UILabel *offLabel;

@property (nonatomic, assign) BOOL startSwitchState;        // 터치가 시작될 때, 스위치의 ON OFF 상태
@property (nonatomic, assign) BOOL didChangeWhileTracking;  // 터치가 종료될때까지 한번이라도 최초 상태를 벗어나는 움직임이 존재했는가를 의미한다.
@property (nonatomic, strong) MGUSevenSwitchConfiguration *configuration;

@property (nonatomic, strong) UIView *decoView;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@property (nonatomic, strong) UIView *sevenBackgroundView; // 혹시나 애플이랑 이름이 겹칠까봐. 보더가 그림자를 먹는 이유로 인하여 따로 만들었다.
@end

@implementation MGUSevenSwitch

- (CGSize)sizeThatFits:(CGSize)size {
//    CGFloat height = 22.0;
//    CGFloat width  = height * 1.75;
    return CGSizeMake(51.0, 31.0);
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.bounds, CGRectZero) == NO && CGRectEqualToRect(self.bounds, self.previousRect) == NO) {
        _previousRect = self.bounds;
        CommonInit(self);
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    self.knobView.expand = YES;
    self.startSwitchState = self.switchOn;
    self.didChangeWhileTracking = NO;

    if (self.switchOn == NO) {
        [self decoViewAnimationForExand:NO];
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGFloat x = [touch locationInView:self].x;
    if ( (x > self.frame.size.width / 2) && (self.switchOn == NO) ) {          // off 상태인데 on  상태 영역을 넘어갔다면
        self.switchOn = YES;
        self.didChangeWhileTracking = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
        [self impactOccurred];
    } else if ( (x < self.frame.size.width / 2) && (self.switchOn == YES) ) {  // on  상태인데 off 상태 영역을 넘어갔다면
        self.switchOn = NO;
        self.didChangeWhileTracking = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
        [self impactOccurred];
    }

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];

    if (self.didChangeWhileTracking == NO) {
        self.switchOn = !self.switchOn;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self impactOccurred];
    } else if (self.switchOn != self.startSwitchState) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    self.knobView.expand        = NO; // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
    self.didChangeWhileTracking = NO; // <- 다시 재설정한다.
    
    if (self.switchOn == NO) {
        [self decoViewAnimationForExand:YES];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self endTrackingWithTouch:nil withEvent:event];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithCenter:(CGPoint)center
                      switchOn:(BOOL)switchOn
                 configuration:(MGUSevenSwitchConfiguration *)configuration {
    CGFloat height = 31.0;
    CGFloat width  = 51.0;
    CGRect defaultRectFrame = CGRectMake(center.x - (width  / 2.0),
                                         center.y - (height / 2.0),
                                         width,
                                         height);
    
    self = [self initWithFrame:defaultRectFrame switchOn:switchOn configuration:configuration];
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame
                     switchOn:(BOOL)switchOn
                configuration:(MGUSevenSwitchConfiguration *)configuration {
    self = [super initWithFrame: frame];
    if (self) {
        _previousRect = self.bounds;
        if (configuration != nil) {
            self.configuration = configuration;
        } else {
            self.configuration = [MGUSevenSwitchConfiguration defaultConfiguration];
        }
        _switchOn = switchOn;
        _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleLight];
        
        if (CGRectEqualToRect(_previousRect, CGRectZero) == NO) {
            CommonInit(self);
        }
    }
    return self;
}


static void CommonInit(MGUSevenSwitch *self) {
    for (UIView  *view  in [self.subviews reverseObjectEnumerator]) { [view removeFromSuperview]; }
    [self.layer removeAllAnimations];
    self->_cornerRadius = self.configuration.cornerRadius;
    self->_knobRatio = self.configuration.knobRatio;
    self->_backAccessoryView = self.configuration.backAccessoryView;
    self->_knobAccessoryView = self.configuration.knobAccessoryView;
    
    self->_decoViewColor = self.configuration.decoViewColor;
    self->_offTintColor = self.configuration.offTintColor;
    self->_onTintColor = self.configuration.onTintColor;
    self->_offBorderColor = self.configuration.offBorderColor;
    self->_onBorderColor = self.configuration.onBorderColor;
    
    self->_offThumbTintColor  = self.configuration.offThumbTintColor;
    self->_onThumbTintColor   = self.configuration.onThumbTintColor;
    self->_shadowColor        = self.configuration.shadowColor;
    
    self->_knobImage = self.configuration.knobImage;
    self->_onImage   = self.configuration.onImage;
    self->_offImage  = self.configuration.offImage;
    self->_onLabelTitle  = self.configuration.onLabelTitle;
    self->_offLabelTitle = self.configuration.offLabelTitle;
    self->_onLabelTextAlignment = self.configuration.onLabelTextAlignment;
    self->_offLabelTextAlignment = self.configuration.offLabelTextAlignment;
    self->_onLabelTextColor  = self.configuration.onLabelTextColor;
    self->_offLabelTextColor  = self.configuration.offLabelTextColor;
    self->_onLabelTextFont  = self.configuration.onLabelTextFont;
    self->_offLabelTextFont  = self.configuration.offLabelTextFont;
    
    self.clipsToBounds = NO;       // knob의 shadow를 위해
    self.layer.masksToBounds = NO; // knob의 shadow를 위해
//    self.layer.borderWidth = [self borderWidth];
//
//    if (self.switchOn == YES) {
//        self.layer.borderColor = self.onBorderColor.CGColor;
//        self.layer.backgroundColor = self.onTintColor.CGColor;
//    } else {
//        self.layer.borderColor = self.offBorderColor.CGColor;
//        self.layer.backgroundColor = self.offTintColor.CGColor;
//    }

    [self setupBackgroundView];   // backgroundView setup
    [self setupdecoView];   // decoView setup
    [self setupImageViews]; // image view setup
    [self setupLabels];     // labels setup
    [self setupknobView];   // knobView setup

    [self setCornerRadius:self.cornerRadius];  // knob과 self의 radius를 설정한다.
//    [self setIsRounded:self.isRounded]; // knob과 self의 radius를 설정한다.
}

- (void)setupBackgroundView {
    _sevenBackgroundView = [UIView new];
    self.sevenBackgroundView.clipsToBounds = NO;       // knob의 shadow를 위해
    self.sevenBackgroundView.layer.masksToBounds = NO; // knob의 shadow를 위해
    self.sevenBackgroundView.userInteractionEnabled = NO;
    self.sevenBackgroundView.layer.borderWidth = [self borderWidth];
    if (self.switchOn == YES) {
        self.sevenBackgroundView.layer.borderColor = self.onBorderColor.CGColor;
        self.sevenBackgroundView.layer.backgroundColor = self.onTintColor.CGColor;
    } else {
        self.sevenBackgroundView.layer.borderColor = self.offBorderColor.CGColor;
        self.sevenBackgroundView.layer.backgroundColor = self.offTintColor.CGColor;
    }
    [self addSubview:self.sevenBackgroundView];
    self.sevenBackgroundView.frame = self.bounds;
    self.sevenBackgroundView.translatesAutoresizingMaskIntoConstraints = YES;
    self.sevenBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    if (self.backAccessoryView != nil) {
        self.backAccessoryView.userInteractionEnabled = NO;
        self.backAccessoryView.frame = self.bounds;
        [self addSubview:self.backAccessoryView];
        self.backAccessoryView.translatesAutoresizingMaskIntoConstraints = YES;
        self.backAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
}

- (void)setupdecoView {
    _decoView = [UIView new];
    self.decoView.frame = CGRectInset(self.bounds, [self borderWidth], [self borderWidth]);
    self.decoView.backgroundColor = self.decoViewColor;
    self.decoView.layer.masksToBounds = YES;
    self.decoView.userInteractionEnabled = NO;
    [self addSubview:self.decoView];
    
    if (self.cornerRadius == MGUSevenSwitchCornerRadiusAutomatic) {
        self.decoView.layer.cornerRadius = self.decoView.frame.size.height / 2.0;
    } else {
//        self.decoView.layer.cornerRadius = 2.0;
        self.decoView.layer.cornerRadius = self.cornerRadius * (self.decoView.frame.size.height / self.frame.size.height);
    }
    
    if (self.switchOn == YES) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.decoView.layer.opacity = 0.0f;
        self.decoView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.1, 0.1, 1.0);
        [CATransaction commit];
    }
}

- (void)setupImageViews {
    self.onImageView  = [[UIImageView alloc] initWithFrame:[self decorationViewFrameForONState:YES]];
    self.offImageView = [[UIImageView alloc] initWithFrame:[self decorationViewFrameForONState:NO]];
    
    self.onImageView.contentMode  = UIViewContentModeCenter;
    self.offImageView.contentMode = UIViewContentModeCenter;
    self.onImageView.image = self.onImage;
    self.offImageView.image = self.offImage;
    
    if (self.switchOn == YES) {
        self.onImageView.alpha  = 1.0;
        self.offImageView.alpha = 0.0;
    } else {
        self.onImageView.alpha  = 0.0;
        self.offImageView.alpha = 1.0;
    }
    [self addSubview:self.onImageView];
    [self addSubview:self.offImageView];
}

- (void)setupLabels {
    self.onLabel  = [[UILabel alloc] initWithFrame:[self decorationViewFrameForONState:YES]];
    self.offLabel = [[UILabel alloc] initWithFrame:[self decorationViewFrameForONState:NO]];
    
    self.onLabel.textAlignment  = self.onLabelTextAlignment;
    self.offLabel.textAlignment = self.offLabelTextAlignment;
    
    self.onLabel.textColor = self.onLabelTextColor;
    self.offLabel.textColor = self.offLabelTextColor;
    
    self.onLabel.font = self.onLabelTextFont;
    self.offLabel.font = self.offLabelTextFont;

    self.onLabel.text = self.onLabelTitle;
    self.offLabel.text = self.offLabelTitle;
    
    [self addSubview:self.onLabel];
    [self addSubview:self.offLabel];
}

- (void)setupknobView {
    self.knobView = [[MGUSevenKnobView alloc] initWithFrame:[self knobViewFrameForONState:self.switchOn]];
    self.knobView.on = self.switchOn;
    self.knobView.layer.masksToBounds = NO; // shadow 표현을 위해 필요하다.
    self.knobView.userInteractionEnabled = NO;
    self.knobView.layer.shadowColor = self.shadowColor.CGColor;
    self.knobView.layer.shadowRadius = 2.0;
    self.knobView.layer.shadowOpacity = 0.5;
    self.knobView.layer.shadowOffset = CGSizeMake(0.0, 1.5);
    [self addSubview:self.knobView];
    
    self.knobImageView = [[UIImageView alloc] initWithFrame:self.knobView.bounds];
    self.knobImageView.contentMode = UIViewContentModeCenter; // UIViewContentModeScaleAspectFit
    self.knobImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.knobView addSubview:self.knobImageView];
    
    if (self.knobAccessoryView != nil) {
        self.knobAccessoryView.frame = self.knobView.bounds;
        [self.knobView addSubview:self.knobAccessoryView];
        self.knobAccessoryView.translatesAutoresizingMaskIntoConstraints = YES;
        self.knobAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    
    if (self.switchOn == YES) {
        self.knobView.backgroundColor = self.onThumbTintColor;
    } else {
        self.knobView.backgroundColor = self.offThumbTintColor;
    }
}

- (CGRect)decorationViewFrameForONState:(BOOL)oNState {
    CGSize labelImageViewSize = CGSizeMake(self.frame.size.width - self.frame.size.height, self.frame.size.height);
    if (oNState == YES) {
        return (CGRect){CGPointZero, labelImageViewSize};
    } else {
        return (CGRect){CGPointMake(self.frame.size.height, 0.0), labelImageViewSize};
    }
}

- (CGRect)knobViewFrameForONState:(BOOL)oNState {
//    CGFloat w = self.frame.size.height -  2.0;
//    CGFloat w = self.frame.size.height - (2 * [self borderWidth]);
    CGFloat knobViewHeight = self.frame.size.height - (2.0 * [self borderWidth]);
    CGFloat knobViewWidth = knobViewHeight * self.knobRatio;
    if (oNState == YES) {
//        return CGRectMake(self.frame.size.width - w - [self borderWidth], [self borderWidth], w, w);
        return  CGRectMake(self.frame.size.width - knobViewWidth - [self borderWidth],
                           [self borderWidth],
                           knobViewWidth,
                           knobViewHeight);
    } else {
//        return  CGRectMake([self borderWidth], [self borderWidth], w, w);
        return  CGRectMake([self borderWidth], [self borderWidth], knobViewWidth, knobViewHeight);
    }
}


#pragma mark - 세터 & 게터
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.knobView.layer.shadowColor = shadowColor.CGColor;
}

- (void)setCornerRadius:(MGUSevenSwitchCornerRadius)cornerRadius {
    _cornerRadius = cornerRadius;
    if (cornerRadius == MGUSevenSwitchCornerRadiusAutomatic) {
        self.sevenBackgroundView.layer.cornerRadius = self.frame.size.height * 0.5;
        self.knobView.layer.cornerRadius = (self.frame.size.height - (2.0 * [self borderWidth])) * 0.5;
    } else {
        self.sevenBackgroundView.layer.cornerRadius = cornerRadius;
        self.knobView.layer.cornerRadius = cornerRadius * ((self.frame.size.height - (2.0 * [self borderWidth])) / self.frame.size.height);
    }
    //! 안하는게 낫다.
//    self.knobView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.knobView.bounds
//                                                                 cornerRadius:self.knobView.layer.cornerRadius].CGPath;
}

- (void)setKnobImage:(UIImage *)thumbImage {
    self.knobImageView.image = thumbImage;
    _knobImage = thumbImage;
}

- (void)setOnImage:(UIImage *)onImage {
    self.onImageView.image = onImage;
    _onImage = onImage;
}

- (void)setOffImage:(UIImage *)offImage {
    self.offImageView.image = offImage;
    _offImage = offImage;
}

- (void)setSwitchOn:(BOOL)switchOn {
    if ( _switchOn != switchOn ) {
        _switchOn = switchOn;
        self.knobView.on = switchOn;
        [self moveSwitchToOn:switchOn];
    }
}

//! - setSwitchOn: 에서만 호출된다.
- (void)moveSwitchToOn:(BOOL)switchOn {
    void (^animationsBlock)(void) = ^{
        CGFloat knobRadius = self.knobView.frame.size.width / 2.0;

        if (switchOn == YES) {
            self.knobView.center = CGPointMake(self.frame.size.width - knobRadius - [self borderWidth], self.knobView.center.y);
            if (self.knobView.backgroundColor != self.onThumbTintColor) { // 포인터 비교(퍼포먼스 고려)
                self.knobView.backgroundColor = self.onThumbTintColor;
            }
            
            self.onImageView.alpha  = 1.0;
            self.offImageView.alpha = 0;
            self.onLabel.alpha  = 1.0;
            self.offLabel.alpha = 0;
        } else {
            self.knobView.center = CGPointMake(knobRadius + [self borderWidth], self.knobView.center.y);
            if (self.knobView.backgroundColor != self.offThumbTintColor) { // 포인터 비교(퍼포먼스 고려)
                self.knobView.backgroundColor = self.offThumbTintColor;
            }
            self.onImageView.alpha  = 0.0;
            self.offImageView.alpha = 1.0;
            self.onLabel.alpha  = 0.0;
            self.offLabel.alpha = 1.0;
        }
    };
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState;
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.3
                                                          delay:0.0
                                                        options:options
                                                     animations:animationsBlock
                                                     completion:^(UIViewAnimatingPosition finalPosition) {}];
    
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    basicSettingForCAAnimation(borderColorAnimation);
    basicSettingForCAAnimation(backgroundColorAnimation);
    basicSettingForCAAnimation(animationGroup);
    
    if (switchOn == YES) {
        borderColorAnimation.fromValue = (id)self.offBorderColor.CGColor;
        borderColorAnimation.toValue   = (id)self.onBorderColor.CGColor;
        backgroundColorAnimation.fromValue = (id)self.offTintColor.CGColor;
        backgroundColorAnimation.toValue   = (id)self.onTintColor.CGColor;
    } else {
        borderColorAnimation.fromValue = (id)self.onBorderColor.CGColor;
        borderColorAnimation.toValue   = (id)self.offBorderColor.CGColor;
        backgroundColorAnimation.fromValue = (id)self.onTintColor.CGColor;
        backgroundColorAnimation.toValue   = (id)self.offTintColor.CGColor;
    }
    
    if (self.sevenBackgroundView.layer.presentationLayer != nil) {
        borderColorAnimation.fromValue = (__bridge id)self.sevenBackgroundView.layer.presentationLayer.borderColor;
        backgroundColorAnimation.fromValue = (__bridge id)self.sevenBackgroundView.layer.presentationLayer.backgroundColor;
        self.sevenBackgroundView.layer.borderColor = self.sevenBackgroundView.layer.presentationLayer.borderColor; //! 깜빡 거림을 막는다.
        self.sevenBackgroundView.layer.backgroundColor = self.sevenBackgroundView.layer.presentationLayer.backgroundColor; //! 깜빡 거림을 막는다.
    }
//    if (self.layer.presentationLayer != nil) {
//        borderColorAnimation.fromValue = (__bridge id)self.layer.presentationLayer.borderColor;
//        backgroundColorAnimation.fromValue = (__bridge id)self.layer.presentationLayer.backgroundColor;
//        self.layer.borderColor = self.layer.presentationLayer.borderColor; //! 깜빡 거림을 막는다.
//        self.layer.backgroundColor = self.layer.presentationLayer.backgroundColor; //! 깜빡 거림을 막는다.
//    }
    
    [CATransaction setCompletionBlock:^{
        if (switchOn == YES) {
            self.sevenBackgroundView.layer.borderColor = self.onBorderColor.CGColor;
            self.sevenBackgroundView.layer.backgroundColor = self.onTintColor.CGColor;
//            self.layer.borderColor = self.onBorderColor.CGColor;
//            self.layer.backgroundColor = self.onTintColor.CGColor;
        } else {
            self.sevenBackgroundView.layer.borderColor = self.offBorderColor.CGColor;
            self.sevenBackgroundView.layer.backgroundColor = self.offTintColor.CGColor;
//            self.layer.borderColor = self.offBorderColor.CGColor;
//            self.layer.backgroundColor = self.offTintColor.CGColor;
        }
    }];
    
    animationGroup.animations = @[borderColorAnimation, backgroundColorAnimation];
    [self.sevenBackgroundView.layer addAnimation:animationGroup forKey:@"AnimationGroupKey"];
//    [self.layer addAnimation:animationGroup forKey:@"AnimationGroupKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MGUSevenSwitchStateChangedNotification
                                                        object:self  // poster(보내는 놈)
                                                      userInfo:nil];
}


#pragma mark - 게터 only -
///! 다양한 곳에서 호출되며, 심지어 서브뷰에서도 호출된다. 끝점에서 knobView 사이의 거리에도 해당한다.
- (CGFloat)borderWidth {
    return self.frame.size.height * ( 2.0 / 31.0);
}


#pragma mark - private support
- (void)decoViewAnimationForExand:(BOOL)expand {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    basicSettingForCAAnimation(scaleAnimation);
    if (expand == NO) { // 줄어들 때는 빠르게.
        scaleAnimation.duration = 0.15f;
    }
    if (self.decoView.layer.presentationLayer != nil) {
        self.decoView.layer.transform = self.decoView.layer.presentationLayer.transform;
        scaleAnimation.fromValue = @(self.decoView.layer.presentationLayer.transform.m11);
    } else {
        if (expand == NO) {
            scaleAnimation.fromValue = @(1.0);
        } else {
            scaleAnimation.fromValue = @(0.1);
        }
    }
    
    if (expand == NO) {
        scaleAnimation.toValue   = @(0.1);
    } else {
        scaleAnimation.toValue   = @(1.0);
    }
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.duration = scaleAnimation.duration;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    opacityAnimation.timingFunction = timingFunction;
    opacityAnimation.timingFunctions = @[timingFunction, timingFunction];
    if (self.decoView.layer.presentationLayer != nil) {
        float startOpacityValue = self.decoView.layer.presentationLayer.opacity;
        self.decoView.layer.opacity = startOpacityValue;
        if (expand == NO) { // 작아지는 경우. (큰 상태 ➩ 작은상태)
            opacityAnimation.values   = @[@(startOpacityValue), @(startOpacityValue), @(0.0)];
        } else { // 커지는 경우. (작은상태 ➩ 큰 상태)
            opacityAnimation.values   = @[@(startOpacityValue), @(1.0), @(1.0)];
        }
    } else {
        if (expand == NO) { // 작아지는 경우. (큰 상태 ➩ 작은상태)
            opacityAnimation.values   = @[@(1.0), @(1.0), @(0.0)];
        } else { // 커지는 경우. (작은상태 ➩ 큰 상태)
            opacityAnimation.values   = @[@(0.0), @(1.0), @(1.0)];
        }
    }
    
    if (expand == NO) { // 작아지는 경우. (큰 상태 ➩ 작은상태)
        opacityAnimation.keyTimes = @[@(0.0), @(0.9), @(1.0)];
    } else { // 커지는 경우. (작은상태 ➩ 큰 상태)
        opacityAnimation.keyTimes = @[@(0.0), @(0.1), @(1.0)];
    }

    [CATransaction setCompletionBlock:^{}];
    
    [self.decoView.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
    [self.decoView.layer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

//! 터치로 인해서만 임팩트가 오게 한다.
- (void)impactOccurred {
    //! 여기에다가 스위치 자체에서 impactFeedbackGenerator 꺼버렸을 때를 대비하게 만들면 될듯.
    [self.impactFeedbackGenerator mgrImpactOccurred];
}


#pragma mark - 컨트롤 메서드
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated {
    if (self.switchOn != switchOn) {
        if (animated == YES) {
            [self setSwitchOn:switchOn];
            [self decoViewAnimationForExand:!switchOn];
        } else {
            _switchOn = switchOn;
            CommonInit(self);
        }
    }
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSAssert(FALSE, @"- initWithFrame 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end

static void basicSettingForCAAnimation(CAAnimation * animation) {
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode            = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
}
