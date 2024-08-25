//
//  MGUFinancialKeyboardConfiguration.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-12-31
//  ----------------------------------------------------------------------
//
// button color를 설정하기 위한 구성 객체이다.

#import <UIKit/UIKit.h>

@class MGUFinancialKeyboardButton;
NS_ASSUME_NONNULL_BEGIN

typedef NSString *MGUFinancialKeyboardButtonKey NS_STRING_ENUM; // buttons 딕셔너리의 키로 사용된다.
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonZeroKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonOneKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonTwoKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonThreeKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonFourKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonFiveKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonSixKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonSevenKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonEightKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonNineKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonDecimalPointKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonPlusMinusKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonSpecialKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonDoneKey;
extern MGUFinancialKeyboardButtonKey const MGUFinancialKeyboardButtonBackspaceKey;

@interface MGUFinancialKeyboardConfiguration : NSObject

- (void)activeConfigurationForButtons:(NSDictionary <NSString *, MGUFinancialKeyboardButton *>*)buttons
                       separatorViews:(NSArray <UIView *>*)separatorViews;

//! Configuration Lists
+ (MGUFinancialKeyboardConfiguration *)defaultConfiguration;
+ (MGUFinancialKeyboardConfiguration *)blueConfiguration;
+ (MGUFinancialKeyboardConfiguration *)darkBlueConfiguration;
+ (MGUFinancialKeyboardConfiguration *)standardConfiguration;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
