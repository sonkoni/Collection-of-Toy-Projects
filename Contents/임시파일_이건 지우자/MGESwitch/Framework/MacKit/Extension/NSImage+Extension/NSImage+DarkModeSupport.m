//
//  NSImage+DarkModeSupport.m
//
//  Copyright © 2022 Mulgrim Inc. All rights reserved.
//

#import "NSImage+DarkModeSupport.h"
#import "NSApplication+DarkModeSupport.h"

@implementation NSImage (DarkModeSupport)

+ (NSImage * _Nullable)mgrDynamicImageWithNormalImage:(NSImage *_Nullable)normalImage
                                            darkImage:(NSImage *_Nullable)darkImage {
    if (normalImage == nil || darkImage == nil) {
        return normalImage ? : darkImage;
    }
    if (@available(macOS 10.14, *)) {
        return [NSImage imageWithSize:normalImage.size
                              flipped:NO
                       drawingHandler:^BOOL(NSRect dstRect) {
            if ([NSApplication mgrIsDarkMode] == YES) {
                [darkImage drawInRect:dstRect];
            } else {
                [normalImage drawInRect:dstRect];
            }
            return YES;
            }];
    } else {
        return normalImage;
   }
}

@end
