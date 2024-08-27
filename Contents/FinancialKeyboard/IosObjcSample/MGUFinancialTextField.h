//
//  FinTextField.h
//  IosObjcMGUNumKeyboard
//
//  Created by Kwan Hyun Son on 1/4/24.
//
// UITextField를 기본으로 만들 수 없다. textField 가 first responder가 되는 순간
// 새로운 뷰가 위에 붙는다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUFinancialTextField : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) BOOL allowsDotButton; // @dynamic
@property (nonatomic, assign) BOOL allowsPMButton; // @dynamic

@property (nonatomic, assign) CGFloat dataValue;
@property (nonatomic, assign) CGFloat maxDataValue;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, copy, nullable) void (^completionBlock)(CGFloat dataValue);
//
// @property (nonatomic, assign) CGFloat minDataValue; // dataValue min 값과 맞지 않을 수 있다.
@end

NS_ASSUME_NONNULL_END
