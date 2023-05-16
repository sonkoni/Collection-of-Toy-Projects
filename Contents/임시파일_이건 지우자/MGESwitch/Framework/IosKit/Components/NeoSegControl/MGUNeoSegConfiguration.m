//
//  MGUNeoSegConfiguration.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUNeoSegConfiguration.h"
#import "MGUNeoSegControl_Internal.h"
#import "MGUNeoSeg.h"
#import "MGUNeoSegIndicator.h"
#import "UIColor+DarkModeSupport.h"
#import "UIColor+HEX.h"


@implementation MGUNeoSegConfiguration
- (void)activeConfigurationForSegmentedControl:(MGUNeoSegControl *)segmentedControl {
    segmentedControl.backgroundColor = self.backgroundColor;
    segmentedControl.layer.borderWidth = self.borderWidth;
    segmentedControl.layer.borderColor = self.borderColor.CGColor;
    [segmentedControl adjustGradient:self];
    
    for (UIView *separatorView in segmentedControl.separatorViews) {
        separatorView.backgroundColor = self.separatorColor;
    }
    
    segmentedControl.segmentIndicator.borderWidth = self.indicatorBorderWidth;
    segmentedControl.segmentIndicator.borderColor = self.indicatorBorderColor;
    segmentedControl.segmentIndicator.backgroundColor = self.indicatorBackgroundColor;
    segmentedControl.segmentIndicator.drawsGradientBackground = self.drawsIndicatorGradientBackground;
    segmentedControl.segmentIndicator.gradientTopColor = self.indicatorGradientTopColor;
    segmentedControl.segmentIndicator.gradientBottomColor = self.indicatorGradientBottomColor;
    segmentedControl.segmentIndicator.segmentIndicatorShadowHidden = self.indicatorShadowHidden;
    segmentedControl.segmentIndicator.isSegmentIndicatorBarStyle = self.isIndicatorBarStyle;
    
    segmentedControl.segmentsStackView.spacing = self.interItemSpacing;
    for (MGUNeoSeg *segment in segmentedControl.segments) {
        segment.stackViewAxis = self.segmentContentsAxis; // 세터로 바로 적용됨.
        segment.stackViewSpacing = self.segmentContentsSpacing; // 세터로 바로 적용됨.
        segment.imageViewHeightLayoutConstraint.constant = self.imageViewSize;
        [segment setImageRenderingMode:self.imageRenderingMode];
        
        //! 아래 7개는 - segmentedControl의 layoutSubViews에서 적용된다. segment의 - setSegmentState:를 통해.
        segment.font = self.titleFont;
        segment.selectedFont = self.selectedTitleFont;
        segment.titleColor = self.titleColor;
        segment.selectedTitleColor = self.selectedTitleColor;
        segment.imageTintColor = self.imageTintColor;
        segment.selectedImageTintColor = self.selectedImageTintColor;
        segment.isSelectedTextGlowON = self.isSelectedTextGlowON;
    }
    
    [segmentedControl setNeedsLayout]; //! 반드시 필요하다.
}

