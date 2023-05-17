//
//  MGUDNSwitchConfiguration.m
//  MGRSwitch Project
//
//  Created by Kwan Hyun Son on 2022/05/08.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUDNSwitchConfiguration.h"
#import "MGUDNSwitch.h"

@implementation MGUDNSwitchConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸 메서드
static void CommonInit(MGUDNSwitchConfiguration *self) {
    self->_offTintColor = [UIColor colorWithRed:0.235 green:0.255 blue:0.271 alpha:1.0];
    self->_onTintColor = [UIColor colorWithRed:0.627 green:0.894 blue:0.98 alpha:1.0];
    
    self->_onThumbColor = [UIColor colorWithRed:0.882 green:0.765 blue:0.325 alpha:1.0];
    self->_offThumbColor = [UIColor colorWithRed:0.894 green:0.902 blue:0.788 alpha:1.0];
    
    self->_onSubThumbColor = [UIColor colorWithRed:0.992 green:0.875 blue:0.459 alpha:1.0];
    self->_offSubThumbColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];

    self->_onBorderColor = [UIColor colorWithRed:0.533 green:0.769 blue:0.843 alpha:1.0];
    self->_offBorderColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.0];
}

+ (MGUDNSwitchConfiguration *)defaultConfiguration {
    return [[MGUDNSwitchConfiguration alloc] init];
}

+ (MGUDNSwitchConfiguration *)defaultConfiguration2 {
    MGUDNSwitchConfiguration *config = [[MGUDNSwitchConfiguration alloc] init];
    config.onTintColor = [UIColor colorWithHue:204.0/360.0 saturation:0.83 brightness:0.98 alpha:1.0];
    config.onBorderColor = [UIColor colorWithHue:204.0/360.0 saturation:0.83 brightness:0.84 alpha:1.0];
    config.onThumbColor = [UIColor systemYellowColor];
    return config;
}

+ (MGUDNSwitchConfiguration *)defaultConfiguration3 {
    MGUDNSwitchConfiguration *config = [[MGUDNSwitchConfiguration alloc] init];
    if (@available(iOS 15, *)) {
        config.onTintColor = [UIColor systemCyanColor]; // hsb : 199도, 65%, 94%
    } else {
        config.onTintColor = [UIColor cyanColor];
    }
    config.onBorderColor = [UIColor colorWithHue:199.0/360.0 saturation:0.65 brightness:0.80 alpha:1.0];
    config.onThumbColor = [UIColor systemYellowColor]; // hsb : 48도, 100%, 100%
    config.onSubThumbColor = [UIColor colorWithHue:48.0/360.0 saturation:0.65 brightness:1.0 alpha:1.0];
    return config;
}


- (void)apply:(MGUDNSwitch *)dnSwitch {
//    dnSwitch.offTintColor = self.offTintColor;
//    dnSwitch.onTintColor = self.onTintColor;
//    dnSwitch.onThumbColor = self.onThumbColor;
//    dnSwitch.offThumbColor = self.offThumbColor;
//    dnSwitch.onSubThumbColor = self.onSubThumbColor;
//    dnSwitch.offSubThumbColor = self.offSubThumbColor;
//    
//    dnSwitch.onBorderColor = self.onBorderColor;
//    dnSwitch.offBorderColor = self.offBorderColor;
}

- (void)applyWithNIB:(MGUDNSwitch *)dnSwitch {
//    dnSwitch.offTintColor = (dnSwitch.offTintColor == nil) ? self.offTintColor : dnSwitch.offTintColor;
//    dnSwitch.onTintColor = (dnSwitch.onTintColor == nil) ? self.onTintColor : dnSwitch.onTintColor;
//    dnSwitch.onThumbColor = (dnSwitch.onThumbColor == nil) ? self.onThumbColor : dnSwitch.onThumbColor;
//    dnSwitch.offThumbColor = (dnSwitch.offThumbColor == nil) ? self.offThumbColor : dnSwitch.offThumbColor;
//    dnSwitch.onSubThumbColor = (dnSwitch.onSubThumbColor == nil) ? self.onSubThumbColor : dnSwitch.onSubThumbColor;
//    dnSwitch.offSubThumbColor = (dnSwitch.offSubThumbColor == nil) ? self.offSubThumbColor : dnSwitch.offSubThumbColor;
//    dnSwitch.onBorderColor = (dnSwitch.onBorderColor == nil) ? self.onBorderColor : dnSwitch.onBorderColor;
//    dnSwitch.offBorderColor = (dnSwitch.offBorderColor == nil) ? self.offBorderColor : dnSwitch.offBorderColor;
}

@end
