//
//  MGUDNSwitchConfiguration.h
//  MGRSwitch Project
//
//  Created by Kwan Hyun Son on 2022/05/08.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUDNSwitch;

NS_ASSUME_NONNULL_BEGIN

@interface MGUDNSwitchConfiguration : NSObject

@property (nonatomic, strong) UIColor *offTintColor;
@property (nonatomic, strong) UIColor *onTintColor;

@property (nonatomic, strong) UIColor *onThumbColor;
@property (nonatomic, strong) UIColor *offThumbColor;
@property (nonatomic, strong) UIColor *onSubThumbColor;
@property (nonatomic, strong) UIColor *offSubThumbColor;

@property (nonatomic, strong) UIColor *onBorderColor;
@property (nonatomic, strong) UIColor *offBorderColor;

+ (MGUDNSwitchConfiguration *)defaultConfiguration;
+ (MGUDNSwitchConfiguration *)defaultConfiguration2;
+ (MGUDNSwitchConfiguration *)defaultConfiguration3;

//! 코드로 초기화 할때 사용한다.
- (void)apply:(MGUDNSwitch *)dnSwitch;

//! XIB로 초기화 할때 사용한다.
- (void)applyWithNIB:(MGUDNSwitch *)dnSwitch;

@end

NS_ASSUME_NONNULL_END
