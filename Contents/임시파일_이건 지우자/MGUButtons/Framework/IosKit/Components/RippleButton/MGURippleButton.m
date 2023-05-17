//
//  MGURippleButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURippleButton.h"
#import "MGURippleBackgroundView.h"
#import "MGURippleView.h"

@interface MGURippleButton ()
@property (nonatomic) MGURippleBackgroundView *rippleBackgroundView;
@property (nonatomic) MGURippleView *rippleView;
@end

@implementation MGURippleButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.trackTouchLocation == YES ) {
        self.rippleView.touchCenterLocation = [touch locationInView:self.rippleView];
    }
    
    [self animateToRippleState];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self animateToNormal];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self animateToNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rippleBackgroundViewFrame = self.rippleBackgroundView.frame;
    CGRect rippleViewFrame           = self.rippleView.frame;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (CGRectEqualToRect(rippleBackgroundViewFrame, self.bounds) == NO) {
        self.rippleBackgroundView.frame = self.bounds;
    }
    
    if (CGRectEqualToRect(rippleViewFrame, self.bounds) == NO) {
        self.rippleView.frame = self.bounds;
    }
    
    [CATransaction commit];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGURippleButton *self) {
    // 오프셋 고정.
    // Api:Core Animation/CALayer/shadowOffset
    self.layer.shadowOffset  = CGSizeMake(0, 1); // UIKit에서는 1포인트 아래로 그려지게 된다. 디폴트  (0.0, -3.0)
    self.layer.shadowColor   = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor; // 검정색 알파 0.5 <- 좀 더 그림자를 명확하게 하고 싶다면 알파를 1.0으로
    self.layer.shadowRadius  = 1.5; // <- 기본 상태의 값 (UIKit 디폴트 3.0)
    self.layer.shadowOpacity = 0.5; // <- 기본 상태의 값 (UIKit 디폴트 0.0)
    self->_defaultShadowRadius     = self.layer.shadowRadius;
    self->_defaultShadowOpacity    = self.layer.shadowOpacity;
    self->_rippleShadowOffset      = self.layer.shadowOffset;
    
    self->_rippleShadowEnabled     = YES;
    self->_rippleShadowRadius      = 4.5; // <- YES 일때만 이용된다.
    self->_rippleShadowOpacity     = 0.5; // <- YES 일때만 이용된다.
    self->_rippleShadowOffset      = CGSizeMake(2.0, 4.0);
    
    self->_rippleColor             = [UIColor colorWithWhite:0.9 alpha:1.0];  // <- 리플이 좀 더 진하게
    self->_rippleBackgroundColor   = [UIColor colorWithWhite:0.95 alpha:1.0]; // <- 리플의 백이 좀 더 연하게
    self->_rippleOverBounds        = NO;
    
    self->_buttonCornerRadius      = 0.0;
    self->_trackTouchLocation      = NO;
    
    self->_touchDownAnimationDuration = 0.2;
    self->_touchUpAnimationDuration   = 0.7;
    
    self.rippleBackgroundView = [[MGURippleBackgroundView alloc] initWithFrame:self.bounds];
    [self addSubview:self.rippleBackgroundView];
    self.rippleView = [[MGURippleView alloc] initWithFrame:self.bounds];
    [self addSubview:self.rippleView];
}


#pragma mark - 세터 & 게터
- (void)setRippleShadowEnabled:(BOOL)rippleShadowEnabled {
    if (_rippleShadowEnabled != rippleShadowEnabled) {
        _rippleShadowEnabled = rippleShadowEnabled;
        if (rippleShadowEnabled == YES) {
            self.layer.shadowOpacity = self.defaultShadowOpacity;
        } else {
            self.layer.shadowOpacity = 0.0f;
        }
    }
}

- (void)setRippleOverBounds:(BOOL)rippleOverBounds {
    if (_rippleOverBounds != rippleOverBounds) {
        _rippleOverBounds                = rippleOverBounds;
        self.rippleView.rippleOverBounds = rippleOverBounds;
    }
}

- (void)setRippleColor:(UIColor *)rippleColor {
    if (CGColorEqualToColor(_rippleColor.CGColor, rippleColor.CGColor) == NO) {
        _rippleColor                = rippleColor;
        self.rippleView.rippleColor = rippleColor;
    }
}

- (void)setRippleBackgroundColor:(UIColor *)rippleBackgroundColor {
    if (CGColorEqualToColor(_rippleBackgroundColor.CGColor, rippleBackgroundColor.CGColor) == NO) {
        _rippleBackgroundColor                          = rippleBackgroundColor;
        self.rippleBackgroundView.layer.backgroundColor = rippleBackgroundColor.CGColor;
    }
}

- (void)setButtonCornerRadius:(CGFloat)buttonCornerRadius {
    if (_buttonCornerRadius != buttonCornerRadius) {
        _buttonCornerRadius                          = buttonCornerRadius;
        self.layer.cornerRadius                      = buttonCornerRadius;
        self.rippleBackgroundView.layer.cornerRadius = buttonCornerRadius;
        self.rippleView.layer.cornerRadius           = buttonCornerRadius;
    }
}

- (void)setDefaultShadowRadius:(CGFloat)defaultShadowRadius {
    if (_defaultShadowRadius != defaultShadowRadius) {
        _defaultShadowRadius = defaultShadowRadius;
        self.layer.shadowRadius = defaultShadowRadius;
    }
}

- (void)setDefaultShadowOpacity:(CGFloat)defaultShadowOpacity {
    if (_defaultShadowOpacity != defaultShadowOpacity) {
        _defaultShadowOpacity = defaultShadowOpacity;
        self.layer.shadowOpacity = defaultShadowOpacity;
    }
}

