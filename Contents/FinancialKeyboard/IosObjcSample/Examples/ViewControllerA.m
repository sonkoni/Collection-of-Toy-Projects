//
//  ViewControllerA.m
//  IosObjcMGUNumKeyboard
//
//  Created by Kwan Hyun Son on 12/31/23.
//

#import "ViewControllerA.h"
#import <IosKit/IosKit.h>

@interface ViewControllerA () <MGUFinancialKeyboardDelegate>

@property (weak, nonatomic) IBOutlet MGUFinancialTextField *textField1;
@property (weak, nonatomic) IBOutlet MGUFinancialTextField *textField2;
@property (weak, nonatomic) IBOutlet MGUFinancialTextField *textField3;
@property (weak, nonatomic) IBOutlet MGUFinancialTextField *textField4;

@property (weak, nonatomic) IBOutlet UITextField *appleTextField;

@property (nonatomic, assign) BOOL showKeyboard;
@property (nonatomic, strong) id <NSObject> showObserver;
@property (nonatomic, strong) id <NSObject> hideObserver;
@end

@implementation ViewControllerA

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_showObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_hideObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField1.buttonOptions = MGUFinancialKeyboardBtnOptionsNone;
    self.textField2.buttonOptions = MGUFinancialKeyboardBtnOptionsDot;
    self.textField3.buttonOptions = MGUFinancialKeyboardBtnOptionsDotPM;
    self.textField4.buttonOptions = MGUFinancialKeyboardBtnOptionsPM;
    
    self.textField1.maxDataValue = 3000.0;
    self.textField1.alertMessage = @"1 이상 3,000 이하의 숫자만 유효합니다.";
    __weak __typeof(self.textField1) weakTextField = self.textField1;
    self.textField1.completionBlock = ^(CGFloat dataValue) {
        CGFloat result = MIN(MAX(1.0, dataValue), 3000.0);
        NSInteger finalResult = lround(result);
        weakTextField.dataValue = result; // 실제 사용되는 숫자로 바꿔줘야할 필요가 있을 수 있다
        NSLog(@"finalResult ==> %ld", finalResult);
    };
    self.textField1.dataValue = 50.0;
    
    self.textField2.maxDataValue = 3000.0;
    self.textField2.alertMessage = @"0 이상 3,000 이하의 숫자만 유효합니다.";
    self.textField2.dataValue = 0.0;
    self.textField2.maximumFractionDigits = 4;
    
    self.textField3.maxDataValue = 3000.0;
    self.textField3.alertMessage = @"-3,000 이상 3,000 이하의 숫자만 유효합니다.";
    self.textField3.dataValue = -6.0;
    self.textField3.maximumFractionDigits = 4;
    __weak __typeof(self.textField1) weakField = self.textField3;
    self.textField3.completionBlock = ^(CGFloat dataValue) {
        CGFloat result = MIN(MAX(-3000.0, dataValue), 3000.0);
        weakField.dataValue = result; // 실제 사용되는 숫자로 바꿔줘야할 필요가 있을 수 있다
        NSLog(@"finalResult ==> %f", result);
    };

    [self setupKeyboardObserver];
}

//! 여기서는 다른 곳이 터치되었을 때, 키보드를 내리는 역할을 할것이다.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    //
    // UIResponder의 메서드로써 responder chain을 타고 올라간다. 우선은 view에 갔다가 컨트롤러(next responder- 여기서는 self)로 온 것이다.
    // 자세한 설명은 위키의 Api:UIKit/UIResponder/- touchesBegan:withEvent:‎과 Api:UIKit/UIResponder/nextResponder‎를 참고하면된다.
}

- (void)setupKeyboardObserver {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; // search filterView의 frame을 이동시키기 위해 사용한다.
    __weak __typeof(self)weakSelf = self;
    self.showObserver = [nc addObserverForName:UIKeyboardWillShowNotification
                                        object:nil
                                         queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.showKeyboard = YES;
        [weakSelf handleKeyboardNotification:note];
    }];
    self.hideObserver = [nc addObserverForName:UIKeyboardWillHideNotification // 키보드가 내려갈 때
                                        object:nil
                                         queue:[NSOperationQueue mainQueue]
                                    usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.showKeyboard = NO;
        [weakSelf handleKeyboardNotification:note];
    }];
}

- (void)handleKeyboardNotification:(nullable NSNotification *)notification {
    NSLog(@"handleKeyboardNotification 반가워.!!!!");
    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (notification.userInfo == nil || keyboardFrame == nil) {
        return;
    }
    CGFloat keyboardHeight = keyboardFrame.CGRectValue.size.height;
    NSLog(@"keyboardHeight %f", keyboardHeight);
}

@end
