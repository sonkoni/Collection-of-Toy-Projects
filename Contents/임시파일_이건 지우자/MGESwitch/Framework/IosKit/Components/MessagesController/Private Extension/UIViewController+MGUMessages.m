//
//  UIViewController+MGUMessages.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/20.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIViewController+MGUMessages.h"
#import "MGUMessagesConfig.h"
#import "MGUMessagesViewController.h"

@implementation UIViewController (MGUMessages)
- (BOOL)sm_isVisibleView:(UIView *)view {
    if (view.isHidden == YES || view.alpha == 0.0) {
        return NO;
    }
    
    CGRect frame = [self.view convertRect:view.bounds fromView:view];
    if (CGRectIntersectsRect(self.view.bounds, frame) == NO) {
        return NO;
    }
    return YES;
}

- (UIViewController *)sm_selectPresentationContextTopDown:(MGUMessagesConfig *)config {
    UIViewController *presented = self.presentedViewController;
    if (presented != nil) {
        return [presented sm_selectPresentationContextTopDown:config];
    }
    
    UINavigationController *navigationController = [self sm_selectNavigationControllerTopDown];
    if (config.presentationStyle == MGUMessagesPresentationStyleTop && navigationController != nil) {
        return navigationController;
    }
    
    UITabBarController *tabBarController = [self sm_selectTabBarControllerTopDown];
    if (config.presentationStyle == MGUMessagesPresentationStyleBottom && tabBarController != nil) {
        return tabBarController;
    }
    
    return [MGUMessagesViewController newInstanceConfig:config];
}

- (UIViewController *)sm_selectPresentationContextBottomUp:(MGUMessagesConfig *)config {
//    let topBottomStyle = config.presentationStyle.topBottomStyle
    UIViewController *parentViewController = self.parentViewController;
    if (parentViewController != nil) {
        UINavigationController *navigationController = (UINavigationController *)parentViewController;
        UITabBarController *tabBarController = (UITabBarController *)parentViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]] == YES) {
            if (config.presentationStyle == MGUMessagesPresentationStyleTop &&
                [navigationController sm_isVisibleView:navigationController.navigationBar]) {
                return navigationController;
            }
            return [navigationController sm_selectPresentationContextBottomUp:config];
            
        } else if ([tabBarController isKindOfClass:[UITabBarController class]] == YES) {
            if (config.presentationStyle == MGUMessagesPresentationStyleBottom &&
                [tabBarController sm_isVisibleView:tabBarController.tabBar]) {
                return tabBarController;
            }
            
            return [tabBarController sm_selectPresentationContextBottomUp:config];
        }
    }
        
    if ([self.view isKindOfClass:[UITableView class]] == YES) {
        // Never select scroll view as presentation context
        // because, you know, it scrolls.
        if (parentViewController != nil) {
            [parentViewController sm_selectPresentationContextBottomUp:config];
        } else {
            return [MGUMessagesViewController newInstanceConfig:config];
        }
    }
    
    return self;
}


#pragma mark - Private
- (UINavigationController * _Nullable)sm_selectNavigationControllerTopDown {
    UIViewController *presented = self.presentedViewController;
    if (presented != nil) {
        return [presented sm_selectNavigationControllerTopDown];
    }
    
    UINavigationController *navigationController = (UINavigationController *)self;
    UITabBarController *tabBarController = (UITabBarController *)self;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        if ([navigationController sm_isVisibleView:navigationController.navigationBar] == YES ) {
            return navigationController;
        }
        return [navigationController.topViewController sm_selectNavigationControllerTopDown];
    } else if ([tabBarController isKindOfClass:[UITabBarController class]] == YES) {
        return [tabBarController.selectedViewController sm_selectNavigationControllerTopDown];
    }
    return nil;
}
- (UITabBarController * _Nullable)sm_selectTabBarControllerTopDown {
    UIViewController *presented = self.presentedViewController;
    if (presented != nil) {
        return [presented sm_selectTabBarControllerTopDown];
    }
    
    UINavigationController *navigationController = (UINavigationController *)self;
    UITabBarController *tabBarController = (UITabBarController *)self;
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        return [navigationController.topViewController sm_selectTabBarControllerTopDown];
    } else if ([tabBarController isKindOfClass:[UITabBarController class]] == YES) {
        if ([tabBarController sm_isVisibleView:tabBarController.tabBar] == YES ) {
            return tabBarController;
        }
        return [tabBarController.selectedViewController sm_selectTabBarControllerTopDown];
    }
    return nil;
}

@end
