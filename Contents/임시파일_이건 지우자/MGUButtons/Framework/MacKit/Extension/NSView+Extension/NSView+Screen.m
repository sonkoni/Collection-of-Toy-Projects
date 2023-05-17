//
//  NSView+Screen.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSView+Screen.h"

@implementation NSView (Screen)

- (NSRect)mgrFrameFromScreen {
    CGRect viewRect = [self convertRect:self.bounds toView:nil];
    return [self.window convertRectToScreen:viewRect];
}

@end
