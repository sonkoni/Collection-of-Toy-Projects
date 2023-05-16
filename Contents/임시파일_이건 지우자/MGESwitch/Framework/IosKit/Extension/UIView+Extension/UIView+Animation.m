//
//  UIView+Shake.m
//  shakeAnimation
//
//  Created by Kwan Hyun Son on 16/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "UIView+Animation.h"
#import "UICubicTimingParameters+Extension.h"

@implementation UIView (Shake)

- (void)mgrShake:(int)times
       withDelta:(CGFloat)delta
           speed:(NSTimeInterval)interval
  shakeDirection:(MGRViewShakeDirection)shakeDirection
      completion:(void (^)(void))completion {
    [self _shake:times
       direction:1  // <- 고정
    currentTimes:0  // <- 고정
       withDelta:delta
           speed:interval
  shakeDirection:shakeDirection
      completion:completion];
}

- (void)mgrHorizontalShake {
    [self mgrShake:10
         withDelta:5.0
             speed:0.04
    shakeDirection:MGRViewShakeDirectionHorizontal
        completion:^{ NSLog(@"done!"); }];
}

- (void)mgrVerticalShake {
    [self mgrShake:10
         withDelta:5.0
             speed:0.04
    shakeDirection:MGRViewShakeDirectionVertical
        completion:^{ NSLog(@"done!"); }];
}

- (void)mgrRotationShake {
    [self mgrShake:10
         withDelta:5.0
             speed:0.04
    shakeDirection:MGRViewShakeDirectionRotation
        completion:^{ NSLog(@"done!"); }];
}

- (void)mgrHorizontalShakeAndOpacity {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = [NSNumber numberWithFloat:-5];
    animation.toValue   = [NSNumber numberWithFloat:5];
    animation.duration = 0.05;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = 8;
    animation.autoreverses = YES;
  
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(1.0);
    animation2.toValue   = @(0.0);
    animation2.duration = 1.0;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];


    /// setCompletionBlock은 - addAnimation:forKey: 보다 위에 등장해야한다.
    [CATransaction setCompletionBlock:^{
        NSLog(@"컴플리션!");
    }];
  
    [self.layer addAnimation:animation forKey:@"position"];
    [self.layer addAnimation:animation2 forKey:@"opacity"];
  
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    self.layer.affineTransform = CGAffineTransformIdentity;
    self.layer.opacity = 1.0;
  
    [CATransaction commit];
}


#pragma mark - Private
// 실제로 작동하는 메서드  direction:과 currentTimes:가 추가됨!
- (void)_shake:(int)times
     direction:(int)direction           // 왔다 갔다.
  currentTimes:(int)current             // 몇 번 흔들었냐.
     withDelta:(CGFloat)delta           /// 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
         speed:(NSTimeInterval)interval
shakeDirection:(MGRViewShakeDirection)shakeDirection
    completion:(void (^)(void))completionHandler {
    
    __weak __typeof(self) weakSelf = self;
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:interval
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                     animations:^{
        if (shakeDirection == MGRViewShakeDirectionVertical) {
            weakSelf.transform = CGAffineTransformMakeTranslation(0, delta * direction);
        } else if (shakeDirection == MGRViewShakeDirectionRotation) {
            weakSelf.transform = CGAffineTransformMakeRotation(M_PI * delta / 1000.0 * direction);
        } else if (shakeDirection == MGRViewShakeDirectionHorizontal) {
            weakSelf.transform = CGAffineTransformMakeTranslation(delta * direction, 0);
        } else {
            NSCAssert(FALSE, @"shakeDirection 이 잘못들어왔다.");
        }
    } completion:^(UIViewAnimatingPosition finalPosition) {
        if(current >= times) { // 원하는 숫자만큼 흔들었드면 재자리로 돌아와서 끝내라. return!!
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:interval
                                                                  delay:0.0
                                                                options:UIViewAnimationOptionCurveEaseInOut
                                                             animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }
                                                             completion:^(UIViewAnimatingPosition finalPosition) {
                if(completionHandler != nil) {
                    completionHandler();
                }
            }];
        } else {
            [weakSelf _shake:times
                   direction:(direction * -1)
                currentTimes:(current + 1)
                   withDelta:delta
                       speed:interval
              shakeDirection:shakeDirection
                  completion:completionHandler];
        }
    }];
}


#pragma mark - NS_UNAVAILABLE
// CALayer로 구성해보았다. 근데, UITextField가 조금 늦게 따라옴. 그래서 그냥 폐기하려고한다.
- (void)_shake:(int)times
     withDelta:(CGFloat)delta           // 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
         speed:(NSTimeInterval)interval
shakeDirection:(MGRViewShakeDirection)shakeDirection
    completion:(void (^)(void))completionHandler __attribute__((deprecated("_shake:direction:currentTimes:withDelta:speed:shakeDirection:completion: 사용해라."))) {
    
    CABasicAnimation *animation;
    switch (shakeDirection) {
        case MGRViewShakeDirectionVertical: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            animation.fromValue = [NSNumber numberWithFloat:(-1.0 * delta)];
            animation.toValue   = [NSNumber numberWithFloat:delta];
            break; }
        case MGRViewShakeDirectionRotation: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            animation.fromValue = [NSNumber numberWithFloat:(-1.0 * (M_PI * delta / 1000.0f))];
            animation.toValue   = [NSNumber numberWithFloat:(M_PI * delta / 1000.0f)];
            break; }
        case MGRViewShakeDirectionHorizontal: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            animation.fromValue = [NSNumber numberWithFloat:(-1.0 * delta)];
            animation.toValue   = [NSNumber numberWithFloat:delta];
            break; }
        default:
            break;
    }
  
    animation.beginTime = 0.0;
    animation.duration = interval;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = times;
    animation.autoreverses = YES;
    //animation.fillMode = kCAFillModeForwards;
    //animation.removedOnCompletion = NO;
    /// setCompletionBlock은 - addAnimation:forKey: 보다 위에 등장해야한다.
    [CATransaction setCompletionBlock:^{
        completionHandler();
    }];
  
    [self.layer addAnimation:animation forKey:@"shake"];
  
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    self.layer.affineTransform = CGAffineTransformIdentity;
    [CATransaction commit];
}

