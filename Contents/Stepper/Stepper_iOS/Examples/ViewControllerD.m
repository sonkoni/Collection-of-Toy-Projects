//
//  ViewControllerD.m
//  MGUStepper
//
//  Created by Kwan Hyun Son on 2021/02/03.
//

#import "ViewControllerD.h"
@import IosKit;

@interface ViewControllerD ()
@property (nonatomic, strong) MGUStepper *stepper1;
@end

@implementation ViewControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MGUStepper";
    MGUStepperConfiguration *con = [MGUStepperConfiguration forgeDropConfiguration];
//    con.isStaticLabelTitle = YES;
//    con.items = @[@"∙∙∙"].mutableCopy;
    _stepper1 = [[MGUStepper alloc] initWithConfiguration:con];
    [self.view addSubview:self.stepper1];
    [self.stepper1 mgrPinCenterToSuperviewCenter]; // intrinsicContentSize 설정됨
    [self.stepper1 addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    UISwitch *enableSwitch = [UISwitch new];
    enableSwitch.on = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:enableSwitch];
    [enableSwitch addTarget:self action:@selector(enableSwitchClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stepper1.isStaticLabelTitle = YES;
        self.stepper1.items = @[@"∙∙∙"].mutableCopy;
        [self.stepper1 setAllContensEnabled:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.stepper1.isStaticLabelTitle = NO;
            self.stepper1.items = nil;
            [self.stepper1 setValueQuietly:self.stepper1.value];
            self.stepper1.enabled = YES;
        });
    });
}


#pragma mark - Action
- (void)enableSwitchClick:(UISwitch *)sender { // Stepper 자체를 disable enable해보겠다.
    if (sender.on == NO) {
        self.stepper1.enabled = NO;
    } else {
        self.stepper1.enabled = YES;
    }
}

- (void)stepperValueChanged:(MGUStepper *)sender {
    NSLog(@"stepper.value %f", sender.value);
}

@end
