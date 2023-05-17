//
//  MGUSideBarDismissalAnimator.m
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
//! Dismissal Animator 에서는 다음과 같다. Presentation Animator에서는 null이 되는 것이 반대다.
//! fromView controller [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]
//! toView   controller [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]
//!
//! fromView            [transitionContext viewForKey:UITransitionContextFromViewKey]);
//! toView              [transitionContext viewForKey:UITransitionContextToViewKey] <---- null이 됨!.
//! toView              [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view

//! [transitionContext containerView]는 MGRPresentationController 클래스의의 self.containerView와 동일한 포인터이다.

//! [transitionContext finalFrameForViewController:self.toViewController];
//! [transitionContext finalFrameForViewController:self.fromViewController];
//! [transitionContext initialFrameForViewController:self.toViewController];
//! [transitionContext initialFrameForViewController:self.fromViewController];

#import "MGUSideBarDismissalAnimator.h"
#import "MGUSideBarController.h"
#import "MGUSideBarView.h"

@interface MGUSideBarDismissalAnimator ()
@property (nonatomic, weak) MGUSideBarConfig *sideBarConfig;

@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak, readonly) __kindof UIViewController *fromViewController;
@property (nonatomic, weak, readonly) __kindof UIViewController *toViewController;
@property (nonatomic, weak, readonly) __kindof UIView *fromView;
@property (nonatomic, weak, readonly) __kindof UIView *toView;
@end

@implementation MGUSideBarDismissalAnimator
@dynamic fromViewController;
@dynamic toViewController;
@dynamic fromView;
@dynamic toView;

- (instancetype)initWithSideBarConfig:(MGUSideBarConfig *)sideBarConfig {
    self = [super init];
    if (self) {
        _sideBarConfig = sideBarConfig;
    }
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // UIViewPropertyAnimator(그냥 UIView 애니메이션이 아닌)는 UIPercentDrivenInteractiveTransition를 사용하기 위해 다음이 필요하다.
    UIViewPropertyAnimator *animator = (UIViewPropertyAnimator *)[self interruptibleAnimatorForTransition:transitionContext];
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

//! UIViewPropertyAnimator(그냥 UIView 애니메이션이 아닌)는 UIPercentDrivenInteractiveTransition 적용을 받기 위해서는 다음의 메서드가 필수로 필요하다.
//! 그러나 CAAnimation에서는 언급되어서는 안된다.
- (id<UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    CGFloat displaceWidth = 0.0;
    MGUSideBarWidthDeterminant widthDeterminant = self.sideBarConfig.widthDeterminant;
    if (widthDeterminant.isRatio == YES) {
        displaceWidth = self.fromView.frame.size.width * widthDeterminant.ratio;
    } else {
        displaceWidth = widthDeterminant.absoluteWidth;
        if (widthDeterminant.ratio != 0.0) {
            displaceWidth = MIN(displaceWidth, self.fromView.frame.size.width * widthDeterminant.ratio);
        }
    }
    
    CGRect initialFrame = self.fromView.frame;
    CGRect lastFrame = initialFrame;
    
    if (self.sideBarConfig.isDirectionLeft == YES) {
        lastFrame.origin.x = initialFrame.origin.x - displaceWidth;
    } else {
        lastFrame.origin.x = initialFrame.origin.x + displaceWidth;
    }
    
    void (^animationsBlock)(void) = ^{
        if (!(self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
            self.fromView.frame = lastFrame;
        }
        
        if ((self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleDisplace) ||
            (self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
            CGRect frame = self.toView.frame;
            frame.origin.x = 0.0;
            self.toView.frame = frame;
        }
    };
    
    UIViewPropertyAnimator *animator =
    [[UIViewPropertyAnimator alloc] initWithDuration:[self transitionDuration:transitionContext]
                                                curve:UIViewAnimationCurveEaseInOut
                                            animations:animationsBlock];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        if (transitionContext.transitionWasCancelled == NO) { // 정상적인 디스미스가 완료되었다.
            if ([self.toViewController isKindOfClass:[MGUSideBarDumiController class]] == YES) {
                [self.toViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
    }];
    
    //! gesture로도 발동하게 만들었으므로 transitionCoordinator를 여기에 넣어야한다.
    //! Present 는 gesture로 발동하지 않으므로 - animateTransition:에 넣어야한다.
    [self.fromView layoutIfNeeded];
    if (self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal) {
        MGUSideBarView *view = (MGUSideBarView *)self.fromView;
        UIView *maskView = view.maskView;
        CGRect maskViewLastFrame = view.containerView.frame;
        
        if (self.sideBarConfig.isDirectionLeft == YES) {
            maskViewLastFrame.origin.x = maskViewLastFrame.origin.x - maskViewLastFrame.size.width;
        } else {
            maskViewLastFrame.origin.x = maskViewLastFrame.origin.x + maskViewLastFrame.size.width;
        }
        id <UIViewControllerTransitionCoordinator>transitionCoordinator = [self.fromViewController.presentingViewController transitionCoordinator];
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            maskView.frame = maskViewLastFrame;
            view.shadowView.frame = view.containerView.frame;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        }];
    }
    
    return animator;
}


#pragma mark - 세터 & 게터
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

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
