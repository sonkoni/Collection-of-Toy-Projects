//
//  ViewControllerB.m
//  MGUStepper
//
//  Created by Kwan Hyun Son on 2020/11/10.
//

#import "ViewControllerB.h"
@import IosKit;

@interface ViewControllerB ()
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UIView *containerView3;
@property (weak, nonatomic) IBOutlet UIView *containerView4;
@property (weak, nonatomic) IBOutlet UIView *containerView5;

@property (nonatomic, strong) MGUStepper *stepper1;
@property (nonatomic, strong) MGUStepper *stepper2;
@property (nonatomic, strong) MGUStepper *stepper3;
@property (nonatomic, strong) MGUStepper *stepper4;
@property (nonatomic, strong) MGUStepper *stepper5;
@property (nonatomic, strong) NSArray <MGUStepper *>*steppers;
@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MGUStepper - code & config";
    _stepper1 = [[MGUStepper alloc] initWithConfiguration:[MGUStepperConfiguration iOS13Configuration]];
    [self.containerView1 addSubview:self.stepper1];
    [self.stepper1 mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper1 addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    _stepper2 = [[MGUStepper alloc] initWithConfiguration:[MGUStepperConfiguration iOS7Configuration]];
    [self.containerView2 addSubview:self.stepper2];
    [self.stepper2 mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper2 addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    _stepper3 = [[MGUStepper alloc] initWithConfiguration:[MGUStepperConfiguration forgeDropConfiguration]];
    [self.containerView3 addSubview:self.stepper3];
    [self.stepper3 mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper3 addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _stepper4 = [MGUStepper new];
    [self.containerView4 addSubview:self.stepper4];
    [self.stepper4 mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper4 addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    MGUStepperConfiguration *config = [MGUStepperConfiguration forgeDropConfiguration2];
    config.items = @[@"H"].mutableCopy;
    _stepper5 = [[MGUStepper alloc] initWithConfiguration:config];
    [self.containerView5 addSubview:self.stepper5];
    [self.stepper5 mgrPinCenterToSuperviewCenter];  // intrinsicContentSize 설정됨
    [self.stepper5 addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];

    UISwitch *enableSwitch = [UISwitch new];
    enableSwitch.on = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:enableSwitch];
    [enableSwitch addTarget:self action:@selector(enableSwitchClick:) forControlEvents:UIControlEventValueChanged];
    
    _steppers = @[self.stepper1, self.stepper2, self.stepper3, self.stepper4, self.stepper5];
}


#pragma mark - Action
- (void)enableSwitchClick:(UISwitch *)sender { // Stepper 자체를 disable enable해보겠다.
    for (MGUStepper *stepper in self.steppers) {
        stepper.enabled = sender.on;
    }
}

- (void)stepperValueChanged:(MGUStepper *)sender {
    NSLog(@"stepper.value %f", sender.value);
}

@end
