//
//  ViewController3.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 22/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "ViewControllerF2.h"
@import BaseKit;
@import IosKit;

@interface ViewControllerF2 ()
@property (nonatomic, strong) MGUFavoriteSwitch *starChangeSwitch;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *favoriteSwitch1;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *favoriteSwitch2;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *favoriteSwitch3;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *favoriteSwitch4;
@end

@implementation ViewControllerF2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *likeImage = [UIImage imageNamed:@"MGUFavoriteSwitch_like" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
    UIImage *heartImage = [UIImage imageNamed:@"MGUFavoriteSwitch_heart" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
    UIImage *smileImage = [UIImage imageNamed:@"MGUFavoriteSwitch_smile" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
    UIImage *starImage = [UIImage imageNamed:@"MGUFavoriteSwitch_star" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
    
    self.favoriteSwitch1.mainImage = likeImage;
    self.favoriteSwitch2.mainImage = heartImage;
    self.favoriteSwitch3.mainImage = smileImage;
    self.favoriteSwitch4.mainImage = starImage;
    _starChangeSwitch = [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
                                                       imageType:MGUFavoriteSwitchImageTypeCollectSet
                                                     colorConfig:nil];
    self.starChangeSwitch.layer.borderWidth = 1.0f;
    [self.view addSubview:self.starChangeSwitch];
    self.starChangeSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.starChangeSwitch.widthAnchor constraintEqualToConstant:50.0f].active = YES;
    [self.starChangeSwitch.heightAnchor constraintEqualToConstant:50.0f].active = YES;
    [self.starChangeSwitch.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.starChangeSwitch.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30.0f].active = YES;
    
    [self.starChangeSwitch addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)tappedButton:(MGUFavoriteSwitch *)sender {
    NSLog(@"sender -> %d", sender.selected);
}

- (IBAction)dimissButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end

//@interface ViewController ()
//@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *heartButton;

//@property (nonatomic, strong) MGUFavoriteSwitch *bigSmileButton2;
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    CGFloat width = (self.view.frame.size.width - 44.0) / 4.0;
//    CGFloat x = width / 2.0;
//    CGFloat y = self.view.frame.size.height / 2.0 - 22.0;
//
//    // star button
//    MGUFavoriteSwitch *starButton =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
//                                   imageType:MGUFavoriteSwitchImageTypeStar
//                                 colorConfig:nil];
//    // heart button
//    x = x + width;
//    MGUFavoriteSwitch *heartButton =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
//                                   imageType:MGUFavoriteSwitchImageTypeHeart
//                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MattePink]];
//    // like button
//    x = x + width;
//    MGUFavoriteSwitch *likeButton =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
//                                   imageType:MGUFavoriteSwitchImageTypeLike
//                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteSky]];
//    // smile button
//    x = x + width;
//    MGUFavoriteSwitch *smileButton =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectMake(x, y, 44.0, 44.0)
//                                   imageType:MGUFavoriteSwitchImageTypeSmile
//                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteGreen]];
//
//    [starButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//    [heartButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//    [likeButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//    [smileButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//
//    [self.view addSubview:starButton];
//    [self.view addSubview:heartButton];
//    [self.view addSubview:likeButton];
//    [self.view addSubview:smileButton];
//    starButton.selected = YES;
//    likeButton.selected = YES;
//    starButton.sparkMode = MGUFavoriteSwitchSparkModeShine;
//    likeButton.sparkMode = MGUFavoriteSwitchSparkModeShine;
//
//    //! xib
//    [self.heartButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//
//    starButton.layer.borderWidth = 1.0;
//    heartButton.layer.borderWidth = 1.0;
//    likeButton.layer.borderWidth = 1.0;
//    smileButton.layer.borderWidth = 1.0;
//    self.heartButton.layer.borderWidth = 1.0;
//
//    _bigSmileButton =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
//                                   imageType:MGUFavoriteSwitchImageTypeSmile
//                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteGreen]];
//
//    [self.bigSmileButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.bigSmileButton];
//    self.bigSmileButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.bigSmileButton.trailingAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
//    [self.bigSmileButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-300.0f].active = YES;
//    [self.bigSmileButton.widthAnchor constraintEqualToConstant:100.0].active = YES;
//    [self.bigSmileButton.heightAnchor constraintEqualToConstant:100.0].active = YES;
//
//    _bigSmileButton2 =
//    [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
//                                   imageType:MGUFavoriteSwitchImageTypeSmile
//                                 colorConfig:[MGUFavoriteSwitchColorConfiguration MatteSky]];
//
//    [self.bigSmileButton2 addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.bigSmileButton2];
//    self.bigSmileButton2.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.bigSmileButton2.leadingAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
//    [self.bigSmileButton2.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-300.0f].active = YES;
//    [self.bigSmileButton2.widthAnchor constraintEqualToConstant:100.0].active = YES;
//    [self.bigSmileButton2.heightAnchor constraintEqualToConstant:100.0].active = YES;
//
//    self.bigSmileButton.layer.borderWidth = 1.0;
//    self.bigSmileButton2.layer.borderWidth = 1.0;
//    self.bigSmileButton2.sparkMode = MGUFavoriteSwitchSparkModeShine;
//
//    UILabel *bigSmileLabel = [UILabel new];
//    [self.view addSubview:bigSmileLabel];
//    bigSmileLabel.text = @"위의 스마일 버튼 처럼 크기를 오토레이아웃으로 조정해도 잘 먹게 만들었다.";
//    bigSmileLabel.numberOfLines = 0;
//    bigSmileLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [bigSmileLabel.topAnchor constraintEqualToAnchor:self.bigSmileButton.bottomAnchor constant:30.0f].active = YES;
//    [bigSmileLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
//    [bigSmileLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8].active = YES;
//
//    starButton.duration = 2.0f;
//    heartButton.duration = 2.0f;
//    self.bigSmileButton.duration  = 2.5f;
//    self.bigSmileButton2.duration  = 2.5f;
//
//
//    MGUFavoriteSwitch *testSwitch = [[MGUFavoriteSwitch alloc] initWithFrame:CGRectZero
//                                                                   imageType:MGUFavoriteSwitchImageTypeCollectSet
//                                                                 colorConfig:nil];
//    testSwitch.layer.borderWidth = 1.0f;
//    [self.view addSubview:testSwitch];
//    testSwitch.translatesAutoresizingMaskIntoConstraints = NO;
//    [testSwitch.widthAnchor constraintEqualToConstant:50.0f].active = YES;
//    [testSwitch.heightAnchor constraintEqualToConstant:50.0f].active = YES;
//    [testSwitch.centerYAnchor constraintEqualToAnchor:self.bigSmileButton2.centerYAnchor].active = YES;
//    [testSwitch.leadingAnchor constraintEqualToAnchor:self.bigSmileButton2.trailingAnchor].active = YES;
//
//}
//

//
//- (IBAction)pushButtonClick:(id)sender {
//    ViewController2 *vc = [ViewController2 new];
//    [self presentViewController:vc animated:YES completion:nil];
//}
//@end
//