- (instancetype)init {
    self  = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _isSelectedTextGlowON    = NO;
    
    _selectedTitleColor  = [UIColor darkGrayColor];
    _titleColor          = [UIColor lightGrayColor];
    
    _selectedImageTintColor  = [UIColor blackColor];
    _imageTintColor          = [UIColor lightGrayColor];
    _titleFont               = [UIFont systemFontOfSize:13.0f];
    _selectedTitleFont       = [UIFont boldSystemFontOfSize:13.0f];
    _segmentContentsAxis = UILayoutConstraintAxisVertical;
    _segmentContentsSpacing = 0.0f;
    _imageViewSize = 15.0f;
    _imageRenderingMode = UIImageRenderingModeAlwaysTemplate;
    
    _separatorColor          = [UIColor clearColor];
    _separatorHeightRatio = 0.55f;
    
    /// selected segment indicator가 전체 the control의 outer edge에서 inset되는 양을 의미한다.
    _segmentIndicatorInset   = 0.0f;
    
    /// 전체 control의 코너의 radius
    _cornerRadiusPercent = 0.20f;
    
    _borderWidth = 1.0f;
    _borderColor = [UIColor lightGrayColor];
    
    _indicatorBorderWidth  = 1.0;
    _indicatorBorderColor  = [UIColor lightGrayColor];
    
    _backgroundColor     = [UIColor colorWithWhite:0.9f alpha:1.0f];
    _drawsGradientBackground = NO;
    //! _drawsGradientBackground = YES 일때막 작동함.
    _gradientTopColor    = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
    _gradientBottomColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.0f];
    
    _indicatorBackgroundColor         = [UIColor whiteColor];
    _drawsIndicatorGradientBackground = NO;
    _indicatorGradientTopColor        = [UIColor colorWithRed:0.27f green:0.54f blue:0.21f alpha:1.0f];
    _indicatorGradientBottomColor     = [UIColor colorWithRed:0.22f green:0.43f blue:0.16f alpha:1.0f];
    _indicatorShadowHidden = YES;
    _isIndicatorBarStyle = NO;
    _indicatorCornerRadiusAlwaysZero = NO;
    
    _interItemSpacing = 0.0f;
}


#pragma mark - 생성 & 소멸 메서드
+ (MGUNeoSegConfiguration *)defaultConfiguration {
    return [[MGUNeoSegConfiguration alloc] init];
}

+ (MGUNeoSegConfiguration *)iOS13Configuration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 1.0f;
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    
    configuration.selectedTitleColor = [UIColor blackColor];
    configuration.titleColor = [UIColor blackColor];
    
    configuration.selectedImageTintColor = [UIColor blackColor];
    configuration.imageTintColor = [UIColor blackColor];
    
    configuration.borderWidth = 0.0f;
    configuration.indicatorBorderWidth  = 0.0;
    configuration.cornerRadiusPercent = 0.5;
    configuration.segmentIndicatorInset = 2.0f;
    configuration.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:239.0/255.0 alpha:1.0];
    configuration.separatorColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:217.0/255.0 alpha:1.0];
    configuration.indicatorShadowHidden = NO;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)iOS7Configuration {
    
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    UIColor *mainColor = [UIColor colorWithRed:0.0 green:122.0/255 blue:1.0 alpha:1.0];
    
    configuration.interItemSpacing = 0.0f;
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    
    configuration.selectedTitleColor = [UIColor whiteColor];
    configuration.titleColor = mainColor;
    configuration.segmentContentsSpacing = 5.0f;
    
    configuration.selectedImageTintColor = [UIColor whiteColor];
    configuration.imageTintColor = mainColor;
    
    configuration.indicatorBorderWidth  = 0.0;
    configuration.indicatorShadowHidden = YES;
    configuration.segmentIndicatorInset = 0.0f;
    configuration.indicatorBackgroundColor = mainColor;
    configuration.indicatorCornerRadiusAlwaysZero = YES;
    
    configuration.borderWidth = 1.0f;
    configuration.borderColor = mainColor;
    configuration.cornerRadiusPercent = 0.25;
    configuration.backgroundColor = [UIColor whiteColor];
    
    configuration.separatorHeightRatio = 1.0f;
    configuration.separatorColor = mainColor;
    
    return configuration;

}

