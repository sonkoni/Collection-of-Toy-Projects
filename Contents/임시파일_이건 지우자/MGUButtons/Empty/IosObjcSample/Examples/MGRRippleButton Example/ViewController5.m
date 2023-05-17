//
//  ViewController.m
//  ZFRippleButtonDemo
//
//  Created by Kwan Hyun Son on 01/08/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "ViewController5.h"
@import IosKit;

@interface ViewController5 ()
@property (weak) IBOutlet MGURippleButton *flatClearButton1;
@property (weak) IBOutlet MGURippleButton *flatClearButton2;

@property (weak) IBOutlet MGURippleButton *shadowButton1;
@property (weak) IBOutlet MGURippleButton *shadowButton2;
@property (weak) IBOutlet MGURippleButton *shadowAnd2LineButton;

@property (nonatomic) UIColor *clearBaseColor;
@property (nonatomic) UIColor *noneClearBaseColor;
@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MGURippleButton";
    //! background가 clear일 때, 사용하는 색
    self.clearBaseColor     = [UIColor colorWithWhite:0.3 alpha:0.12f];
    //! background가 clear가 아닐 때, 사용하는 색
    self.noneClearBaseColor = [UIColor colorWithWhite:0.1 alpha:0.16f];
    
    [self setUpFlatClearButton1];
    [self setUpFlatClearButton2];
    [self setUpShadowButton1];
    [self setUpShadowButton2];
    [self setUpShadowAnd2LineButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//! xib 에서 UIButtonTypeSystem으로 만들었다.
//! 눌렀을 때, 글자가 하이라이팅 되는 효과가 존재한다.
//! UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
//! textColor를 이용하여, rippleView, rippleBackgroudView의 색을 만들어보았다. (일명 스마트 칼라.)
- (void)setUpFlatClearButton1 {
    
    CGColorRef clearBaseColor = self.clearBaseColor.CGColor;
    
    self.flatClearButton1.backgroundColor = UIColor.clearColor;
    [self.flatClearButton1 addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.flatClearButton1 setTitle:@"Flat Style, Clear Color" forState:UIControlStateNormal];
    
    [self.flatClearButton1 setTitleColor:[UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1.0]
                               forState:UIControlStateNormal];
    
    self.flatClearButton1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
    self.flatClearButton1.rippleShadowEnabled = NO;  // <- Flat 스타일로 나타나게 하려면, 그림자를 없애야겠지.
    self.flatClearButton1.trackTouchLocation  = YES; // 손가락 따라가는게 더 멋져.
    
    //! 텍스트 색깔로 부터 색을 따오는 논리이다. <- 스마트 칼라
    //! 둘다 색이 같다고 하더라도, 색이 겹치는 부분(ripple)은 더 진하게 나온다!
    self.flatClearButton1.rippleColor = [self.flatClearButton1.titleLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(clearBaseColor)];
    self.flatClearButton1.rippleBackgroundColor = [self.flatClearButton1.titleLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(clearBaseColor)];
}

//! xib 에서 UIButtonTypeCustom으로 만들었다.
//! 눌렀을 때, 글자가 하이라이팅 되는 효과가 제거된다.
//! UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
- (void)setUpFlatClearButton2 {
    
    self.flatClearButton2.backgroundColor = UIColor.clearColor;
    [self.flatClearButton2 addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.flatClearButton2 setTitle:@"Flat Style, Clear Color" forState:UIControlStateNormal];
    
    [self.flatClearButton2 setTitleColor:[UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1.0]
                                forState:UIControlStateNormal];
    
    self.flatClearButton2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
    self.flatClearButton2.rippleShadowEnabled = NO;  // <- Flat 스타일로 나타나게 하려면, 그림자를 없애야겠지.
    self.flatClearButton2.trackTouchLocation  = YES; // 손가락 따라가는게 더 멋져.
    
    //! 둘다 색이 같다고 하더라도, 색이 겹치는 부분(ripple)은 더 진하게 나온다!
    self.flatClearButton2.rippleColor           = self.clearBaseColor;
    self.flatClearButton2.rippleBackgroundColor = self.clearBaseColor;
    
}

- (void)setUpShadowButton1 {
    
    CGColorRef noneClearBaseColor = self.noneClearBaseColor.CGColor;
    
    self.shadowButton1.backgroundColor = [UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1];
    [self.shadowButton1 addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.shadowButton1 setTitle:@"Shadow Style" forState:UIControlStateNormal];
    [self.shadowButton1 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.shadowButton1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
    
    //self.shadowButton1.rippleShadowEnabled = YES; 디폴트    
    self.shadowButton1.trackTouchLocation  = YES; // 손가락 따라가는게 더 멋져.
    
    //! 텍스트 색깔로 부터 색을 따오는 논리이다. <- 스마트 칼라
    //! BFPaperButton 에서는 버튼의 배경색을 지정하면, rippleBackgroundColor를 clear로 했다.
    self.shadowButton1.rippleColor = [self.shadowButton1.titleLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(noneClearBaseColor)];
    self.shadowButton1.rippleBackgroundColor = UIColor.clearColor;
}


- (void)setUpShadowButton2 {
    
    self.shadowButton2.backgroundColor = [UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1];
    [self.shadowButton2 addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.shadowButton2 setTitle:@"Shadow Style" forState:UIControlStateNormal];
    [self.shadowButton2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.shadowButton2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f];
    
    //self.shadowButton1.rippleShadowEnabled = YES; 디폴트
    self.shadowButton2.trackTouchLocation  = YES; // 손가락 따라가는게 더 멋져.
    //! 텍스트 색깔로 부터 색을 따오는 논리이다.
    //! BFPaperButton 에서는 버튼의 배경색을 지정하면, rippleBackgroundColor를 clear로 했다.
    self.shadowButton2.rippleColor           = self.noneClearBaseColor;
    self.shadowButton2.rippleBackgroundColor = UIColor.clearColor;
}


- (void)setUpShadowAnd2LineButton {
    CGColorRef noneClearBaseColor = self.noneClearBaseColor.CGColor;
    
    self.shadowAnd2LineButton.backgroundColor = [UIColor colorWithRed:33.f/255.f green:150.f/255.f blue:243.f/255.f alpha:1];
    [self.shadowAnd2LineButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.shadowAnd2LineButton setTitle:@"Shadow Style, 2 Line Button!!!" forState:UIControlStateNormal];
    [self.shadowAnd2LineButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.shadowAnd2LineButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]; //[UIFont systemFontOfSize:10.f];
    self.shadowAnd2LineButton.titleLabel.numberOfLines = 0;
    
    //self.shadowButton1.rippleShadowEnabled = YES; 디폴트
    self.shadowAnd2LineButton.trackTouchLocation  = YES; // 손가락 따라가는게 더 멋져.
    //! 텍스트 색깔로 부터 색을 따오는 논리이다.
    //! BFPaperButton 에서는 버튼의 배경색을 지정하면, rippleBackgroundColor를 clear로 했다.
    self.shadowAnd2LineButton.rippleColor = [self.shadowAnd2LineButton.titleLabel.textColor colorWithAlphaComponent:CGColorGetAlpha(noneClearBaseColor)];
    self.shadowAnd2LineButton.rippleBackgroundColor = UIColor.clearColor;
}


- (void)buttonWasPressed:(MGURippleButton *)sender {
}

@end
