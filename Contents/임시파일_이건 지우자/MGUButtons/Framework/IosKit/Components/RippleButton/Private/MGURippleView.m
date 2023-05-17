//
//  MGURippleButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURippleView.h"
#import "MGURippleButton.h"

@interface MGURippleView () <CAAnimationDelegate>
@property (nonatomic) NSMutableArray <CALayer *>*rippleLayers;
@end

@implementation MGURippleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSAssert(false, @"허가되지 않은 초기화 메서드 호출!");
    return nil;
}

- (void)willMoveToSuperview:(MGURippleButton *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.layer.cornerRadius         = newSuperview.layer.cornerRadius;
    self.rippleOverBounds           = newSuperview.rippleOverBounds;
    self.rippleColor                = newSuperview.rippleColor;
    self.touchDownAnimationDuration = newSuperview.touchDownAnimationDuration;
    self.touchUpAnimationDuration   = newSuperview.touchUpAnimationDuration;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 소멸 메서드
- (void)commonInit {
    self.userInteractionEnabled = NO;
    _rippleOverBounds           = NO;
    self.clipsToBounds          = YES;
    self.layer.masksToBounds    = YES;
    _touchCenterLocation        = CGPointZero;
    _rippleLayers               = [NSMutableArray arrayWithCapacity:10];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드
- (void)setRippleOverBounds:(BOOL)rippleOverBounds {
    if (_rippleOverBounds != rippleOverBounds) {
        _rippleOverBounds = rippleOverBounds;
        // 넘어가는 것을 허용한다면.
        if (rippleOverBounds == YES) {
            self.clipsToBounds       = NO;
            self.layer.masksToBounds = NO;
        } else {
            self.clipsToBounds       = YES;
            self.layer.masksToBounds = YES;
        }
        
    }
}

- (CALayer *)setupRippleLayer {
    CALayer *layer = [CALayer layer];
    [self.rippleLayers addObject:layer];
    [self.layer addSublayer:layer];
    
    layer.backgroundColor = self.rippleColor.CGColor;
    layer.opacity         = 0.0f;
    
    layer.frame    = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    layer.cornerRadius = layer.frame.size.width / 2.0;
    if (self.trackTouchLocation == YES) {
        layer.position = self.touchCenterLocation;
    } else {
        layer.position = self.center;
    }
    
    return layer;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 컨트롤 메서드

- (void)animateToRippleState {
    
    CALayer *layer = [self setupRippleLayer];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue         = @(0.0f);
    opacityAnimation.toValue           = @(1.0f);
    
    CABasicAnimation *scaleAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue           = @(0.5f);
    scaleAnimation.toValue             = @(0.8f);

    CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
    groupAnimation.duration            = 0.7f;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.animations          = @[opacityAnimation, scaleAnimation];
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    
    [CATransaction setCompletionBlock:^{}];
    [layer addAnimation:groupAnimation forKey:@"GroupShadowAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
}

- (void)animateToNormal {
    
    CALayer *layer = self.rippleLayers.lastObject;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    if (layer.presentationLayer != nil) {
        CGFloat startValue = layer.presentationLayer.opacity;
        opacityAnimation.values          = @[@(startValue), @(1.0), @(0.0)];
        opacityAnimation.keyTimes        = @[@(0.0), @(0.1), @(1.0)];
    } else {
        opacityAnimation.values          = @[@(1.0), @(0.0)];
        opacityAnimation.keyTimes        = @[@(0.0), @(1.0)];
    }
    
    CABasicAnimation *scaleAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    if (layer.presentationLayer != nil) {
        CATransform3D transform = layer.presentationLayer.transform;
        scaleAnimation.fromValue       = @(transform.m11); // <- 현재 스케일에 해당한다.
    } else {
        scaleAnimation.fromValue       = @(0.8f);
    }

    scaleAnimation.toValue             = @(1.5f);
    
    CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
    groupAnimation.duration            = self.touchUpAnimationDuration;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    groupAnimation.animations          = @[opacityAnimation, scaleAnimation];
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    
    [CATransaction setCompletionBlock:^{}];
    [layer removeAnimationForKey:@"GroupShadowAnimationKey"];
    //! - animationDidStop:finished: 를 받으려면, delegate 설정과 - setValue:forKey: 가
    //! - addAnimation:forKey: 보다 먼저 등장해야한다.
    groupAnimation.delegate = self;
    [groupAnimation setValue:@"GroupShadowAnimationKey" forKey:@"DeleteKey"];
    [layer addAnimation:groupAnimation forKey:@"GroupShadowAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 델리게이트 메서드 <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"DeleteKey"] isEqualToString:@"GroupShadowAnimationKey"]) {
        [[self.rippleLayers objectAtIndex:0] removeFromSuperlayer];
        if (self.rippleLayers.count > 0) {
            [self.rippleLayers removeObjectAtIndex:0];
        }
    }
}

@end
