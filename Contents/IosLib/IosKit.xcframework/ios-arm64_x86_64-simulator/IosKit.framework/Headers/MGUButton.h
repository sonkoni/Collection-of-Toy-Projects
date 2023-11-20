//
//  MGUButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUButtonConfiguration.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE @interface MGUButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable BOOL continuousPressIsPossible; // 디폴트 NO, long press 시, 일정한 간격으로 반복적 호출
@property (nonatomic, assign) IBInspectable NSTimeInterval continuousPressRepeatTimeInterval;
@property (nonatomic, assign) IBInspectable NSTimeInterval continuousPressDelay;
@property (nonatomic, assign) IBInspectable BOOL breadEffect;    // 디폴트 NO
@property (nonatomic, assign) IBInspectable BOOL shrinkEffect;   // 디폴트 NO
@property (nonatomic, assign) IBInspectable BOOL isRippleCircle; // 디폴트 YES
@property (nonatomic, strong) IBInspectable UIColor *rippleColor; //breadEffect, shrinkEffect에 디폴트 gray alpha 0.2

@property (nonatomic, strong) UIFont *buttonTitleLabelFont;

- (void)updateButtonAppearance; //! 내부에서도 호출되며, configuration 객체에 의해서도 호출된다.

/* 색깔 설정관련 **/
@property (nonatomic, strong) IBInspectable UIColor *buttonBackgroundColor;            // Enable - Normal
@property (nonatomic, strong) IBInspectable UIColor *buttonContentsColor;              // Enable - Normal
@property (nonatomic, strong) IBInspectable UIColor *highlightedButtonBackgroundColor; // Enable - Highlighted
@property (nonatomic, strong) IBInspectable UIColor *highlightedButtonContentsColor;   // Enable - Highlighted
@property (nonatomic, strong) IBInspectable UIColor *selectedButtonBackgroundColor; // Enable - Selected
@property (nonatomic, strong) IBInspectable UIColor *selectedButtonContentsColor;   // Enable - Selected
@property (nonatomic, strong) IBInspectable UIColor *disabledButtonBackgroundColor;    // Disabled
@property (nonatomic, strong) IBInspectable UIColor *disabledButtonContentsColor;      // Disabled
@property (nonatomic, strong) IBInspectable UIColor *buttonShadowColor;                // 디폴트 clear
@property (nonatomic, strong) IBInspectable UIColor *borderColor;                      // 디폴트 clear


+ (instancetype)buttonWithConfiguration:(MGUButtonConfiguration * _Nullable)configuration; // 이게 편할듯.
- (instancetype)initWithFrame:(CGRect)frame configuration:(MGUButtonConfiguration * _Nullable)configuration;

- (void)switchMainImage;
- (void)switchAlternativeImage;

//! 기존 것. 그닥 쓸일 없을 듯. 사용하고 싶다면, 외부에서 잡고 컨트롤 해줘야한다.  많이 쓸일이 없을 것 같아서 이정도만 해뒀다.
- (void)pulse;
- (void)flash;
- (void)shake;
- (void)glowON;
- (void)glowOFF;

@end

NS_ASSUME_NONNULL_END
// 
//[self.button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];


