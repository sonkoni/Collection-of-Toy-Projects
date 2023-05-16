//
//  MGUNeoSegControl.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//
// https://github.com/sh-khashimov/RESegmentedControl


#import <IosKit/MGUNeoSegConfiguration.h>
#import <IosKit/MGUNeoSegModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUNeoSegControl : UIControl
@property (nonatomic, nullable) MGUNeoSegConfiguration *configuration; // 설정에 해당하는 객체이다.
@property (nonatomic, readonly) NSUInteger numberOfSegments; // control의 세그먼트의 갯수이다.
@property (nonatomic, assign) UIImpactFeedbackStyle impactFeedbackStyle; // 디폴트 UIImpactFeedbackStyleMedium
@property (nonatomic, assign) BOOL impactOff; // 디폴트 YES.
@property (nonatomic, strong, readonly) UIView *indicator; // 인디케이터를 가지고 니 맘대로 하고 커스터 마이징 하고 싶다면 이것을 이용하라. @dynamic

//! 현재 선택된 segment의 인덱스를 알 수 있다. 또한 코드로 때려 넣으면 강제로 움직일 수 있다. 따라서 readwrite이다.
//! 실제로 이 메서드는 외부, 프로그래머에 의해서 강제로 옮기는 경우 호출될 수 있다.
@property (nonatomic) NSUInteger selectedSegmentIndex;
@property (nonatomic) NSInteger currentTouchIndex;

//! 내부에서 탭에의해 움직일때 animated:YES로 움직인다.
//! animated:NO는 위의 프라퍼티 메서드와 완벽하게 같다.
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated;
- (void)setSelectedSegmentTitle:(NSString *)selectedSegmentTitle animated:(BOOL)animated; // 위의 메서드를 string으로도 작동하게 만들었다.

/* 초기화 메서드. init 메서드는 기본빵으로 2개를 만든다. */
- (instancetype)initWithTitles:(NSArray <MGUNeoSegModel *>*)segmentModels  // 초기화 메서드
                  selecedtitle:(NSString * _Nullable)selecedtitle
                 configuration:(MGUNeoSegConfiguration * _Nullable)configuration NS_DESIGNATED_INITIALIZER;

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index; // 기존에 존재하는 세그먼트의 타이틀을 확인한다.
- (NSString *)titleForSelectedSegmentIndex; // 현재 선택된 세그먼터의 타이틀을 반환. - titleForSegmentAtIndex: 메서드를 이용.
- (UIImage *)segmentImageForSegmentAtIndex:(NSUInteger)index;
- (UIImage *)segmentImageForSelectedSegmentIndex;

//!- 편집 메서드
- (void)insertSegmentWithModel:(MGUNeoSegModel *)segmentModel  // 기존의 control에 세그먼트를 추가적으로 삽입할 때 호
                       atIndex:(NSUInteger)index;
- (void)removeSegmentAtIndex:(NSUInteger)index; // 기존의 segmented control에 특정 세그먼트를 삭제할 때, 호출되는 메서드이다.
- (void)removeAllSegments; // 모든 세그먼트를 삭제할 때는 이 메서드를 이용한다.
- (void)setModel:(MGUNeoSegModel *)segmentModel AtIndex:(NSUInteger)index; // 기존에 존재하는 세그먼트에 타이틀을 설정(재설정)한다.

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
//
// 다음과 같은 컨트롤 Targetet 메서드를 등록하고 구현하라.
// [segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
