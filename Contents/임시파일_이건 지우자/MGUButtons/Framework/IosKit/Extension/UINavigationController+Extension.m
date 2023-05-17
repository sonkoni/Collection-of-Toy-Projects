//
//  UINavigationController+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

- (void)mgrPushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
              completionBlock:(void(^_Nullable)(void))completionBlock
        secondCompletionBlock:(void(^_Nullable)(void))secondCompletionBlock {
    
    [self pushViewController:viewController animated:animated];
    
    id <UIViewControllerTransitionCoordinator>transitionCoordinator =  self.transitionCoordinator;
    if (animated == NO || transitionCoordinator == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock!= nil) {
                completionBlock();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (secondCompletionBlock!= nil) {
                        secondCompletionBlock();
                    }
                });
            }
        });
    } else {
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (completionBlock!= nil) {
                completionBlock();
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (secondCompletionBlock!= nil) {
                secondCompletionBlock();
            }
        }];
    }
}


- (UIViewController *)mgrPopViewControllerAnimated:(BOOL)animated
                                   completionBlock:(void(^_Nullable)(void))completionBlock
                             secondCompletionBlock:(void(^_Nullable)(void))secondCompletionBlock {
    
    UIViewController *result = [self popViewControllerAnimated:animated];
    
    id <UIViewControllerTransitionCoordinator>transitionCoordinator =  self.transitionCoordinator;
    if (animated == NO || transitionCoordinator == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock!= nil) {
                completionBlock();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (secondCompletionBlock!= nil) {
                        secondCompletionBlock();
                    }
                });
            }
        });
    } else {
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (completionBlock!= nil) {
                completionBlock();
            }
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (secondCompletionBlock!= nil) {
                secondCompletionBlock();
            }
        }];
    }
    
    return result;
}

@end
    
