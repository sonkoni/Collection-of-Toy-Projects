//
//  ViewController7.m
//  MGUButtons
//
//  Created by Kwan Hyun Son on 2022/08/02.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "ViewController7.h"
@import IosKit;

@interface ViewController7 ()

@end

@implementation ViewController7

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    MGUDisplaySwitcherButton *button = [[MGUDisplaySwitcherButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 35.0, 35.0)];
    button.buttonStyle = MGUDisplaySwitcherButtonStyleHamburger;
    button.config = [MGUDisplaySwitcherButtonConfiguration barButtonConfig];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"체인지";
}

- (void)buttonAction:(MGUDisplaySwitcherButton *)sender {
    if (sender.buttonStyle == MGUDisplaySwitcherButtonStyleHamburger) {
        [sender setStyle:MGUDisplaySwitcherButtonStyleGrid animated:YES];
    } else {
        [sender setStyle:MGUDisplaySwitcherButtonStyleHamburger animated:YES];
    }
}

@end
