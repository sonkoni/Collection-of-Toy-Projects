//
//  MGUSegmentConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSegmentConfiguration.h"

@implementation MGUSegmentConfiguration

- (instancetype)init {
    self  = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUSegmentConfiguration *self) {
    self->_isSelectedTextGlowON    = NO;
    self->_alignment               = NSTextAlignmentCenter;
    self->_selectedTitleTextColor  = [UIColor darkGrayColor];
    self->_titleTextColor          = [UIColor lightGrayColor];
    self->_titleFont         = [UIFont systemFontOfSize:13.0];
    self->_selectedTitleFont = [UIFont boldSystemFontOfSize:13.0];
    
    self->_segmentIndicatorAnimationDuration = 0.15;
    self->_usesSpringAnimations    = NO;
    self->_springAnimationDampingRatio = 0.7; //! _usesSpringAnimations가 YES 일때막 작동함.
    
    /// selected segment indicator가 전체 the control의 outer edge에서 inset되는 양을 의미한다.
    self->_segmentIndicatorInset   = 0.0f;
    self->_cornerRadiusPercent = 0.20f; // 전체 control의 코너의 radius
    
    self->_borderWidth = 1.0f;
    self->_borderColor = [UIColor lightGrayColor];
    
    self->_segmentIndicatorBorderWidth  = 1.0;
    self->_segmentIndicatorBorderColor  = [UIColor lightGrayColor];
    
    self->_backgroundColor     = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self->_drawsGradientBackground = NO;
    //! _drawsGradientBackground = YES 일때막 작동함.
    self->_gradientTopColor    = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
    self->_gradientBottomColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.0f];
    
    self->_segmentIndicatorBackgroundColor = [UIColor whiteColor];
    self->_drawsSegmentIndicatorGradientBackground = NO;
    self->_segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.27f green:0.54f blue:0.21f alpha:1.0f];
    self->_segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.22f green:0.43f blue:0.16f alpha:1.0f];
}


#pragma mark - 생성 & 소멸 메서드
+ (instancetype)defaultConfiguration {
    return [[MGUSegmentConfiguration alloc] init];
}

+ (instancetype)blueConfiguration {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    configuration.selectedTitleTextColor = [UIColor whiteColor];
    configuration.titleTextColor = [UIColor colorWithRed:0.38 green:0.68 blue:0.93 alpha:1.0];
    configuration.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38 green:0.68 blue:0.93 alpha:1.0];
    
    configuration.backgroundColor = [UIColor colorWithRed:0.31 green:0.53 blue:0.72 alpha:1.0];
    
    configuration.segmentIndicatorBorderColor = UIColor.yellowColor; // 세그먼트 border의 색깔.
    configuration.segmentIndicatorBorderWidth = 2.0; // 색을 보여주려면, border의 굵기가 0 보다 커야한다.
    
    configuration.cornerRadiusPercent = 1.0; // 전체 control의 코너의 radius
    
    configuration.borderColor = UIColor.redColor; // 전체틀의 border의 색깔.
    configuration.borderWidth = 2.0f; // 색을 보여주려면, border의 굵기가 0 보다 커야한다.
    
    configuration.segmentIndicatorInset = 2.0; // 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.usesSpringAnimations = YES; // 탭해서 움직일때 스프링을 줄것인가
    
    return configuration;
}

+ (instancetype)flatGrayConfiguration {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    configuration.titleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    
    configuration.selectedTitleTextColor = [UIColor whiteColor];
    configuration.titleTextColor = [UIColor colorWithRed:0.30f green:0.31f blue:0.36f alpha:1.0f];
    configuration.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    
    
    configuration.backgroundColor = [UIColor colorWithRed:0.09f green:0.09f blue:0.12f alpha:1.0f];
    configuration.segmentIndicatorBorderWidth = 0.0;
    configuration.segmentIndicatorBorderColor = UIColor.clearColor;
    
    configuration.cornerRadiusPercent = 1.0f;
    
    configuration.borderWidth = 2.0f;
    configuration.borderColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    //! 선택된 글자에 글로우 이펙트를 줄 수 있다.
    configuration.isSelectedTextGlowON = YES;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 5.0f;
    
    return configuration;
}