+ (MGUNeoSegConfiguration *)yellowConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 0.0f;
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    
    configuration.selectedTitleColor = [UIColor blackColor];
    configuration.titleColor = [UIColor grayColor];
    configuration.segmentContentsAxis = UILayoutConstraintAxisHorizontal;
    configuration.segmentContentsSpacing = 5.0f;
    
    
    configuration.selectedImageTintColor = [UIColor blackColor];
    configuration.imageTintColor = [UIColor blackColor];
    
    configuration.indicatorBorderWidth  = 0.0;
    configuration.indicatorShadowHidden = YES;
    configuration.segmentIndicatorInset = 0.0f;
    configuration.indicatorBackgroundColor = [UIColor colorWithRed:251.0/255.0 green:193.0/255.0 blue:9.0/255.0 alpha:1.0];
    
    configuration.borderWidth = 1.0f;
    configuration.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:217.0/255.0 alpha:1.0];
    configuration.cornerRadiusPercent = 0.0;
    configuration.backgroundColor = [UIColor whiteColor];
    
    configuration.separatorHeightRatio = 1.0f;
    configuration.separatorColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:217.0/255.0 alpha:1.0];
    
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)orangeConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 0.0f;
    configuration.backgroundColor = [UIColor colorWithRed:1.0 green:128.0/255.0 blue:0.0 alpha:1.0];
    configuration.cornerRadiusPercent = 0.0f;
    configuration.borderWidth = 0.0f;
    
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightBlack];
    configuration.selectedTitleColor = [UIColor blackColor];
    configuration.titleColor = [UIColor whiteColor];
    configuration.selectedImageTintColor = [UIColor blackColor];
    configuration.imageTintColor = [UIColor whiteColor];
    
    configuration.isIndicatorBarStyle = YES;
    configuration.indicatorBorderWidth = 0.0f;
    configuration.indicatorBackgroundColor = [UIColor blackColor];
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)greenConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 10.0f;
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    
    configuration.selectedTitleColor = [UIColor whiteColor];
    configuration.titleColor = [UIColor blackColor];
    configuration.segmentContentsSpacing = 5.0f;
    
    configuration.selectedImageTintColor = [UIColor blackColor];
    configuration.imageTintColor = [UIColor blackColor];
    
    configuration.indicatorBorderWidth  = 0.0;
    configuration.indicatorShadowHidden = NO;
    configuration.segmentIndicatorInset = 2.0f;
    configuration.indicatorBackgroundColor = [UIColor colorWithRed:50.0/255.0 green:87.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    configuration.borderWidth = 0.0f;
    configuration.cornerRadiusPercent = 0.3;
    configuration.backgroundColor = [UIColor clearColor];
    
    configuration.separatorHeightRatio = 1.0f;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)forgeConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 10.0f;
    configuration.titleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    configuration.selectedTitleFont = [UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold];
    
    configuration.titleColor = [UIColor secondaryLabelColor];
    configuration.selectedTitleColor = [UIColor labelColor];
    
    configuration.segmentContentsSpacing = 5.0f;
    
    configuration.selectedImageTintColor = [UIColor blackColor];
    configuration.imageTintColor = [UIColor blackColor];
    configuration.imageViewSize = 30.0f;
    
    configuration.indicatorBorderWidth  = 0.0;
    configuration.indicatorShadowHidden = NO;
    configuration.segmentIndicatorInset = 2.0f;
    configuration.indicatorBackgroundColor = [UIColor secondarySystemFillColor];
    configuration.imageRenderingMode = UIImageRenderingModeAlwaysOriginal;
    
    configuration.borderWidth = 0.0f;
    configuration.cornerRadiusPercent = 0.3;
    
    configuration.backgroundColor =
    [UIColor mgrColorWithLightModeColor:[UIColor mgrColorFromHexString:@"E2E2E2"]
                          darkModeColor:[UIColor mgrColorFromHexString:@"1E1E1E"]
                  darkElevatedModeColor:nil];
    
    configuration.separatorHeightRatio = 1.0f;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)clearConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.interItemSpacing = 0.0;
    configuration.selectedTitleColor = [UIColor clearColor];
    configuration.titleColor = [UIColor clearColor];
    configuration.segmentContentsSpacing = 0.0;
    
    configuration.selectedImageTintColor = [UIColor clearColor];
    configuration.imageTintColor = [UIColor clearColor];
    
    configuration.indicatorBorderWidth  = 0.0;
    configuration.indicatorShadowHidden = YES;
    configuration.segmentIndicatorInset = 0.0;
    configuration.indicatorBackgroundColor = [UIColor clearColor];
    
    configuration.borderWidth = 0.0;
    configuration.cornerRadiusPercent = 0.0;
    configuration.indicatorCornerRadiusAlwaysZero = YES;
    configuration.backgroundColor = [UIColor clearColor];
    
    configuration.separatorHeightRatio = 1.0;
    return configuration;
}


