//
//  MGAStepperConfiguration.h
//  MGUStepperExample
//
//  Created by Kwan Hyun Son on 2022/11/02.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGAStepperLabelType) {
    MGAStepperLabelTypeHidden = 1, // 가운데 텍스트 라벨을 아예 감추는 것.
    MGAStepperLabelTypeShowFixed = 2, // 가운데 텍스트 라벨을 보이게 하지만 손가락으로 드래깅은 되지 않는다.
    MGAStepperLabelTypeShowDraggable = 3 //! 디폴트
};

@interface MGAStepperConfiguration : NSObject <NSCopying>

@property (nonatomic) CGFloat value; // 디폴트 0.0;  쌩으로 현재 값을 바꾸려면 이것을 이용하라.
@property (nonatomic) CGFloat minimumValue; // 디폴트 0.0;
@property (nonatomic) CGFloat maximumValue; // 디폴트 100.0;
@property (nonatomic) CGFloat stepValue; // 디폴트 1.0;
@property (nonatomic) BOOL showIntegerIfDoubleIsInteger; // 디폴트 YES;

@property (nonatomic) BOOL autorepeat; // 디폴트 YES;
@property (nonatomic) CGFloat cornerRadius; // 디폴트 7.0;
@property (nonatomic) CGFloat borderWidth; // 디폴트 0.0;
@property (nonatomic) NSColor *borderColor; // 디폴트 NSColor.clear;
@property (nonatomic) NSColor *fullColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1 //! dynaimic

@property (nonatomic) NSColor *separatorColor; // 디폴트 NSColor.clear;
@property (nonatomic) CGFloat separatorWidth;  // 디폴트 1.0;
@property (nonatomic) CGFloat separatorHeightRatio;  // 디폴트 0.55;

@property (nonatomic) NSColor *buttonsBackgroundColor; // 디폴트 red:0.21, green:0.5, blue:0.74, alpha:1
@property (nonatomic) NSColor *limitHitAnimationColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1 한계점
@property (nonatomic) NSImage *leftNormalImage; // 디폴트 @"−";
@property (nonatomic, nullable) NSImage *leftDisabledImage; // 디폴트 @"−"; nil 이면 normal 에서 흐려진다.
@property (nonatomic) NSImage *rightNormalImage; // 디폴트 @"+";
@property (nonatomic, nullable) NSImage *rightDisabledImage; // 디폴트 @"+"; nil 이면 normal 에서 흐려진다.
@property (nonatomic) NSColor *buttonsContensColor; // 디폴트 NSColor.white;
@property (nonatomic) NSFont *buttonsFont; // 디폴트 "AvenirNext-Bold", size: 20.0
@property (nonatomic) NSColor *impactColor; // 디폴트 199/255.0 199/255.0 204/255.0 @dynamic

@property (nonatomic, assign) MGAStepperLabelType stepperLabelType; // 디폴트 : MGUStepperLabelTypeShowDraggable

@property (nonatomic) BOOL isStaticLabelTitle; // 디폴트 NO. 가운데 라벨의 타이틀이 스텝퍼의 값 증감에 따라 바뀌는지 여부.
@property (nonatomic) NSColor *labelTextColor; // 디폴트 NSColor.white;
@property (nonatomic) NSColor *labelBackgroundColor; // 디폴트 red:0.26, green:0.6, blue:0.87, alpha:1
@property (nonatomic) NSFont *labelFont; // 디폴트 "AvenirNext-Bold", size: 25.0
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

