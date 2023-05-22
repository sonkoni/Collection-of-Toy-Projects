//
//  ViewControllerC.m
//  MGUStepper
//
//  Created by Kwan Hyun Son on 2022/11/01.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "ViewControllerC.h"
@import IosKit;

@interface ViewControllerC ()
@property (nonatomic, strong) MGUStepper *stepper;
@end

@implementation ViewControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"More Custom";
    _stepper = [[MGUStepper alloc] initWithConfiguration:[self testConfiguration]];
    [self.view addSubview:self.stepper];
    [self.stepper mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    UIVisualEffectView *visualEffectView =
        [UIVisualEffectView mgrBlurViewWithBlurEffectStyle:UIBlurEffectStyleSystemThinMaterial];
    [self.stepper insertSubview:visualEffectView atIndex:0];
    [visualEffectView mgrPinEdgesToSuperviewEdges];
    visualEffectView.userInteractionEnabled = NO;
    

    UISwitch *enableSwitch = [UISwitch new];
    enableSwitch.on = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:enableSwitch];
    [enableSwitch addTarget:self action:@selector(enableSwitchClick:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Action
- (void)enableSwitchClick:(UISwitch *)sender { // Stepper 자체를 disable enable해보겠다.
    if (sender.on == NO) {
        self.stepper.enabled = NO;
    } else {
        self.stepper.enabled = YES;
    }
}

- (void)stepperValueChanged:(MGUStepper *)sender {
    NSLog(@"stepper.value %f", sender.value);
}

- (MGUStepperConfiguration *)testConfiguration {
    MGUStepperConfiguration *result = [MGUStepperConfiguration defaultConfiguration];
    // result.stepperLabelType = MGUStepperLabelTypeShowFixed;
    CGSize size = CGSizeMake(300.0, 67.0);
    CGFloat labelWidthRatio = (size.width - (2.0 * size.height)) / size.width;
    result.stepperLabelType = MGUStepperLabelTypeShowDraggable;
    result.intrinsicContentSize = size;
    result.cornerRadius = (size.height/2.0);

    UIImageSymbolConfiguration *symbolConfiguration =
        [UIImageSymbolConfiguration configurationWithPointSize:22.0
                                                        weight:UIImageSymbolWeightBold
                                                         scale:UIImageSymbolScaleLarge];
    
    UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImageSymbolConfiguration *colorConfig =
        [UIImageSymbolConfiguration configurationWithPaletteColors:@[color]];
    colorConfig = [colorConfig configurationByApplyingConfiguration:symbolConfiguration];
    result.leftNormalImage = [UIImage systemImageNamed:@"minus.circle.fill" withConfiguration:colorConfig];
    result.rightNormalImage = [UIImage systemImageNamed:@"plus.circle.fill" withConfiguration:colorConfig];
    
    color = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    colorConfig = [UIImageSymbolConfiguration configurationWithPaletteColors:@[color]];
    colorConfig = [colorConfig configurationByApplyingConfiguration:symbolConfiguration];
    result.leftDisabledImage = [UIImage systemImageNamed:@"minus.circle" withConfiguration:colorConfig];
    result.rightDisabledImage = [UIImage systemImageNamed:@"plus.circle" withConfiguration:colorConfig];
    
    result.buttonsContensColor = [UIColor systemRedColor];
    result.labelTextColor = [UIColor labelColor];
    result.fullColor = [UIColor clearColor];
    
    result.buttonsBackgroundColor = [UIColor clearColor];
    result.labelBackgroundColor = [UIColor clearColor];
    result.impactColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    result.minimumValue = 0.0;
    result.maximumValue = 10.0;
    result.labelFont = [UIFont mgrSystemPreferredFont:UIFontTextStyleTitle2
                                               traits:UIFontDescriptorTraitBold];
    result.labelWidthRatio = labelWidthRatio;
    result.minimumValue = 0.0;
    result.maximumValue = 8.0;
    
    NSMutableArray <NSString *>*arr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 9; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld Smoothies", i+1];
        [arr addObject:str];
    }
    
    result.items = arr;
    return result;
}

@end
