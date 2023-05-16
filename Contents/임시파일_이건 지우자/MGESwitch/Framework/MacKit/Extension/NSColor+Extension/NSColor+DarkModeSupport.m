//
//  NSColor+DarkModeSupport.m
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSColor+DarkModeSupport.h"

@implementation NSColor (DarkModeSupport)

+ (NSColor *)mgrColorWithLightModeColor:(NSColor * _Nonnull)lightModeColor
                          darkModeColor:(NSColor * _Nonnull)darkModeColor {
    NSCParameterAssert(darkModeColor);  // 인수가 nil 또는 NO 이면 crash!
    NSCParameterAssert(lightModeColor); // 인수가 nil 또는 NO 이면 crash!

    lightModeColor = [lightModeColor copy];
    darkModeColor  = [darkModeColor copy];

    if (@available(macOS 10.15, *)) {
        return [NSColor colorWithName:nil dynamicProvider:^NSColor *(NSAppearance *appearance) {
            NSAppearanceName aquaORDarkAqua = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
            if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
                return lightModeColor;
            } else {
                return darkModeColor;
            }
        }];
    }
    
    return lightModeColor;
}


- (CGColorRef)mgrEffectiveCGColor:(id <NSAppearanceCustomization>)target {
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 110000
    NSAppearance *effectiveAppearance = (target == nil) ? [NSApp effectiveAppearance] : [target effectiveAppearance];
    __block CGColorRef result = NULL;
    [effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        result = self.CGColor;
    }];
    return result;
#else
    if (@available(macOS 11.0, *)) {
        NSAppearance *effectiveAppearance = (target == nil) ? [NSApp effectiveAppearance] : [target effectiveAppearance];
        __block CGColorRef result = NULL;
        [effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
            result = self.CGColor;
        }];
        return result;
    } else {
        NSAppearance *oldAppearance = [NSAppearance currentAppearance];
        NSAppearance.currentAppearance = (target == nil) ? [NSApp effectiveAppearance] : [target effectiveAppearance];
        CGColorRef result = self.CGColor;
        NSAppearance.currentAppearance = oldAppearance;
        return result;
    }
#endif
}

@end
