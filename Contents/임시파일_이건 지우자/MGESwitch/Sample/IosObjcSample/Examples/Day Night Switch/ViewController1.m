//
//  ViewController1.m
//  MGRButtons
//
//  Created by Kwan Hyun Son on 13/07/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController1.h"
#import <IosKit/IosKit.h>

@interface ViewController1 ()
@property (nonatomic) MGUDNSwitch * dayNightSwitch;
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Day Night Switch를 만들었다.";
    
    
    self.dayNightSwitch = [[MGUDNSwitch alloc] initWithCenter:self.view.center switchOn:YES configuration:nil];
    
    [self.view addSubview:self.dayNightSwitch];
    self.dayNightSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dayNightSwitch.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.dayNightSwitch.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.dayNightSwitch.widthAnchor   constraintEqualToConstant:self.dayNightSwitch.frame.size.width].active = YES;
    [self.dayNightSwitch.heightAnchor  constraintEqualToConstant:self.dayNightSwitch.frame.size.height].active = YES;
    
    [self.dayNightSwitch addTarget:self action:@selector(dNSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //! 큰 스위치.
    //MGUDNSwitch * test = [[MGUDNSwitch alloc] initWithFrame:CGRectMake(150, 150, 50 * 1.75, 50) switchOn:NO];
    MGUDNSwitch * test = [[MGUDNSwitch alloc] initWithFrame:CGRectZero switchOn:NO configuration:[MGUDNSwitchConfiguration defaultConfiguration2]];
    [self.view addSubview:test];
    test.translatesAutoresizingMaskIntoConstraints = NO;
    [test.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [test.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-200].active = YES;
    [test.widthAnchor   constraintEqualToConstant:50 * 1.75].active = YES;
    [test.heightAnchor  constraintEqualToConstant:50].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dNSwitchValueChanged:(MGUDNSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"밸류가 바뀌었네. ON");
    } else {
        NSLog(@"밸류가 바뀌었네. OFF");
    }
}

- (IBAction)onWithAnimated:(id)sender {
    [self.dayNightSwitch setSwitchOn:YES withAnimated:YES];
}
- (IBAction)offWithAnimated:(id)sender{
    [self.dayNightSwitch setSwitchOn:NO withAnimated:YES];
}
- (IBAction)onWithNoAnimated:(id)sender{
    [self.dayNightSwitch setSwitchOn:YES withAnimated:NO];
}
- (IBAction)offWithNoAnimated:(id)sender{
    [self.dayNightSwitch setSwitchOn:NO withAnimated:NO];
}
@end

