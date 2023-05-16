//
//  UIControl+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIControl+Extension.h"

@implementation UIControl (Extension)

- (UIAction *)mgrAddActionForControlEventTouchUpInside:(void(^)(void))actionBlock {
    UIAction *myAction =
    [UIAction actionWithTitle:@"" image:nil identifier:nil handler:^(UIAction *action) {
        if (actionBlock != nil) {
            actionBlock();
        }
    }];
    [self addAction:myAction forControlEvents:UIControlEventTouchUpInside];
    return myAction; // 제거할 때 사용할 수 있다.
}

- (void)mgrRemoveActionForControlEventTouchUpInside:(UIAction *)action {
    [self removeAction:action forControlEvents:UIControlEventTouchUpInside];
}

@end
