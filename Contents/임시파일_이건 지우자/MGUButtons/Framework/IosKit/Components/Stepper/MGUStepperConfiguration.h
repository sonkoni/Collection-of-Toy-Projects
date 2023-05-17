//
//  MGUStepperConfiguration.h
//  GMStepperExample
//
//  Created by Kwan Hyun Son on 2020/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUStepperLabelType) {
    MGUStepperLabelTypeHidden = 1, // 가운데 텍스트 라벨을 아예 감추는 것.
    MGUStepperLabelTypeShowFixed = 2, // 가운데 텍스트 라벨을 보이게 하지만 손가락으로 드래깅은 되지 않는다.
    MGUStepperLabelTypeShowDraggable = 3 //! 디폴트
};

@interface MGUStepperConfiguration : NSObject <NSCopying>

@property (nonatomic) CGFloat value; // 디폴트 0.0;  쌩으로 현재 값을 바꾸려면 이것을 이용하라.
@property (nonatomic) CGFloat minimumValue; // 디폴트 0.0;
@property (nonatomic) CGFloat maximumValue; // 디폴트 100.0;
@property (nonatomic) CGFloat stepValue; // 디폴트 1.0;
@property (nonatomic) BOOL showIntegerIfDoubleIsInteger; // 디폴트 YES;

@property (nonatomic) BOOL autorepeat; // 디폴트 YES;
@property (nonatomic) CGFloat cornerRadius; // 디폴트 7.0;
@property (nonatomic) CGFloat borderWidth; // 디폴트 0.0;
@property (nonatomic) UIColor *borderColor; // 디폴트 UIColor.clear;
@property (nonatomic) UIColor *fullColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1 //! dynaimic

@property (nonatomic) UIColor *separatorColor; // 디폴트 UIColor.clear;
@property (nonatomic) CGFloat separatorWidth;  // 디폴트 1.0;
@property (nonatomic) CGFloat separatorHeightRatio;  // 디폴트 0.55;

@property (nonatomic) UIColor *buttonsBackgroundColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1
@property (nonatomic) UIColor *limitHitAnimationColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1 한계점
@property (nonatomic) UIImage *leftNormalImage; // 디폴트 @"−";
@property (nonatomic, nullable) UIImage *leftDisabledImage; // 디폴트 @"−"; nil 이면 normal 에서 흐려진다.
@property (nonatomic) UIImage *rightNormalImage; // 디폴트 @"+";
@property (nonatomic, nullable) UIImage *rightDisabledImage; // 디폴트 @"+"; nil 이면 normal 에서 흐려진다.
@property (nonatomic) UIColor *buttonsContensColor; // 디폴트 UIColor.white;
@property (nonatomic) UIFont *buttonsFont; // 디폴트 "AvenirNext-Bold", size: 20.0
@property (nonatomic) UIColor *impactColor; // 디폴트 199/255.0 199/255.0 204/255.0 @dynamic

@property (nonatomic, assign) MGUStepperLabelType stepperLabelType; // 디폴트 : MGUStepperLabelTypeShowDraggable

@property (nonatomic) BOOL isStaticLabelTitle; // 디폴트 NO. 가운데 라벨의 타이틀이 스텝퍼의 값 증감에 따라 바뀌는지 여부.
@property (nonatomic) UIColor *labelTextColor; // 디폴트 UIColor.white;
@property (nonatomic) UIColor *labelBackgroundColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1
@property (nonatomic) UIFont *labelFont; // 디폴트 "AvenirNext-Bold", size: 25.0
@property (nonatomic) CGFloat labelCornerRadius; // 디폴트 0.0;
@property (nonatomic) CGFloat labelWidthRatio; // 디폴트 0.5 전체 스탭퍼에서 라벨의 가로길이의 비율.

//! 일반적인 경우가 아니다. - 실제 사용할 때, 따로 입력해준다.
//! 1단위의 스텝을 가지면서, 스탭마다 특정한 문자열로 대신 나타내고 싶을때, 사용한다.
//! 또한, isStaticLabelTitle == YES 일 경우 이 값의 첫 번째 값을 이용한다.
@property (nonatomic, strong) NSMutableArray <NSString *>*items;

@property (nonatomic, assign) CGSize intrinsicContentSize;

//--------------------------------------------------------
//! 기본 템플릿들이다.
+ (instancetype)defaultConfiguration;
+ (instancetype)iOS13Configuration;
+ (instancetype)iOS7Configuration;
+ (instancetype)forgeDropConfiguration;
+ (instancetype)forgeDropConfiguration2; // 가운데 타이틀 라벨의 글자가 고정되게 만들어보았다.
@end

NS_ASSUME_NONNULL_END
