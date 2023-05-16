//
//  MMNumberKeyboard.m
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUNumKeyboard.h"
#import "MGUNumKeyboard+Layout.h"
#import "MGUNumKeyboardButton.h"
#import "UIResponder+Extension.h"
#import "UIColor+Extension.h"

@interface MGUNumKeyboard () // <UIInputViewAudioFeedback, UITextInputDelegate>  소리 및 입력

@property (nonatomic, strong) NSMutableDictionary <NSString *, MGUNumKeyboardButton *>*buttons;
@property (nonatomic, strong) NSMutableArray <UIView *>*separatorViews;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, assign, readonly) CGRect contentRect;
@property (nonatomic, assign, readonly) CGSize allowableDefaultButtonSize; // 일반적인 버튼의 허용 사이즈 (큰 버튼 제외한)
@property (nonatomic, assign) CGFloat keyboardBorderThickness; // 키보드 버튼이 rounded Rect 이냐 angled Rect 이냐에 따라 다르다.
@property (nonatomic, assign) MGUNumKeyboardLayoutType layoutType;

@property (nonatomic, assign, readonly) NSInteger numberOfRows;
@property (nonatomic, assign, readonly) NSInteger numberOfColumns;

//@property (nonatomic, weak) id<UITextInputDelegate> systemInputDelegate; // UITextField의 inputDelegate 는 UIKit에서 동적으로 주어진다. 반복적
@property (nonatomic, assign) BOOL allowDrawing;
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation MGUNumKeyboard
@dynamic returnKeyTitle;
@dynamic keyboardBorderThickness;
@dynamic contentRect;
@dynamic allowableDefaultButtonSize;
@dynamic numberOfRows;
@dynamic numberOfColumns;

- (void)awakeFromNib {
    [super awakeFromNib];
    NSCAssert(FALSE, @"IB로 초기화할 수 없다.");
}

//! - sizeToFit 호출하면 이 메서드가 호출될 것이다. pad에서만 호출되게했다.
- (CGSize)sizeThatFits:(CGSize)size {
    size.height = 234;
    return size; // width의 설정값은 어차피 무시된다.
    //
    // 꼭, - sizeToFit과 같이 쓸 필요는 없지만, - sizeToFit을 호출하면 이 메서드가 호출된다.
}

- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, frame) == NO) {
        self.allowDrawing = YES;
    }
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds {
    if (CGRectEqualToRect(self.bounds, bounds) == NO) {
        self.allowDrawing = YES;
    }
    [super setBounds:bounds];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self configureReturnButtonState];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(CGRectZero, self.bounds) == NO ) {
        if (self.allowDrawing == YES || self.isFirst == YES) {
            self.isFirst = NO;
            self.allowDrawing = NO;
            if (self.layoutType == MGUNumKeyboardLayoutTypeStandard1) {
                [self layoutButtonForStandardStyle1];
            } else if (self.layoutType == MGUNumKeyboardLayoutTypeStandard2) {
                [self layoutButtonForStandardStyle2];
            } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle1) {
                [self layoutButtonForLowHeightStyle1];
            } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle2) {
                [self layoutButtonForLowHeightStyle2];
            }
        }
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                       locale:(nullable NSLocale *)locale
                   layoutType:(MGUNumKeyboardLayoutType)layoutType
                configuration:(MGUNumKeyboardConfiguration * _Nullable)configuration {
    self = [super initWithFrame:frame inputViewStyle:UIInputViewStyleKeyboard];
    if (self) {
        self.locale = locale;
        _layoutType = layoutType;
        CommonInit(self);
        if (configuration == nil) {
            configuration = [MGUNumKeyboardConfiguration blueConfiguration];
        }
        [configuration activeConfigurationForButtons:self.buttons
                                      separatorViews:self.separatorViews];
    }
    return self;
    //
    // MGUNumKeyboard 및 서브뷰의 모양을 변경할 때 사용할 UIInputViewStyle.(enum)
    // UIInputViewStyleDefault 또는 UIInputViewStyleKeyboard
}

static void CommonInit(MGUNumKeyboard *self) {
    self->_roundedButtonShape = NO;
    self->_allowsDoneButton   = NO;
    self->_soundOn            = YES;
    self->_allowDrawing       = NO;
    self->_isFirst            = YES;
    [self setupKeyBoardButtons]; // 버튼을 생성한다.
    [self setupTargetAction];
    [self setupSeparatorViews];

    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    } else {
        [self sizeToFit]; // - sizeThatFits: 메서드를 호출한다.
    }
    //
    // flexibleHeight 옵션이 포함되어 있으면, 크기가 시스템 기본 키보드로 크기가 된다. 더 컴팩트 한 키보드를 선호하기 때문에 iPad에서는 그다지 의미가 없다.
    // self.autoresizingMask = UIViewAutoresizingNone;  <- 수동으로 맞추고 다음과 같이 설정하라.
    // self.frame = CGRectMake(0, 0, 0, 300);
}

