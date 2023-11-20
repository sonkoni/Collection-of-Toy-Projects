//
//  MGUOnOffButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-03
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import <IosKit/MMTMidButtonSkin.h>
#import <IosKit/MMTTopButtonSkin.h>
#import <IosKit/MMTBottomButtonSkin.h>
#import <IosKit/MGUOnOffButtonLockSkin.h>
@protocol MGUOnOffSkinInterface;

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGUOnOffButtonTouchArea
 @abstract   버튼의 터치 영역을 확장에 대한 표현
 @constant   MGUOnOffButtonTouchAreaNormal          일반적인
 @constant   MGUOnOffButtonTouchAreaOneAndHalfTimes 1.5 배 영역까지 받겠다.
 @constant   MGUOnOffButtonTouchAreaTwice           2 배 영역 영역까지 받겠다.
 */
typedef NS_ENUM(NSUInteger, MGUOnOffButtonTouchArea) {
    MGUOnOffButtonTouchAreaNormal = 0,
    MGUOnOffButtonTouchAreaOneAndHalfTimes = 4,
    MGUOnOffButtonTouchAreaTwice = 2
};

@interface MGUOnOffButton : UIControl

@property (nonatomic, strong, nullable) __kindof UIView <MGUOnOffSkinInterface>*skinView;
@property (nonatomic, assign) UIImpactFeedbackStyle impactFeedbackStyle; // 디폴트 UIImpactFeedbackStyleMedium
@property (nonatomic, assign) BOOL impactOff; // 디폴트 NO.

@property (nonatomic, assign) MGUOnOffButtonTouchArea touchArea; // 디폴트 MGROnOffButtonTouchAreaNormal
- (BOOL)isSelected; // 버튼 상태 체크를 위해

- (instancetype)initWithFrame:(CGRect)frame
                     skinView:(__kindof UIView <MGUOnOffSkinInterface>* _Nullable)skinView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated notify:(BOOL)notify;

- (instancetype)initWithFrame:(CGRect)frame
                primaryAction:(UIAction * _Nullable)primaryAction __attribute__((unavailable("이용불가. - initWithFrame:skinView:를 이용하라.")));

@end

NS_ASSUME_NONNULL_END
