//
//  MGUOnOffButton.h
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/11/16.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IosKit/MMTMidButtonSkin.h>
#import <IosKit/MMTTopButtonSkin.h>
#import <IosKit/MMTBottomButtonSkin.h>
@protocol MGUOnOffSkinInterface;

NS_ASSUME_NONNULL_BEGIN

@interface MGUOnOffButton : UIControl

@property (nonatomic, strong, nullable) __kindof UIView <MGUOnOffSkinInterface>*skinView;
@property (nonatomic, assign) UIImpactFeedbackStyle impactFeedbackStyle; // 디폴트 UIImpactFeedbackStyleMedium
@property (nonatomic, assign) BOOL impactOff; // 디폴트 NO.

- (instancetype)initWithFrame:(CGRect)frame
                     skinView:(__kindof UIView <MGUOnOffSkinInterface>* _Nullable)skinView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated notify:(BOOL)notify;

- (instancetype)initWithFrame:(CGRect)frame
                primaryAction:(UIAction * _Nullable)primaryAction __attribute__((unavailable("이용불가. - initWithFrame:skinView:를 이용하라.")));
@end

NS_ASSUME_NONNULL_END
