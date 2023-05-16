//
//  UIButton+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIButton+Extension.h"

//! 카테고리처럼 쓰는 기능이 하나인 버튼
@interface _MGUButton : UIButton
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) dispatch_group_t dispatchGroup;
@end

@implementation UIButton (Shrink)
+ (UIButton *)mgrShinkButton:(CGFloat)scale {
    _MGUButton *result = [_MGUButton new];
    if (scale >= 0.1) {
        result.scale = scale;
    } else {
        result.scale = 0.85;
    }
    return result;
}
@end

@implementation _MGUButton

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL begins = [super beginTrackingWithTouch:touch withEvent:event];
    [self shrinkAnimation];
    return begins;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self inverseShrinkAnimation];
}


#pragma mark - 세터 & 게터
- (dispatch_group_t)dispatchGroup {
    if (_dispatchGroup == nil) {
        _dispatchGroup = dispatch_group_create();
    }
    return _dispatchGroup;
}


#pragma mark - Actions
- (void)shrinkAnimation {
    dispatch_group_enter(self.dispatchGroup);
    dispatch_group_enter(self.dispatchGroup);
    
    CFTimeInterval duration = 0.2;

    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    shrinkAnimation.duration            = duration;
    shrinkAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shrinkAnimation.removedOnCompletion = NO;
    shrinkAnimation.fillMode            = kCAFillModeForwards;
    shrinkAnimation.fromValue = @(1.0);
    shrinkAnimation.toValue = @(self.scale);
    if (self.layer.presentationLayer) {
        self.layer.transform = self.layer.presentationLayer.transform;
        shrinkAnimation.fromValue = @(self.layer.presentationLayer.transform.m11);
    }
    
    [CATransaction setCompletionBlock:^{
        dispatch_group_leave(self.dispatchGroup);
    }];
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    
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
    CFTimeInterval duration = 0.2;
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    shrinkAnimation.duration            = duration;
    shrinkAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shrinkAnimation.removedOnCompletion = NO;
    shrinkAnimation.fillMode            = kCAFillModeForwards;
    self.layer.transform = self.layer.presentationLayer.transform; // 항상 0.85
    shrinkAnimation.fromValue = @(self.scale);
    shrinkAnimation.toValue = @(1.0);
    [CATransaction setCompletionBlock:^{}];
    [self.layer addAnimation:shrinkAnimation forKey:@"ShrinkAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

@end
