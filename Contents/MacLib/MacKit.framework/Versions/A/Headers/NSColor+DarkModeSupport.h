//
//  NSColor+DarkModeSupport.h
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//
// https://pspdfkit.com/blog/2019/adopting-dark-mode-on-ios/
// https://engineering.nodesagency.com/categories/ios/2019/07/03/Dark-Mode
// https://stackoverflow.com/questions/64511602/updating-programmatically-set-colors-on-mode-change-dark-mode-light-mode-on-m
// https://developer.apple.com/forums/thread/105584
// https://developer.apple.com/documentation/uikit/appearance_customization/supporting_dark_mode_in_your_interface?language=objc
// https://stackoverflow.com/questions/51672124/how-can-dark-mode-be-detected-on-macos-10-14
// https://eunjin3786.tistory.com/301
// https://zeddios.tistory.com/1161
// https://christiantietze.de/posts/2021/10/nscolor-performAsCurrentDrawingAppearance-resolve-current-appearance/

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (DarkModeSupport)
//! Make Dynamic Color
+ (NSColor *)mgrColorWithLightModeColor:(NSColor * _Nonnull)lightModeColor
                          darkModeColor:(NSColor * _Nonnull)darkModeColor;

// .CGColor 는 UIKit과는 다르게, 항상 아쿠아 모드 칼라를 반환하므로
// 다음과 같은 편의 메서드를 만들었다.
/*
 <NSAppearanceCustomization> 따르는 객체
 NSWindow, NSView, NSPopover, NSMenu, NSApplication, NSPopover
 
 * Mode 변경 시 NSView 에서 설정가능.
 - (void)viewDidChangeEffectiveAppearance {
     [super viewDidChangeEffectiveAppearance];
     NSAppearance *effectiveAppearance = self.effectiveAppearance; // OR [NSApp effectiveAppearance];
     [effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
         self.layer.backgroundColor = [NSColor colorNamed:@"mgrColor"].CGColor;
     }];
     NSAppearanceName aquaORDarkAqua = [effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
     if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
         //! Aqua 이므로 하고 싶은거 해라.
     } else {
         //! Dark Aqua 이므로 하고 싶은거 해라.
     }
 }
 
 * 그냥 설정 시 - 일반적으로 초기화 단계에서 사용.
 static void CommonInit(MGPView *self) {
     self.wantsLayer = YES;
     NSColor *dynamicColor = [NSColor colorNamed:@"mgrColor"];
     self.layer.backgroundColor = [dynamicColor mgrEffectiveCGColor:self];
 }
*/
- (CGColorRef)mgrEffectiveCGColor:(id <NSAppearanceCustomization> _Nullable)target;
@end

NS_ASSUME_NONNULL_END

/** 뷰에서 디텍팅할 때.
- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    NSAppearance *effectiveAppearance = self.effectiveAppearance; // OR [NSApp effectiveAppearance];
    NSAppearanceName aquaORDarkAqua = [effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
    if ([aquaORDarkAqua isEqualToString:NSAppearanceNameAqua] == YES) {
        //! Aqua 이므로 하고 싶은거 해라.
    } else {
        //! Dark Aqua 이므로 하고 싶은거 해라.
    }
 
    //! NSColor -> CGColor로 바로 바꾸면 라이트 칼라만 나온다.
    //! macOS 11.0+
    [effectiveAppearance performAsCurrentDrawingAppearance:^{
        self.layer.backgroundColor = self.mgrBackgroundColor.CGColor;
    }];
}
*/

/** 이런 것도 가능함.
 id dnc =  [NSDistributedNotificationCenter defaultCenter];
 id <NSObject>ob = [dnc addObserverForName:@"AppleInterfaceThemeChangedNotification"
                                    object:nil
                                     queue:[NSOperationQueue mainQueue]
                                usingBlock:^(NSNotification *note) {
     NSLog(@"바뀜!!");
 }];
*/
