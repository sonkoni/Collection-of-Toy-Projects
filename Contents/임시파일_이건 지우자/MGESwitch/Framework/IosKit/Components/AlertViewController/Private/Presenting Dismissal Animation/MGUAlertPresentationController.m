//
//  MGUAlertPresentationController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

//! 기본적으로 다음의 프라퍼티를 갖고 있다.
//! self.presentingViewController
//! self.presentedViewController
//! self.presentingViewController.view
//! self.presentedView
//! self.frameOfPresentedViewInContainerView

#import "MGUAlertPresentationController.h"
#import "MGUAlertViewController.h"
#import "UIView+AutoLayout.h"

@interface MGUAlertPresentationController ()
@end
@implementation MGUAlertPresentationController


#pragma mark - 띄우기
- (void)presentationTransitionWillBegin {
    self.presentedViewController.view.layer.cornerRadius = 6.0f;
    self.presentedViewController.view.layer.masksToBounds = YES;

    self.backgroundDimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundDimmingView.alpha = 0.0;
    self.backgroundDimmingView.backgroundColor = [UIColor blackColor]; // 뒷 배경이 흐려지는 것은 이놈 탓이다.
    [self.containerView addSubview:self.backgroundDimmingView]; // self.containerView 는 UITransitionView이다.
    [self.backgroundDimmingView mgrPinEdgesToSuperviewEdges]; // 오토레이아웃!
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.backgroundDimmingView addGestureRecognizer:tapGR];

    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.backgroundDimmingView.alpha = 0.6;
        } else {
            self.backgroundDimmingView.alpha = 0.4;
        }
        
        } completion:nil];

    if (self.transitionStyle & MGUAlertViewTransitionStyleBGScale) {
        [self runningScaleAnimationWithShrink:YES];
    }
    //
    // dark background 뷰에서 애니메이션을 만들었다.
    // _dimmingView addSubview:[[self presentedViewController] view]]; 여기서 붙이지 않았다.
    // MGUAlertPresentationAnimator 클래스에서 UITransitionView(=self.containerView)에 붙였다.
    // 즉, [self.containerView addSubview:[[self presentedViewController] view]]; 이런 효과이다. 대상은 역시 alertView이다.
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];

    if (completed == NO) { // 정상적으로 완료되지 않았음을 의미한다. 위키 : Api:UIKit/UIPresentationController/- presentationTransitionDidEnd:
        [self.backgroundDimmingView removeFromSuperview]; // 일종의 보일러 코드 라고 보자.
    } else {
        if ([self.presentedViewController isMemberOfClass:[MGUAlertViewController class]] == YES) { // Sheet는 Text Field가 없다.
            MGUAlertViewController *alertViewController = (MGUAlertViewController *)(self.presentedViewController);
            UITextField *textField = alertViewController.textFields.firstObject;
            [textField becomeFirstResponder];
        }
    }
}


#pragma mark - 날리기
- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.backgroundDimmingView.alpha = 0.0;
    } completion:nil];
    
    if (self.transitionStyle & MGUAlertViewTransitionStyleBGScale) {
        [self runningScaleAnimationWithShrink:NO];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];

    if (completed == YES) { // 오직, completed parameter가 YES인 경우에만 커스텀 뷰를 제거해야한다. 보일러 코드.
        [self.backgroundDimmingView removeFromSuperview];
        [self.presentingViewController.view.layer removeAllAnimations];
    }
}


#pragma mark - layout
- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    self.presentedView.frame = [self frameOfPresentedViewInContainerView]; // 디폴트 구현은 container view의 frame rectangle
    //
    // 본 앱에서는 위 둘의 frame이 모두 같았다.
}

- (BOOL)shouldPresentInFullscreen { // 디폴트 YES, 뒤에가 보인다면(비친다면) NO로 설정하자. CA 애니메이션을 쓴다면 삭제해도 무관하다.
    return NO;
}


#pragma mark - 커스텀 컨트롤
- (void)tapGestureRecognized:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.backgroundTapDismissalGestureEnabled) {
        MGUAlertViewController *alertViewController = (MGUAlertViewController *)(self.presentedViewController);
        NSArray<MGUAlertAction *> *actions = alertViewController.actions;
        for (MGUAlertAction *action in actions) {
            if (action.style == UIAlertActionStyleCancel) {
                __weak __typeof(action) weakAction = action;
                void (^completionBlock)(void) = ^{
                    if (action.handler != nil) {
                        action.handler(weakAction);
                    }
                };
                [self.presentingViewController dismissViewControllerAnimated:YES completion:completionBlock];
                return;
            }
        }
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//! CAAnimation이 작동에 문제가 없다. UIView 애니메이션에는 버그가 존재한다.
- (void)runningScaleAnimationWithShrink:(BOOL)isShrink {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    if (isShrink == YES) {
        if (self.presentingViewController.view.layer.presentationLayer != nil) {
            CATransform3D transform  = self.presentingViewController.view.layer.presentationLayer.transform;
            scaleAnimation.fromValue = @(transform.m11); // <- 현재 스케일에 해당한다.
        } else {
            scaleAnimation.fromValue = @(1.0);
        }
        scaleAnimation.toValue       = @(0.91);
    } else {
        if (self.presentingViewController.view.layer.presentationLayer != nil) {
            CATransform3D transform  = self.presentingViewController.view.layer.presentationLayer.transform;
            scaleAnimation.fromValue = @(transform.m11); // <- 현재 스케일에 해당한다.
        } else {
            scaleAnimation.fromValue = @(0.91);
        }
        scaleAnimation.toValue       = @(1.0);
    }
      
    scaleAnimation.duration            = 0.2;
    scaleAnimation.beginTime           = 0.0;
    scaleAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode            = kCAFillModeForwards;
    [CATransaction setCompletionBlock:^{}];
    [self.presentingViewController.view.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
    [CATransaction begin]; // begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

@end


// 디폴트 값이 NO이다. YES로 하면 띄우면서 띄워 올리는 주체가 되는 뷰를 제거 시켜버린다. 구경하고 싶다면 YES로 해봐라.
//- (BOOL)shouldRemovePresentersView {
//    return YES;
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {} completion:nil];
//}
