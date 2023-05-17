//
//  NSApplication+DarkModeSupport.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSApplication+DarkModeSupport.h"

@implementation NSApplication (DarkModeSupport)

+ (MGRAppCurrentAppearanceType)mgrAppCurrentAppearanceType {
    BOOL isDarkMode = [NSApplication mgrIsDarkMode];
    if (NSApp.appearance == nil) {
        return (isDarkMode == NO)? MGRAppCurrentAppearanceTypeSystemAqua : MGRAppCurrentAppearanceTypeSystemDarkAqua;
    } else {
        return (isDarkMode == NO)? MGRAppCurrentAppearanceTypeAlwaysAqua : MGRAppCurrentAppearanceTypeAlwaysDarkAqua;
    }
}

+ (BOOL)mgrIsDarkMode {
    NSAppearance *effectiveAppearance = [NSApp effectiveAppearance];
    NSAppearanceName aquaORDarkAqua = [effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
    if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
        return NO;
    } else {
        return YES;
    }
    //
    // [NSAppearance currentDrawingAppearance] 로도 가능한듯. 구버전은 [NSAppearance currentAppearance]; // DEPRECATED
}

+ (void)mgrAdoptAquaAppearance {
    NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua]; // 앱 전체에 적용.
}

+ (void)mgrAdoptDarkAquaAppearance {
    NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameDarkAqua]; // 앱 전체에 적용.
}

+ (void)mgrAdoptVibrantLightAppearance {
    NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight]; // 앱 전체에 적용.
}

+ (void)mgrAdoptVibrantDarkAppearance {
    NSApp.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]; // 앱 전체에 적용.
}

@end
