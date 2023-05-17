//
//  MGUSideBarPresentationAnimator.m
//  SlideSideBarMenuProject
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
//! Presentation Animator 에서는 다음과 같다. Dismissal Animator에서는 null이 되는 것이 반대다.
//! fromView controller [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]
//! toView   controller [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]
//!
//! fromView            [transitionContext viewForKey:UITransitionContextFromViewKey]); <---- null이 됨!.
//! fromView            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view
//! toView              [transitionContext viewForKey:UITransitionContextToViewKey]

//! [transitionContext containerView]는 MGRPresentationController 클래스의의 self.containerView와 동일한 포인터이다.


//! [transitionContext finalFrameForViewController:self.toViewController];
//! [transitionContext finalFrameForViewController:self.fromViewController];
//! [transitionContext initialFrameForViewController:self.toViewController];
//! [transitionContext initialFrameForViewController:self.fromViewController];

#import "MGUSideBarPresentationAnimator.h"
#import "MGUSideBarController.h"
#import "MGUSideBarView.h"

@interface MGUSideBarPresentationAnimator ()
@property (nonatomic, weak) MGUSideBarConfig *sideBarConfig;

@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak, readonly) __kindof UIViewController *fromViewController;
@property (nonatomic, weak, readonly) __kindof UIViewController *toViewController;
@property (nonatomic, weak, readonly) __kindof UIView *fromView;
@property (nonatomic, weak, readonly) __kindof UIView *toView;
@end

@implementation MGUSideBarPresentationAnimator
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
    //! gesture로 발동하지 않으므로 transitionCoordinator를 여기에 넣어야한다.
    //! Dismiss 는 gesture로 발동하므로 - interruptibleAnimatorForTransition:에 넣어야한다.
    [self.toView layoutIfNeeded];
    if (self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal) {
        MGUSideBarView *view = (MGUSideBarView *)self.toView;
        UIView *maskView = view.maskView;
        CGRect maskViewLastFrame = view.containerView.frame;
        CGRect maskViewInitialFrame = maskViewLastFrame;
        
        if (self.sideBarConfig.isDirectionLeft == YES) {
            maskViewInitialFrame.origin.x = maskViewInitialFrame.origin.x - maskViewLastFrame.size.width;
        } else {
            maskViewInitialFrame.origin.x = maskViewInitialFrame.origin.x + maskViewLastFrame.size.width;
        }
        
        maskView.frame = maskViewInitialFrame;
        view.shadowView.frame = maskViewLastFrame;
        id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.toViewController.presentingViewController transitionCoordinator];
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            maskView.frame = maskViewLastFrame;
            
            CGRect shadowViewLastFrame = maskViewLastFrame;
            if (self.sideBarConfig.isDirectionLeft == YES) {
                shadowViewLastFrame.origin.x = shadowViewLastFrame.origin.x + shadowViewLastFrame.size.width;
            } else {
                shadowViewLastFrame.origin.x = shadowViewLastFrame.origin.x - shadowViewLastFrame.size.width;
            }
            view.shadowView.frame = shadowViewLastFrame;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    }
    
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

//! UIViewPropertyAnimator(그냥 UIView 애니메이션이 아닌)는 UIPercentDrivenInteractiveTransition 적용을 받기 위해서는 다음의 메서드가 필수로 필요하다.
//! 그러나 CAAnimation에서는 언급되어서는 안된다.
- (id<UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    self.toView.frame = [transitionContext finalFrameForViewController:self.toViewController];
    [[transitionContext containerView] addSubview:self.toView]; // UITransitionView는 윈도우에 붙어있음.
    
    CGFloat displaceWidth = 0.0;
    MGUSideBarWidthDeterminant widthDeterminant = self.sideBarConfig.widthDeterminant;
    if (widthDeterminant.isRatio == YES) {
        displaceWidth = self.toView.frame.size.width * widthDeterminant.ratio;
    } else {
        displaceWidth = widthDeterminant.absoluteWidth;
        if (widthDeterminant.ratio != 0.0) {
            displaceWidth = MIN(displaceWidth, self.toView.frame.size.width * widthDeterminant.ratio);
        }
    }
    
    CGRect lastFrame = self.toView.frame;
    CGRect initialFrame = lastFrame;
    if (self.sideBarConfig.isDirectionLeft == YES) {
        initialFrame.origin.x = lastFrame.origin.x - displaceWidth; // - lastFrame.size.width;
    } else {
        initialFrame.origin.x = lastFrame.origin.x + displaceWidth; //  + lastFrame.size.width;
    }
    
    if (!(self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
        self.toView.frame = initialFrame;
    }

    CGRect fromViewLastFrame = self.fromView.frame;
    if (self.sideBarConfig.isDirectionLeft == YES) {
        fromViewLastFrame.origin.x = fromViewLastFrame.origin.x + displaceWidth;
    } else {
        fromViewLastFrame.origin.x = fromViewLastFrame.origin.x - displaceWidth;
    }
    
    void (^animationsBlock)(void) = ^{
        if (!(self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
            self.toView.frame = lastFrame;
        }
        if ((self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleDisplace) ||
            (self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
            self.fromView.frame = fromViewLastFrame;
        }
    };
    
    UIViewPropertyAnimator *animator =
    [[UIViewPropertyAnimator alloc] initWithDuration:[self transitionDuration:transitionContext]
                                                curve:UIViewAnimationCurveEaseInOut
                                            animations:animationsBlock];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];  //! 이거 안해주면 얼어버린다.
    }];
    
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
    return [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
}

- (__kindof UIView *)toView {
    return [self.transitionContext viewForKey:UITransitionContextToViewKey];
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
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
