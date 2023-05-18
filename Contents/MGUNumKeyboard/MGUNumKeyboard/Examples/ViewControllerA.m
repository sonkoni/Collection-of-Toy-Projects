//
//  ViewControllerA.m
//  MGUNumKeyboard
//
//  Created by Kwan Hyun Son on 15/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewControllerA.h"
@import AudioKit;
@import IosKit;

@interface ViewControllerA () <MGUNumKeyboardDelegate, UITextFieldDelegate>
@property (weak) IBOutlet UIView *containerView;
@property (weak) IBOutlet UITextField *textField;
@property (weak) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) MGOSoundKeyboard *sound;
@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStackView *stackView = (UIStackView *)(self.textField.superview);
    [stackView setCustomSpacing:50.0 afterView:self.textField];
    
    
    self.navigationItem.title = @"Layout Type - Standard1";
    _sound = [MGOSoundKeyboard keyBoardSound];
    
    self.containerView.backgroundColor = UIColor.clearColor;
    self.textLabel.layer.cornerRadius = 3.0f;
    self.textLabel.layer.borderColor = UIColor.blackColor.CGColor;
    self.textLabel.layer.borderWidth = 1.0f;

    //self.containerView.layer.borderColor = UIColor.redColor.CGColor;
    //self.containerView.layer.borderWidth = 0.5f;
    MGUNumKeyboard *keyboard = [[MGUNumKeyboard alloc] initWithFrame:CGRectZero
                                                              locale:nil
                                                          layoutType:MGUNumKeyboardLayoutTypeStandard1
                                                       configuration:[MGUNumKeyboardConfiguration darkBlueConfiguration]];
    
    keyboard.delegate = self;
    keyboard.allowsDoneButton = YES;
    keyboard.roundedButtonShape = YES;
    keyboard.normalSoundPlayBlock = self.sound.playSoundKeyPress;
    keyboard.deleteSoundPlayBlock = self.sound.playSoundKeyDelete;
    
    keyboard.keyInput = self.textField; // self.textField.inputView = keyboardX; 이렇게 설정 금지.
    self.textField.userInteractionEnabled = NO;
    //! self.textField.alpha = 0.0f; <- 이렇게 실전에서는 처리할 것이다.
    keyboard.soundOn = YES;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.containerView addSubview:keyboard];
    [keyboard mgrPinEdgesToSuperviewEdges];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textField.text = nil; // 최초에는 빈상태로 하자.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

//! 여기서는 다른 곳이 터치되었을 때, 키보드를 내리는 역할을 할것이다.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    //
    // UIResponder의 메서드로써 responder chain을 타고 올라간다. 우선은 view에 갔다가 컨트롤러(next responder- 여기서는 self)로 온 것이다.
    // 자세한 설명은 위키의 Api:UIKit/UIResponder/- touchesBegan:withEvent:‎과 Api:UIKit/UIResponder/nextResponder‎를 참고하면된다.
}

#pragma mark === UITextField - UIControlEventEditingChanged ===
- (void)textFieldDidChange:(UITextField *)sender {
    NSRange subRange = [sender.text rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        NSArray <NSString *>*strArr = [sender.text componentsSeparatedByString:@"."];
        NSString *floatString = strArr.lastObject;
        
        if (floatString.length >= 3) {
            NSNumberFormatter *formatter = NSNumberFormatter.new;
            formatter.numberStyle = NSNumberFormatterNoStyle;
            formatter.roundingMode = NSNumberFormatterRoundFloor;
            formatter.maximumFractionDigits = 2;
            formatter.minimumFractionDigits = 2;
            NSString *cutNumString = [formatter stringFromNumber:@(sender.text.doubleValue)];
            sender.text = cutNumString;
        }
    } else { // 정수에서(.가 없을 때) 맥시멈 초과가 발생할 수 있다.
        NSInteger number = sender.text.integerValue;
        if (number >= 100000000) { // 1억
            number = number / 10;
            sender.text = [NSString stringWithFormat:@"%ld", (long)number];
        }
    }
    
    self.textLabel.text = [self transformString:sender.text];
    
//    NSNumberFormatter *formatter = NSNumberFormatter.new;
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    formatter.roundingMode = NSNumberFormatterRoundFloor;
//    formatter.maximumIntegerDigits = 8;
//    formatter.minimumIntegerDigits = 1;
//    formatter.maximumFractionDigits = 2;
//    formatter.minimumFractionDigits = 2;
//    formatter.allowsFloats = YES;
    //formatter.alwaysShowsDecimalSeparator  = YES;
//    NSString *cutNumString = [formatter stringFromNumber:@(sender.text.doubleValue)];
//    NSLog(@"가공 :{%@}", cutNumString);
//    sender.text = cutNumString;
    
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


#pragma mark - <MGUNumKeyboardDelegate>
//! 구현 자체를 안하면 YES를 반환하는 것과 동일한 효과이다. 딱히 구현할 필요가 없다.
- (BOOL)numberKeyboard:(MGUNumKeyboard *)numberKeyboard shouldInsertText:(NSString *)text {return YES;}
- (BOOL)numberKeyboardShouldReturn:(MGUNumKeyboard *)numberKeyboard  {return YES;}
- (BOOL)numberKeyboardShouldDeleteBackward:(MGUNumKeyboard *)numberKeyboard  {return YES;}


#pragma mark - <UITextFieldDelegate> 메서드
//! keyboard에서 retrun을 했을 때, 일어나는 반응을 컨트롤한다!!!
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
    //
    // <UITextFieldDelegate> 메서드에 해당하는 것으로 delegate 설정을 반드시 해야한다!! 자꾸 까먹는듯.
}

@end
