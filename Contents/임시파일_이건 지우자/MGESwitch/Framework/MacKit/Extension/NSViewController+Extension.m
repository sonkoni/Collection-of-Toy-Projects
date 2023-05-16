//
//  NSViewController+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSViewController+Extension.h"

@implementation NSViewController (Extension)

- (void)mgrAddChildViewController:(__kindof NSViewController *)childController
                       targetView:(NSView * _Nullable)view {
    [self addChildViewController:childController];
    if (view == nil) {
        childController.view.frame = self.view.bounds;
        [self.view addSubview:childController.view];
    } else {
        childController.view.frame = view.bounds;
        [view addSubview:childController.view];
    }
    childController.view.translatesAutoresizingMaskIntoConstraints = YES;
    childController.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
}

- (void)mgrAddChildSplitViewController:(__kindof NSSplitViewController *)splitViewController {
    [self mgrAddChildViewController:splitViewController targetView:self.view];
}


- (void)mgrRemoveFromParentViewController {
    [self.view removeFromSuperview];
    [self removeFromParentViewController]; // [self didMoveToParentViewController:nil]; 이 코드를 자동호출 시킨다.
}

- (NSViewController *)mgrRecurrenceFindOfIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    __block __kindof NSViewController *result = nil;
    void (^getFindSubViewBlock)(NSViewController *current) = ^(NSViewController *current){
        if ([current.identifier isEqualToString:identifier] == YES) {
            result = current;
            return;
        }

        NSMutableArray <NSViewController *>*currentSearchingArea = @[].mutableCopy;
        if (self.childViewControllers != nil) {
            currentSearchingArea = self.childViewControllers.mutableCopy;
        }
         // iOS와는 다르다. macOS는 실제로 present한 곳에서만 잡힌다.
        if (self.presentedViewControllers != nil) {
            [currentSearchingArea addObjectsFromArray:self.presentedViewControllers];
        }
        
        for (NSViewController *sub in currentSearchingArea) {
            id temp = [sub mgrRecurrenceFindOfIdentifier:identifier];
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
    NSNibName nibName = [self nibName];
    if(nibName == nil) { nibName = NSStringFromClass([self class]); }
    NSArray *topLevelObjects = nil;
    NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
    if(nibPath != nil) {
        [bundle loadNibNamed:nibName owner:self topLevelObjects:&topLevelObjects];
//        이렇게 nib 을 이용해도 되지만 반복적으로 사용하는 것이 아니므로 윗 줄처럼 사용하는 것이 나을 것으로 판단된다.
//        NSNib *nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
//        [nib instantiateWithOwner:self topLevelObjects:&topLevelObjects];
    } else {
        self.view = [NSView new]; // 이것도 정해줄 수 있다.
    }
}
@end
