//
//  ViewController2.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 20/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "ViewControllerF1.h"
@import BaseKit;
@import IosKit;

@interface ViewControllerF1 ()
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *smileButton1;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *smileButton2;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *smileButton3;
@property (weak, nonatomic) IBOutlet MGUFavoriteSwitch *likeButton;
@end

@implementation ViewControllerF1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *smileImage = [UIImage imageNamed:@"MGUFavoriteSwitch_smile" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];;
    self.smileButton1.mainImage = smileImage;
    self.smileButton2.mainImage = smileImage;
    self.smileButton3.mainImage = smileImage;
    
    self.likeButton.mainImage =
        [UIImage imageNamed:@"MGUFavoriteSwitch_like" inBundle:[NSBundle mgrIosRes] withConfiguration:nil];
    [self.likeButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventValueChanged];
}

- (void)tappedButton:(MGUFavoriteSwitch *)sender {
    NSLog(@"sender -> %d", sender.selected);
}

- (IBAction)deselctNotifyYES:(id)sender {
    [self.likeButton setSelected:NO animated:NO notify:YES];
}

- (IBAction)deselctNotifyNO:(id)sender {
    [self.likeButton setSelected:NO animated:NO notify:NO];
}

- (IBAction)select_AnimatedNO_NotifyNO:(id)sender {
    [self.likeButton setSelected:YES animated:NO notify:NO];
}

- (IBAction)select_AnimatedNO_NotifyYES:(id)sender {
    [self.likeButton setSelected:YES animated:NO notify:YES];
}

- (IBAction)select_AnimatedYES_NotifyNO:(id)sender {
    [self.likeButton setSelected:YES animated:YES notify:NO];
}

- (IBAction)select_AnimatedYES_NotifyYES:(id)sender {
    [self.likeButton setSelected:YES animated:YES notify:YES];
}


- (IBAction)dimissButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
