//
//  MGUActionSheetConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUActionSheetConfiguration.h"
#import "MGUAlertActionConfiguration.h"
#import "UIColor+Extension.h"

@implementation MGUActionSheetConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.swipeDismissalGestureEnabled = NO;
        self.alwaysArrangesActionButtonsVertically = YES;
//        self.showsSeparators = YES;
//        self.separatorColor = [UIColor redColor];
        self.transitionStyle = MGUAlertViewTransitionStyleFGSlideFromBottom;
        _isFullAppearance = NO;
    }

    return self;
}


#pragma mark - FIX Value.
- (void)setSwipeDismissalGestureEnabled:(BOOL)swipeDismissalGestureEnabled {
    [super setSwipeDismissalGestureEnabled:NO];
}

- (BOOL)swipeDismissalGestureEnabled {
    return NO;
}

- (BOOL)alwaysArrangesActionButtonsVertically {
    return YES;
}

- (void)setAlwaysArrangesActionButtonsVertically:(BOOL)alwaysArrangesActionButtonsVertically {
    [super setAlwaysArrangesActionButtonsVertically:YES];
}

- (void)setTransitionStyle:(MGUAlertViewTransitionStyle)transitionStyle {
    if (transitionStyle & MGUAlertViewTransitionStyleFGSlideFromTop) { // 사용불가
        transitionStyle -= MGUAlertViewTransitionStyleFGSlideFromTop;
    }
    
    if (transitionStyle & MGUAlertViewTransitionStyleFGSlideFromTopRotation) { // 사용불가
        transitionStyle -= MGUAlertViewTransitionStyleFGSlideFromTopRotation;
    }
    
    [super setTransitionStyle:transitionStyle];
}


#pragma mark - Template
+ (MGUActionSheetConfiguration *)dosePickerConfiguration {
    MGUActionSheetConfiguration *configuration = [MGUActionSheetConfiguration new];
    configuration.backgroundTapDismissalGestureEnabled = YES;
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

+ (MGUActionSheetConfiguration *)forgeSaveAlarmConfiguration {
    MGUActionSheetConfiguration *configuration = [MGUActionSheetConfiguration new];
    configuration.backgroundTapDismissalGestureEnabled = YES;
    //configuration.contentViewInset = UIEdgeInsetsMake(12.0f, 0.0f, 8.0f, 0.0f);
    configuration.alertViewCornerRadius = 15.0;
    configuration.contentViewInset = UIEdgeInsetsZero;
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
@end
