//
//  MGADNSwitchConfiguration.h
//
//  Created by Kwan Hyun Son on 2022/04/20.
//

#import <Cocoa/Cocoa.h>
@class MGADNSwitch;

NS_ASSUME_NONNULL_BEGIN

@interface MGADNSwitchConfiguration : NSObject

@property (nonatomic, strong) NSColor *offTintColor;
@property (nonatomic, strong) NSColor *onTintColor;

@property (nonatomic, strong) NSColor *onThumbTintColor;
@property (nonatomic, strong) NSColor *offThumbTintColor;
@property (nonatomic, strong) NSColor *onSubThumbColor;
@property (nonatomic, strong) NSColor *offSubThumbColor;

@property (nonatomic, strong) NSColor *onBorderColor;
@property (nonatomic, strong) NSColor *offBorderColor;

@property (nonatomic, assign, getter = isHandCursorType) BOOL handCursorType; // 👆 디폴트는 YES

+ (MGADNSwitchConfiguration *)defaultConfiguration;
+ (MGADNSwitchConfiguration *)defaultConfiguration2;
+ (MGADNSwitchConfiguration *)defaultConfiguration3;

//! 코드로 초기화 할때 사용한다.
- (void)apply:(MGADNSwitch *)dnSwitch;

//! XIB로 초기화 할때 사용한다.
- (void)applyWithNIB:(MGADNSwitch *)dnSwitch;
@end

NS_ASSUME_NONNULL_END
