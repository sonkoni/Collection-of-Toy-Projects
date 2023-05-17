//
//  MGUNeoSegConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUNeoSegControl;

NS_ASSUME_NONNULL_BEGIN
@interface MGUNeoSegConfiguration : NSObject

@property (nonatomic) UIColor *borderColor; // 전체 control 의 border의 색깔
@property (nonatomic) CGFloat borderWidth;  // 전체 control 의 border의 굵기
@property (nonatomic) CGFloat cornerRadiusPercent; // 0.0 ~ 1.0 디폴트 0.20 전체 control의 코너의 radius
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) BOOL    drawsGradientBackground; // 디폴트 NO
@property (nonatomic) UIColor *gradientTopColor;
@property (nonatomic) UIColor *gradientBottomColor;
@property (nonatomic) CGFloat interItemSpacing; // 디폴트 0.0;

@property (nonatomic) UIColor *separatorColor;
@property (nonatomic) CGFloat separatorHeightRatio; // 디폴트 0.55

@property (nonatomic) BOOL isSelectedTextGlowON; // selected segment 에 해당하는 글자를 빛나게 할 것인지.
@property (nonatomic) UIFont *selectedTitleFont; // selected segment   텍스트 폰트
@property (nonatomic) UIColor *selectedTitleColor; // selected segment   텍스트 칼라
@property (nonatomic) UIColor *selectedImageTintColor;
@property (nonatomic) UIFont *titleFont; // unselected segment 텍스트 폰트
@property (nonatomic) UIColor *titleColor; // unselected segment 텍스트 칼라
@property (nonatomic) UIColor *imageTintColor;
@property (nonatomic) CGFloat imageViewSize; // 이미지는 정사각형. 디폴트 15.0f
@property (nonatomic) UIImageRenderingMode imageRenderingMode; // 디폴트 템플릿
@property (nonatomic) UILayoutConstraintAxis segmentContentsAxis; // 하나의 세그먼트 내의 텍스트와 이미지의 레이아웃.
@property (nonatomic) CGFloat segmentContentsSpacing; // 하나의 세그먼트 내의 텍스트와 이미지의 간격.

@property (nonatomic) BOOL isIndicatorBarStyle; // 디폴트 NO
@property (nonatomic) CGFloat segmentIndicatorInset; // 디폴트 0.0f selected indicator가 전체의 outer edge에서 inset되는 양
@property (nonatomic) CGFloat indicatorBorderWidth; // selected segment indicator 의 border의 굵기
@property (nonatomic) UIColor *indicatorBorderColor; // selected segment indicator 의 border의 색깔
@property (nonatomic) UIColor *indicatorBackgroundColor; // indicator를 단색이면 이것만 사용. 그래디언트를 줄꺼면 밑에 3개를 사용.
@property (nonatomic) BOOL    drawsIndicatorGradientBackground; // 디폴트 NO
@property (nonatomic) UIColor *indicatorGradientTopColor;
@property (nonatomic) UIColor *indicatorGradientBottomColor;
@property (nonatomic) BOOL indicatorCornerRadiusAlwaysZero; // 디폴트 NO - NO이면 control의 radius를 따라간다.
@property (nonatomic) BOOL indicatorShadowHidden; // 디폴트 YES


- (void)activeConfigurationForSegmentedControl:(MGUNeoSegControl *)segmentedControl;

//!----------------------------------------------------------------------------------------------------------------
+ (MGUNeoSegConfiguration *)defaultConfiguration;
+ (MGUNeoSegConfiguration *)iOS13Configuration;
+ (MGUNeoSegConfiguration *)iOS7Configuration;
+ (MGUNeoSegConfiguration *)yellowConfiguration;
+ (MGUNeoSegConfiguration *)orangeConfiguration;
+ (MGUNeoSegConfiguration *)greenConfiguration;
+ (MGUNeoSegConfiguration *)forgeConfiguration;
+ (MGUNeoSegConfiguration *)clearConfiguration;


#pragma mark - MGUSegmentedControl 의 예제를 흉내
+ (MGUNeoSegConfiguration *)blueConfiguration;
+ (MGUNeoSegConfiguration *)flatGrayConfiguration;
+ (MGUNeoSegConfiguration *)purpleConfiguration;
+ (MGUNeoSegConfiguration *)switchConfiguration;

@end

NS_ASSUME_NONNULL_END

// iOS 13 스타일
//.SFUI-RegularG3 13.00pt
//.SFUI-MediumG3 13.00pt <- 인디케이터가 있는 곳 조금 더 두꺼움.
//[0.94999999999999996, 0, 0, 0.94999999999999996, -0.61750000000000049, 0];
