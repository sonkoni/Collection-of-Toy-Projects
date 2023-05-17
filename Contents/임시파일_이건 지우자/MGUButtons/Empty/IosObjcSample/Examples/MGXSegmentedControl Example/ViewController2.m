//
//  ViewController2.m
//  MGUButtons
//
//  Created by Kwan Hyun Son on 30/09/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController2.h"
@import IosKit;

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UIView *containerView3;
@property (weak, nonatomic) IBOutlet UIView *containerView4;
@property (weak, nonatomic) IBOutlet UIView *containerView5;
@property (weak, nonatomic) IBOutlet UIView *containerView6;
@property (weak, nonatomic) IBOutlet UIView *containerView7;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUNeoSegControl";
    
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
    
    MGUNeoSegControl *segmentedControl6 =
    [[MGUNeoSegControl alloc] initWithTitles:[self urlIimageModels]
                                   selecedtitle:@"chrome"
                                  configuration:[MGUNeoSegConfiguration iOS7Configuration]];
    
    [self.containerView6 addSubview:segmentedControl6];
    [segmentedControl6 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(355.0, 29.0)];
    [segmentedControl6 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];

    MGUNeoSegConfiguration *config = [MGUNeoSegConfiguration forgeConfiguration];
    self.containerView7.backgroundColor = config.backgroundColor;
    MGUNeoSegControl *segmentedControl7 =
    [[MGUNeoSegControl alloc] initWithTitles:[self dropTitleAndImageModels]
                                   selecedtitle:@"chrome"
                                  configuration:config];
    
    [self.containerView7 addSubview:segmentedControl7];
    [segmentedControl7 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(300.0, 80.0)];
    [segmentedControl7 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl7.impactOff = NO;
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

- (NSArray <MGUNeoSegModel *>*)dropTitleAndImageModels {
    MGUNeoSegModel *model1 = [MGUNeoSegModel segmentModelWithTitle:@"10" imageName:@"chamber_drop_10_size"];
    MGUNeoSegModel *model2 = [MGUNeoSegModel segmentModelWithTitle:@"15" imageName:@"chamber_drop_15_size"];
    MGUNeoSegModel *model3 = [MGUNeoSegModel segmentModelWithTitle:@"20" imageName:@"chamber_drop_20_size"];
    MGUNeoSegModel *model4 = [MGUNeoSegModel segmentModelWithTitle:@"60" imageName:@"chamber_drop_60_size"];
    return @[model1, model2, model3, model4];
}

@end
