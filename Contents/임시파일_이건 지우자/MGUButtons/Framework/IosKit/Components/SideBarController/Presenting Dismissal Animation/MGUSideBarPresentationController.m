//
//  MGUSideBarPresentationController.m
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
//! 기본적으로 다음의 프라퍼티를 갖고 있다.
//! self.presentingViewController
//! self.presentedViewController
//! self.presentingViewController.view
//! self.presentedView
//! self.frameOfPresentedViewInContainerView

#import "MGUSideBarPresentationController.h"
#import "MGUSideBarController.h"
#import "UIView+AutoLayout.h"
#import "UIView+Recurrence.h"

@interface MGUSideBarPresentationController ()
@property (nonatomic, weak) MGUSideBarConfig *sideBarConfig;
@end

@implementation MGUSideBarPresentationController
#pragma mark - 띄우기
- (void)presentationTransitionWillBegin {
    self.presentedViewController.view.layer.cornerRadius = 6.0;
    self.presentedViewController.view.layer.masksToBounds = YES;

    // Reveal 스타일일 경우에는 Dimming을 하지 않는 것이 좋을 것 같다.
    if (self.sideBarConfig.transitionStyle & MGUSideBarControllerTransitionStyleReveal) {
        return;
    }
    
    self.backgroundDimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundDimmingView.alpha = 0.0;
    self.backgroundDimmingView.backgroundColor = [UIColor blackColor]; // 뒷 배경이 흐려지는 것은 이놈 탓이다.
    [self.containerView addSubview:self.backgroundDimmingView]; // self.containerView 는 UITransitionView이다.
    [self.backgroundDimmingView mgrPinEdgesToSuperviewEdges]; // 오토레이아웃!
    

    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self.presentingViewController transitionCoordinator];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.backgroundDimmingView.alpha = 0.6;
        } else {
            self.backgroundDimmingView.alpha = 0.4;
        }
        
        } completion:nil];
    //
    // dark background 뷰에서 애니메이션을 만들었다.
    // _dimmingView addSubview:[[self presentedViewController] view]]; 여기서 붙이지 않았다.
    // MGRPresentationAnimator 클래스에서 UITransitionView(=self.containerView)에 붙였다.
    // 즉, [self.containerView addSubview:[[self presentedViewController] view]]; 이런 효과이다. 대상은 역시 alertView이다.
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];

    if (completed == NO) { // 정상적으로 완료되지 않았음을 의미한다. 위키 : Api:UIKit/UIPresentationController/- presentationTransitionDidEnd:
        [self.backgroundDimmingView removeFromSuperview]; // 일종의 보일러 코드 라고 보자.
    } else {
        if ([self.presentedViewController isMemberOfClass:[MGUSideBarController class]] == YES) {
            MGUSideBarController *sideBarController = (MGUSideBarController *)(self.presentedViewController);
            if (sideBarController.configuration.acceptFirstResponder == YES) {  // 텍스트 필드가 존재할 때. 띄우면서 퍼스트 리스폰더로 만들것인지
                UIView *view = sideBarController.childViewControllers.firstObject.view;
                NSArray <__kindof UITextField *>*textFields = [view mgrRecurrenceAllSubviewsOfType:[UITextField class]];
                for (UITextField *textField in textFields) {
                    if (textField.hidden == NO && textField.userInteractionEnabled == YES) {
                        [textField becomeFirstResponder];
                        break;
                    }
                }
            }
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


#pragma mark - 생성 & 소멸
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                  sideBarConfig:(MGUSideBarConfig *)sideBarConfig {
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        _sideBarConfig = sideBarConfig;
        CommonInit(self);
    }
    return self;
}


static void CommonInit(MGUSideBarPresentationController *self) {}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController { NSCAssert(FALSE, @"- initWithPresentedViewController:presentingViewController: 사용금지."); return nil; }
@end


// 디폴트 값이 NO이다. YES로 하면 띄우면서 띄워 올리는 주체가 되는 뷰를 제거 시켜버린다. 구경하고 싶다면 YES로 해봐라.
//- (BOOL)shouldRemovePresentersView {
//    return YES;
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {} completion:nil];
//}
