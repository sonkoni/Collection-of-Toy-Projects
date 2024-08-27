//
//  FinTextField.m
//  IosObjcMGUNumKeyboard
//
//  Created by Kwan Hyun Son on 1/4/24.
//

#import <IosKit/IosKit.h>
#import "MGUFinancialTextField.h"

// #define TestMode YES
#define TestMode NO

@interface MGUFinancialTextField () <MGUFinancialKeyboardDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *reponderButton;
@property (nonatomic, readonly) MGUFinancialKeyboard *keyboard;
@end

@implementation MGUFinancialTextField
@dynamic allowsDotButton;
@dynamic allowsPMButton;
@dynamic keyboard;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}

#pragma mark - 생성 & 소멸

static void CommonInit(MGUFinancialTextField *self) {
    self.clipsToBounds = NO;
    __weak __typeof(self) weakSelf = self;
    self->_textField = [[UITextField alloc] initWithFrame:self.bounds];
    self->_reponderButton = [UIButton new];
    self->_textLabel = [UILabel new];
    [self addSubview:self.textField];
    [self addSubview:self.reponderButton];
    [self addSubview:self.textLabel];
    [self.textField mgrPinEdgesToSuperviewEdges];
    [self.reponderButton mgrPinCenterToSuperviewCenter];
    [self.reponderButton.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:6.0].active = YES;
    [self.reponderButton.heightAnchor constraintEqualToAnchor:self.heightAnchor constant:6.0].active = YES;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.textLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:-14].active = YES;
    [self.textLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    
    self.reponderButton.layer.borderWidth = 3.0;
    self.reponderButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.reponderButton.layer.cornerRadius = 8.0;
    self.reponderButton.backgroundColor = [UIColor clearColor]; // [[UIColor systemRedColor] colorWithAlphaComponent:0.3];
    [self.reponderButton setTitle:nil forState:UIControlStateNormal];
    [self.reponderButton addTarget:self 
                            action:@selector(reponderButtonClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    MGUFinancialKeyboard *keyboard = [[MGUFinancialKeyboard alloc] initWithFrame:CGRectZero
                                                                          locale:nil
                                                                      layoutType:MGUFinancialKeyboardLayoutTypeStandard
                                                                   configuration:[MGUFinancialKeyboardConfiguration standardConfiguration]];
    
    keyboard.delegate = self;
    keyboard.allowsDoneButton = YES;
    keyboard.allowsDotButton = YES;
    keyboard.allowsPMButton = YES;
    keyboard.roundedButtonShape = YES;
    keyboard.specialKeyHandlerBlock = ^{
        weakSelf.textField.text = @"";
        [weakSelf.textField insertText:@"0"];
    };
    self.textField.inputView = keyboard;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.font = [UIFont systemFontOfSize:14.0];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textField.delegate = self;
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    self.textLabel.userInteractionEnabled = NO;
    self.textLabel.textAlignment = NSTextAlignmentRight;
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
    if (TestMode) {
        [self.textLabel.bottomAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        self.textLabel.layer.borderWidth = 1.0;
        self.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.textField.tintColor = [UIColor clearColor];
        self.textField.textColor = [UIColor clearColor];
        [self.textLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    }
}

#pragma mark - 세터 & 게터
- (MGUFinancialKeyboard *)keyboard {
    return (MGUFinancialKeyboard *)(self.textField.inputView);
}

- (BOOL)allowsDotButton {
    return self.keyboard.allowsDotButton;
}

- (void)setAllowsDotButton:(BOOL)allowsDotButton {
    self.keyboard.allowsDotButton = allowsDotButton;
}

- (BOOL)allowsPMButton {
    return self.keyboard.allowsPMButton;
}

- (void)setAllowsPMButton:(BOOL)allowsPMButton {
    self.keyboard.allowsPMButton = allowsPMButton;
}

- (void)setDataValue:(CGFloat)dataValue {
    _dataValue = dataValue;
    NSString *result = [NSString stringWithFormat:@"%ld", lround(dataValue)];
    self.textLabel.text = [self transformString:result];
}

#pragma mark - Actions

#pragma mark - <MGUFinancialKeyboardDelegate>
//! 구현 자체를 안하면 YES를 반환하는 것과 동일한 효과이다. 딱히 구현할 필요가 없다.
- (BOOL)numberKeyboard:(MGUFinancialKeyboard *)numberKeyboard shouldInsertText:(NSString *)text {
    return YES;
}
- (BOOL)numberKeyboardShouldReturn:(MGUFinancialKeyboard *)numberKeyboard  {
    return YES;
}
- (BOOL)numberKeyboardShouldDeleteBackward:(MGUFinancialKeyboard *)numberKeyboard  {
    return YES;
}

#pragma mark - <UITextFieldDelegate>

/// 여기서 무조건 잃는다. 따라서 여기서 최종 설정이 들어가야한다.
- (void)textFieldDidEndEditing:(UITextField *)textField
                        reason:(UITextFieldDidEndEditingReason)reason {
    NSLog(@"textFieldDidEndEditing:reason: ~~");
    [self.keyboard hideAlertMessage];
    [self setupFucusState:NO];
    if (self.completionBlock != nil) {
        self.completionBlock(self.dataValue);
    }
    self.textField.text = nil;
}

// 물리 키보드 입력 방지. 숫자만 허용해보자. 시험삼아서
// https://stackoverflow.com/questions/29504304/detect-backspace-event-in-uitextfield
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    // if (string.length == 0) {
    //     const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    //     int isBackSpace = strcmp(_char, "\b");
    //     if (isBackSpace == -8) {
    //         return YES;
    //         // NSLog(@"Backspace was pressed");
    //     }
    // }
    
    static NSArray <NSString *>*strs = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    for (NSString *str in strs) {
        if ([str isEqualToString:string]) {
            if ([textField.text isEqualToString:@"0"]) {
                textField.text = @"";
            }
            return YES;
        }
    }
    return NO;
}

#pragma mark - Private

- (void)textFieldDidChange:(UITextField *)sender {
    NSLog(@"textFieldDidChange: 메서드 호출됨!!!!");
    NSInteger number = sender.text.doubleValue;
    CGFloat result = (CGFloat)number;
    if (number > self.maxDataValue) {
        [self.keyboard showAlertMessage:self.alertMessage];
        result = number / 10.0;
        sender.text = [NSString stringWithFormat:@"%ld", (long)result];
    } else {
        [self.keyboard hideAlertMessage];
    }
    self.textLabel.text = [self transformString:sender.text];
    self.dataValue = sender.text.doubleValue;
}

- (void)reponderButtonClicked:(UIButton *)sender {
    if (self.textField.isFirstResponder == NO) {
        [self.textField becomeFirstResponder];
    }
    [self setupFucusState:YES];
}

- (void)setupFucusState:(BOOL)stateOn {
    if (stateOn) {
        self.reponderButton.layer.borderColor = [UIColor mgrFocusRingColor].CGColor;
    } else {
        self.reponderButton.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
}

- (NSString *)transformString:(NSString *)str {
    NSNumberFormatter *formatter = NSNumberFormatter.new;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSRange subRange = [str rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        formatter.alwaysShowsDecimalSeparator  = YES;
        NSString *floatStr = [str componentsSeparatedByString:@"."].lastObject;
        if (floatStr.length == 0) {
            formatter.minimumFractionDigits = 0;
        } else if (floatStr.length == 1) {
            formatter.minimumFractionDigits = 1;
        } else if (floatStr.length == 2) {
            formatter.minimumFractionDigits = 2;
        }
        
    } else {
        formatter.alwaysShowsDecimalSeparator  = NO;
    }
    formatter.maximumFractionDigits = 2;
    return [formatter stringFromNumber:@(str.doubleValue)];
}

@end
