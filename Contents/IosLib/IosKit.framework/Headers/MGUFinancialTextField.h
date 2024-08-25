//
//  MGUFinancialTextField.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-01-05
//  ----------------------------------------------------------------------
//
// UITextField를 기본으로 만들 수 없다. textField 가 first responder가 되는 순간
// 새로운 뷰가 위에 붙는다.

#import <IosKit/MGUFinancialKeyboard.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUFinancialTextField : UIView
@property (nonatomic, assign) MGUFinancialKeyboardBtnOptions buttonOptions;
@property (nonatomic, assign) CGFloat dataValue; // @dynamic
@property (nonatomic, assign) CGFloat maxDataValue;
@property (nonatomic, assign) NSUInteger maximumFractionDigits;
@property (nonatomic, strong) NSString *alertMessage; // alertMessage를 표시하고 싶지 않다면 @""를 대입하라.
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy, nullable) void (^completionBlock)(CGFloat dataValue);
@property (nonatomic, readonly, getter=isFocusState) BOOL focusState;
@property (nonatomic, assign, getter=isDisabled) BOOL disabled; // enabled가 system Private으로 존재함.
//
// @property (nonatomic, assign) CGFloat minDataValue; // dataValue min 값과 맞지 않을 수 있다.
@end

NS_ASSUME_NONNULL_END
