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

@end
