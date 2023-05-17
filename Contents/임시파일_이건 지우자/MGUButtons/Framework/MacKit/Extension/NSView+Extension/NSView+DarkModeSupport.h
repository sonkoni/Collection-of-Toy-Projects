//  NSView+DarkModeSupport.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-10
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (DarkModeSupport)

- (void)mgrAdoptAquaAppearance;
- (void)mgrAdoptDarkAquaAppearance;

// 다음 두 가지 Vibrant appearances는 NSVisualEffectView 또는 NSVisualEffectView의 컨테이너 subviews 중 하나에서만 설정해야 한다.
- (void)mgrAdoptVibrantLightAppearance;
- (void)mgrAdoptVibrantDarkAppearance;

// The following appearance names are for matching using bestMatchFromAppearancesWithNames: Passing any of them to appearanceNamed: will return NULL
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastAqua API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastDarkAqua API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastVibrantLight API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastVibrantDark API_AVAILABLE(macos(10.14));
//    NSArray<NSAppearanceName> * names = @[NSAppearanceNameAccessibilityHighContrastAqua,
//                                          NSAppearanceNameAccessibilityHighContrastDarkAqua,
//                                          NSAppearanceNameAccessibilityHighContrastVibrantLight,
//                                          NSAppearanceNameAccessibilityHighContrastVibrantDark];
//    self.appearance = [NSAppearance appearanceNamed:[[NSAppearance alloc] bestMatchFromAppearancesWithNames:names]];

@end

NS_ASSUME_NONNULL_END
