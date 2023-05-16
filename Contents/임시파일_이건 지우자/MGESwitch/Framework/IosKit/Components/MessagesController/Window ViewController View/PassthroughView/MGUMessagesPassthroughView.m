//
//  MGUMessagesPassthroughView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/18.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesPassthroughView.h"

@implementation MGUMessagesPassthroughView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view =[super hitTest:point withEvent:event];
    return (view == self && self.tappedHander == nil) ? nil : view;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesPassthroughView *self) {
    [self addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapped:(id)sender {
    if (self.tappedHander != nil) {
        self.tappedHander();
    }
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame primaryAction:(UIAction *)primaryAction  { NSCAssert(FALSE, @"- initWithFrame:primaryAction: 사용금지."); return nil; }

@end

