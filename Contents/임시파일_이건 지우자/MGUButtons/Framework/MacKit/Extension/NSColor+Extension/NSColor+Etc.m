//
//  NSMenuItem+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSColor+Etc.h"

@implementation NSColor (Etc)

- (void)mgrGetRed:(CGFloat *)red
            green:(CGFloat *)green
             blue:(CGFloat *)blue
            alpha:(CGFloat *)alpha {
    NSColor *color = self;
    if (self.type == NSColorTypeCatalog) {
        color = [self colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    }
    [color getRed:red green:green blue:blue alpha:alpha];
}

@end