- (void)setupKeyBoardButtons {
    self.buttons = [NSMutableDictionary dictionary];
    for (NSUInteger number = 0; number <= 9; number++) {
        MGUNumKeyboardButton *button = [MGUNumKeyboardButton buttonWithType:UIButtonTypeSystem];
        NSString *title = @(number).stringValue;
        [button setTitle:title forState:UIControlStateNormal];
        self.buttons[title] = button;
    }

    self.buttons[MGUNumKeyboardButtonBackspaceKey] = [MGUNumKeyboardButton buttonWithType:UIButtonTypeSystem];
    self.buttons[MGUNumKeyboardButtonSpecialKey] = [MGUNumKeyboardButton buttonWithType:UIButtonTypeSystem];
    self.buttons[MGUNumKeyboardButtonDoneKey] = [MGUNumKeyboardButton buttonWithType:UIButtonTypeSystem];
    
    MGUNumKeyboardButton *decimalPointButton = [MGUNumKeyboardButton buttonWithType:UIButtonTypeSystem];
    NSLocale *locale = self.locale ? self.locale : [NSLocale currentLocale];
    NSString *decimalSeparator = [locale objectForKey:NSLocaleDecimalSeparator];
    [decimalPointButton setTitle:decimalSeparator ?: @"." forState:UIControlStateNormal];
    self.buttons[MGUNumKeyboardButtonDecimalPointKey] = decimalPointButton;
    
    for (MGUNumKeyboardButton *button in self.buttons.objectEnumerator) {
        [self addSubview:button];
    }
}