@end

@implementation UIView (Hinge)

- (void)mgrHingeWithAnchor:(MGRViewHingeAnchor)hingeAnchor
                    radian:(CGFloat)radian
              tearDuration:(NSTimeInterval)tearDuration
              fallDuration:(NSTimeInterval)fallDuration
                completion:(void(^_Nullable)(void))completion {
    if (self.frame.size.width <= 0.0 || self.frame.size.height <= 0.0) {
        NSCAssert(FALSE, @"넓이가 존재하는 것만 해라.");
    }
    int sign = 1;
    if (hingeAnchor == MGRViewHingeAnchorTopLeft) {
        CGPoint point = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        self.layer.anchorPoint = CGPointZero;
        self.center = point;
    } else {
        CGPoint point = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
        self.layer.anchorPoint = CGPointMake(1.0, 0.0);
        self.center = point;
        sign = -1;
    }
    
    CGPoint dropPoint = CGPointMake(self.center.x, self.center.y + UIScreen.mainScreen.bounds.size.height);
    
    UIViewPropertyAnimator *animator =
    [[UIViewPropertyAnimator alloc] initWithDuration:tearDuration
                                    timingParameters:[UICubicTimingParameters mgrParametersWithCustomCurve:MGRViewAnimationCurveEaseOutBack]];
    [animator addAnimations:^{
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, radian * sign);
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:fallDuration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveEaseIn
                                                         animations:^{
            self.center = dropPoint;
            self.alpha = 0.0;
        }
                                                         completion:^(UIViewAnimatingPosition finalPosition) {
            if (completion != nil) {
                completion();
            }
        }];
    }];
    
    [animator startAnimationAfterDelay:0.0];
}

- (void)mgrHingeWithAnchor:(MGRViewHingeAnchor)hingeAnchor
                completion:(void(^)(void))completion {
    if (self.frame.size.width <= 0.0 || self.frame.size.height <= 0.0) {
        NSCAssert(FALSE, @"넓이가 존재하는 것만 해라.");
    }
    CGFloat radian = atan2(self.frame.size.width, self.frame.size.height);
    [self mgrHingeWithAnchor:hingeAnchor radian:radian tearDuration:0.5 fallDuration:0.4 completion:completion];
}

/** Deprecated.
- (void)mgrHingeWithAnchor:(MGRViewHingeAnchor)hingeAnchor
                completion:(void(^)(void))completion {
    int sign = 1;
    if (hingeAnchor == MGRViewHingeAnchorTopLeft) {
        CGPoint point = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        self.layer.anchorPoint = CGPointZero;
        self.center = point;
    } else {
        CGPoint point = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
        self.layer.anchorPoint = CGPointMake(1.0, 0.0);
        self.center = point;
        sign = -1;
    }
    
    CGPoint dropPoint = CGPointMake(self.center.x, self.center.y + 300.0);
    
    UIViewPropertyAnimator *animator =
    [[UIViewPropertyAnimator alloc] initWithDuration:0.5
                                    timingParameters:[UICubicTimingParameters mgrParametersWithCustomCurve:MGRViewAnimationCurveEaseOutBack]];
    [animator addAnimations:^{
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (95.0 * M_PI) / 180.0 * sign);
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.4
                                                                delay:0.0
                                                            options:UIViewAnimationOptionCurveEaseIn
                                                            animations:^{
            self.center = dropPoint;
            self.alpha = 0.0;
        }
                                                            completion:^(UIViewAnimatingPosition finalPosition) {
            if (completion != nil) {
                completion();
            }
        }];
    }];
    
    [animator startAnimationAfterDelay:0.0];
}
*/

@end

/** Hinge 대신에 다이나믹 애니메이터로 만들 수도 있다.
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = self.moveView.frame;
        [self.moveView removeFromSuperview];
        [self.view addSubview:self.moveView];
        self.moveView.frame = frame;

        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.dynamicAnimator.delegate = self;
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.moveView]];
        [self.dynamicAnimator addBehavior:gravityBehavior];

        CGPoint attachedToAnchor = CGPointMake(self.moveView.frame.origin.x + self.moveView.frame.size.width, self.moveView.frame.origin.y-1.0);
        UIOffset offsetFromCenter = UIOffsetMake((self.moveView.frame.size.width / 2.0), -(self.moveView.frame.size.height / 2.0));

        UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.moveView
                                                   offsetFromCenter:offsetFromCenter
                                                   attachedToAnchor:attachedToAnchor];
        attachBehavior.length = 1.0;
        attachBehavior.damping = 0.1;
        attachBehavior.frequency = 0;
        [self.dynamicAnimator addBehavior:attachBehavior];

        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.moveView]];
        collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
//        collision.translatesReferenceBoundsIntoBoundary = YES;
        [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0.0, 0.0, -self.view.bounds.size.height, 0.0)];
        [self.dynamicAnimator addBehavior:collisionBehavior];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dynamicAnimator removeBehavior:attachBehavior];
        });
    });


#pragma mark - <UIDynamicAnimatorDelegate>
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.dynamicAnimator removeAllBehaviors];
    self.dynamicAnimator = nil;
    [self.moveView removeFromSuperview];
    self.moveView = nil;
    NSLog(@"pause");
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {
    NSLog(@"resume");
}
*/
