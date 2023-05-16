//
//  MGURulerViewConfig.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGURulerViewWeightMode) {
    MGURulerViewWeightModeKG  = 1,
    MGURulerViewWeightModeLB
};

typedef CGFloat MGURulerViewNiddleVPosition;
static const MGURulerViewNiddleVPosition MGURulerViewNiddleVPositionVeryLow  = 2.0 / 8.0;
static const MGURulerViewNiddleVPosition MGURulerViewNiddleVPositionLow      = 3.0 / 8.0;
static const MGURulerViewNiddleVPosition MGURulerViewNiddleVPositionCenter   = 4.0 / 8.0;
static const MGURulerViewNiddleVPosition MGURulerViewNiddleVPositionHigh     = 5.0 / 8.0;
static const MGURulerViewNiddleVPosition MGURulerViewNiddleVPositionVeryHigh = 6.0 / 8.0;


typedef CGFloat MGURulerViewLabelSize;
static const MGURulerViewLabelSize MGURulerViewLabelSizeSmall  = 5.0 / 10.0;
static const MGURulerViewLabelSize MGURulerViewLabelSizeMedium = 7.0 / 10.0;
static const MGURulerViewLabelSize MGURulerViewLabelSizeLarge  = 9.0 / 10.0;


/*!
 * @abstract    @c MGURulerViewConfig - 기능과는 무관하고 바늘의 배치, 길이, 위치를 결정해준다.
 * @discussion  가운데 indicator 의 모양은 MGURulerView+DrawIndicator 에서 처리한다.
 */
@interface MGURulerViewConfig : NSObject

@property (nonatomic, assign) MGURulerViewNiddleVPosition littleNiddleVerticalPositionStart;
@property (nonatomic, assign) MGURulerViewNiddleVPosition littleNiddleVerticalPositionEnd;
@property (nonatomic, assign) MGURulerViewNiddleVPosition mediumNiddleVerticalPositionStart;
@property (nonatomic, assign) MGURulerViewNiddleVPosition mediumNiddleVerticalPositionEnd;
@property (nonatomic, assign) MGURulerViewNiddleVPosition longNiddleVerticalPositionStart;
@property (nonatomic, assign) MGURulerViewNiddleVPosition longNiddleVerticalPositionEnd;
@property (nonatomic, assign) BOOL showHorizontalLine;

@property (nonatomic, assign) CGFloat littleNiddleWidth; // HorizontalLine 과 굵기를 공유한다.
@property (nonatomic, assign) CGFloat mediumNiddleWidth;
@property (nonatomic, assign) CGFloat longNiddleWidth;

@property (nonatomic, strong) UIColor *littleNiddleColor; // HorizontalLine 과 색을 공유한다.
@property (nonatomic, strong) UIColor *mediumNiddleColor;
@property (nonatomic, strong) UIColor *longNiddleColor;

@property (nonatomic, strong) UIColor *indicatorNiddleMainColor;
@property (nonatomic, strong) UIColor *indicatorNiddleAssistantColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) MGURulerViewLabelSize labelSize;
@property (nonatomic, assign) MGURulerViewWeightMode weightMode;
@property (nonatomic, assign) BOOL upperStyle; // ruler를 위에 좀 더 붙게 만든다.

+ (MGURulerViewConfig *)defaultConfigWithWeightMode:(MGURulerViewWeightMode)weightMode;
+ (MGURulerViewConfig *)pricklyConfigWithWeightMode:(MGURulerViewWeightMode)weightMode;
+ (MGURulerViewConfig *)forgeConfigWithWeightMode:(MGURulerViewWeightMode)weightMode;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
