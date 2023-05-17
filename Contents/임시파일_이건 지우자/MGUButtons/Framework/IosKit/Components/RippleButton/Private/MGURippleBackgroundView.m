//
//  MGURippleButton.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURippleBackgroundView.h"
#import "MGURippleButton.h"

@interface MGURippleBackgroundView () 
@end

@implementation MGURippleBackgroundView

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
    self.layer.backgroundColor      = newSuperview.rippleBackgroundColor.CGColor;
    self.layer.cornerRadius         = newSuperview.layer.cornerRadius;
    self.layer.masksToBounds        = YES;
    self.clipsToBounds              = YES;
    self.touchDownAnimationDuration = newSuperview.touchDownAnimationDuration;
    self.touchUpAnimationDuration   = newSuperview.touchUpAnimationDuration;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 소멸 메서드
- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.layer.opacity = 0.0f;
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 컨트롤 메서드
- (void)animateToRippleState {
    
    /// rippleBackgroundView의 애니메이션은 단순히 알파를 올리는 것이다. 0 -> 1
    /// 물론 서브뷰에 해당하는 rippleView도 같이 보이게 될 것이다.
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    if (self.layer.presentationLayer != nil) {
        opacityAnimation.fromValue = @(self.layer.presentationLayer.opacity);
    } else {
        opacityAnimation.fromValue = @(0.0f);
    }
    
    opacityAnimation.toValue             = @(1.0f);
    opacityAnimation.duration            = self.touchDownAnimationDuration;
    opacityAnimation.fillMode            = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer removeAnimationForKey:@"OpacityAnimationKey"];
    
    [CATransaction setCompletionBlock:^{}];
    [self.layer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)animateToNormal {
    
    /// 위치 애니메이션과 크기 애니메이션을 만든다. 시작점에 해당한다.
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    if (self.layer.presentationLayer != nil) {
        CGFloat startValue = self.layer.presentationLayer.opacity;
        opacityAnimation.values          = @[@(startValue), @(1.0), @(0.0)];
        opacityAnimation.keyTimes        = @[@(0.0), @(0.55), @(1.0)];
    } else {
        opacityAnimation.values          = @[@(1.0), @(0.0)];
        opacityAnimation.keyTimes        = @[@(0.0), @(1.0)];
    }
    
    opacityAnimation.duration            = self.touchUpAnimationDuration;
    opacityAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    opacityAnimation.fillMode            = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    [self.layer removeAnimationForKey:@"OpacityAnimationKey"];
    [CATransaction setCompletionBlock:^{}];
    [self.layer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}
@end
