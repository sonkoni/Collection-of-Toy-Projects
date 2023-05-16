//
//  NSView+Shadow.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSView+Shadow.h"

@implementation NSView (Shadow)


- (void)mgrAddShadow:(NSColor *)shadowColor shadowBlurRadius:(CGFloat)shadowBlurRadius shadowOffset:(NSSize)shadowOffset {
    if (self.layer == nil || self.wantsLayer == NO) {
        NSLog(@"layer 가 존재하고 wantsLayer 가 YES 일 때에만, shadow가 보인다.");
    }
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = shadowColor;
    shadow.shadowBlurRadius = shadowBlurRadius;
    shadow.shadowOffset = shadowOffset;
    self.shadow = shadow;
}

- (void)mgrRemoveShadow {
    self.shadow = nil;
}

@end

