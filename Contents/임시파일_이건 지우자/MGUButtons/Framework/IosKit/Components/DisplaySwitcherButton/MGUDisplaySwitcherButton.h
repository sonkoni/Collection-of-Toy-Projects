//
//  FRDLivelyButton.h
//
//  Created by Sebastien Windal on 2/24/14.
//  MIT license. See the LICENSE file distributed with this work.
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
