//
//  MGUAlertDismissalAnimator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

//! Dismissal Animator 에서는 다음과 같다. Presentation Animator에서는 null이 되는 것이 반대다.
//! fromView controller [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]
//! toView   controller [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]
//!
//! fromView            [transitionContext viewForKey:UITransitionContextFromViewKey]);
//! toView              [transitionContext viewForKey:UITransitionContextToViewKey] <---- null이 됨!.
//! toView              [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view

//! [transitionContext containerView]는 MGUAlertPresentationController 클래스의의 self.containerView와 동일한 포인터이다.

//! [transitionContext finalFrameForViewController:self.toViewController];
//! [transitionContext finalFrameForViewController:self.fromViewController];
//! [transitionContext initialFrameForViewController:self.toViewController];
//! [transitionContext initialFrameForViewController:self.fromViewController];

#import "MGUAlertDismissalAnimator.h"

@interface MGUAlertDismissalAnimator ()
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak, readonly) __kindof UIViewController *fromViewController;
@property (nonatomic, weak, readonly) __kindof UIViewController *toViewController;
@property (nonatomic, weak, readonly) __kindof UIView *fromView;
@property (nonatomic, weak, readonly) __kindof UIView *toView;
@end

@implementation MGUAlertDismissalAnimator
@dynamic fromViewController;
@dynamic toViewController;
@dynamic fromView;
@dynamic toView;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    if ((self.transitionStyle & MGUAlertViewTransitionStyleFGFade) == NO) {
        CASpringAnimation *translationYSpringAnimation = [CASpringAnimation animationWithKeyPath:@"transform.translation.y"];
        translationYSpringAnimation.fromValue = @(0.0f);
        translationYSpringAnimation.toValue   = @(1.2f * self.fromView.frame.size.height);
        translationYSpringAnimation.removedOnCompletion = NO;
        translationYSpringAnimation.fillMode            = kCAFillModeForwards;
        translationYSpringAnimation.initialVelocity = 10.0;
        translationYSpringAnimation.mass    = 0.3;
        translationYSpringAnimation.stiffness = 150.f;
        translationYSpringAnimation.damping = 20.0;
        translationYSpringAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        translationYSpringAnimation.duration = translationYSpringAnimation.settlingDuration; //! <- Api:Core Animation/CASpringAnimation/settlingDuration
        [CATransaction setCompletionBlock:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
            //[transitionContext completeTransition:YES]; //! 이거 안해주면 얼어버린다.
            [self.fromView.layer removeAllAnimations];
        }];
        [self.fromView.layer addAnimation:translationYSpringAnimation forKey:@"TranslationYSpringAnimationKey"];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.fromView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0.0, (1.2f * self.fromView.frame.size.height), 0.0);
        [CATransaction commit];
        
    } else { // Fade
        CABasicAnimation *opacityAnimation   = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue   = @(1.0);
        opacityAnimation.toValue     = @(0.0);
        opacityAnimation.removedOnCompletion = NO;
        opacityAnimation.fillMode            = kCAFillModeForwards;
        opacityAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        opacityAnimation.duration = [self transitionDuration:transitionContext];
        [CATransaction setCompletionBlock:^{
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
            // [transitionContext completeTransition:YES]; //! 이거 안해주면 얼어버린다.
            [self.fromView.layer removeAnimationForKey:@"OpacityAnimationKey"];
        }];
        [self.fromView.layer addAnimation:opacityAnimation forKey:@"OpacityAnimationKey"];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.fromView.layer.opacity = 0.0;
        [CATransaction commit];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.transitionStyle & MGUAlertViewTransitionStyleFGFade) {
        return 0.3f;
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
    return [self.transitionContext viewForKey:UITransitionContextFromViewKey];
}

- (__kindof UIView *)toView {
    return [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
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
