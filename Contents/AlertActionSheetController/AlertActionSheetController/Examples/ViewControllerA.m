//
//  ViewControllerA.m
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 27/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "ViewControllerA.h"
@import IosKit;

@interface ViewControllerA ()
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UIView *containerView3;
@property (weak, nonatomic) IBOutlet UIView *containerView4;
@property (weak, nonatomic) IBOutlet UIView *containerView5;
@end

@implementation ViewControllerA

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"various examples";
    
    MGUNeoSegControl *segmentedControl1 =
    [[MGUNeoSegControl alloc] initWithTitles:[self imageModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration iOS7Configuration]];
    
    [self.containerView1 addSubview:segmentedControl1];
    [segmentedControl1 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 29.0)];
    [segmentedControl1 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MGUNeoSegControl *segmentedControl2 =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration iOS13Configuration]];
    
    [self.containerView2 addSubview:segmentedControl2];
    [segmentedControl2 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 31.0)];
    [segmentedControl2 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MGUNeoSegControl *segmentedControl3 =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleAndImageModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration orangeConfiguration]];
    
    [self.containerView3 addSubview:segmentedControl3];
    [segmentedControl3 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 50.0)];
    [segmentedControl3 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MGUNeoSegControl *segmentedControl4 =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleAndImageModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration yellowConfiguration]];
    
    [self.containerView4 addSubview:segmentedControl4];
    [segmentedControl4 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 50.0)];
    [segmentedControl4 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MGUNeoSegControl *segmentedControl5 =
    [[MGUNeoSegControl alloc] initWithTitles:[self titleModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration greenConfiguration]];
    
    [self.containerView5 addSubview:segmentedControl5];
    [segmentedControl5 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 50.0)];
    [segmentedControl5 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChanged:(MGUNeoSegControl *)sender {
    NSLog(@"밸류가 바뀌었다. %lu", (unsigned long)sender.selectedSegmentIndex);
}


#pragma mark - Helper
- (NSArray <MGUNeoSegModel *>*)titleModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"safari"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"chrome"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:@"firefox"];
    return @[model1, model2, model3];
}

- (NSArray <MGUNeoSegModel *>*)imageModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:nil imageName:@"safari"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:nil imageName:@"chrome"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:nil imageName:@"firefox"];
    return @[model1, model2, model3];
}

- (NSArray <MGUNeoSegModel *>*)urlIimageModels {
    NSArray <NSString *>*urls =
    @[@"https://github.com/sh-khashimov/RESegmentedControl/blob/master/Images/browsers/safari.png?raw=true",
      @"https://github.com/sh-khashimov/RESegmentedControl/blob/master/Images/browsers/chrome.png?raw=true",
      @"https://github.com/sh-khashimov/RESegmentedControl/blob/master/Images/browsers/firefox.png?raw=true"];

    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:nil imageUrl:urls[0]];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:nil imageUrl:urls[1]];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:nil imageUrl:urls[2]];
    return @[model1, model2, model3];
}

- (NSArray <MGUNeoSegModel *>*)titleAndImageModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"safari" imageName:@"safari"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"chrome" imageName:@"chrome"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:@"firefox" imageName:@"firefox"];
    return @[model1, model2, model3];
}


@end
