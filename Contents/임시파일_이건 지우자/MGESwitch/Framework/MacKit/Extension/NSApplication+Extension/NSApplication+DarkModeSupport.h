//
//  NSApplication+DarkModeSupport.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-20
//  ----------------------------------------------------------------------
//
// https://developer.apple.com/documentation/appkit/nsappearancecustomization/choosing_a_specific_appearance_for_your_macos_app?language=objc
// https://developer.apple.com/documentation/uikit/appearance_customization/supporting_dark_mode_in_your_interface?language=objc
// https://developer.apple.com/forums/thread/105584

#import <Cocoa/Cocoa.h>

/*!
 @enum       MGRAppCurrentAppearanceType
 @abstract   현재 내 앱의 모드가 라이트 모드인지 다크모드인지 그리고 그 모드가 시스템을 따라 간건지 아니면 always 붙박이 인지 알려주는 flag이다.
 @constant   MGRAppCurrentAppearanceTypeSystemAqua 시스템을 따라가는데 현재 라이트 모드이다.
 @constant   MGRAppCurrentAppearanceTypeSystemDarkAqua 시스템을 따라가는데 현재 다크 모드이다.
 @constant   MGRAppCurrentAppearanceTypeAlwaysAqua 시스템과 무관하게 언제나 라이트 모드이다.
 @constant   MGRAppCurrentAppearanceTypeAlwaysDarkAqua 시스템과 무관하게 언제나 다크 모드이다.
 */
typedef NS_ENUM(NSUInteger, MGRAppCurrentAppearanceType) {
    MGRAppCurrentAppearanceTypeSystemAqua = 1,
    MGRAppCurrentAppearanceTypeSystemDarkAqua,
    MGRAppCurrentAppearanceTypeAlwaysAqua,
    MGRAppCurrentAppearanceTypeAlwaysDarkAqua
};

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (DarkModeSupport)

// 현재 내 앱의 모드가 라이트 모드인지 다크모드인지 그리고 그 모드가 시스템을 따라 간건지 아니면 always 붙박이 인지 알려주는 flag이다.
+ (MGRAppCurrentAppearanceType)mgrAppCurrentAppearanceType;

// 현재 내 앱이 다크 모드인지 아닌지 판단. 시스템을 따라가든. 아니면 자체적이든 상관하지 않고 내 앱의 다크모드인지 아닌지를 말해준다.
+ (BOOL)mgrIsDarkMode;

// 앱 전체에 적용.
+ (void)mgrAdoptAquaAppearance;
+ (void)mgrAdoptDarkAquaAppearance;

// 다음 두 가지 Vibrant appearances는 NSVisualEffectView 또는 NSVisualEffectView의 컨테이너 subviews 중 하나에서만 설정해야 한다.
+ (void)mgrAdoptVibrantLightAppearance;
+ (void)mgrAdoptVibrantDarkAppearance;

// The following appearance names are for matching using bestMatchFromAppearancesWithNames: Passing any of them to appearanceNamed: will return NULL
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastAqua API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastDarkAqua API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastVibrantLight API_AVAILABLE(macos(10.14));
// APPKIT_EXTERN NSAppearanceName const NSAppearanceNameAccessibilityHighContrastVibrantDark API_AVAILABLE(macos(10.14));
//    NSArray<NSAppearanceName> * names = @[NSAppearanceNameAccessibilityHighContrastAqua,
//                                          NSAppearanceNameAccessibilityHighContrastDarkAqua,
//                                          NSAppearanceNameAccessibilityHighContrastVibrantLight,
//                                          NSAppearanceNameAccessibilityHighContrastVibrantDark];
//    NSApp.appearance = [NSAppearance appearanceNamed:[[NSAppearance alloc] bestMatchFromAppearancesWithNames:names]];

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-05-20 : 라이브러리 정리됨
 */
