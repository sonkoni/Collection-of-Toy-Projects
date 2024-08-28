//
//  UIColor+MMNumberKeyboardAdditions.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//
// https://pspdfkit.com/blog/2019/adopting-dark-mode-on-ios/
// https://engineering.nodesagency.com/categories/ios/2019/07/03/Dark-Mode

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkModeSupport)

+ (UIColor *)mgrColorWithLightModeColor:(UIColor * _Nonnull)lightModeColor
                          darkModeColor:(UIColor * _Nonnull)darkModeColor
                  darkElevatedModeColor:(UIColor * _Nullable)darkElevatedModeColor; // Dark Mode에서 모달로 떴을 때 색.
@end

NS_ASSUME_NONNULL_END
