//
//  MGUSegmentConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUSegmentConfiguration : NSObject

@property (nonatomic) BOOL isSelectedTextGlowON;
@property (nonatomic) NSTextAlignment alignment;

@property (nonatomic) UIFont *selectedTitleFont;
@property (nonatomic) UIColor *selectedTitleTextColor;

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *titleTextColor;

@property (nonatomic) CGFloat segmentIndicatorBorderWidth;
@property (nonatomic) UIColor *segmentIndicatorBorderColor;

@property (nonatomic) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) UIColor *segmentIndicatorBackgroundColor;
@property (nonatomic) BOOL    drawsSegmentIndicatorGradientBackground;                    // <- 디폴트 NO
@property (nonatomic) UIColor *segmentIndicatorGradientTopColor;
@property (nonatomic) UIColor *segmentIndicatorGradientBottomColor;

@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) BOOL    drawsGradientBackground;                                    // <- 디폴트 NO
@property (nonatomic) UIColor *gradientTopColor;
@property (nonatomic) UIColor *gradientBottomColor;

/// 전체 control의 코너의 radius
@property (nonatomic) CGFloat cornerRadiusPercent; // 0.0 ~ 1.0 디폴트 0.20f

/// selected segment indicator가 전체 the control의 outer edge에서 inset되는 양을 의미한다.
@property (nonatomic) CGFloat segmentIndicatorInset; // <- 디폴트 0.0f;
@property (nonatomic) CGFloat segmentIndicatorAnimationDuration; // <- 디폴트 0.15f;

/// 스프링 애니메이션 관련 조건값들 duration은 일반 애니메이션의 segmentIndicatorAnimationDuration 값을 쓴다.
@property (nonatomic) BOOL    usesSpringAnimations;        // <- 디폴트 값 NO
@property (nonatomic) CGFloat springAnimationDampingRatio; //  <- 디폴트 값 0.7f;


+ (instancetype)defaultConfiguration;

// 기본 템플릿들이다.
+ (instancetype)blueConfiguration;
+ (instancetype)flatGrayConfiguration;
+ (instancetype)purpleConfiguration;
+ (instancetype)switchConfiguration;

// Forge-Drop에 쓰인 템플렛
+ (instancetype)pumpGravityConfiguration;

// Forge-Drop에 쓰인 템플렛 변신용
+ (instancetype)transFormableConfiguration1;
@end

NS_ASSUME_NONNULL_END
