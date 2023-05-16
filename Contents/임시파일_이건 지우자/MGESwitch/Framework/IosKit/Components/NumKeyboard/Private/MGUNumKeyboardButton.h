//
//  MMKeyboardButton.h
//  keyBoard_koni
//
//  Created by Kwan Hyun Son on 18/10/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUNumKeyboardButton : UIButton

@property (nonatomic, assign) BOOL usesRoundedCorners;  // 디폴트는 NO, 버튼의 cornerRadius를 줄 것인가.
@property (nonatomic, assign) BOOL continuousPressIsPossible; // 디폴트는 NO, long press 시, 일정한 간격으로 반복적으로 호출될 것인가

- (void)updateButtonAppearance; //! 내부에서도 호출되며, configuration 객체에 의해서도 호출된다.

/* 색깔 설정관련 **/
@property (nonatomic, strong) UIColor *buttonBackgroundColor;            // Enable - Normal
@property (nonatomic, strong) UIColor *buttonContentsColor;              // Enable - Normal
@property (nonatomic, strong) UIColor *highlightedButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic, strong) UIColor *highlightedButtonContentsColor;   // Enable - Highlighted
@property (nonatomic, strong) UIColor *disabledButtonBackgroundColor;    // Disabled
@property (nonatomic, strong) UIColor *disabledButtonContentsColor;      // Disabled
@property (nonatomic, strong) UIColor *buttonShadowColor;                // Shadow
@property (nonatomic, strong) UIColor *borderColor;                // border

@end

NS_ASSUME_NONNULL_END
