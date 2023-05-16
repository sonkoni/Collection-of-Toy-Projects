//
//  ViewController2.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController2.h"
@import IosKit;

@interface ViewController2 ()
@property (weak) IBOutlet MGUFlatSwitch *flatSwitch;
// - (IBAction)flatSwitchClick:(id)sender; <- IB 사용할 때. 여기서는 직접 수동으로하겠다.
@property (strong) MGUFlatSwitch *flatSwitch2;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Flat Switch를 만들었다.";
    
    [self.flatSwitch addTarget:self action:@selector(keke:) forControlEvents:UIControlEventValueChanged];
    
    self.flatSwitch2 = [[MGUFlatSwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.flatSwitch2.lineWidth = 3.0f;
    self.flatSwitch2.baseCircleStrokeColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.6 alpha:0.5]
                          darkModeColor:[UIColor.redColor colorWithAlphaComponent:0.5]
                  darkElevatedModeColor:nil];
    
    self.flatSwitch2.checkMarkNCircleStrokeColor =
    [UIColor mgrColorWithLightModeColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.6 alpha:1.0]
                          darkModeColor:[UIColor redColor]
                  darkElevatedModeColor:nil];
    
    [self.view addSubview:self.flatSwitch2];
    self.flatSwitch2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.flatSwitch2.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.flatSwitch2.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.flatSwitch2.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.flatSwitch2.heightAnchor constraintEqualToConstant:50].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// - (IBAction)flatSwitchClick:(id)sender {}  <- IB 사용할 때. 여기서는 직접 수동으로하겠다.

- (void)keke:(MGUFlatSwitch *)sender {
    NSLog(@"선택됬니 %d", sender.isSelected);
}

@end
