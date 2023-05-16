//
//  UIColor+MMNumberKeyboardAdditions.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//
// https://developer.apple.com/documentation/uikit/appearance_customization/supporting_dark_mode_in_your_interface?language=objc
// https://pspdfkit.com/blog/2019/adopting-dark-mode-on-ios/
// https://engineering.nodesagency.com/categories/ios/2019/07/03/Dark-Mode
// https://eunjin3786.tistory.com/301

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkModeSupport)

+ (UIColor *)mgrColorWithLightModeColor:(UIColor * _Nonnull)lightModeColor
                          darkModeColor:(UIColor * _Nonnull)darkModeColor
                  darkElevatedModeColor:(UIColor * _Nullable)darkElevatedModeColor; // Dark Mode에서 모달로 떴을 때 색.


/*
 * Mode 변경 시 view controller, view 에서 설정가능.
 * 추가적으로 view controller 에 - willTransitionToTraitCollection:withTransitionCoordinator: 도 존재함.
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection]; // 최초에 반드시 호출!
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.view.layer.backgroundColor = [UIColor colorNamed:@"mgrColor"].CGColor;
        }];
    }
}
 
 * 그냥 설정 시 - 일반적으로 초기화 단계에서 사용.
 - (void)viewDidLoad {
     [super viewDidLoad];
     UIColor *dynamicColor = [UIColor colorNamed:@"mgrColor"];
     self.view.layer.backgroundColor = [dynamicColor mgrEffectiveCGColor:self];
 }
*/
- (CGColorRef)mgrEffectiveCGColor:(id <UITraitEnvironment>_Nullable)target;
@end

NS_ASSUME_NONNULL_END
