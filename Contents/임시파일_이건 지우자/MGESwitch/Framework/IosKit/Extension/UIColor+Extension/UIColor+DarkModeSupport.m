//
//  UIColor+MMNumberKeyboardAdditions.m
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "UIColor+DarkModeSupport.h"

@implementation UIColor (DarkModeSupport)

+ (UIColor *)mgrColorWithLightModeColor:(UIColor * _Nonnull)lightModeColor
                          darkModeColor:(UIColor * _Nonnull)darkModeColor
                  darkElevatedModeColor:(UIColor * _Nullable)darkElevatedModeColor {
    NSCParameterAssert(darkModeColor);  // 인수가 nil 또는 NO 이면 crash!
    NSCParameterAssert(lightModeColor); // 인수가 nil 또는 NO 이면 crash!
    
    if (@available(iOS 13.0, *)) {
        lightModeColor = [lightModeColor copy];
        darkModeColor  = [darkModeColor copy];
        darkElevatedModeColor = [darkElevatedModeColor copy];
        
        return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                if (traitCollection.userInterfaceLevel == UIUserInterfaceLevelElevated &&
                    darkElevatedModeColor != nil) {
                    return darkElevatedModeColor;
                } else { // UIUserInterfaceLevelBase
                    return darkModeColor;
                }
            } else {
                return lightModeColor;
            }
        }];
    }
    
    return lightModeColor;
    //
    // Api:UIKit/UIColor/+ colorWithDynamicProvider: 참고하라.
    // 신기하다. block의 system 이 기억한다.
    
}

- (CGColorRef)mgrEffectiveCGColor:(id <UITraitEnvironment>)target {
    UITraitCollection *traitCollection =
        (target.traitCollection != nil) ? target.traitCollection : [UITraitCollection currentTraitCollection];
    __block CGColorRef result = NULL;
    [traitCollection performAsCurrentTraitCollection:^{
        result = self.CGColor;
    }];
    return result;
}

@end
