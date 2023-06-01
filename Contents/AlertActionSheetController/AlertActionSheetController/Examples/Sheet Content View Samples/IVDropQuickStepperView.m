//
//  IVDropQuickStepperView.m
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2020/12/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "IVDropQuickStepperView.h"

@interface IVDropQuickStepperView ()
@property (nonatomic, assign) CGFloat maxValue; // 분
@end

@implementation IVDropQuickStepperView

#pragma mark - 생성 & 소멸
- (instancetype)initWithCurrentValue:(CGFloat)currentValue maxValue:(CGFloat)maxValue {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _currentValue = currentValue;
        _maxValue = maxValue;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(IVDropQuickStepperView *self) {
    UIStackView *stackView = [UIStackView new];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    UIView *view1 = [UIView new];
    UIView *view2 = [UIView new];
    view1.backgroundColor = [UIColor clearColor];
    view2.backgroundColor = [UIColor clearColor];
    [stackView addArrangedSubview:view1];
    [stackView addArrangedSubview:view2];
    
    [self addSubview:stackView];
    [stackView mgrPinEdgesToSuperviewEdges];
    
    self->_hourStepper =
    [[MGUStepper alloc] initWithConfiguration:[MGUStepperConfiguration forgeDropConfiguration2]];
    self.hourStepper.items = @[@"H"].mutableCopy;
    self->_minuteStepper =
    [[MGUStepper alloc] initWithConfiguration:[MGUStepperConfiguration forgeDropConfiguration2]];
    self.minuteStepper.items = @[@"M"].mutableCopy;
    
    self.hourStepper.maximumValue = self.maxValue;
    self.minuteStepper.maximumValue = self.maxValue;
    [self.hourStepper setValueQuietly:self.currentValue];
    [self.minuteStepper setValueQuietly:self.currentValue];
    
    self.hourStepper.stepValue = 60.0;
    
    [view1 addSubview:self.hourStepper];
    [view2 addSubview:self.minuteStepper];
    [self.hourStepper mgrPinCenterToSuperviewCenter];
    [self.minuteStepper mgrPinCenterToSuperviewCenter];
    
    [self.hourStepper addTarget:self
                         action:@selector(stepperValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self.minuteStepper addTarget:self
                           action:@selector(stepperValueChanged:)
                 forControlEvents:UIControlEventValueChanged];

}

- (void)stepperValueChanged:(MGUStepper *)sender {
    if (sender == self.hourStepper) {
        self.currentValue = self.hourStepper.value;
        [self.minuteStepper setValueQuietly:self.currentValue];
    } else {
        self.currentValue = self.minuteStepper.value;
        [self.hourStepper setValueQuietly:self.currentValue];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - Helper
- (CGFloat)totalHourValue {
    return round(self.maxValue / 60.0);
}

- (CGFloat)totalMinValue {
    return round(self.maxValue);
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }

@end
