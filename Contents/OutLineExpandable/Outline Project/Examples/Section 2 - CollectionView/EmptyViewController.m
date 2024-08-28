//
//  EmptyViewController.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/24.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "EmptyViewController.h"
#import "MGROutlineIndicatorLineView.h"

@interface EmptyViewController ()

@end

@implementation EmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MGROutlineIndicatorLineView *lineView = [MGROutlineIndicatorLineView new];
    lineView.frame = CGRectMake(50.0, 350.0, 300, 50);
//    lineView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [self.view addSubview:lineView];
}

@end
