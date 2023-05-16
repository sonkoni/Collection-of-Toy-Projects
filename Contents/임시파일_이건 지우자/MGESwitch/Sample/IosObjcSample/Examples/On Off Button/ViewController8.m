//
//  ViewController8.m
//  MGRSwitch Project
//
//  Created by Kwan Hyun Son on 2021/11/17.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "ViewController8.h"
@import IosKit;

@interface ViewController8 ()
@property (weak, nonatomic) IBOutlet UIView *container1;
@property (weak, nonatomic) IBOutlet UIView *container2;
@property (weak, nonatomic) IBOutlet UIView *container3;
@property (weak, nonatomic) IBOutlet UIView *container4;
@property (nonatomic, strong) MGUOnOffButton *button;
@property (nonatomic, strong) MGUOnOffButton *button2;
@property (nonatomic, strong) MGUOnOffButton *button3;
@property (nonatomic, strong) MGUOnOffButton *button4;
@end

@implementation ViewController8

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.view.backgroundColor = [UIColor whiteColor];
    self.container1.backgroundColor = [UIColor clearColor];
    _button = [[MGUOnOffButton alloc] initWithFrame:CGRectZero skinView:[MMTMidButtonSkin new]];
    [self.container1 addSubview:self.button];
    [self.button mgrPinEdgesToSuperviewEdges];
    
    self.container2.backgroundColor = [UIColor clearColor];
    _button2 = [[MGUOnOffButton alloc] initWithFrame:CGRectZero skinView:[MMTTopButtonSkin new]];
    [self.container2 addSubview:self.button2];
    [self.button2 mgrPinEdgesToSuperviewEdges];
    
    self.container3.backgroundColor = [UIColor clearColor];
    _button3 = [[MGUOnOffButton alloc] initWithFrame:CGRectZero skinView:[MMTBottomButtonSkin new]];
    [self.container3 addSubview:self.button3];
    [self.button3 mgrPinEdgesToSuperviewEdges];
    
    self.container4.backgroundColor = [UIColor clearColor];
    _button4 = [[MGUOnOffButton alloc] initWithFrame:CGRectZero skinView:[MGUOnOffButtonLockSkin new]];
    [self.container4 addSubview:self.button4];
    [self.button4 mgrPinEdgesToSuperviewEdges];
}
@end
