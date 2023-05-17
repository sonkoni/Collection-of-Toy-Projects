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

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (DarkModeSupport)
+ (NSColor *)mgrColorWithLightModeColor:(NSColor * _Nonnull)lightModeColor
                          darkModeColor:(NSColor * _Nonnull)darkModeColor;
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
