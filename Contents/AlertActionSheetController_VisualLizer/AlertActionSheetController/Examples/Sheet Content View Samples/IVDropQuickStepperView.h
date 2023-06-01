//
//  IVDropQuickStepperView.h
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2020/12/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUStepper;

NS_ASSUME_NONNULL_BEGIN

@interface IVDropQuickStepperView : UIControl
@property (nonatomic, assign) CGFloat currentValue; // 분
@property (nonatomic, strong) MGUStepper *hourStepper;
@property (nonatomic, strong) MGUStepper *minuteStepper;

- (instancetype)initWithCurrentValue:(CGFloat)currentValue maxValue:(CGFloat)totalValue;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
