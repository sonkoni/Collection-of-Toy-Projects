//
//  ViewController.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 15/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "ViewControllerF.h"
#import "ViewControllerF1.h"
#import "ViewControllerF2.h"
@import BaseKit;
@import IosKit;

@interface ViewControllerF ()
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *heartButton;
@property (nonatomic, strong) MGUFavoriteSwitch *bigSmileButton;
@property (nonatomic, strong) MGUFavoriteSwitch *bigSmileButton2;
@end

@implementation ViewControllerF

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUFavoriteSwitch";
    
    CGFloat width = (self.view.frame.size.width - 44.0) / 4.0;
    CGFloat x = width / 2.0;
    CGFloat y = self.view.frame.size.height / 2.0 - 22.0;
    
    // star button
    MGUFavoriteSwitch *starButton =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
                                   imageType:MGUFavoriteSwitchImageTypeStar
                                 colorConfig:nil];
    // heart button
    x = x + width;
    MGUFavoriteSwitch *heartButton =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
                                   imageType:MGUFavoriteSwitchImageTypeHeart
                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MattePink]];
    // like button
    x = x + width;
    MGUFavoriteSwitch *likeButton =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
                                   imageType:MGUFavoriteSwitchImageTypeLike
                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteSky]];
    // smile button
    x = x + width;
    MGUFavoriteSwitch *smileButton =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
                                   imageType:MGUFavoriteSwitchImageTypeSmile
                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteGreen]];

    [starButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    [heartButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    [likeButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    [smileButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:starButton];
    [self.view addSubview:heartButton];
    [self.view addSubview:likeButton];
    [self.view addSubview:smileButton];
    starButton.selected = YES;
    likeButton.selected = YES;
    starButton.sparkMode = MGUFavoriteSwitchSparkModeShine;
    likeButton.sparkMode = MGUFavoriteSwitchSparkModeShine;

    //! xib
    [self.heartButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    self.heartButton.mainImage =
        [UIImage imageNamed:@"MGUFavoriteSwitch_heart"
                   inBundle:[NSBundle mgrIosRes]
          withConfiguration:nil];
    starButton.layer.borderWidth = 1.0;
    heartButton.layer.borderWidth = 1.0;
    likeButton.layer.borderWidth = 1.0;
    smileButton.layer.borderWidth = 1.0;
    self.heartButton.layer.borderWidth = 1.0;

    _bigSmileButton =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
                                   imageType:MGUFavoriteSwitchImageTypeSmile
                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteGreen]];
    
    [self.bigSmileButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.bigSmileButton];
    self.bigSmileButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bigSmileButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.bigSmileButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50.0f].active = YES;
    //[self.bigSmileButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-300.0f].active = YES;
    [self.bigSmileButton.widthAnchor constraintEqualToConstant:100.0].active = YES;
    [self.bigSmileButton.heightAnchor constraintEqualToConstant:100.0].active = YES;
    
    _bigSmileButton2 =
    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
                                   imageType:MGUFavoriteSwitchImageTypeSmile
                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteSky]];
    
    [self.bigSmileButton2 addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.bigSmileButton2];
    self.bigSmileButton2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bigSmileButton2.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.bigSmileButton2.centerYAnchor constraintEqualToAnchor:self.bigSmileButton.centerYAnchor].active = YES;
    [self.bigSmileButton2.widthAnchor constraintEqualToConstant:100.0].active = YES;
    [self.bigSmileButton2.heightAnchor constraintEqualToConstant:100.0].active = YES;
    
    self.bigSmileButton.layer.borderWidth = 1.0;
    self.bigSmileButton2.layer.borderWidth = 1.0;
    self.bigSmileButton2.sparkMode = MGUFavoriteSwitchSparkModeShine;

    UILabel *bigSmileLabel = [UILabel new];
    [self.view addSubview:bigSmileLabel];
    bigSmileLabel.text = @"위의 스마일 버튼 처럼 크기를 오토레이아웃으로 조정해도 잘 먹게 만들었다.";
    bigSmileLabel.numberOfLines = 0;
    bigSmileLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [bigSmileLabel.topAnchor constraintEqualToAnchor:self.bigSmileButton.bottomAnchor constant:30.0f].active = YES;
    [bigSmileLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [bigSmileLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8].active = YES;
    
    starButton.duration = 2.0f;
    heartButton.duration = 2.0f;
    self.bigSmileButton.duration  = 2.5f;
    self.bigSmileButton2.duration  = 2.5f;
}

- (void)tappedButton:(MGUFavoriteSwitch *)sender {
    NSLog(@"sender -> %d", sender.selected);
}

- (IBAction)pushButtonClick1:(id)sender {
    ViewControllerF2 *vc = [ViewControllerF2 new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)pushButtonClick:(id)sender {
    ViewControllerF1 *vc = [ViewControllerF1 new];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
