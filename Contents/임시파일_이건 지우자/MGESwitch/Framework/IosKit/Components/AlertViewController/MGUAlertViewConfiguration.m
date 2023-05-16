//
//  MGUAlertViewConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertViewConfiguration.h"
#import "MGUAlertActionConfiguration.h"
#import "UIColor+Extension.h"

@implementation MGUAlertViewConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _transitionStyle =
        MGUAlertViewTransitionStyleFGSlideFromTopRotation +
        MGUAlertViewTransitionStyleBGScale;

        _backgroundTapDismissalGestureEnabled = NO;
        _swipeDismissalGestureEnabled = NO;
        _alwaysArrangesActionButtonsVertically = NO;

        _titleTextColor = [UIColor darkGrayColor];
        _messageTextColor = [UIColor darkGrayColor];

        _alertViewBackgroundColor = [UIColor whiteColor];
        _alertViewCornerRadius = 6.0f;
        _blurEffectStyle = UIBlurEffectStyleSystemMaterial;

        _showsSeparators = YES;
        _separatorColor = [UIColor lightGrayColor];

        _contentViewInset = UIEdgeInsetsZero;

        _titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _messageFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

        _buttonConfiguration = [MGUAlertActionConfiguration new];

        _destructiveButtonConfiguration = [MGUAlertActionConfiguration new];
        _destructiveButtonConfiguration.titleColor = [UIColor colorWithRed:1.0f green:0.23f blue:0.21f alpha:1.0f];

        _cancelButtonConfiguration = [MGUAlertActionConfiguration new];
        _cancelButtonConfiguration.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        
        _onlyOneContentView = NO;
    }

    return self;
}

+ (MGUAlertViewConfiguration *)dosePickerConfiguration {
    MGUAlertViewConfiguration *configuration = [MGUAlertViewConfiguration new];
    configuration.backgroundTapDismissalGestureEnabled = YES;
    configuration.swipeDismissalGestureEnabled = YES;
    
    configuration.transitionStyle = MGUAlertViewTransitionStyleFGSlideFromTop;
    configuration.contentViewInset = UIEdgeInsetsMake(12.0f, 0.0f, 8.0f, 0.0f);
    configuration.alertViewBackgroundColor = [UIColor colorWithRed:10.0 / 255.0 green:59.0 / 255.0 blue:128.0 / 255.0 alpha:1.0];
    configuration.separatorColor = [UIColor colorWithRed:62.0 / 255.0 green:128.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
    configuration.titleTextColor = [UIColor whiteColor];
    configuration.messageTextColor = [UIColor colorWithRed:134.0 / 255.0 green:163.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    configuration.buttonConfiguration.titleColor = [UIColor whiteColor];
    
    configuration.cancelButtonConfiguration.titleColor =
    [UIColor colorWithRed:255.0 / 255.0 green:110.0 / 255.0 blue:71.0 / 255.0 alpha:1.0];
    
    return configuration;
}


+ (MGUAlertViewConfiguration *)forgeSaveAlarmConfiguration {
    MGUAlertViewConfiguration *configuration = [MGUAlertViewConfiguration new];
    configuration.backgroundTapDismissalGestureEnabled = YES;
    configuration.swipeDismissalGestureEnabled = YES;
    
    configuration.transitionStyle = MGUAlertViewTransitionStyleFGFade;
    configuration.contentViewInset = UIEdgeInsetsMake(12.0f, 0.0f, 8.0f, 0.0f);
    configuration.alertViewCornerRadius = 15.0f;
    
//    configuration.alertViewBackgroundColor =
//    [UIColor mgrColorWithLightModeColor:[UIColor colorWithWhite:0.87 alpha:1.0]
//                          darkModeColor:[UIColor colorWithWhite:0.09 alpha:1.0]
//                  darkElevatedModeColor:nil];
    configuration.alertViewBackgroundColor = [UIColor clearColor];
    configuration.blurEffectStyle = UIBlurEffectStyleSystemThickMaterial;
    configuration.separatorColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.57 alpha:1.0]
                          darkModeColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    configuration.titleTextColor = [UIColor mgrColorWithLightModeColor:[UIColor blackColor]
                                                         darkModeColor:[UIColor whiteColor]
                                                 darkElevatedModeColor:nil];
    
    configuration.messageTextColor = configuration.titleTextColor;
    configuration.buttonConfiguration.titleColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.1 green:0.6 blue:0.84 alpha:1.0]
                          darkModeColor:[UIColor colorWithRed:0.11 green:0.63 blue:0.90 alpha:1.0]
                  darkElevatedModeColor:nil];
    
    configuration.cancelButtonConfiguration.titleColor = configuration.buttonConfiguration.titleColor;
    return configuration;
}

+ (MGUAlertViewConfiguration *)onboardingConfiguration {
    MGUAlertViewConfiguration *configuration = [MGUAlertViewConfiguration new];
    configuration.backgroundTapDismissalGestureEnabled = NO;
    configuration.swipeDismissalGestureEnabled = NO;
    configuration.onlyOneContentView = YES;
    configuration.contentViewInset = UIEdgeInsetsZero;
    
    configuration.transitionStyle = MGUAlertViewTransitionStyleFGFade;
    configuration.alertViewCornerRadius = 40.0f;

    configuration.alertViewBackgroundColor = [UIColor clearColor];
    configuration.blurEffectStyle = UIBlurEffectStyleSystemThickMaterial;
    configuration.separatorColor = [UIColor clearColor];
    
    configuration.titleTextColor = [UIColor clearColor];
    
    configuration.messageTextColor = configuration.titleTextColor;
    configuration.buttonConfiguration.titleColor = [UIColor clearColor];
    
    configuration.cancelButtonConfiguration.titleColor = configuration.buttonConfiguration.titleColor;
    
    return configuration;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    // TODO: Implement this
    return self;
}

@end
