//
//  MGUNumKeyboard+Layout.m
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/04/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUNumKeyboard+Layout.h"
#import "MGUNumKeyboardButton.h"

static const CGFloat MGUNumKeyboardButtonInset = 4.0;
static CGRect ButtonRectMake(CGRect rect, CGRect contentRect, BOOL roundedButtonShape);

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

@implementation MGUNumKeyboard (Layout)

- (void)layoutButtonForStandardStyle1 {
    //! Layout number buttons
    MGUNumKeyboardButton *zeroButton = self.buttons[@(0).stringValue];
    [zeroButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.allowableDefaultButtonSize.width)]; // '0' 위치 유지 위해.
    zeroButton.frame = [self buttonRectForRow:5 column:1 widthScale:2.0 heightScale:1.0];
    
    
    for (NSInteger number = 1; number <= 9; number++) {
        NSUInteger idx = (number - 1); // ( 1 <=... <=9 숫자가 0<= ... <= 8로 대응한다.)
//        7 8 9  ->  6 7 8
//        4 5 6  ->  3 4 5
//        1 2 3  ->  0 1 2
        NSInteger column = (idx % 3) + 1;
        NSInteger row = 4 - (idx / 3);
        MGUNumKeyboardButton *button = self.buttons[@(number).stringValue];
        button.frame = [self buttonRectForRow:row column:column widthScale:1.0 heightScale:1.0];
    }
    
    MGUNumKeyboardButton *decimalPointKey = self.buttons[MGUNumKeyboardButtonDecimalPointKey];
    decimalPointKey.frame = [self buttonRectForRow:5 column:3 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *specialButton = self.buttons[MGUNumKeyboardButtonSpecialKey];
    specialButton.frame = [self buttonRectForRow:1 column:1 widthScale:1.0 heightScale:1.0];
    
    if (self.allowsDoneButton == YES) {
        MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
        backspaceButton.frame = [self buttonRectForRow:1 column:2 widthScale:1.0 heightScale:1.0];
        MGUNumKeyboardButton *doneButton = self.buttons[MGUNumKeyboardButtonDoneKey];
        doneButton.frame = [self buttonRectForRow:1 column:3 widthScale:1.0 heightScale:1.0];
    } else {
        MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
        backspaceButton.frame = [self buttonRectForRow:1 column:2 widthScale:2.0 heightScale:1.0];
        MGUNumKeyboardButton *doneButton = self.buttons[MGUNumKeyboardButtonDoneKey];
        doneButton.hidden = YES;
    }
    
    [self layoutSeparatorViews];
}

