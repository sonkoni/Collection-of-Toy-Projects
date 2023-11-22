//
//  MGUStepper.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-03
//  ----------------------------------------------------------------------
//
//! UIStepper 사이즈 CGSize = {94, 32} 좌우버튼 가로 사이즈 46.5 이며, 1은 세퍼레이터이다.
//! 구버전은 사이즈 CGSize = {94, 29} 좌우버튼 가로 사이즈 47 이며, 1은 세퍼레이터이다.
//! 배경색 : 238 238 239,  세퍼레이터 칼라 : 213 213 217, 하이라이트 칼라 : 199 199 204
//! 하이라이트 애니메이션 크기변화 (0.85 X 0.75) => (1.0 X 1.0)

#import <UIKit/UIKit.h>
#import <IosKit/MGUStepperConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MGUStepper : UIControl

@property (nonatomic) IBInspectable CGFloat value; // 디폴트 0.0;  쌩으로 현재 값을 바꾸려면 이것을 이용하라.
@property (nonatomic) IBInspectable CGFloat minimumValue; // 디폴트 0.0;
@property (nonatomic) IBInspectable CGFloat maximumValue; // 디폴트 100.0;
@property (nonatomic) IBInspectable CGFloat stepValue; // 디폴트 1.0;
@property (nonatomic) IBInspectable BOOL showIntegerIfDoubleIsInteger; // 디폴트 YES;

@property (nonatomic) IBInspectable BOOL autorepeat; // 디폴트 YES;
@property (nonatomic) IBInspectable CGFloat cornerRadius; // 디폴트 7.0;
@property (nonatomic) IBInspectable CGFloat borderWidth; // 디폴트 0.0;
@property (nonatomic) IBInspectable UIColor *borderColor; // 디폴트 UIColor.clear;
@property (nonatomic) IBInspectable UIColor *fullColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1 //! dynaimic

@property (nonatomic) IBInspectable UIColor *separatorColor; // 디폴트 UIColor.clear;
@property (nonatomic) IBInspectable CGFloat separatorWidth;  // 디폴트 1.0;
@property (nonatomic) IBInspectable CGFloat separatorHeightRatio;  // 디폴트 0.55;

@property (nonatomic) IBInspectable UIColor *buttonsBackgroundColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1
@property (nonatomic) IBInspectable UIColor *limitHitAnimationColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1 한계점
@property (nonatomic) IBInspectable UIImage *leftNormalImage; // 디폴트 @"−";
@property (nonatomic) IBInspectable UIImage *leftDisabledImage; // 디폴트 @"−";
@property (nonatomic) IBInspectable UIImage *rightNormalImage; // 디폴트 @"+";
@property (nonatomic) IBInspectable UIImage *rightDisabledImage; // 디폴트 @"+";
@property (nonatomic) IBInspectable UIColor *buttonsContensColor; // 디폴트 UIColor.white;
@property (nonatomic) IBInspectable UIFont *buttonsFont; // 디폴트 "AvenirNext-Bold", size: 20.0
@property (nonatomic) IBInspectable UIColor *impactColor; // 디폴트 199/255.0 199/255.0 204/255.0 @dynamic

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSUInteger stepperLabelType;
#else
@property (nonatomic, assign) MGUStepperLabelType stepperLabelType; // 디폴트 : MGUStepperLabelTypeShowDraggable
#endif

@property (nonatomic) IBInspectable BOOL isStaticLabelTitle; // 디폴트 NO;
@property (nonatomic) IBInspectable UIColor *labelTextColor; // 디폴트 UIColor.white;
@property (nonatomic) IBInspectable UIColor *labelBackgroundColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1
@property (nonatomic) IBInspectable UIFont *labelFont; // 디폴트 "AvenirNext-Bold", size: 25.0
@property (nonatomic) IBInspectable CGFloat labelCornerRadius; // 디폴트 0.0;
@property (nonatomic) IBInspectable CGFloat labelWidthRatio; // 디폴트 0.5 전체 스탭퍼에서 라벨의 가로길이의 비율.

//! 일반적인 경우가 아니다.
//! 1단위의 스텝을 가지면서, 스탭마다 특정한 문자열로 대신 나타내고 싶을때, 사용한다.
//! 또는 고정 글자를 이용할 때도 사용할 수 있다.
@property (nonatomic, strong, nullable) NSMutableArray <NSString *>*items;

- (void)setAllContentsEnabled:(BOOL)enabled; // - (void)setEnabled:(BOOL)enabled; 은 가운데 라벨은 항상 enable이다.
- (void)setValueQuietly:(CGFloat)value;

- (instancetype)initWithFrame:(CGRect)frame
                configuration:(MGUStepperConfiguration * _Nullable)configuration;
- (instancetype)initWithConfiguration:(MGUStepperConfiguration * _Nullable)configuration;
@end

NS_ASSUME_NONNULL_END

/** 타이머의 간격을 체크해볼 수 있는 유용한 블락이다. 이 프로젝트에서는 사용하지는 않았다. 주석으로만 남겨두자.
__block CFAbsoluteTime prevTime = 0.0f; // typedef CFTimeInterval CFAbsoluteTime;
self.printTimerGaps = ^void(void) {
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (prevTime != 0.0) {
        printf("now - prevTime : %f \n", now - prevTime);
    }
    prevTime = now;
};
**/

