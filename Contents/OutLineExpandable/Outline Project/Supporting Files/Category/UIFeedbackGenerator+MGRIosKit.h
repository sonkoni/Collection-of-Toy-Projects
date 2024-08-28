//
//  UIFeedbackGenerator+MGRIosKit.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-06-01
//  ----------------------------------------------------------------------
//
/*!
 * @class      UIFeedbackGenerator의 세 개의 구체 클래스에 대한 카테고리.
 * @abstract   UINotificationFeedbackGenerator, UIImpactFeedbackGenerator, UISelectionFeedbackGenerator
 * @discussion 진동도 추가로 넣었다.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - UINotificationFeedbackGenerator 카테고리
@interface UINotificationFeedbackGenerator (MGRIosKit)
// UINotificationFeedbackTypeError   
// UINotificationFeedbackTypeSuccess 
// UINotificationFeedbackTypeWarning

+ (instancetype)mgrNew;
- (void)mgrNotificationOccurred:(UINotificationFeedbackType)notificationType;
@end


#pragma mark - UIImpactFeedbackGenerator 카테고리
@interface UIImpactFeedbackGenerator (MGRIosKit)
// UIImpactFeedbackStyleHeavy // A collision between large, heavy user interface elements.
// UIImpactFeedbackStyleLight // A collision between small, light user interface elements. MGRAlertViewController의 버튼에서 사용. MGRSwitch 역시
// UIImpactFeedbackStyleMedium // A collision between moderately sized user interface elements.
// UIImpactFeedbackStyleRigid
// UIImpactFeedbackStyleSoft

+ (instancetype)mgrImpactFeedbackGeneratorWithStyle:(UIImpactFeedbackStyle)style;
- (void)mgrImpactOccurred;
- (void)mgrImpactOccurredWithIntensity:(CGFloat)intensity;
@end


#pragma mark - UISelectionFeedbackGenerator 카테고리
@interface UISelectionFeedbackGenerator (MGRIosKit)
// 1종류.
+ (instancetype)mgrNew;
- (void)mgrSelectionChanged;
@end


#pragma mark - 진동함수
extern void mgrSystemSoundID_Vibrate(void);

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2021-06-01 : 라이브러리 정리됨
*/
