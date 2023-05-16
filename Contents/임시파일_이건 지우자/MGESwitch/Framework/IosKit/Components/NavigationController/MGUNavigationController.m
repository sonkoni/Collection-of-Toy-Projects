//
//  MGUNavigationController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNavigationController.h"

@interface MGUNavigationController ()
@end

@implementation MGUNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *result = [super popViewControllerAnimated:animated];
    id <UIViewControllerTransitionCoordinator>transitionCoordinator = self.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext>context) {
    } completion:^(id <UIViewControllerTransitionCoordinatorContext>context) {
        if (context.isCancelled == YES) {
            if (self.popCancelledCompletion) { self.popCancelledCompletion(); }
        } else {
            if (self.popSuccessCompletion) { self.popSuccessCompletion(); }
        }
    }];
    return result;
}

- (NSArray <__kindof UIViewController *>*)popToViewController:(UIViewController *)viewController
                                                     animated:(BOOL)animated {
    NSArray <UIViewController *>*result = [super popToViewController:viewController animated:animated];
    id <UIViewControllerTransitionCoordinator>transitionCoordinator = self.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id <UIViewControllerTransitionCoordinatorContext>context) {
        if (context.isCancelled == YES) {
            if (self.popCancelledCompletion) { self.popCancelledCompletion(); }
            // NSLog(@"캔서A"); // <- 손가락으로 발동을 하지 않으므로 무조건 석세스만 할듯.
        } else {
            if (self.popSuccessCompletion) { self.popSuccessCompletion(); }
            // NSLog(@"석세스A");
        }
    }];
    return result; // 제거되는 UIViewController 배열. 앞쪽은 더 밑 바닥에 깔려 있었던 컨트롤러
}

- (NSArray <__kindof UIViewController *>*)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray <UIViewController *>*result = [super popToRootViewControllerAnimated:animated];
    id <UIViewControllerTransitionCoordinator>transitionCoordinator = self.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext>context) {
    } completion:^(id <UIViewControllerTransitionCoordinatorContext>context) {
        if (context.isCancelled == YES) {
            if (self.popCancelledCompletion) { self.popCancelledCompletion(); }
            // NSLog(@"캔서A"); // <- 손가락으로 발동을 하지 않으므로 무조건 석세스만 할듯.
        } else {
            if (self.popSuccessCompletion) { self.popSuccessCompletion(); }
            // NSLog(@"석세스A");
        }
    }];
    return result; // 제거되는 UIViewController 배열. 앞쪽은 더 밑 바닥에 깔려 있었던 컨트롤러
}
@end
