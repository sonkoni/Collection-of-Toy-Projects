//
//  MGUSevenSwitchConfiguration.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 28/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUSevenSwitchConfiguration.h"

@implementation MGUSevenSwitchConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - 생성 & 소멸 메서드
+ (MGUSevenSwitchConfiguration *)defaultConfiguration {
    return [[MGUSevenSwitchConfiguration alloc] init];
}

- (void)commonInit {
    _cornerRadius = MGUSevenSwitchCornerRadiusAutomatic;
    _knobRatio = MGUSevenSwitchKnobRatioAutomatic;
    _backAccessoryView = nil;
    _knobAccessoryView = nil;
    //_offTintActiveColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]; // 회색빛
    //_offTintActiveColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0]; // 회색빛
    //_offTintColor       = UIColor.whiteColor;
    
    _decoViewColor      = [UIColor whiteColor];
    _offTintColor       = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]; // 회색빛
    _onTintColor        = [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1.0];
    _onBorderColor      = self.onTintColor;
    _offBorderColor     = self.offTintColor;

    _offThumbTintColor  = UIColor.whiteColor;
    _onThumbTintColor   = UIColor.whiteColor;

    _shadowColor        = UIColor.grayColor;
//    _shadowColor        = UIColor.redColor;

    _knobImage          = nil;
    _onImage            = nil;
    _offImage           = nil;

    _onLabelTitle       = @"";
    _offLabelTitle      = @"";
    
    _onLabelTextAlignment = NSTextAlignmentCenter;
    _offLabelTextAlignment = NSTextAlignmentCenter;
    _onLabelTextColor = UIColor.lightGrayColor;
    _offLabelTextColor = UIColor.lightGrayColor;
    _onLabelTextFont = [UIFont systemFontOfSize:12.0f];
    _offLabelTextFont = [UIFont systemFontOfSize:12.0f];
}

+ (MGUSevenSwitchConfiguration *)defaultConfiguration2 {
    MGUSevenSwitchConfiguration *configuration = [[MGUSevenSwitchConfiguration alloc] init];
    configuration.onLabelTitle       = @"ON";
    configuration.offLabelTitle      = @"OFF";
    configuration.onLabelTextColor = [UIColor blackColor];
    configuration.offLabelTextColor = [UIColor blackColor];
    return configuration;
}

+ (MGUSevenSwitchConfiguration *)yellowConfiguration {
    MGUSevenSwitchConfiguration *configuration = [[MGUSevenSwitchConfiguration alloc] init];
    configuration.onTintColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:1.0/255.0 alpha:1.0];
    //configuration.offTintColor = [UIColor colorWithRed:10.0/255.0 green:59.0/255.0 blue:128.0/255.0 alpha:1.0];
    configuration.decoViewColor = [UIColor colorWithRed:10.0/255.0 green:59.0/255.0 blue:128.0/255.0 alpha:1.0];
    
//    configuration.offTintActiveColor = [UIColor colorWithRed:62.0/255.0 green:128.0/255.0 blue:220.0/255.0 alpha:1.0];
    configuration.offTintColor = [UIColor colorWithRed:62.0/255.0 green:128.0/255.0 blue:220.0/255.0 alpha:1.0];
    
    configuration.onBorderColor      = configuration.onTintColor;
    configuration.offBorderColor     = configuration.offTintColor;
    configuration.onLabelTitle       = @"ON";
    configuration.offLabelTitle      = @"OFF";

    configuration.onLabelTextColor = [UIColor colorWithRed:12.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0];
    configuration.offLabelTextColor = [UIColor colorWithRed:62.0/255.0 green:128.0/255.0 blue:220.0/255.0 alpha:1.0];
    
    return configuration;
}

@end
