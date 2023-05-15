//! 사용방법
//! 초기화 메서드는 다음과 같다. 스위치를 ON 상태 또는 OFF 상태로 초기화 할 수 있다.
/// 1. - initWithSize:style:switchOn:;
/// 만약, - init 메서드로 초기화하면, 기본적인 셋팅으로 만들어진다. 크기(노멀), 색(디폴트), 셀렉션(ON)


//! 스위치의 현재 상태를 확인하고 싶다면 swichOn(getter)를 통해 확인하자.

//! 스위치의 상태를 프로그래머틱하게 변경하고 싶다면(즉, 손가락을 대지 않고)
//! - setSwitchOn:WithAnimated:를 이용하자.
//! animated YES이면 애니메이션이 작동하면서 변화된다.
//! 또한 변화가 있다면, 변경 알림도 온다. ON -> OFF 또는 OFF -> ON // 그러나 ON -> ON 또는 OFF -> OFF 라면 알림은 오지 않는다.
//! animated NO이면 애니메이션이 작동되지 않고 변화된다. 변화가 있던 없던 간에 알림은 오지 않는다.

//! 알림은 두 개가 존재한다.
//! 1. 번은 실시간 변화에 따른 알림이다. 2. 번은 손가락이 때어졌을 때 발생하는 알림이다. 앱에 따라서 적절히 사용한다.
//! 1. UIControlEventValueChanged
//! 2. UIControlEventTouchUpInside | UIControlEventTouchUpOutside
//! 사용 방법은 다음과 같다.
//! [switch addTarget:self action:@selector(dNSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
//! [switch addTarget:self action:@selector(dNSwitchMoveStoped:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];


#import <UIKit/UIKit.h>

#pragma mark - Switch type
typedef NS_ENUM(NSInteger, MGUMaterialSwitchStyle) {
    MGUMaterialSwitchStyleLight,
    MGUMaterialSwitchStyleDark,
    MGUMaterialSwitchStyleDefault
};

#pragma mark - Initial MGUMaterialSwitch size (big, normal, small)
typedef NS_ENUM(NSInteger, MGUMaterialSwitchSize) {
    MGUMaterialSwitchSizeBig,
    MGUMaterialSwitchSizeNormal,
    MGUMaterialSwitchSizeSmall
};


@interface MGUMaterialSwitch : UIControl

/** A Boolean value whether the bounce animation effect is enabled when state change movement */
@property (nonatomic) BOOL bounceEnabled;
/** A Boolean value whether the ripple animation effect is enabled or not */
@property (nonatomic) BOOL rippleEnabled;

//! 버튼의 상태를 결정한다. 이 값을 프로그래머틱하게 설정하면 애니메이션이 들어가면서 변환된다.
//! 그러나 on 상태에서 또 on을 설정하면, 아무런 일도 일어나지 않게 만들었다.
@property (nonatomic) BOOL switchOn;

@property (nonatomic) CGFloat animaitonDuration;

/** 손잡이의 색깔. */
@property (nonatomic, strong) UIColor *knobOnColor;
@property (nonatomic, strong) UIColor *knobOffColor;

@property (nonatomic, strong) UIColor *trackOnColor;
@property (nonatomic, strong) UIColor *trackOffColor;

@property (nonatomic, strong) UIColor *knobDisabledColor;
@property (nonatomic, strong) UIColor *trackDisabledColor;

@property (nonatomic, strong) UIColor *rippleFillColor;

#pragma mark - Initializer
/**
 *  Initializes a MGUMaterialSwitch in the easiest way with default parameters.
 *
 *  @MGUMaterialSwitchStyle: MGUMaterialSwitchStyleDefault,
 *  @MGUMaterialSwitchState: MGUMaterialSwitchStateOn,
 *  @MGUMaterialSwitchSize: MGUMaterialSwitchSizeNormal
 *
 *  @return A MGRFadingInfoView with above parameters
 */
- (instancetype)init;

- (instancetype)initWithSize:(MGUMaterialSwitchSize)size
                       style:(MGUMaterialSwitchStyle)style
                    switchOn:(BOOL)switchOn NS_DESIGNATED_INITIALIZER;


//! animated가 YES이면, 단순히, setSwitchOn:을 호출하게 만들었다.
//! 만약 변화가 있다면 알림도 온다. 그러나, animated가 NO이면 알림 없이 스위치의 상태를 변경한다.
- (void)setSwitchOn:(BOOL)switchOn WithAnimated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
