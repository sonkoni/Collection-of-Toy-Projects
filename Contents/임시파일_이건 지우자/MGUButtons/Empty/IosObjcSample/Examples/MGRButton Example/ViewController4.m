//
//  MGRViewController3.m
//  MGUButtons
//
//  Created by Kwan Hyun Son on 20/06/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "ViewController4.h"
@import IosKit;

@interface ViewController4 ()
@property (weak) IBOutlet UIView *backView1;
@property (weak) IBOutlet UIView *backView2;
@property (weak) IBOutlet UIView *backView3;
@property (weak) IBOutlet UIView *backView4;
@property (weak) IBOutlet UIView *backView5;
@property (weak) IBOutlet UIView *backView8;

@property (nonatomic, strong) MGUButton *MGUButton5;
@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGUButton Class";
    
    [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        if( [obj.subviews.firstObject isKindOfClass:[MGUButton class]] == YES ){
            obj.subviews.firstObject.layer.cornerRadius = 8.0;
        }
    }];
    
    _MGUButton5 = [MGUButton buttonWithType:UIButtonTypeSystem];
    [self.backView5 addSubview:self.MGUButton5];
    [self.MGUButton5 mgrPinCenterToSuperviewCenterWithFixSize:CGSizeMake(200.0, 50.0)];
    self.MGUButton5.buttonBackgroundColor = UIColor.redColor;
    self.MGUButton5.buttonContentsColor = UIColor.greenColor;
    [self.MGUButton5 setTitle:@"HI!" forState:UIControlStateNormal];
    self.MGUButton5.buttonTitleLabelFont  = [UIFont fontWithName:@"Futura-Medium" size:30.0];
    self.MGUButton5.breadEffect = YES;
    
    //! 수동으로 playPause, backward, forward 버튼을 만들어보자.
    UIStackView *stackView = [UIStackView new];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.layoutMargins = UIEdgeInsetsMake(10.0, 40.0, 10.0, 40.0);
    stackView.layoutMarginsRelativeArrangement = YES;
    
    [self.backView8 addSubview:stackView];
    [stackView mgrPinEdgesToSuperviewEdges];
    
    MGUButton *playPause = [MGUButton buttonWithConfiguration:[MGUButtonConfiguration standardPlayPauseConfiguration]];
    MGUButton *backward = [MGUButton buttonWithConfiguration:[MGUButtonConfiguration standardBackwardConfiguration]];
    MGUButton *forward = [MGUButton buttonWithConfiguration:[MGUButtonConfiguration standardForwardConfiguration]];
    
    [stackView addArrangedSubview:backward];
    [stackView addArrangedSubview:playPause];
    [stackView addArrangedSubview:forward];
    CGSize buttonSize = CGSizeMake(60.0, 60.0); //! 크기가 60이 적당하다.
    [backward mgrPinFixSize:buttonSize];
    [playPause mgrPinFixSize:buttonSize];
    [forward mgrPinFixSize:buttonSize];
    
    playPause.selected = NO;
    [playPause addTarget:self action:@selector(playPauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)pulseButtonClick:(MGUButton *)sender {
    [sender pulse];
}
- (IBAction)flashButtonClick:(MGUButton *)sender {
    [sender flash];
}
- (IBAction)shakeButtonClick:(MGUButton *)sender {
    [sender shake];
}

- (IBAction)glowButtonClick:(MGUButton *)sender {
    if(sender.tag == 0) {
        sender.tag = 1;
        [sender glowON];
    } else {
        sender.tag = 0;
        [sender glowOFF];
    }    
}

//! 실제로 이미지를 바꾸는 것은 오디오의 노티피케이션으로 한다.
- (void)playPauseButtonClick:(MGUButton *)sender {
    if (sender.selected == NO) {
        [sender switchAlternativeImage];
    } else {
        [sender switchMainImage];
    }
    sender.selected = !sender.selected;
}

@end
