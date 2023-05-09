//
//  ViewController.m
//  TESTTEST
//
//  Created by Kwan Hyun Son on 15/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonPush:(UIButton *)sender {
    [self.littleView removeFromSuperview];
    [self.testView addSubview:self.littleView];
    
    self.littleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.littleView.topAnchor constraintEqualToAnchor:self.testView.topAnchor].active = YES;
    [self.littleView.leadingAnchor constraintEqualToAnchor:self.testView.leadingAnchor].active = YES;
    
    UIViewPropertyAnimator * animator = [[UIViewPropertyAnimator alloc] initWithDuration:1.0
                                                                            dampingRatio:0.4
                                                                              animations:^{
        [self.testView layoutIfNeeded];
    }];

    [animator startAnimation];
}

@end
