//
//  ViewController2A.m
//  MGUButtons
//
//  Created by Kwan Hyun Son on 2021/11/19.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "ViewController2A.h"
@import IosKit;

@interface ViewController2A ()
@property (weak, nonatomic) IBOutlet UIView *container1;
@property (weak, nonatomic) IBOutlet UIView *container2;
@end

@implementation ViewController2A

- (void)viewDidLoad {
    [super viewDidLoad];
    self.container1.layer.cornerRadius = 0.0;
    self.container1.layer.borderWidth = 1.0;
    self.container1.layer.borderColor = [UIColor redColor].CGColor;
    self.container1.backgroundColor = [UIColor clearColor];
    
    self.container2.layer.cornerRadius = 0.0;
    self.container2.layer.borderWidth = 1.0;
    self.container2.layer.borderColor = [UIColor redColor].CGColor;
    self.container2.backgroundColor = [UIColor clearColor];
    
    MGUNeoSegControl *segmentedControl =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleModels]
                                   selecedtitle:@"0"
                                  configuration:[MGUNeoSegConfiguration clearConfiguration]];
    segmentedControl.impactOff = NO;
    
    [self.container1 addSubview:segmentedControl];
    [segmentedControl mgrPinSizeToSuperviewSize];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIView *myIndicator = [UIView new];
    [segmentedControl.indicator addSubview:myIndicator];
    myIndicator.backgroundColor = [UIColor redColor];
    [myIndicator mgrPinCenterToSuperviewCenter];
    [myIndicator.widthAnchor constraintEqualToConstant:15.0].active = YES;
    [myIndicator.heightAnchor constraintEqualToConstant:70.0].active = YES;
    
    MGUNeoSegControl *segmentedControl2 =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleModels2]
                                   selecedtitle:@"0"
                                  configuration:[MGUNeoSegConfiguration clearConfiguration]];
    segmentedControl2.impactOff = NO;
    
    [self.container2 addSubview:segmentedControl2];
    [segmentedControl2 mgrPinSizeToSuperviewSize];
    [segmentedControl2 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIView *myIndicator2 = [UIView new];
    [segmentedControl2.indicator addSubview:myIndicator2];
    myIndicator2.backgroundColor = [UIColor redColor];
    [myIndicator2 mgrPinCenterToSuperviewCenter];
    [myIndicator2.widthAnchor constraintEqualToConstant:15.0].active = YES;
    [myIndicator2.heightAnchor constraintEqualToConstant:70.0].active = YES;
    
    // 아래 변수를 조정해서 MMT 프로젝트에서 3 개짜리 세그먼트를 만들어 주면 될듯.
    // 세그먼트의 가로가 56 일때. 인터아이템 스페이싱이 10이다.
    // configuration.interItemSpacing = 0.0;
    
    /// configuration.interItemSpacing = 0.0;
//    configuration.segmentIndicatorInset = 0.0;
}

- (NSArray <MGUNeoSegModel *>*)titleModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"0"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"1"];
    return @[model1, model2];
}

- (NSArray <MGUNeoSegModel *>*)titleModels2 {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"0"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"1"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:@"2"];
    return @[model1, model2, model3];
}

- (void)valueChanged:(MGUNeoSegControl *)sender {
    NSLog(@"밸류가 바뀌었다. %lu", (unsigned long)sender.selectedSegmentIndex);
}

@end