//!----------------------------------------------------------------------
+ (MGUNeoSegConfiguration *)blueConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    configuration.selectedTitleColor = [UIColor whiteColor];
    configuration.titleColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    configuration.indicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:1.0f];
    
    //! 세그먼트 border의 색깔.
    configuration.indicatorBorderColor = UIColor.yellowColor;
    configuration.indicatorBorderWidth = 2.0f; // 색을 보여주려면, border의 굵기가 0 보다 커야한다.
    
    /// 전체 control의 코너의 radius
    configuration.cornerRadiusPercent = 1.0f;
    
    //! 전체틀의 border의 색깔.
    configuration.borderColor = UIColor.redColor;
    configuration.borderWidth = 2.0f; // 색을 보여주려면, border의 굵기가 0 보다 커야한다.
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 2.0;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)flatGrayConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    configuration.titleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    
    configuration.selectedTitleColor = [UIColor whiteColor];
    configuration.titleColor = [UIColor colorWithRed:0.30f green:0.31f blue:0.36f alpha:1.0f];
    configuration.indicatorBackgroundColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    
    
    configuration.backgroundColor = [UIColor colorWithRed:0.09f green:0.09f blue:0.12f alpha:1.0f];
    configuration.indicatorBorderWidth = 0.0;
    configuration.indicatorBorderColor = UIColor.clearColor;
    
    configuration.cornerRadiusPercent = 1.0f;
    
    configuration.borderWidth = 2.0f;
    configuration.borderColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    //! 선택된 글자에 글로우 이펙트를 줄 수 있다.
    configuration.isSelectedTextGlowON = YES;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 5.0f;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)purpleConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    configuration.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    
    configuration.selectedTitleColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    configuration.titleColor = [UIColor colorWithWhite:0.34f alpha:1.0f];
    
    configuration.indicatorBackgroundColor = UIColor.clearColor;
    configuration.drawsIndicatorGradientBackground = YES;
    configuration.indicatorGradientTopColor = [UIColor colorWithRed:0.65f green:0.25f blue:0.95f alpha:1.0f];
    configuration.indicatorGradientBottomColor = [UIColor colorWithRed:0.4f green:0.15f blue:0.8f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor clearColor];
    configuration.drawsGradientBackground = YES;
    configuration.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    configuration.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    
    configuration.indicatorBorderWidth = 0.0;
    configuration.indicatorBorderColor = UIColor.clearColor;
    
    configuration.borderWidth = 0.0f;
    configuration.borderColor = UIColor.clearColor;
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 4.0f;
    
    return configuration;
}

+ (MGUNeoSegConfiguration *)switchConfiguration {
    MGUNeoSegConfiguration *configuration = [[MGUNeoSegConfiguration alloc] init];
    
    //! 원하는 폰트를 줄 수 있다.
    configuration.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
    configuration.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    
    configuration.selectedTitleColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    configuration.titleColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    
    configuration.indicatorBackgroundColor = [UIColor clearColor];
    configuration.drawsIndicatorGradientBackground = YES;
    configuration.indicatorGradientTopColor = [UIColor colorWithRed:0.75f green:0.9f blue:0.4f alpha:1.0f];
    configuration.indicatorGradientBottomColor = [UIColor colorWithRed:0.47f green:0.72f blue:0.29f alpha:1.0f];
    
    configuration.backgroundColor = [UIColor clearColor];
    configuration.drawsGradientBackground = YES;
    configuration.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    configuration.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    
    configuration.indicatorBorderWidth = 0.0;
    configuration.indicatorBorderColor = UIColor.clearColor;
    
    configuration.cornerRadiusPercent = 1.0f;
    
    configuration.borderWidth = 2.0f;
    configuration.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    
    //! 세그먼트를 틀에서 얼마나 간격을 줄 것인가
    configuration.segmentIndicatorInset = 6.0f;
    
    return configuration;
}

@end
