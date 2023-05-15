//
//  MGURulerView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//

#import <IosKit/MGURulerViewConfig.h>
@class MGURulerView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MGURulerViewIndicatorType) {
    MGURulerViewIndicatorBallHeadType = 1,
    MGURulerViewIndicatorWheelHeadType, // two color
    MGURulerViewIndicatorLineType
};


@protocol MGURulerViewDelegate <NSObject>
@required
// 스크롤이 움직여서 값이 바뀔때만 호출.
- (void)rulerViewDidScroll:(MGURulerView *)rulerView
       currentDisplayValue:(CGFloat)currentDisplayValue;
@optional
@end
// MGURulerViewDelegate 프로토콜에서 호출하여 사용함.
NSAttributedString *MGURulerViewMainLabelAttrStr(CGFloat value, UIFont *font, UIColor *color);

@interface MGURulerView : UIView
@property (nonatomic, assign) MGURulerViewWeightMode weightMode;
@property (nonatomic, weak) id <MGURulerViewDelegate> delegate;
@property (nonatomic, assign) BOOL soundOn; // pickerViewSoundPlay(tracking), tockSoundPlay(NO tracking)
@property (nonatomic, assign) BOOL hasRubberEffect; // 디폴트 YES;
@property (nonatomic, assign) BOOL doubleTapMove; // 디폴트 YES;
@property (nonatomic, assign) BOOL tripleTapMove; // 디폴트 NO;
@property (nonatomic, assign) NSUInteger doubleTapSpace; // 디폴트 200
@property (nonatomic, assign) NSUInteger tripleTapSpace; // 디폴트 300
@property (nonatomic, copy, nullable) void (^normalSoundPlayBlock)(void);
@property (nonatomic, copy, nullable) void (^skipSoundPlayBlock)(void);
// [self.sound workoutSelectHapticSoundPlay]; // normal
// [self.sound workoutResumedAutoDetectSoundPlay]; // skip 쓩

//! 이동 메서드이다
- (void)moveToLeft;
- (void)moveToRight;
- (void)moveFarToLeft; // 작은칸 100 칸
- (void)moveFarToRight; // 작은칸 100 칸
- (void)moveToLeftSpaces:(NSUInteger)spaces; // 100 이면 작은칸 100칸
- (void)moveToRightSpaces:(NSUInteger)spaces; // 100 이면 작은칸 100칸

- (void)goToValue:(CGFloat)value animated:(BOOL)animated notify:(BOOL)notify;  // 한방에 가는 메서드이다.

- (instancetype)initWithFrame:(CGRect)frame
                 initialValue:(CGFloat)initialValue
                indicatorType:(MGURulerViewIndicatorType)indicatorType
                       config:(MGURulerViewConfig *)config NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