- (void)layoutButtonForStandardStyle2 {
    //! Layout number buttons
    MGUNumKeyboardButton *zeroButton = self.buttons[@(0).stringValue];
    [zeroButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.allowableDefaultButtonSize.width)]; // '0' 위치 유지 위해.
    zeroButton.frame = [self buttonRectForRow:4 column:1 widthScale:2.0 heightScale:1.0];
    
    for (NSInteger number = 1; number <= 9; number++) {
        NSUInteger idx = (number - 1); // ( 1 <=... <=9 숫자가 0<= ... <= 8로 대응한다.)
//        7 8 9  ->  6 7 8
//        4 5 6  ->  3 4 5
//        1 2 3  ->  0 1 2
        NSInteger column = (idx % 3) + 1;
        NSInteger row = 3 - (idx / 3);
        MGUNumKeyboardButton *button = self.buttons[@(number).stringValue];
        button.frame = [self buttonRectForRow:row column:column widthScale:1.0 heightScale:1.0];
    }
    
    MGUNumKeyboardButton *decimalPointKey = self.buttons[MGUNumKeyboardButtonDecimalPointKey];
    decimalPointKey.frame = [self buttonRectForRow:4 column:3 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
    backspaceButton.frame = [self buttonRectForRow:1 column:4 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *specialButton = self.buttons[MGUNumKeyboardButtonSpecialKey];
    specialButton.frame = [self buttonRectForRow:2 column:4 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *doneButton = self.buttons[MGUNumKeyboardButtonDoneKey];
    doneButton.frame = [self buttonRectForRow:3 column:4 widthScale:1.0 heightScale:2.0];
    
    [self layoutSeparatorViews];
}

- (void)layoutButtonForLowHeightStyle1 {
    //! Layout number buttons
    for (NSInteger number = 0; number <= 9; number++) {
//        1 2 3 4 5  ->  0 1 2 3 4
//        6 7 8 9 0  ->  5 6 7 8 9
        NSUInteger idx = (number == 0)? 9 : number - 1;
        NSInteger column = (idx % 5) + 1;
        NSInteger row = (idx / 5) + 1;
        MGUNumKeyboardButton *button = self.buttons[@(number).stringValue];
        button.frame = [self buttonRectForRow:row column:column widthScale:1.0 heightScale:1.0];
    }
    
    MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
    backspaceButton.frame = [self buttonRectForRow:3 column:1 widthScale:2.0 heightScale:1.0];
    
    MGUNumKeyboardButton *doneButton = self.buttons[MGUNumKeyboardButtonDoneKey];
    doneButton.frame = [self buttonRectForRow:3 column:3 widthScale:2.0 heightScale:1.0];
    
    MGUNumKeyboardButton *decimalPointKey = self.buttons[MGUNumKeyboardButtonDecimalPointKey];
    decimalPointKey.frame = [self buttonRectForRow:3 column:5 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *specialButton = self.buttons[MGUNumKeyboardButtonSpecialKey];
    specialButton.hidden = YES;
    
    [self layoutSeparatorViews];
}

- (void)layoutButtonForLowHeightStyle2 {
    //! Layout number buttons
    for (NSInteger number = 0; number <= 9; number++) {
//        1 2 3 4 5  ->  0 1 2 3 4
//        6 7 8 9 0  ->  5 6 7 8 9
        NSUInteger idx = (number == 0)? 9 : number - 1;
        NSInteger column = (idx % 5) + 1; // 열
        NSInteger row = (idx / 5) + 1; // 행
        MGUNumKeyboardButton *button = self.buttons[@(number).stringValue];
        button.frame = [self buttonRectForRow:row column:column widthScale:1.0 heightScale:1.0];
    }
    
    MGUNumKeyboardButton *backspaceButton = self.buttons[MGUNumKeyboardButtonBackspaceKey];
    backspaceButton.frame = [self buttonRectForRow:1 column:6 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *doneButton = self.buttons[MGUNumKeyboardButtonDoneKey];
    doneButton.hidden = YES;
    
    MGUNumKeyboardButton *decimalPointKey = self.buttons[MGUNumKeyboardButtonDecimalPointKey];
    decimalPointKey.frame = [self buttonRectForRow:2 column:6 widthScale:1.0 heightScale:1.0];
    
    MGUNumKeyboardButton *specialButton = self.buttons[MGUNumKeyboardButtonSpecialKey];
    specialButton.hidden = YES;
    
    [self layoutSeparatorViews];
}

#pragma mark - Layout Separator Views
- (void)layoutSeparatorViews {
    if (self.roundedButtonShape == YES) {
        return;
    }
    
    CGFloat thickness = 1.0 / self.window.contentScaleFactor;
    [self.separatorViews enumerateObjectsUsingBlock:^(UIView *separator, NSUInteger idx, BOOL *stop) {
        separator.hidden = NO;
        CGRect rect = (CGRect){CGPointZero, CGSizeMake(thickness, thickness)};
        
        NSInteger columnLine = (idx - self.numberOfRows); // ( 5<= .. <=6 을 0<=...<=1 로 바꾼다.)
        
        if (idx < self.numberOfRows) { // 가장 위에서 부터 가로로...
            rect.origin.y = idx * self.allowableDefaultButtonSize.height;
            rect.size.width = CGRectGetWidth(self.contentRect);
        } else { // 가장 왼쪽(좌*상 첫 번째 버튼의 오른쪽 세로 라인)에서 위에서 아래로 세로로 선을 긋는다.
            rect.origin.x = (columnLine + 1) * self.allowableDefaultButtonSize.width;
            rect.size.height = CGRectGetHeight(self.contentRect);
        }
        
        if (self.layoutType == MGUNumKeyboardLayoutTypeStandard1) {
            if (columnLine == 0) {
                rect.size.height = rect.size.height - self.allowableDefaultButtonSize.height;
            } else { // columnLine == 1
                if (self.allowsDoneButton == NO) {
                    rect.origin.y = self.allowableDefaultButtonSize.height;
                    rect.size.height = rect.size.height - self.allowableDefaultButtonSize.height;
                }
            }
        }
        
        if (self.layoutType == MGUNumKeyboardLayoutTypeStandard2) {
            if (idx == self.numberOfRows - 1) {
                rect.size.width = rect.size.width - self.allowableDefaultButtonSize.width;
            }
            if (columnLine == 0) {
                rect.size.height = rect.size.height - self.allowableDefaultButtonSize.height;
            }
        }
        
        if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle1) {
            if (columnLine == 0 || columnLine == 2) {
                rect.size.height = rect.size.height - self.allowableDefaultButtonSize.height;
            }
        }
        
        if (self.layoutType == MGUNumKeyboardLayoutTypeLowHeightStyle2) {
            // 건드릴 것이 없다.
        }
        
        separator.frame = CGRectOffset(rect, self.contentRect.origin.x, self.contentRect.origin.y);
    }];
}

- (CGRect)rectForIndex:(NSInteger)index rect:(CGRect)rect {
    return CGRectZero;
}

#pragma mark - private Helper
- (CGFloat)keyboardBorderThickness {
    if(self.roundedButtonShape == YES) {
        return 7.0;
    } else {
        return 0.0;
    }
}

//! 버튼이 채워질 수 있는 전체 영역을 의미한다.
- (CGRect)contentRect {
    CGFloat maximumWidth = 500.0;
    CGFloat width = MIN(maximumWidth, CGRectGetWidth(self.bounds) - (self.keyboardBorderThickness * 2.0));
    CGRect contentRect = CGRectMake(round((CGRectGetWidth(self.bounds) - width) / 2.0),
                                    self.keyboardBorderThickness,
                                    width,
                                    CGRectGetHeight(self.bounds) - (self.keyboardBorderThickness * 2.0));
    
    return UIEdgeInsetsInsetRect(contentRect, self.safeAreaInsets); // 키보드 키가 들어갈 사각형(위, 아래 인셋을 모두 제외한)
}

//! 일반적인 버튼의 사이즈를 의미한다. 그림 참고.
- (CGSize)allowableDefaultButtonSize {
    return CGSizeMake(CGRectGetWidth(self.contentRect)  / self.numberOfColumns,
                      CGRectGetHeight(self.contentRect) / self.numberOfRows);
}

- (CGRect)buttonRectForRow:(NSInteger)row
                    column:(NSInteger)column
                widthScale:(CGFloat)widthScale
               heightScale:(CGFloat)heightScale{
    CGRect rect = (CGRect){CGPointZero, self.allowableDefaultButtonSize};
    rect.origin.x = rect.size.width * (column -1);
    rect.origin.y = rect.size.height * (row -1);
    rect.size.width = rect.size.width * widthScale;
    rect.size.height = rect.size.height * heightScale;
    
    return ButtonRectMake(rect, self.contentRect, self.roundedButtonShape);
}

@end

#pragma mark - 지원 함수
static CGRect ButtonRectMake(CGRect rect, CGRect contentRect, BOOL roundedButtonShape) {
    rect = CGRectOffset(rect, contentRect.origin.x, contentRect.origin.y);
    
    if (roundedButtonShape == YES) {
        return CGRectInset(rect, MGUNumKeyboardButtonInset, MGUNumKeyboardButtonInset);
    } else {
        return rect;
    }
};
