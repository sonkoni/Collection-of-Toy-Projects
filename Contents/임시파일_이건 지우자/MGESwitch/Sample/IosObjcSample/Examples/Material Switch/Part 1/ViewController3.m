//
//  ViewController3.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 01/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController3.h"
@import IosKit;

@interface ViewController3 ()
@property (nonatomic) MGUMaterialSwitch * materialSwitch;
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Material Switch를 만들었다.";
    
    self.materialSwitch = [[MGUMaterialSwitch alloc] initWithSize:MGUMaterialSwitchSizeBig
                                                            style:MGUMaterialSwitchStyleDefault
                                                         switchOn:YES];
    [self.view addSubview:self.materialSwitch];
    self.materialSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.materialSwitch.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.materialSwitch.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.materialSwitch.widthAnchor   constraintEqualToConstant:self.materialSwitch.frame.size.width].active = YES;
    [self.materialSwitch.heightAnchor  constraintEqualToConstant:self.materialSwitch.frame.size.height].active = YES;
    
    [self.materialSwitch addTarget:self action:@selector(dNSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.materialSwitch addTarget:self
                            action:@selector(dNSwitchMoveStoped:)
                  forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

- (void)dNSwitchValueChanged:(MGUMaterialSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"밸류가 바뀌었네. ON");
    } else {
        NSLog(@"밸류가 바뀌었네. OFF");
    }
}

- (void)dNSwitchMoveStoped:(MGUMaterialSwitch *)sender {
    if (sender.switchOn == YES) {
        NSLog(@"멈췄구나. 현재 상태는 ON");
    } else {
        NSLog(@"멈췄구나. 현재 상태는 OFF");
    }
}

- (IBAction)onWithAnimated:(id)sender {
    [self.materialSwitch setSwitchOn:YES WithAnimated:YES];
}
- (IBAction)offWithAnimated:(id)sender{
    [self.materialSwitch setSwitchOn:NO WithAnimated:YES];
}
- (IBAction)onWithNoAnimated:(id)sender{
    [self.materialSwitch setSwitchOn:YES WithAnimated:NO];
}
- (IBAction)offWithNoAnimated:(id)sender{
    [self.materialSwitch setSwitchOn:NO WithAnimated:NO];
    
}

- (IBAction)disabled:(id)sender{
    [self.materialSwitch setEnabled:(!self.materialSwitch.enabled)];
}


@end
