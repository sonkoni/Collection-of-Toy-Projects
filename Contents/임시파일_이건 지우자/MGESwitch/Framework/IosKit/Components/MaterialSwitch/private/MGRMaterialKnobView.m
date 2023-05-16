//
//  MGRMaterialKnobView.m
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 29/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGRMaterialKnobView.h"
#import "MGUMaterialSwitch.h"

@interface MGRMaterialKnobView()
@end
@implementation MGRMaterialKnobView

- (void)willMoveToSuperview:(MGUMaterialSwitch *)switchView {
    [super willMoveToSuperview:switchView];
    /// 이렇게 넣어주는 것이 맞다. 최초에 만들어지고 난 후, 리셋을 할 수 도 있다.
    if (switchView.isEnabled == NO) {
        self.layer.backgroundColor = [switchView knobDisabledColor].CGColor;
    } else {
        if (self.on == YES) {
            self.layer.backgroundColor = [switchView knobOnColor].CGColor;
        } else {
            self.layer.backgroundColor = [switchView knobOffColor].CGColor;
        }
    }
    self.rippleLayer.fillColor = [switchView rippleFillColor].CGColor;
    
    self.animaitonDuration = [switchView animaitonDuration];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.rippleLayer.frame = self.layer.bounds;
}

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 & 소멸 메서드
- (instancetype)initWithFrame:(CGRect)frame switchOn:(BOOL)switchOn {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled  = NO;
        _on                      = switchOn;
        _touched                 = NO;
        self.layer.cornerRadius  = self.frame.size.height / 2;
        
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowOffset  = CGSizeMake(0.0, 1.0);
        self.layer.shadowColor   = [UIColor blackColor].CGColor;
        self.layer.shadowRadius  = 2.0f;
        
        //! rippleLayer 설정을한다.
        [self.layer addSublayer:[self setUpRippleLayer]];
    }
    
    return self;
}

- (CAShapeLayer *)setUpRippleLayer {
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height / 2.0];
    
    self.rippleLayer = [CAShapeLayer layer];
    self.rippleLayer.contentsScale = UIScreen.mainScreen.scale;
    self.rippleLayer.path        = path.CGPath;
    self.rippleLayer.frame       = self.layer.bounds;
    self.rippleLayer.opacity     = 0.2;
    self.rippleLayer.lineWidth   = 0;
    self.rippleLayer.strokeColor = [UIColor clearColor].CGColor;
    self.rippleLayer.opacity     = 0.0f;
    
    return self.rippleLayer;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 & 게터 메서드

- (void)setOn:(BOOL)on {
    if (_on != on) {
        _on = on;
        [self moveknobViewToOn:on];
    }
}

- (void)setTouched:(BOOL)touched {
    _touched = touched;
    [self touchRippleAnimationWithTouched:touched];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 컨트롤 메서드

/// ============================================================
// setOn: 를 도와주는 컨트롤 메서드이다.
- (void)moveknobViewToOn:(BOOL)on {
    MGUMaterialSwitch *switchView = (MGUMaterialSwitch *)self.superview;
    if (switchView.isEnabled == NO)
        return;
    
    CABasicAnimation *knobViewColorAnimation   = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    knobViewColorAnimation.duration            = self.animaitonDuration;
    knobViewColorAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    knobViewColorAnimation.fillMode            = kCAFillModeForwards;
    knobViewColorAnimation.removedOnCompletion = NO;
    
    if (on == YES) {
        knobViewColorAnimation.fromValue = (id)switchView.knobOffColor.CGColor;
        knobViewColorAnimation.toValue   = (id)switchView.knobOnColor.CGColor;
    } else {
        knobViewColorAnimation.fromValue = (id)switchView.knobOnColor.CGColor;
        knobViewColorAnimation.toValue   = (id)switchView.knobOffColor.CGColor;
    }
    
    [CATransaction setCompletionBlock:^{}];
    [self.layer addAnimation:knobViewColorAnimation forKey:@"KnobViewColorAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
}

- (void)touchRippleAnimationWithTouched:(BOOL)touched {
    
    if (touched == YES) {
        [self.layer removeAnimationForKey:@"TouchEndRippleAnimationKey"];
        [self touchBeginRippleAnimation];
    } else {
        [self.layer removeAnimationForKey:@"TouchBeginRippleAnimationKey"];
        [self touchEndRippleAnimation];
    }
}


/// ============================================================
// touchRippleAnimationWithTouched: 를 도와주는 컨트롤 메서드이다.
- (void)touchBeginRippleAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @(0.0f);
    scaleAnimation.toValue   = @(2.0f);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(0.0);
    alphaAnimation.toValue   = @(0.2);
    
    CAAnimationGroup *groupAnimation   = [CAAnimationGroup animation];
    groupAnimation.duration            = self.animaitonDuration + 0.1;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnimation.animations          = @[scaleAnimation, alphaAnimation];
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    
    [CATransaction setCompletionBlock:^{}];
    [self.rippleLayer addAnimation:groupAnimation forKey:@"TouchBeginRippleAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

/// ============================================================
// touchRippleAnimationWithTouched: 를 도와주는 컨트롤 메서드이다.
- (void)touchEndRippleAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @(1.0f);
    scaleAnimation.toValue   = @(2.5f);
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(0.4f);
    alphaAnimation.toValue   = @(0.0f);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration          = self.animaitonDuration + 0.1;
    groupAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    groupAnimation.animations        = @[scaleAnimation, alphaAnimation];
    groupAnimation.removedOnCompletion = NO; // default 는 YES이다.
    groupAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준
    
    [CATransaction setCompletionBlock:^{}];
    [self.rippleLayer addAnimation:groupAnimation forKey:@"TouchEndRippleAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
    
}


@end
