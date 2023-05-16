//
//  MGUMessagesPassthroughWindow.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/18.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesPassthroughWindow.h"

@interface MGUMessagesPassthroughWindow ()
@property (nonatomic, weak, nullable) UIView *hitTestView;
@end

@implementation MGUMessagesPassthroughWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // iOS has started embedding the MGUMessages view in private views that block
    // interaction with views underneath, essentially making the window behave like a modal.
    // To work around this, we'll ignore hit test results on these views.
    UIView *view = [super hitTest:point withEvent:event];
    if (view != nil && self.hitTestView != nil && self.hitTestView != view && [self isDescendantOfView:view] == YES) {
        return nil;
    }
    return view;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithHitTestView:(UIView *)hitTestView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _hitTestView = hitTestView;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
+ (instancetype)new { NSCAssert(FALSE, @"- new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
- (instancetype)initWithWindowScene:(UIWindowScene *)windowScene { NSCAssert(FALSE, @"- initWithWindowScene: 사용금지."); return nil; }
@end
