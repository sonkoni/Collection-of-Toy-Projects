//
//  MGUAlertViewConfiguration.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//
//

#import <UIKit/UIKit.h>
@class MGUAlertActionConfiguration;

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS (NSInteger, MGUAlertViewTransitionStyle) {
    MGUAlertViewTransitionStyleNone = 0, // 0000 0000
    MGUAlertViewTransitionStyleFGFade = 1 << 0, // 0000 0001 Fade 로 등장함.
    MGUAlertViewTransitionStyleFGSlideFromTop = 1 << 1, // 0000 0010  위에서 쿵 내려옴
    MGUAlertViewTransitionStyleFGSlideFromTopRotation = 1 << 2, // 0000 0100 위에서 쿵 내려옴 & 회전
    MGUAlertViewTransitionStyleFGSlideFromBottom = 1 << 3, // 0000 1000 아래에서에서 쿵 내려옴
    
    MGUAlertViewTransitionStyleBGScale = 1 << 4 // 0001 0000 뒤의 존재하는 뷰의 크기를 줄인다.
};

@interface MGUAlertViewConfiguration : NSObject <NSCopying>

@property (nonatomic) MGUAlertViewTransitionStyle transitionStyle; // 등장하는 스타일 셋 중에 하나.
// 디폴트 NO. alert view를 둘러싼 희미한 배경을 탭하여 action handler를 실행하지 않고 닫음.
@property (nonatomic) BOOL backgroundTapDismissalGestureEnabled;
// 디폴트 NO.  alert view를 위 또는 아래로 스와이프하여 action handler를 실행하지 않고 닫음.
@property (nonatomic) BOOL swipeDismissalGestureEnabled;

// button이 항상 수직으로 정렬되는지 여부를 결정하는 값. NO로 설정하면 2개의 action button이 있는 경우. 버튼이 좌우로 배열됨.
@property (nonatomic) BOOL alwaysArrangesActionButtonsVertically; // 디폴트 NO.

@property (nonatomic) CGFloat alertViewCornerRadius; // alert view의 코너 라디어스
@property (nonatomic) UIColor *alertViewBackgroundColor; // 디폴트 opaque white
//! 블러를 쓰고 싶다면, alertViewBackgroundColor를 clear로 하면된다.
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle; //! blur로 갈지 alertViewBackgroundColor 쓸지 결정

@property (nonatomic) UIColor *titleTextColor;   // alert view 타이틀의 색깔
@property (nonatomic) UIColor *messageTextColor; // alert view 메세지의 색깔
@property (nonatomic) UIFont *titleFont; // alert view 타이틀의 Font
@property (nonatomic) UIFont *messageFont; // alert view 메시지의 Font

@property (nonatomic) BOOL showsSeparators; // 디폴트 YES, 버튼 사이 및 둘레를 감싸는 얇은 선분을 보여줄 것인가 여부.
@property (nonatomic) UIColor *separatorColor; // showsSeparators 가 YES 일때 Separator의 색깔

// content view, second content view, third content view에 적용. 아이콘, 지도, 이미지 등.
@property (nonatomic) UIEdgeInsets contentViewInset; // 디폴트: UIEdgeInsetsZero

// 기본적으로 가지고 있는 title label, text field 및 사이 간격들을 모두 날려버리고 첫 번째 컨텐츠 뷰와 버튼만 살려둔다.
@property (nonatomic) BOOL onlyOneContentView; // 디폴트 NO. 

// MGUAlertAction 객체가 자신의 configuration 객체(MGUAlertActionConfiguration) 가 없을 때, 이 프라퍼티가 사용된다.
@property (nonatomic) MGUAlertActionConfiguration *buttonConfiguration; // default style
@property (nonatomic) MGUAlertActionConfiguration *destructiveButtonConfiguration; // destructive style
@property (nonatomic) MGUAlertActionConfiguration *cancelButtonConfiguration; // cancel style

+ (MGUAlertViewConfiguration *)dosePickerConfiguration;
+ (MGUAlertViewConfiguration *)forgeSaveAlarmConfiguration;
+ (MGUAlertViewConfiguration *)onboardingConfiguration; //! 하나의 컨텐츠에만 집중할 수 있게. 버튼도 없게.

@end
NS_ASSUME_NONNULL_END



