//
//  AnimationContext.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesAnimationContext.h"

@implementation MGUMessagesAnimationContext

- (instancetype)initWithMessageView:(UIView *)messageView
                      containerView:(UIView *)containerView
                  safeZoneConflicts:(MGUMessagesSafeZoneConflicts)safeZoneConflicts
                    interactiveHide:(BOOL)interactiveHide {
    self = [super init];
    if (self) {
        self.messageView = messageView;
        self.containerView = containerView;
        self.safeZoneConflicts = safeZoneConflicts;
        self.interactiveHide = interactiveHide;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