+ (instancetype)purpleConfiguration {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    configuration.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    
    configuration.selectedTitleTextColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    configuration.titleTextColor = [UIColor colorWithWhite:0.34f alpha:1.0f];
    
    configuration.segmentIndicatorBackgroundColor = UIColor.clearColor;
    configuration.drawsSegmentIndicatorGradientBackground = YES;
    configuration.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.65f green:0.25f blue:0.95f alpha:1.0f];
    configuration.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.4f green:0.15f blue:0.8f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor clearColor];
    configuration.drawsGradientBackground = YES;
    configuration.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    configuration.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    
    configuration.segmentIndicatorBorderWidth = 0.0;
    configuration.segmentIndicatorBorderColor = UIColor.clearColor;
    
    configuration.borderWidth = 0.0f;
    configuration.borderColor = UIColor.clearColor;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 4.0f;
    
    return configuration;
}

+ (instancetype)switchConfiguration {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
    configuration.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    
    configuration.selectedTitleTextColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    configuration.titleTextColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    
    configuration.segmentIndicatorBackgroundColor = [UIColor clearColor];
    configuration.drawsSegmentIndicatorGradientBackground = YES;
    configuration.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.75f green:0.9f blue:0.4f alpha:1.0f];
    configuration.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.47f green:0.72f blue:0.29f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor clearColor];
    configuration.drawsGradientBackground = YES;
    configuration.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    configuration.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    
    configuration.segmentIndicatorBorderWidth = 0.0;
    configuration.segmentIndicatorBorderColor = UIColor.clearColor;
    
    configuration.cornerRadiusPercent = 1.0f;
    
    configuration.borderWidth = 2.0f;
    configuration.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 6.0f;
    
    return configuration;
}

+ (instancetype)pumpGravityConfiguration {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"Futura-Medium" size:17.0f];
    configuration.titleFont = [UIFont fontWithName:@"Futura-Medium" size:17.0f];
    
    configuration.selectedTitleTextColor = UIColor.whiteColor;
    configuration.titleTextColor = UIColor.whiteColor;
    
    configuration.segmentIndicatorBackgroundColor = [UIColor colorWithRed:74.0f/255.0f green:144.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:173.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
    configuration.segmentIndicatorBorderWidth = 0.0;
    configuration.segmentIndicatorBorderColor = UIColor.clearColor;
    
    configuration.cornerRadiusPercent = (2.0/3.0);
    
    configuration.borderWidth = 0.0f;
    configuration.borderColor = UIColor.clearColor;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 5.0f;
    configuration.usesSpringAnimations  = YES;
    
    return configuration;
}

+ (instancetype)transFormableConfiguration1 {
    MGUSegmentConfiguration *configuration = [[MGUSegmentConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"Futura-Medium" size:17];
    configuration.titleFont = [UIFont fontWithName:@"Futura-Medium" size:17];
    
    configuration.selectedTitleTextColor = [UIColor colorWithRed:74.0f/255.0f green:144.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
    configuration.titleTextColor = UIColor.lightGrayColor;
    
    configuration.segmentIndicatorBackgroundColor = [UIColor colorWithRed:245.f/255.f green:242.f/255.f blue:241.f/255.f alpha:1.0];
    
    configuration.backgroundColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f]; // collpaed 일때는 clear
    
    configuration.segmentIndicatorBorderWidth = 0.0;
    configuration.segmentIndicatorBorderColor = UIColor.clearColor;
    
    //configuration.cornerRadiusPercent = (2.0/3.0);
    configuration.cornerRadiusPercent = 0.9;
    
    configuration.borderWidth = 0.0f;
    configuration.borderColor = UIColor.clearColor;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 5.0f;
    configuration.usesSpringAnimations  = YES;
    configuration.segmentIndicatorAnimationDuration = 0.2;
    
    return configuration;
    //
    // MGRTRSegmentedControl 는 자신의 selectedTitleTextColor를 설정함에 있어서
    // 1. expanded 상태일 때에는  -> configuration의 selectedTitleTextColor를 이용한다.
    // 2. collapsed 상태일 때에는 -> configuration의 titleTextColor를 이용한다.
    //
    // MGRTRSegmentedControl 는 자신의 backgroundColor를 설정함에 있어서
    // 1. expanded 상태일 때에는  -> configuration의 backgroundColor를 이용한다.
    // 2. collapsed 상태일 때에는 -> clearColor를 이용한다.
}

@end


