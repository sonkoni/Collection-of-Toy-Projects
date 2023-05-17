//
//  MGRFavSwitchCircleLayer.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 21/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUFavSwitchRippleLayer.h"

@interface MGUFavSwitchRippleLayer () <CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *circleMaskLayer;
@property (nonatomic, strong) CAKeyframeAnimation *circleTransformAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *circleMaskTransformAnimation;

@end

@implementation MGUFavSwitchRippleLayer


- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setTimeDuration:(CGFloat)timeDuration {
    _timeDuration = timeDuration;
    self.circleTransformAnimation.duration = 0.333 * timeDuration;
    self.circleMaskTransformAnimation.duration = 0.333 * timeDuration;
}

- (void)commonInit {
    _circleMaskLayer = [CAShapeLayer layer];
    self.mask = self.circleMaskLayer;
    _circleTransformAnimation     = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];   // <- circle
    _circleMaskTransformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];   // <- circle
    [self animationBasicSetup:self.circleTransformAnimation];
    [self animationBasicSetup:self.circleMaskTransformAnimation];
}

- (void)animationBasicSetup:(CAKeyframeAnimation *)animation {
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.calculationMode = kCAAnimationLinear;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

- (void)setupRippleLayerAnimation {
    self.cornerRadius = self.bounds.size.height / 2.0;
    self.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    self.circleMaskLayer.fillColor = [UIColor blackColor].CGColor; // 디폴트 값이 검정이지만, 명확하게 써주자.
    self.circleMaskLayer.frame = self.bounds;
    self.circleMaskLayer.fillRule = kCAFillRuleEvenOdd;

    //! 사각형과 원 두 개의 path이다. 사각형과 원 사이의 면적을 칠한다.
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [maskPath addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                        radius:0.2
                    startAngle:0.0
                      endAngle:M_PI * 2
                     clockwise:YES];

    self.circleMaskLayer.path = maskPath.CGPath;
        
    self.circleTransformAnimation.values = @[
        @(0.0),    //  0/10
        @(0.5),    //  1/10
        @(1.0),    //  2/10
        @(1.2),    //  3/10
        @(1.3),    //  4/10
        @(1.37),   //  5/10
        @(1.4),    //  6/10
        @(1.4)     // 10/10
    ];
    
    self.circleTransformAnimation.keyTimes = @[
        @(0.0),    //  0/10
        @(0.1),    //  1/10
        @(0.2),    //  2/10
        @(0.3),    //  3/10
        @(0.4),    //  4/10
        @(0.5),    //  5/10
        @(0.6),    //  6/10
        @(1.0)     // 10/10
    ];
    
    self.circleMaskTransformAnimation.values = @[
        @(1.0),                           //  0/10
        @(1.0),                           //  2/10
        @(self.bounds.size.width/2.0 * 1.25 ), //  3/10
        @(self.bounds.size.width/2.0 * 2.688), //  4/10
        @(self.bounds.size.width/2.0 * 3.923), //  5/10
        @(self.bounds.size.width/2.0 * 4.375), //  6/10
        @(self.bounds.size.width/2.0 * 4.731), //  7/10
        @(self.bounds.size.width/2.0 * 5.0),   //  9/10
        @(self.bounds.size.width/2.0 * 5.0)    // 10/10
    ];
    self.circleMaskTransformAnimation.keyTimes = @[
        @(0.0),    //  0/10
        @(0.2),    //  2/10
        @(0.3),    //  3/10
        @(0.4),    //  4/10
        @(0.5),    //  5/10
        @(0.6),    //  6/10
        @(0.7),    //  7/10
        @(0.9),    //  9/10
        @(1.0)     // 10/10
    ];    
}

- (void)startRippleAnimation {
    self.circleTransformAnimation.delegate = self;
    [self addAnimation:self.circleTransformAnimation forKey:@"RippleTransformAnimationKey1"];
    [self.circleMaskLayer addAnimation:self.circleMaskTransformAnimation forKey:@"RippleTransformAnimationKey2"];
}

- (void)stopRippleAnimation {
    [self removeAllAnimations];
    [self.circleMaskLayer removeAllAnimations];
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        [self stopRippleAnimation];
        if (self.completionBlock != nil) {
            self.completionBlock();
        }
    }
}
@end
