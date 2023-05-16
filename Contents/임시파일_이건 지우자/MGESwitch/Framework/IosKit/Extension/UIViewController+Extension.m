//
//  UIViewController+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <BaseKit/BaseKit.h>

@implementation UIViewController (Extension)
- (void)mgrPresentAlertViewController:(UIAlertController *)viewControllerToPresent
                             animated:(BOOL)flag
                           completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]] == NO) {
        NSAssert(FALSE, @"UIAlertController 클래스만 넣어라.");
        return;
    }
    
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    
    if (viewControllerToPresent.preferredStyle == UIAlertControllerStyleActionSheet) {
        NSArray <NSLayoutConstraint *>*constraints =
        [[viewControllerToPresent.view.subviews mgrMap:^id _Nonnull(UIView *view) {
            return view.constraints;
        }] mgrFlatten];
        constraints = [constraints mgrFilter:^BOOL(NSLayoutConstraint *constraint) {
            if ((constraint.constant < 0.0) &&
                (constraint.secondItem == nil) &&
                (constraint.firstAttribute == NSLayoutAttributeWidth) ) {
                return YES;
            } else {
                return NO;
            }
        }];
        constraints.firstObject.active = NO;
    }
}

- (void)mgrAddChildViewController:(__kindof UIViewController *)childController
                       targetView:(UIView * _Nullable)view {
    [self addChildViewController:childController]; // [childController willMoveToParentViewController:self]; <- 이 코드를 자동호출 시킨다.
    if (view == nil) {
        childController.view.frame = self.view.bounds;
        [self.view addSubview:childController.view];
    } else {
        childController.view.frame = view.bounds;
        [view addSubview:childController.view];
    }
    [childController didMoveToParentViewController:self];
}

- (void)mgrRemoveFromParentViewController {
    [self willMoveToParentViewController:nil]; // - removeFromParentViewController 호출 전에 반드시 호출해줘야한다.
    [self.view removeFromSuperview];
    [self removeFromParentViewController]; // [self didMoveToParentViewController:nil]; 이 코드를 자동호출 시킨다.
}

- (__kindof UIViewController * _Nullable)mgrRecurrenceFindOfIdentifier:(NSString *)restorationIdentifier {
    return [self _mgrRecurrenceFindOfIdentifier:restorationIdentifier startView:YES];
}
- (__kindof UIViewController * _Nullable)_mgrRecurrenceFindOfIdentifier:(NSString *)restorationIdentifier
                                                              startView:(BOOL)startView {
    __block __kindof UIViewController *result = nil;
    void (^getFindSubViewBlock)(UIViewController *current) = ^(UIViewController *current){
        if ([current.restorationIdentifier isEqualToString:restorationIdentifier] == YES) {
            result = current;
            return;
        }

        NSMutableArray <UIViewController *>*currentSearchingArea = @[].mutableCopy;
        if (self.childViewControllers != nil) {
            currentSearchingArea = self.childViewControllers.mutableCopy;
        }
        
        if (self.presentedViewController != nil) {
            if (startView == YES) {
                [currentSearchingArea addObjectsFromArray:@[self.presentedViewController]];
            } else if (self.parentViewController == nil) { // Family의 Root
                [currentSearchingArea addObjectsFromArray:@[self.presentedViewController]];
            }
        }
        
        for (UIViewController *sub in currentSearchingArea) {
            id temp = [sub _mgrRecurrenceFindOfIdentifier:restorationIdentifier startView:NO];
            if (temp != nil) {
                result = temp;
                return;
            }
        }
    };
    getFindSubViewBlock(self);
    return result;
}

- (void)mgrLoadView {
    NSBundle *bundle = [self nibBundle];
    if(bundle == nil) { bundle = [NSBundle mainBundle]; }
    NSString *nibName = [self nibName];
    if(nibName == nil) { nibName = NSStringFromClass([self class]); }
    
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    if(nibPath != nil) {
        [bundle loadNibNamed:nibName owner:self options:nil];
        // 이 메서드는 부가적으로 view 아웃렛을 자동 설정한다. 즉, self.view에 nib의 view 할당.
//        self.view = [bundle loadNibNamed:nibName owner:self options:nil].lastObject; 이거와 동일한 효과다.
//
//        UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
//        [nib instantiateWithOwner:self options:nil]; 이것도 아래 줄의 메커니즘과 동일한 효과이다. 부가적 아웃렛 설정이 포함되어있다.
//        self.view = [nib instantiateWithOwner:self options:nil].lastObject;
    } else {
        self.view = [[UIView alloc] init];
    }
}
@end
