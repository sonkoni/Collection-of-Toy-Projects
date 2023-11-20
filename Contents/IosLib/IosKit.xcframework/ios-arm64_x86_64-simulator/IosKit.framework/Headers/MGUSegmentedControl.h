//
//  MGUSegmentedControl.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//


#import <IosKit/MGUSegmentConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@class MGUSegmentedControl;
@protocol MGUSegmentedControlDataSource <NSObject> // 거의 필요 없을 듯하다.
@optional
- (NSUInteger)numberOfSegments:(MGUSegmentedControl *)control;
- (NSString *)segmentedControl:(MGUSegmentedControl *)control titleForSegmentAtIndex:(NSUInteger)index;
@end

@interface MGUSegmentedControl : UIControl

@property (nonatomic, weak, nullable) IBOutlet id <MGUSegmentedControlDataSource>dataSource; // data source 객체 - 델리게이트라고 보면된다. 반드시 설정하자.
@property (nonatomic, nullable) MGUSegmentConfiguration *configuration; // 설정에 해당하는 객체이다.

@property (nonatomic, assign) BOOL isSelectedTextGlowON; // selected segment 에 해당하는 글자를 빛나게 할 것인지.

@property (nonatomic, assign) NSTextAlignment alignment; // 텍스트의 정렬을 어떻게 할 거인지. 거의 센터이므로 안건드리는게 나을듯.

@property (nonatomic) UIFont *selectedTitleFont;       // selected segment   텍스트 폰트
@property (nonatomic) UIColor *selectedTitleTextColor; // selected segment   텍스트 칼라
@property (nonatomic) UIFont *titleFont;               // unselected segment 텍스트 폰트
@property (nonatomic) UIColor *titleTextColor;         // unselected segment 텍스트 칼라

@property (nonatomic) CGFloat segmentIndicatorBorderWidth;  // selected segment indicator 의 border의 굵기
@property (nonatomic) UIColor *segmentIndicatorBorderColor; // selected segment indicator 의 border의 색깔

@property (nonatomic) CGFloat borderWidth;  // segmented control 의 border의 굵기
@property (nonatomic) UIColor *borderColor; // segmented control 의 border의 색깔

@property (nonatomic) UIColor *segmentIndicatorBackgroundColor; // selected segment indicator를 단색으로 갈꺼면 이것만 사용. 그래디언트를 줄꺼면 밑에 3개를 사용.
@property (nonatomic) BOOL    drawsSegmentIndicatorGradientBackground; // <- 디폴트 NO
@property (nonatomic) UIColor *segmentIndicatorGradientTopColor;
@property (nonatomic) UIColor *segmentIndicatorGradientBottomColor;

//! segmented control의 색, 단색으로 갈거면, UIView에서 상속받은 backgroundColor 프라퍼티를 사용하라.
@property (nonatomic) BOOL    drawsGradientBackground;    // <- 디폴트 NO
@property (nonatomic) UIColor *gradientTopColor;
@property (nonatomic) UIColor *gradientBottomColor;

@property (nonatomic) CGFloat cornerRadiusPercent; // 전체 control의 코너의 radius 1.0은 반을 깎는다. : 0.0 ~ 1.0 디폴트 0.20f

@property (nonatomic) CGFloat segmentIndicatorInset; // <- 디폴트 0.0f; selected segment indicator가 전체 the control의 outer edge에서 inset되는 양

@property (nonatomic) CGFloat segmentIndicatorAnimationDuration; // <- 디폴트 0.15f;
@property (nonatomic) BOOL    usesSpringAnimations;              // <- 디폴트 값 NO
@property (nonatomic) CGFloat springAnimationDampingRatio;       // <- 디폴트 값 0.7f;

//! 현재 선택된 segment의 인덱스를 알 수 있다. 또한 코드로 때려 넣으면 강제로 움직일 수 있다. 따라서 readwrite이다.
//! 실제로 이 메서드는 외부, 프로그래머에 의해서 강제로 옮기는 경우 호출될 수 있다.
@property (nonatomic) NSUInteger selectedSegmentIndex;

//! 내부에서 탭에의해 움직일때 animated:YES로 움직인다.
//! animated:NO는 위의 프라퍼티 메서드와 완벽하게 같다.
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated;
- (void)setSelectedSegmentTitle:(NSString *)selectedSegmentTitle animated:(BOOL)animated; // 위의 메서드를 string으로도 작동하게 만들었다.

@property (nonatomic, readonly) NSUInteger numberOfSegments; // control의 세그먼트의 갯수이다. readonly이다.

/* 초기화 메서드. init 메서드는 기본빵으로 2개를 만든다. */
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles; // 초기화 메서드 1
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles  // 초기화 메서드 2
                  selecedtitle:(NSString * _Nullable)selecedtitle;
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles  // 초기화 메서드 3
                 configuration:(MGUSegmentConfiguration * _Nullable)configuration;
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles  // 초기화 메서드 4
                  selecedtitle:(NSString * _Nullable)selecedtitle
                 configuration:(MGUSegmentConfiguration * _Nullable)configuration;

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index; // 기존의 segmented control에 세그먼트를 추가적으로 삽입할 때, 호출됨

- (void)removeSegmentAtIndex:(NSUInteger)index; // 기존의 segmented control에 특정 세그먼트를 삭제할 때, 호출되는 메서드이다.
- (void)removeAllSegments; // 모든 세그먼트를 삭제할 때는 이 메서드를 이용한다.

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index; // 기존에 존재하는 세그먼트에 타이틀을 설정(재설정)한다.

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index; // 기존에 존재하는 세그먼트의 타이틀을 확인한다.
- (NSString *)titleForSelectedSegmentIndex; // 현재 선택된 세그먼터의 타이틀을 반환한다. - titleForSegmentAtIndex: 메서드를 sting으로도 작동하게 만들었다.

@end

NS_ASSUME_NONNULL_END
//
// 다음과 같은 컨트롤 Targetet 메서드를 등록하고 구현하라.
// [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
// 스프링 애니메이션 관련 조건값들 duration은 일반 애니메이션의 segmentIndicatorAnimationDuration 값을 쓴다.
