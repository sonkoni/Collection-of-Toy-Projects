//
//  MGASevenSwitchConfiguration.m
//  NGRSwitch_Project
//
//  Created by Kwan Hyun Son on 2022/04/20.
//

#import "MGASevenSwitchConfiguration.h"
#import "MGASevenSwitch.h"

@implementation MGASevenSwitchConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

#pragma mark - 생성 & 소멸 메서드
static void CommonInit(MGASevenSwitchConfiguration *self) {
    self->_decoLayerColor = [NSColor colorWithWhite:0.99 alpha:1.0];
    self->_offTintColor = [NSColor colorWithCalibratedRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    self->_onTintColor = [NSColor colorWithCalibratedRed:0.27 green:0.86 blue:0.36 alpha:1.0];
    self->_onThumbTintColor = [NSColor whiteColor];
    self->_offThumbTintColor = [NSColor whiteColor];
    self->_onBorderColor = self.onTintColor;
    self->_offBorderColor = [NSColor lightGrayColor];
    self->_handCursorType = YES;  // 👆 디폴트는 YES.
    
//    _isRounded = YES;
//    _shadowColor        = UIColor.grayColor;
//    _knobImage          = nil;
//    _onImage            = nil;
//    _offImage           = nil;
//    _onLabelTitle       = @"";
//    _offLabelTitle      = @"";
//    _onLabelTextAlignment = NSTextAlignmentCenter;
//    _offLabelTextAlignment = NSTextAlignmentCenter;
//    _onLabelTextColor = UIColor.lightGrayColor;
//    _offLabelTextColor = UIColor.lightGrayColor;
//    _onLabelTextFont = [UIFont systemFontOfSize:12.0f];
//    _offLabelTextFont = [UIFont systemFontOfSize:12.0f];
}


+ (MGASevenSwitchConfiguration *)defaultConfiguration {
    return [[MGASevenSwitchConfiguration alloc] init];
}


- (void)apply:(MGASevenSwitch *)sevenSwitch {
    sevenSwitch.decoLayerColor = self.decoLayerColor;
    sevenSwitch.offTintColor = self.offTintColor;
    sevenSwitch.onTintColor = self.onTintColor;
    sevenSwitch.onThumbTintColor = self.onThumbTintColor;
    sevenSwitch.offThumbTintColor = self.offThumbTintColor;
    sevenSwitch.onBorderColor = self.onBorderColor;
    sevenSwitch.offBorderColor = self.offBorderColor;
    sevenSwitch.handCursorType = self.handCursorType;
}

- (void)applyWithNIB:(MGASevenSwitch *)sevenSwitch {
    sevenSwitch.decoLayerColor = (sevenSwitch.decoLayerColor == nil) ? self.decoLayerColor : sevenSwitch.decoLayerColor;
    sevenSwitch.offTintColor = (sevenSwitch.offTintColor == nil) ? self.offTintColor : sevenSwitch.offTintColor;
    sevenSwitch.onTintColor = (sevenSwitch.onTintColor == nil) ? self.onTintColor : sevenSwitch.onTintColor;
    sevenSwitch.onThumbTintColor = (sevenSwitch.onThumbTintColor == nil) ? self.onThumbTintColor : sevenSwitch.onThumbTintColor;
    sevenSwitch.offThumbTintColor = (sevenSwitch.offThumbTintColor == nil) ? self.offThumbTintColor : sevenSwitch.offThumbTintColor;
    sevenSwitch.onBorderColor = (sevenSwitch.onBorderColor == nil) ? sevenSwitch.onTintColor : sevenSwitch.onBorderColor; // 조금 특이.
    sevenSwitch.offBorderColor = (sevenSwitch.offBorderColor == nil) ? self.offBorderColor : sevenSwitch.offBorderColor;
//    sevenSwitch.handCursorType = (sevenSwitch.handCursorType == nil) ? self.handCursorType : sevenSwitch.handCursorType;
}

@end