- (void)setupTargetAction {
    for (MGUNumKeyboardButton *button in self.buttons.objectEnumerator) {
        [button setExclusiveTouch:YES]; // 위키 설명 -> Api:UIKit/UIView/exclusiveTouch
        [button addTarget:self action:@selector(playSoundOnButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonInput:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
    backspaceButton.continuousPressIsPossible = YES;
    [backspaceButton addTarget:self action:@selector(backspaceRepeat:) forControlEvents:UIControlEventValueChanged];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(highlightChangesDueToPanGR:)];
    [self addGestureRecognizer:panGR];
}

- (void)setupSeparatorViews {
    NSUInteger numberOfSeparators = (self.numberOfColumns - 1) + self.numberOfRows;
    _separatorViews = [NSMutableArray arrayWithCapacity:numberOfSeparators];
    
    for (NSUInteger i = 0; i < numberOfSeparators; i++) {
        UIView *separator = [UIView new];
        separator.userInteractionEnabled = NO;
        separator.hidden = YES;
        UIColor *separatorColor =
        [UIColor mgrColorWithLightModeColor:[UIColor colorWithWhite:0.0f alpha:0.1f]
                              darkModeColor:[UIColor colorWithWhite:0.0f alpha:0.1f]
                      darkElevatedModeColor:nil];
        separator.backgroundColor = separatorColor;
        [self addSubview:separator];
        [self.separatorViews addObject:separator];
    }
}


#pragma mark - 세터 & 게터
//! lazy 그리고 keyInput 프라퍼티를 다른 곳에서 설정는 것은 없다. get만 할 뿐이다.
- (id<UIKeyInput>)keyInput {
    if (_keyInput == nil) {
        id <UIKeyInput> keyInput = [UIResponder mgrCurrentFirstResponder];
        if ([keyInput conformsToProtocol:@protocol(UIKeyInput)] == NO) { // 결과적으로 그냥 nil만 반환된다.
            NSLog(@"경고 : First responder가 %@ UIKeyInput 프로토콜을 따르지 않는다.", keyInput);
            return nil;
        } else {
            _keyInput = keyInput;
        }
    }
    
    return _keyInput;
    //    if ([(id <UITextInput>)_keyInput inputDelegate] != self) {
    //        self.systemInputDelegate = [(id <UITextInput>)_keyInput inputDelegate];
    //        [(id <UITextInput>)_keyInput setInputDelegate:self];
    //    }
    //
    // 현재 앱에서는 keyInput은 텍스트 필드가 될 것이다.
    //! 최초 이후에는 _keyInput는 nil이 아니지만, UITextField의 inputDelegate 프라퍼티는 UIKit에 의해 동적으로
    //! 갱신된다. 애플 private 클래스인 'UIKeyboardImpl'로 꽂아지게 된다.
    //! <UITextInputDelegate> 프로토콜 메서드를 받고 싶다면, 키보드가 등장 할때마다, 이렇게 꽂아줘야한다.
    //! 혹시나, UIKit input system에 문제가 생길까봐서 systemInputDelegate('UIKeyboardImpl'에 해당) 프라퍼티(weak)로 할당하여
    //! <UITextInputDelegate> 프로토콜 메서드 내부에서 systemInputDelegate('UIKeyboardImpl') 에게도 메서드를 호출하였다.
}

- (void)setAllowsDoneButton:(BOOL)allowsDoneButton {
    if (_allowsDoneButton != allowsDoneButton) {
        _allowsDoneButton = allowsDoneButton;
        [self setNeedsLayout];
    }
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically {
    if (enablesReturnKeyAutomatically != _enablesReturnKeyAutomatically) {
        _enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
        [self configureReturnButtonState];
    }
}

- (void)setRoundedButtonShape:(BOOL)roundedButtonShape {
    if (_roundedButtonShape != roundedButtonShape) {
        _roundedButtonShape = roundedButtonShape;
        for (MGUNumKeyboardButton *button in self.buttons.allValues) {
            button.usesRoundedCorners = self.roundedButtonShape;
        }
    }
}

- (void)setReturnKeyTitle:(NSString *)title {
    if ((title != nil) && (title.length > 0)) {
        MGUNumKeyboardButton *button = self.buttons[MGUNumKeyboardButtonDoneKey];
        [button setTitle:title forState:UIControlStateNormal];
    }
}

- (NSString *)returnKeyTitle {
    MGUNumKeyboardButton *button = self.buttons[MGUNumKeyboardButtonDoneKey];
    return [button titleForState:UIControlStateNormal];
}

- (NSInteger)numberOfRows {
    if (self.layoutType == MGUNumKeyboardLayoutTypeStandard1) {
        return 5;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeStandard2) {
        return 4;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle1) {
        return 3;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle2) {
        return 2;
    } else {
        NSAssert(FALSE, @"존재하지 않는 타입을 선택했다.");
        return 0;
    }
}

- (NSInteger)numberOfColumns {
    if (self.layoutType == MGUNumKeyboardLayoutTypeStandard1) {
        return 3;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeStandard2) {
        return 4;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle1) {
        return 5;
    } else if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle2) {
        return 6;
    } else {
        NSAssert(FALSE, @"존재하지 않는 타입을 선택했다.");
        return 0;
    }
}

#pragma mark - 컨트롤
- (void)configureReturnButtonState {
    if ( (self.keyInput.hasText == YES) || (self.enablesReturnKeyAutomatically == NO)) {
        self.buttons[MGUNumKeyboardButtonDoneKey].enabled = YES;
    } else {
        self.buttons[MGUNumKeyboardButtonDoneKey].enabled = NO;
    }
}

- (void)playSoundOnButton:(MGUNumKeyboardButton *)button {
    UITextField *textField = (UITextField *)self.keyInput; // 커서를 옮기기 위해서
    UITextPosition *newPosition = textField.endOfDocument;
    textField.selectedTextRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
    if (self.soundOn == YES) {
        MGUNumKeyboardButtonKey keyboardButtonKey = [self.buttons allKeysForObject:button].firstObject; // 어차피 key에 대한 객체는 유일하다.
        if ([keyboardButtonKey isEqualToString:MGUNumKeyboardButtonBackspaceKey] == YES) {
            if (self.deleteSoundPlayBlock != nil) {
                self.deleteSoundPlayBlock();
            }
        } else {
            if (self.normalSoundPlayBlock != nil) {
                self.normalSoundPlayBlock();
            }
        }
    }
    //[[UIDevice currentDevice] playInputClick]; // 이것을 사용하기 위해서는 <UIInputViewAudioFeedback> 메서드 enableInputClicksWhenVisible 가 YES
}

//! UIControlEventTouchUpInside 에 반응하는 타겟 액션 메서드이다.
- (void)buttonInput:(MGUNumKeyboardButton *)button {
    if (self.keyInput == nil) { // Get first responder.
        return;
    }
        
    MGUNumKeyboardButtonKey keyboardButtonKey = [self.buttons allKeysForObject:button].firstObject; // 어차피 key에 대한 객체는 유일하다.
    
    NSArray <MGUNumKeyboardButtonKey>*numberStrings = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    if ([numberStrings containsObject:keyboardButtonKey] == YES) { // Handle number.
        if ([self.delegate respondsToSelector:@selector(numberKeyboard:shouldInsertText:)] == YES) {
            BOOL shouldInsert = [self.delegate numberKeyboard:self shouldInsertText:keyboardButtonKey];
            if (shouldInsert == NO) {
                return;
            }
        }
        
        UITextField *textField = (UITextField *)(self.keyInput);
        if ([textField.text isEqualToString:MGUNumKeyboardButtonZeroKey] == YES) { // 0 만 존재할 때에는 0을 지우고 들어간다.
            textField.text = @"";
        }
        
        [self.keyInput insertText:keyboardButtonKey];
    }
    
    else if ([keyboardButtonKey isEqualToString:MGUNumKeyboardButtonBackspaceKey] == YES) { // Handle backspace.
        BOOL shouldDeleteBackward = YES;
        
        if ([self.delegate respondsToSelector:@selector(numberKeyboardShouldDeleteBackward:)] == YES) {
            shouldDeleteBackward = [self.delegate numberKeyboardShouldDeleteBackward:self];
        }
        
        if (shouldDeleteBackward == YES) {
            [self.keyInput deleteBackward];
            if ([self.keyInput hasText] == NO) { // 그래도 0은 남겨두자.
                [self.keyInput insertText:MGUNumKeyboardButtonZeroKey];
            }
        }
    }
    
    else if ([keyboardButtonKey isEqualToString:MGUNumKeyboardButtonDoneKey] == YES) { // Handle done.
        BOOL shouldReturn = YES;
        
        if ([self.delegate respondsToSelector:@selector(numberKeyboardShouldReturn:)] == YES) {
            shouldReturn = [self.delegate numberKeyboardShouldReturn:self];
        }
        
        if (shouldReturn == YES) {
            [self dismissKeyboard:button];
        }
    }
    
    else if ([keyboardButtonKey isEqualToString:MGUNumKeyboardButtonSpecialKey] == YES) { // Handle special key.
        if (self.specialKeyHandlerBlock != nil) {
            self.specialKeyHandlerBlock();
        } else {
            [self dismissKeyboard:button];
        }
    }
    
    else if ([keyboardButtonKey isEqualToString:MGUNumKeyboardButtonDecimalPointKey] == YES) { // Handle .(decimal key)
        //NSString *decimalText = [button titleForState:UIControlStateNormal];
        NSString *decimalText = @".";
        UITextField * textField = (UITextField *)(self.keyInput);
        
        NSRange subRange = [textField.text rangeOfString:decimalText];
        if(subRange.location != NSNotFound) { // . 이 이미 존재한다면 더 넣으면 안된다.
            return;
        } else if ([self.delegate respondsToSelector:@selector(numberKeyboard:shouldInsertText:)]) {
            BOOL shouldInsert = [self.delegate numberKeyboard:self shouldInsertText:decimalText];
            if (shouldInsert == NO) {
                return;
            }
        }
        
        if ([self.keyInput hasText] == NO) { // 아무 것도 없다면(@"") 0. 이 찍히게 만들어야한다.
            decimalText = [NSString stringWithFormat:@"%@%@", MGUNumKeyboardButtonZeroKey, decimalText];
        }
        
       [self.keyInput insertText:decimalText];
    }
    [self configureReturnButtonState];
}

- (void)backspaceRepeat:(MGUNumKeyboardButton *)button {
    if ([self.keyInput hasText] == NO) {
        return;
    }
    
    [self playSoundOnButton:button];
    [self buttonInput:button];
}

- (void)highlightChangesDueToPanGR:(UIPanGestureRecognizer *)gr {
    CGPoint point = [gr locationInView:self];
    if (gr.state == UIGestureRecognizerStateChanged || gr.state == UIGestureRecognizerStateEnded) {
        for (MGUNumKeyboardButton *button in self.buttons.objectEnumerator) {
            BOOL points = CGRectContainsPoint(button.frame, point) && !button.isHidden;
            
            if (gr.state == UIGestureRecognizerStateChanged) {
                [button setHighlighted:points];
            } else {
                [button setHighlighted:NO];
            }
            
            if (gr.state == UIGestureRecognizerStateEnded && points) {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)dismissKeyboard:(id)sender {
    if ([self.keyInput isKindOfClass:[UIResponder class]] == YES) {
        [(UIResponder *)self.keyInput resignFirstResponder];
    }
}

@end

/** <UITextInputDelegate> */
//- (void)selectionWillChange:(id <UITextInput>)textInput {
//    [self.systemInputDelegate selectionWillChange:textInput];
//    NSLog(@"- selectionWillChange:");
//    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
//}
//
//- (void)selectionDidChange:(id <UITextInput>)textInput {
//    [self.systemInputDelegate selectionDidChange:textInput];
//    NSLog(@"- selectionDidChange:");
//    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
//}
//
//- (void)textWillChange:(id <UITextInput>)textInput {
//    [self.systemInputDelegate textWillChange:textInput];
//    NSLog(@"- textWillChange:");
//    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
//}
//
//- (void)textDidChange:(id <UITextInput>)textInput {
//    [self.systemInputDelegate textDidChange:textInput];
//    NSLog(@"- textDidChange:");
//    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
//    [self configureReturnButtonState];
//}


/** <UIInputViewAudioFeedback> 메서드가 오직 한개 밖에 없다. 소리를 사용하고 싶다면, YES */
//- (BOOL)enableInputClicksWhenVisible {
//    return YES;
//}
