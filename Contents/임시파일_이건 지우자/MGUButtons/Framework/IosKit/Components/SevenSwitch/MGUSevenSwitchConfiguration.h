//
//  MGUSevenSwitchConfiguration.h
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 28/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat MGUSevenSwitchCornerRadius NS_TYPED_EXTENSIBLE_ENUM;
static MGUSevenSwitchCornerRadius const MGUSevenSwitchCornerRadiusAutomatic = -1.0; // 원형의 radius

typedef CGFloat MGUSevenSwitchKnobRatio NS_TYPED_EXTENSIBLE_ENUM; // 세로 대 가로 비율.
static MGUSevenSwitchKnobRatio const MGUSevenSwitchKnobRatioAutomatic = 1.0; // knob이 가로 세로 비율이 같다.


@interface MGUSevenSwitchConfiguration : NSObject

@property (nonatomic) MGUSevenSwitchCornerRadius cornerRadius;
@property (nonatomic) MGUSevenSwitchKnobRatio knobRatio;

///@property (nonatomic) UIColor *offTintActiveColor; // 디폴트 [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];

@property (nonatomic, nullable) __kindof UIView *backAccessoryView;
@property (nonatomic, nullable) __kindof UIView *knobAccessoryView;
@property (nonatomic) UIColor *decoViewColor;     // white
@property (nonatomic) UIColor *offTintColor;      // 디폴트 white
@property (nonatomic) UIColor *onTintColor;       // 디폴트 [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1.0]

@property (nonatomic) UIColor *onBorderColor;
@property (nonatomic) UIColor *offBorderColor;    // 디폴트 [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] 회색빛

@property (nonatomic) UIColor *offThumbTintColor; // 디폴트 whiteColor
@property (nonatomic) UIColor *onThumbTintColor;  // 디폴트 whiteColor

@property (nonatomic) UIColor *shadowColor;       // grayColor

@property (nonatomic, strong, nullable) UIImage *knobImage;
@property (nonatomic, strong, nullable) UIImage *onImage;
@property (nonatomic, strong, nullable) UIImage *offImage;

@property (nonatomic) NSString *onLabelTitle;
@property (nonatomic) NSString *offLabelTitle;
@property (nonatomic) NSTextAlignment onLabelTextAlignment;
@property (nonatomic) NSTextAlignment offLabelTextAlignment;
@property (nonatomic) UIColor *onLabelTextColor;
@property (nonatomic) UIColor *offLabelTextColor;
@property (nonatomic) UIFont *onLabelTextFont;
@property (nonatomic) UIFont *offLabelTextFont;

+ (MGUSevenSwitchConfiguration *)defaultConfiguration;
+ (MGUSevenSwitchConfiguration *)defaultConfiguration2;
+ (MGUSevenSwitchConfiguration *)yellowConfiguration;

@end

NS_ASSUME_NONNULL_END
