//
//  MGRViewController.h
//  MGURulerView
//
//  Created by Kwan Hyun Son on 16/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@import IosKit;

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerA : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) MGURulerViewConfig *rulerViewConfig;
@property (nonatomic, assign) MGURulerViewIndicatorType indicatorType;

@property (weak) IBOutlet UILabel *label;
- (IBAction)leftClick:(UIButton *)sender;
- (IBAction)rightClick:(UIButton *)sender;
- (IBAction)longLeftClick:(UIButton *)sender;
- (IBAction)longRightClick:(UIButton *)sender;


@property (weak) IBOutlet UITextField *gotoTextField;
- (IBAction)gotoClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
