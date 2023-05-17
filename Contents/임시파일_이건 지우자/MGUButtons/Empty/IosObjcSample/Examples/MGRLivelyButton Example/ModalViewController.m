//
//  ModalTestViewController.m
//  FRDLivelyButtonDemo
//
//  Created by Sebastien Windal on 7/17/14.
//  Copyright (c) 2014 Sebastien Windal. All rights reserved.
//

#import "ModalViewController.h"
@import IosKit;

@interface ModalViewController ()
@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGULivelyButton *button = [[MGULivelyButton alloc] initWithFrame:CGRectMake(0,0,36,28)
                                                               style:MGULivelyButtonStyleArrowLeft
                                                       configuration:[MGULivelyButtonConfiguration blue_2_D_D_Config]];

    //! UIControlEventTouchUpInside 가 아니라 UIControlEventTouchDown를 써봤다.
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    MGULivelyButton *testButton = [[MGULivelyButton alloc] initWithFrame:CGRectZero
                                                                   style:MGULivelyButtonStyleHamburger
                                                           configuration:[MGULivelyButtonConfiguration black_4_15_D_Config]];
    [testButton addTarget:self action:@selector(testButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    testButton.translatesAutoresizingMaskIntoConstraints = NO;
    [testButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [testButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [testButton.widthAnchor constraintEqualToConstant:60.0f].active = YES;
    [testButton.widthAnchor constraintEqualToAnchor:testButton.heightAnchor].active = YES;
}


- (void)buttonAction:(MGULivelyButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)testButtonTap:(MGULivelyButton *)sender {
    if (sender.buttonStyle == MGULivelyButtonStyleHamburger) {
        [sender setStyle:MGULivelyButtonStyleLocation animated:YES];
    } else {
        [sender setStyle:MGULivelyButtonStyleHamburger animated:YES];
    }
}

@end
