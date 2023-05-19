//
//  MGUDisplaySwitcherButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUDisplaySwitcherButtonConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGUDisplaySwitcherButtonStyle) {
    MGUDisplaySwitcherButtonStyleNone,        // No style
    MGUDisplaySwitcherButtonStyleHamburger,   // Hamburger button style: ≡
    MGUDisplaySwitcherButtonStyleGrid
};

IB_DESIGNABLE @interface MGUDisplaySwitcherButton : UIButton

@property (nonatomic, strong, nullable) MGUDisplaySwitcherButtonConfiguration *config; // 설정에 해당하는 객체이다.

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger buttonStyle;
#else
@property (nonatomic, assign) MGUDisplaySwitcherButtonStyle buttonStyle; // set은 setStyle:animated: animated = NO와 같다.
#endif

- (void)setStyle:(MGUDisplaySwitcherButtonStyle)style animated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(MGUDisplaySwitcherButtonStyle)style
                configuration:(MGUDisplaySwitcherButtonConfiguration * _Nullable)configuration;
@end

NS_ASSUME_NONNULL_END
