//
//  UIResponder+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIResponder+Extension.h"

static __weak id mgr_current_first_responder;

@implementation UIResponder (FirstResponder)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
+ (id _Nullable)mgrCurrentFirstResponder {
    mgr_current_first_responder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(mgrFindFirstResponder:) to:nil from:nil forEvent:nil];
    return mgr_current_first_responder;
}

#pragma clang diagnostic pop
- (void)mgrFindFirstResponder:(id)sender {
    mgr_current_first_responder = self;
}

@end
