//
//  MGUNumKeyboardConfiguration.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 23/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//
// button color를 설정하기 위한 구성 객체이다.

#import <UIKit/UIKit.h>

@class MGUNumKeyboardButton;
NS_ASSUME_NONNULL_BEGIN

typedef NSString *MGUNumKeyboardButtonKey NS_STRING_ENUM; // buttons 딕셔너리의 키로 사용된다.
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonZeroKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonOneKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonTwoKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonThreeKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonFourKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonFiveKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSixKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSevenKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonEightKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonNineKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonDecimalPointKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonSpecialKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonDoneKey;
extern MGUNumKeyboardButtonKey const MGUNumKeyboardButtonBackspaceKey;

@interface MGUNumKeyboardConfiguration : NSObject

- (void)activeConfigurationForButtons:(NSDictionary <NSString *, MGUNumKeyboardButton *>*)buttons
                       separatorViews:(NSArray <UIView *>*)separatorViews;

//! Configuration Lists
+ (MGUNumKeyboardConfiguration *)defaultConfiguration;
+ (MGUNumKeyboardConfiguration *)blueConfiguration;
+ (MGUNumKeyboardConfiguration *)darkBlueConfiguration;
+ (MGUNumKeyboardConfiguration *)forgeConfiguration;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
