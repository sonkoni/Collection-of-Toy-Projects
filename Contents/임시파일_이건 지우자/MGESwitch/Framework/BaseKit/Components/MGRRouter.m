//
//  MGRRouter.m
//  Copyright © 2022 mulgrim. All rights reserved.
//

#import "MGRRouter.h"

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
@implementation NSViewController (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier {
    for (NSViewController *presented in self.presentedViewControllers) {
        if ([presented.identifier isEqual:identifier]) {return presented;}
    }
    for (NSViewController *child in self.childViewControllers) {
        if ([child.identifier isEqual:identifier]) {return child;}
    }
    return nil;
}
- (void)mgrOpenScene:(NSViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if ([self.presentedViewControllers containsObject:scene] || [self.childViewControllers containsObject:scene]) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self openScene:scene animated:animated];
    } else {
        [self presentViewControllerAsSheet:scene];
    }
}
- (void)mgrCloseScene:(NSViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    BOOL isPresentedScene = [self.presentedViewControllers containsObject:scene];
    if (!isPresentedScene && ![self.childViewControllers containsObject:scene]) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self closeScene:scene animated:animated];
    } else if (isPresentedScene) {
        [self dismissViewController:scene];
    } else {
        [scene.view removeFromSuperview];
        [scene removeFromParentViewController];
    }
}
- (void)mgrCloseAnimated:(BOOL)animated {
    if (self.parentViewController) {
        [self.parentViewController mgrCloseScene:self animated:animated];
    } else {
        [self.presentingViewController mgrCloseScene:self animated:animated];
    }
}
@end

#elif TARGET_OS_IOS
#import <UIKit/UIKit.h>
@implementation UIViewController (Router)
- (id _Nullable)mgrDigScene:(NSString *)identifier {
    if ([self.presentedViewController.restorationIdentifier isEqual:identifier]) {return self.presentedViewController;}
    for (UIViewController *child in self.childViewControllers) {
        if ([child.restorationIdentifier isEqual:identifier]) {return child;}
    }
    return nil;
}
- (void)mgrOpenScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController == scene || [self.childViewControllers containsObject:scene]) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self openScene:scene animated:animated];
    } else {
        [self presentViewController:scene animated:animated completion:nil];
    }
}
- (void)mgrCloseScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController != scene && ![self.childViewControllers containsObject:scene]) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self closeScene:scene animated:animated];
    } else if (self.presentedViewController == scene) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        [scene.view removeFromSuperview];
        [scene removeFromParentViewController];
    }
}
- (void)mgrCloseAnimated:(BOOL)animated {
    if (self.parentViewController) {
        [self.parentViewController mgrCloseScene:self animated:animated];
    } else {
        [self.presentingViewController mgrCloseScene:self animated:animated];
    }
}
@end


@implementation UINavigationController (Router)
- (void)mgrOpenScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController == scene || self.viewControllers.lastObject == scene) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self openScene:scene animated:animated];
    } else if ([self.viewControllers containsObject:scene]) {
        [self popToViewController:scene animated:animated];
    } else {
        [self pushViewController:scene animated:animated];
    }
}
- (void)mgrCloseScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController != scene && ![self.viewControllers containsObject:scene]) {return;}
    if (self.viewControllers.firstObject == scene) {
        [self mgrCloseAnimated:animated]; // 루트컨트롤러를 닫으면 컨테이너도 닫는다
    } else if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self closeScene:scene animated:animated];
    } else if (self.presentedViewController == scene) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else if (self.topViewController == scene) {
        [self popViewControllerAnimated:animated];
    } else {
        NSUInteger idx = [self.viewControllers indexOfObject:scene];
        [self popToViewController:[self.viewControllers objectAtIndex:(idx - 1)] animated:animated];
    }
}
@end


@implementation UITabBarController (Router)
- (void)mgrOpenScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController == scene || self.selectedViewController == scene) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self openScene:scene animated:animated];
    } else if ([self.viewControllers containsObject:scene]) {
        [self setSelectedViewController:scene];
    } else {
        NSMutableArray *tabList = self.viewControllers.mutableCopy;
        [tabList addObject:scene];
        scene.tabBarItem.title = scene.title;
        [self setViewControllers:tabList animated:animated];
        [self setSelectedViewController:scene];
    }
}
- (void)mgrCloseScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController != scene && ![self.viewControllers containsObject:scene]) {return;}
    if (self.viewControllers.count == 1 && self.viewControllers.firstObject == scene) {
        [self mgrCloseAnimated:animated]; // 마지막 컨트롤러를 닫으면 컨테이너도 닫는다
    } else if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self closeScene:scene animated:animated];
    } else if (self.presentedViewController == scene) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        NSMutableArray *tabList = self.viewControllers.mutableCopy;
        [tabList removeObject:scene];
        [self setViewControllers:tabList animated:animated];
    }
}
@end


@implementation UISplitViewController (Router)
static UISplitViewControllerColumn ColumnForScene(UISplitViewController *self, UIViewController *child) {
    if ([self viewControllerForColumn:UISplitViewControllerColumnPrimary] == child) {
        return UISplitViewControllerColumnPrimary;
    }
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact &&
        [self viewControllerForColumn:UISplitViewControllerColumnCompact] == child) {
        return UISplitViewControllerColumnCompact;
    }
    if ([self viewControllerForColumn:UISplitViewControllerColumnSupplementary] == child) {
        return UISplitViewControllerColumnSupplementary;
    }
    return UISplitViewControllerColumnSecondary;
}
- (void)mgrOpenScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController == scene) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self openScene:scene animated:animated];
    } else if (@available(iOS 14, *)) {
        if (self.style == UISplitViewControllerStyleUnspecified) {
            [self showDetailViewController:scene sender:nil];
        } else if ([self.viewControllers containsObject:scene]){
            [self showColumn:ColumnForScene(self, scene)];
        } else {
            [self setViewController:scene forColumn:UISplitViewControllerColumnSecondary];
            [self showColumn:UISplitViewControllerColumnSecondary];
        }
    } else {
        [self showDetailViewController:scene sender:nil];
    }
}
- (void)mgrCloseScene:(UIViewController *)scene animated:(BOOL)animated {
    NSParameterAssert(scene);
    if (self.presentedViewController != scene && ![self.childViewControllers containsObject:scene]) {return;}
    if ([self conformsToProtocol:@protocol(MGRRoutable)]) {
        [(id<MGRRoutable>)self closeScene:scene animated:animated];
    } else if (self.presentedViewController == scene) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else if (@available(iOS 14, *)) {
        if (self.style != UISplitViewControllerStyleUnspecified) {
            [self hideColumn:ColumnForScene(self, scene)];
        }
    }
    // 구버전에서 컬럼 닫는 것을 모르겠음
}

@end


#endif


// ----------------------------------------------------------------------


@implementation MGRRouter
+ (instancetype)service:(id)service state:(id)state {
    return [[[self class] alloc] initWithService:service state:state];
}
- (instancetype)initWithService:(id)service state:(id)state {
    self = [super init];
    if (self) {_service = service; _state = state;}
    return self;
}
@end
