//
//  MGADNSwitchConfiguration.m
//  NGRSwitch_Project
//
//  Created by Kwan Hyun Son on 2022/04/20.
//

#import "MGADNSwitchConfiguration.h"
#import "MGADNSwitch.h"

@implementation MGADNSwitchConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸 메서드
static void CommonInit(MGADNSwitchConfiguration *self) {
    self->_offTintColor = [NSColor colorWithRed:0.235 green:0.255 blue:0.271 alpha:1.0];
    self->_onTintColor = [NSColor colorWithRed:0.627 green:0.894 blue:0.98 alpha:1.0];
    
    self->_onThumbTintColor = [NSColor colorWithRed: 0.882 green: 0.765 blue: 0.325 alpha: 1.0];
    self->_offThumbTintColor = [NSColor colorWithRed: 0.894 green: 0.902 blue: 0.788 alpha: 1.0];
    
    self->_onSubThumbColor = [NSColor colorWithRed:0.992 green:0.875 blue:0.459 alpha: 1.0];
    self->_offSubThumbColor = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha: 1.0];
    
    self->_onBorderColor = [NSColor colorWithRed:0.533 green:0.769 blue:0.843 alpha:1.0];
    self->_offBorderColor = [NSColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.0];

    self->_handCursorType = YES;  // 👆 디폴트는 YES.
}


+ (MGADNSwitchConfiguration *)defaultConfiguration {
    return [[MGADNSwitchConfiguration alloc] init];
}

+ (MGADNSwitchConfiguration *)defaultConfiguration2 {
    MGADNSwitchConfiguration *config = [[MGADNSwitchConfiguration alloc] init];
    config.onTintColor = [NSColor colorWithHue:204.0/360.0 saturation:0.83 brightness:0.98 alpha:1.0];
    config.onBorderColor = [NSColor colorWithHue:204.0/360.0 saturation:0.83 brightness:0.84 alpha:1.0];
    config.onThumbTintColor = [NSColor systemYellowColor];
    return config;
}

+ (MGADNSwitchConfiguration *)defaultConfiguration3 {
    MGADNSwitchConfiguration *config = [[MGADNSwitchConfiguration alloc] init];
    if (@available(macOS 12, *)) {
        config.onTintColor = [NSColor systemCyanColor]; // hsb : 199도, 65%, 94%
    } else {
        config.onTintColor = [NSColor cyanColor];
    }
    config.onBorderColor = [NSColor colorWithHue:199.0/360.0 saturation:0.65 brightness:0.80 alpha:1.0];
    config.onThumbTintColor = [NSColor systemYellowColor]; // hsb : 48도, 100%, 100%
    config.onSubThumbColor = [NSColor colorWithHue:48.0/360.0 saturation:0.65 brightness:1.0 alpha:1.0];
    return config;
}


- (void)apply:(MGADNSwitch *)dnSwitch {
    dnSwitch.offTintColor = self.offTintColor;
    dnSwitch.onTintColor = self.onTintColor;
    dnSwitch.onThumbTintColor = self.onThumbTintColor;
    dnSwitch.offThumbTintColor = self.offThumbTintColor;
    dnSwitch.onSubThumbColor = self.onSubThumbColor;
    dnSwitch.offSubThumbColor = self.offSubThumbColor;
    
    dnSwitch.onBorderColor = self.onBorderColor;
    dnSwitch.offBorderColor = self.offBorderColor;
    
    dnSwitch.handCursorType = self.handCursorType;
}

- (void)applyWithNIB:(MGADNSwitch *)dnSwitch {
    dnSwitch.offTintColor = (dnSwitch.offTintColor == nil) ? self.offTintColor : dnSwitch.offTintColor;
    dnSwitch.onTintColor = (dnSwitch.onTintColor == nil) ? self.onTintColor : dnSwitch.onTintColor;
    dnSwitch.onThumbTintColor = (dnSwitch.onThumbTintColor == nil) ? self.onThumbTintColor : dnSwitch.onThumbTintColor;
    dnSwitch.offThumbTintColor = (dnSwitch.offThumbTintColor == nil) ? self.offThumbTintColor : dnSwitch.offThumbTintColor;
    dnSwitch.onSubThumbColor = (dnSwitch.onSubThumbColor == nil) ? self.onSubThumbColor : dnSwitch.onSubThumbColor;
    dnSwitch.offSubThumbColor = (dnSwitch.offSubThumbColor == nil) ? self.offSubThumbColor : dnSwitch.offSubThumbColor;
    dnSwitch.onBorderColor = (dnSwitch.onBorderColor == nil) ? self.onBorderColor : dnSwitch.onBorderColor;
    dnSwitch.offBorderColor = (dnSwitch.offBorderColor == nil) ? self.offBorderColor : dnSwitch.offBorderColor;
    
//    dnSwitch.handCursorType = (dnSwitch.handCursorType == nil) ? self.handCursorType : dnSwitch.handCursorType;
}

@end
