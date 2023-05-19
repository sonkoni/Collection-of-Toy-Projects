//
//  MGUDNSwitch.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//
//
//! 사용방법
//! 초기화 메서드는 다음과 같다. 스위치를 ON 상태 또는 OFF 상태로 초기화 할 수 있다.
/// 1. - initWithCenter:switchOn:
/// 2. - initWithFrame:switchOn:

//! 스위치의 현재 상태를 확인하고 싶다면 swichOn(getter)를 통해 확인하자.

//! 스위치의 상태를 프로그래머틱하게 변경하고 싶다면(즉, 손가락을 대지 않고)
//! - setSwitchOn:withAnimated:를 이용하자.
//! animated YES이면 애니메이션이 작동하면서 변화된다.
//! animated NO이면 애니메이션이 작동되지 않고 변화된다.
//! 알람은 오지 않는다. 알람은 손가락으로만 작동한다.

//! 사용 방법은 다음과 같다.
//! [switch addTarget:self action:@selector(dNSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];

#import <IosKit/MGUDNSwitchConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUDNSwitch : UIControl

@property (nonatomic, strong) MGUDNSwitchConfiguration *configuration;

//! 버튼의 상태를 결정한다. 이 값을 프로그래머틱하게 설정하면 애니메이션이 들어가면서 변환된다.
//! 그러나 on 상태에서 또 on을 설정하면, 아무런 일도 일어나지 않게 만들었다.
@property (nonatomic) BOOL switchOn;

- (CGFloat)knobViewMargin; // 이 메서드는 본 클래스 뿐만 아니라 MGUDNKnobView에서 사용하므로 공개해줘야한다.

//! animated가 YES이면, 단순히, setSwitchOn:을 호출하게 만들었다.
//! 그러나, animated가 NO이면 알림 없이 스위치의 상태를 변경한다.
//! 알람은 오지 않는다. 알람은 손가락으로만 작동한다.
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame
                     switchOn:(BOOL)switchOn
                configuration:(MGUDNSwitchConfiguration * _Nullable)configuration;
- (instancetype)initWithCenter:(CGPoint)center
                      switchOn:(BOOL)switchOn
                 configuration:(MGUDNSwitchConfiguration * _Nullable)configuration;
//! height = 30, width  = height * 1.75 추천! 비율은 적절히 선택하라.


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame primaryAction:(nullable UIAction *)primaryAction NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
