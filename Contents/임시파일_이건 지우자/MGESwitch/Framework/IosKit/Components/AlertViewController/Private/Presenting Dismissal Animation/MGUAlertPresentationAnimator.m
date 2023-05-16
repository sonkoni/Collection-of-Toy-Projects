//
//  MGUAlertPresentationAnimator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
//! Presentation Animator 에서는 다음과 같다. Dismissal Animator에서는 null이 되는 것이 반대다.
//! fromView controller [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]
//! toView   controller [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]
//!
//! fromView            [transitionContext viewForKey:UITransitionContextFromViewKey]); <---- null이 됨!.
//! fromView            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view
//! toView              [transitionContext viewForKey:UITransitionContextToViewKey]

//! [transitionContext containerView]는 MGUAlertPresentationController 클래스의의 self.containerView와 동일한 포인터이다.


//! [transitionContext finalFrameForViewController:self.toViewController];
//! [transitionContext finalFrameForViewController:self.fromViewController];
//! [transitionContext initialFrameForViewController:self.toViewController];
//! [transitionContext initialFrameForViewController:self.fromViewController];

#import "MGUAlertPresentationAnimator.h"

@interface MGUAlertPresentationAnimator ()
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak, readonly) __kindof UIViewController *fromViewController;
@property (nonatomic, weak, readonly) __kindof UIViewController *toViewController;
@property (nonatomic, weak, readonly) __kindof UIView *fromView;
@property (nonatomic, weak, readonly) __kindof UIView *toView;
@end

@implementation MGUAlertPresentationAnimator
@dynamic fromViewController;
@dynamic toViewController;
@dynamic fromView;
@dynamic toView;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    self.toView.frame = [transitionContext finalFrameForViewController:self.toViewController];
    [[transitionContext containerView] addSubview:self.toView]; // UITransitionView는 윈도우에 붙어있음.
    
    if ((self.transitionStyle & MGUAlertViewTransitionStyleFGFade) == NO) {
        CASpringAnimation *translationYSpringAnimation = [CASpringAnimation animationWithKeyPath:@"transform.translation.y"];
        
        if (self.transitionStyle & MGUAlertViewTransitionStyleFGSlideFromBottom) {
            translationYSpringAnimation.fromValue = @(1.0 * self.toView.frame.size.height); // 아래에서 올라와
        } else {
            translationYSpringAnimation.fromValue = @(-1.0 * self.toView.frame.size.height); // 위에서 내려와
        }
        translationYSpringAnimation.toValue   = @(0.0f);
        translationYSpringAnimation.removedOnCompletion = NO;
        translationYSpringAnimation.fillMode            = kCAFillModeForwards;
        translationYSpringAnimation.initialVelocity = 10.0;
        translationYSpringAnimation.mass    = 0.8;
        translationYSpringAnimation.damping = 15.0;
        translationYSpringAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        translationYSpringAnimation.duration = translationYSpringAnimation.settlingDuration; //! <- Api:Core Animation/CASpringAnimation/settlingDuration
        
        CASpringAnimation *rotationZSpringAnimation = [CASpringAnimation animationWithKeyPath:@"transform.rotation.z"];
        if (self.transitionStyle & MGUAlertViewTransitionStyleFGSlideFromTopRotation) {
            rotationZSpringAnimation.fromValue = @(M_PI_4 * 1.3f);
            rotationZSpringAnimation.toValue   = @(0.0f);
            rotationZSpringAnimation.removedOnCompletion = NO;
            rotationZSpringAnimation.fillMode            = kCAFillModeForwards;
            rotationZSpringAnimation.initialVelocity = 10.0;
            rotationZSpringAnimation.mass = 0.8;
            rotationZSpringAnimation.damping = 15.0;
            rotationZSpringAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            rotationZSpringAnimation.duration = rotationZSpringAnimation.settlingDuration; //! <- Api:Core Animation/CASpringAnimation/settlingDuration
        }
        [CATransaction setCompletionBlock:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
            //[transitionContext completeTransition:YES];
            [self.toView.layer removeAllAnimations];
        }];
        
        [self.toView.layer addAnimation:translationYSpringAnimation forKey:@"TranslationYSpringAnimationKey"];
        if (self.transitionStyle & MGUAlertViewTransitionStyleFGSlideFromTopRotation) {
            [self.toView.layer addAnimation:rotationZSpringAnimation forKey:@"RotationZSpringAnimationKey"];
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.toView.layer.transform = CATransform3DIdentity;
        [CATransaction commit];
    } else { // Fade
        
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        CABasicAnimation *opacityAnimation   = [CABasicAnimation animationWithKeyPath:@"opacity"];
        transformAnimation.fromValue = @(1.2);
        transformAnimation.toValue   = @(1.0);
        opacityAnimation.fromValue   = @(0.0);
        opacityAnimation.toValue     = @(1.0);
        CAAnimationGroup *group   = [CAAnimationGroup animation];
        group.removedOnCompletion = NO;
        group.fillMode            = kCAFillModeForwards;
        group.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.duration = [self transitionDuration:transitionContext];
        [group setAnimations:@[transformAnimation, opacityAnimation]];
        [CATransaction setCompletionBlock:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
//            [transitionContext completeTransition:YES];
            [self.toView.layer removeAnimationForKey:@"AnimationGroupKey"];
        }];
        [self.toView.layer addAnimation:group forKey:@"AnimationGroupKey"];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.toView.layer.transform = CATransform3DIdentity;
        self.toView.layer.opacity = 1.0;
        [CATransaction commit];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionStyle & MGUAlertViewTransitionStyleFGFade) {
        return 0.2f;
    } else { // MGUAlertViewTransitionStyleSlideFromTop, MGUAlertViewTransitionStyleSlideFromBottom
        return 0.6f;
    }
}

- (__kindof UIViewController *)fromViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (__kindof UIViewController *)toViewController {
    return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
}

- (__kindof UIView *)fromView {
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
}

- (__kindof UIView *)toView {
    return [self.transitionContext viewForKey:UITransitionContextToViewKey];
}

@end

//! UIViewPropertyAnimator(그냥 UIView 애니메이션이 아닌)는 UIPercentDrivenInteractiveTransition
//! 적용을 받기 위해서는 다음의 메서드가 필수로 필요하다. 그러나 CAAnimation에서는 언급되어서는 안된다.
//- (id<UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//
//    void (^animationsBlock)(void) = ^{
//        fromView.frame = CGRectMake(0.0, fromView.frame.size.height, fromView.frame.size.width, fromView.frame.size.height);
//    };
//
//    UIViewPropertyAnimator *animator =
//    [[UIViewPropertyAnimator alloc] initWithDuration:[self transitionDuration:transitionContext]
//                                               curve:UIViewAnimationCurveLinear
//                                          animations:animationsBlock];
//
//    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
//        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
//    }];
//
//    return animator;
//}