- (void)setTouchDownAnimationDuration:(CFTimeInterval)touchDownAnimationDuration {
    if (_touchDownAnimationDuration != touchDownAnimationDuration) {
        _touchDownAnimationDuration = touchDownAnimationDuration;
        self.rippleBackgroundView.touchDownAnimationDuration = touchDownAnimationDuration;
        self.rippleView.touchDownAnimationDuration           = touchDownAnimationDuration;
    }
}

- (void)setTouchUpAnimationDuration:(CFTimeInterval)touchUpAnimationDuration {
    if (_touchUpAnimationDuration != touchUpAnimationDuration) {
        _touchUpAnimationDuration = touchUpAnimationDuration;
        self.rippleBackgroundView.touchUpAnimationDuration = touchUpAnimationDuration;
        self.rippleView.touchUpAnimationDuration           = touchUpAnimationDuration;
    }
}

- (void)setTrackTouchLocation:(BOOL)trackTouchLocation {
    if (_trackTouchLocation != trackTouchLocation) {
        _trackTouchLocation = trackTouchLocation;
        self.rippleView.trackTouchLocation = trackTouchLocation;
    }
}


#pragma mark - 컨트롤
- (void)animateToRippleState {
    
    [self.rippleBackgroundView animateToRippleState];
    [self.rippleView animateToRippleState];
   
    if (self.rippleShadowEnabled == YES) {

        CABasicAnimation *shadowRadiusAnimation  = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        CABasicAnimation *shadowOffsetAnimation  = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
        
        if (self.layer.presentationLayer != nil) {
            shadowRadiusAnimation.fromValue  = @(self.layer.presentationLayer.shadowRadius);
            shadowOpacityAnimation.fromValue = @(self.layer.presentationLayer.shadowOpacity);
            shadowOffsetAnimation.fromValue  = @(self.layer.presentationLayer.shadowOffset);
        } else {
            shadowRadiusAnimation.fromValue  = @(self.defaultShadowRadius);
            shadowOpacityAnimation.fromValue = @(self.defaultShadowOpacity);
            shadowOffsetAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 1)];
        }
        
        shadowRadiusAnimation.toValue  = @(self.rippleShadowRadius);
        shadowOpacityAnimation.toValue = @(self.rippleShadowOpacity);
        shadowOffsetAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(2, 4)];
        
        CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
        groupAnimation.duration            = self.touchDownAnimationDuration;
        groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        groupAnimation.animations          = @[shadowRadiusAnimation, shadowOpacityAnimation, shadowOffsetAnimation];
        groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
        groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
        
        [self.layer removeAnimationForKey:@"GroupShadowAnimationKey"];
        [self.layer addAnimation:groupAnimation forKey:@"GroupShadowAnimationKey"];
    }
    
}

- (void)animateToNormal {
    
    [self.rippleBackgroundView animateToNormal];
    [self.rippleView animateToNormal];
    
    if (self.rippleShadowEnabled == YES) {
        
        CAKeyframeAnimation *shadowRadiusAnimation  = [CAKeyframeAnimation animationWithKeyPath:@"shadowRadius"];
        CAKeyframeAnimation *shadowOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowOpacity"];
        CAKeyframeAnimation *shadowOffsetAnimation  = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
        
        if (self.layer.presentationLayer != nil) {
            CGFloat startRadiusValue  = self.layer.presentationLayer.shadowRadius;
            CGFloat startOpacityValue = self.layer.presentationLayer.shadowOpacity;
            CGSize  startOffsetValue  = self.layer.presentationLayer.shadowOffset;
            
            shadowRadiusAnimation.values    = @[@(startRadiusValue),  @(self.rippleShadowRadius),  @(self.defaultShadowRadius)];
            shadowOpacityAnimation.values   = @[@(startOpacityValue), @(self.rippleShadowOpacity), @(self.defaultShadowOpacity)];
            shadowOffsetAnimation.values    = @[[NSValue valueWithCGSize:startOffsetValue],
                                                [NSValue valueWithCGSize:CGSizeMake(2, 4)],
                                                [NSValue valueWithCGSize:CGSizeMake(0, 1)]];
            shadowRadiusAnimation.keyTimes  = @[@(0.0), @(0.5), @(1.0)];
            shadowOpacityAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
            shadowOffsetAnimation.keyTimes  = @[@(0.0), @(0.5), @(1.0)];
        } else {
            shadowRadiusAnimation.values    = @[@(self.rippleShadowRadius), @(self.defaultShadowRadius)];
            shadowOpacityAnimation.values   = @[@(self.rippleShadowOpacity), @(self.defaultShadowOpacity)];
            shadowOffsetAnimation.values    = @[[NSValue valueWithCGSize:CGSizeMake(2, 4)], [NSValue valueWithCGSize:CGSizeMake(0, 1)]];
            shadowRadiusAnimation.keyTimes  = @[@(0.0), @(1.0)];
            shadowOpacityAnimation.keyTimes = @[@(0.0), @(1.0)];
            shadowOffsetAnimation.keyTimes  = @[@(0.0), @(1.0)];
        }
        
        CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
        groupAnimation.duration            = self.touchUpAnimationDuration;
        groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        groupAnimation.animations          = @[shadowRadiusAnimation, shadowOpacityAnimation, shadowOffsetAnimation];
        groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
        groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
        
        [self.layer removeAnimationForKey:@"GroupShadowAnimationKey"];
        [self.layer addAnimation:groupAnimation forKey:@"GroupShadowAnimationKey"];
    }
}

@end
