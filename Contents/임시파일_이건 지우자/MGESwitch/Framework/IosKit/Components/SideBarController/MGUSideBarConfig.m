//
//  MGUSideBarConfig.m
//  SlideSideBarMenuProject
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSideBarConfig.h"
#import "UIView+Etc.h"

@implementation MGUSideBarConfig
@dynamic isDirectionLeft;

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundTapDismissalGestureEnabled = YES;
        _transitionStyle = MGUSideBarControllerTransitionStyleLeading;
        _widthDeterminant = MGUSideBarWidthDeterminantDefault;
        _acceptFirstResponder = NO;
    }

    return self;
}

- (BOOL)isDirectionLeft {
    if (self.transitionStyle & MGUSideBarControllerTransitionStyleLeft) {
        return YES;
    }
    if (self.transitionStyle & MGUSideBarControllerTransitionStyleRight) {
        return NO;
    }

    UIView *view = [UIView new];
    if (self.transitionStyle & MGUSideBarControllerTransitionStyleLeading) {
        if ([view mgrIsRTLLocale] == NO) { // 일반적인 경우
            return YES;
        } else {
            return NO;
        }
    } else if (self.transitionStyle & MGUSideBarControllerTransitionStyleTrailing) {
        if ([view mgrIsRTLLocale] == NO) { // 일반적인 경우
            return NO;
        } else {
            return YES;
        }
    }
    
    NSCAssert(FALSE, @"여기에 들어오면 안된다.");
    return YES;
}
@end
