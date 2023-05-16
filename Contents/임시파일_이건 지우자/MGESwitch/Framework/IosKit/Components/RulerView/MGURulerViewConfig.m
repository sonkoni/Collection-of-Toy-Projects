//
//  MGURulerViewConfig.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURulerViewConfig.h"
#import "UIColor+DarkModeSupport.h"
#import "UIColor+HEX.h"

@implementation MGURulerViewConfig

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGURulerViewConfig *self) {
    self->_showHorizontalLine = NO;
    self->_littleNiddleWidth = 1.0;
    self->_mediumNiddleWidth = 2.0;
    self->_longNiddleWidth = 2.0;
    self->_upperStyle = NO;
    self->_font = [UIFont monospacedDigitSystemFontOfSize:15.0 weight:UIFontWeightRegular];
    self->_textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self->_labelSize = MGURulerViewLabelSizeMedium;

}

+ (MGURulerViewConfig *)defaultConfigWithWeightMode:(MGURulerViewWeightMode)weightMode; {
    MGURulerViewConfig * config =  [[MGURulerViewConfig alloc] initPrivate];
    config.weightMode = weightMode;
    config.littleNiddleVerticalPositionStart = MGURulerViewNiddleVPositionLow;
    config.mediumNiddleVerticalPositionStart = MGURulerViewNiddleVPositionLow;
    config.longNiddleVerticalPositionStart = MGURulerViewNiddleVPositionLow;
    
    config.littleNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionCenter;
    config.mediumNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionCenter;
    config.longNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionHigh;
    
    config.littleNiddleColor = [UIColor colorWithRed:162.0/255.0 green:197.0/255.0 blue:246.0/255.0 alpha:1.0];
    config.mediumNiddleColor = UIColor.whiteColor;
    config.longNiddleColor = UIColor.whiteColor;
    
    config.indicatorNiddleMainColor =
    [UIColor colorWithRed:255.0/255.0 green:110.0/255.0 blue:71.0/255.0 alpha:1.0];
    config.indicatorNiddleAssistantColor =
    [UIColor colorWithRed:5.0/255.0 green:30.0/255.0 blue:64.0/255.0 alpha:1.0];
    return config;

}

+ (MGURulerViewConfig *)pricklyConfigWithWeightMode:(MGURulerViewWeightMode)weightMode; {
    MGURulerViewConfig * config =  [[MGURulerViewConfig alloc] initPrivate];
    config.weightMode = weightMode;
    config.showHorizontalLine = YES;
    config.mediumNiddleWidth = 1.0;
    config.littleNiddleVerticalPositionStart = MGURulerViewNiddleVPositionLow;
    config.mediumNiddleVerticalPositionStart = MGURulerViewNiddleVPositionLow;
    config.longNiddleVerticalPositionStart = MGURulerViewNiddleVPositionVeryLow;
    
    config.littleNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionCenter;
    config.mediumNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionHigh;
    config.longNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionVeryHigh;
    
    config.littleNiddleColor = UIColor.whiteColor;
    config.mediumNiddleColor = UIColor.whiteColor;
    config.longNiddleColor = UIColor.whiteColor;
    
    config.indicatorNiddleMainColor =
    [UIColor colorWithRed:255.0/255.0 green:101.0/255.0 blue:52.0/255.0 alpha:1.0];
    config.indicatorNiddleAssistantColor =
    [UIColor colorWithRed:5.0/255.0 green:30.0/255.0 blue:64.0/255.0 alpha:1.0];
    return config;
}

+ (MGURulerViewConfig *)forgeConfigWithWeightMode:(MGURulerViewWeightMode)weightMode; {
    MGURulerViewConfig * config =  [[MGURulerViewConfig alloc] initPrivate];
    config.weightMode = weightMode;
    config.littleNiddleVerticalPositionStart = MGURulerViewNiddleVPositionVeryLow;
    config.mediumNiddleVerticalPositionStart = MGURulerViewNiddleVPositionVeryLow;
    config.longNiddleVerticalPositionStart = MGURulerViewNiddleVPositionVeryLow;

    config.littleNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionLow * 1.2;
    config.mediumNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionCenter;
    config.longNiddleVerticalPositionEnd = MGURulerViewNiddleVPositionHigh;
    
    config.littleNiddleColor =
    [UIColor mgrColorWithLightModeColor:[UIColor mgrColorFromHexString:@"C6C6C7"]
                          darkModeColor:[UIColor mgrColorFromHexString:@"333335"]
                  darkElevatedModeColor:nil];
    config.mediumNiddleColor =
    [UIColor mgrColorWithLightModeColor:[UIColor mgrColorFromHexString:@"AEAEB2"]
                          darkModeColor:[UIColor mgrColorFromHexString:@"636366"]
                  darkElevatedModeColor:nil];
    config.longNiddleColor = config.mediumNiddleColor;
        
    config.indicatorNiddleMainColor =
    [UIColor mgrColorWithLightModeColor:[UIColor mgrColorFromHexString:@"FF9500"]
                          darkModeColor:[UIColor mgrColorFromHexString:@"FF9F0C"]
                  darkElevatedModeColor:nil];
    
    config.indicatorNiddleAssistantColor =
    [UIColor colorWithRed:5.0/255.0 green:30.0/255.0 blue:64.0/255.0 alpha:1.0];
    
    config.textColor =
    [UIColor mgrColorWithLightModeColor:[UIColor mgrColorFromHexString:@"A7A7A9"]
                          darkModeColor:[UIColor mgrColorFromHexString:@"68686C"]
                  darkElevatedModeColor:nil];
    
    config.upperStyle = YES;
    return config;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
