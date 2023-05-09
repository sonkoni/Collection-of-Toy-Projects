//
//  ViewController.h
//  TESTTEST
//
//  Created by Kwan Hyun Son on 15/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

@property (weak) IBOutlet UIView *testView;

@property (weak) IBOutlet UIView *littleView;
@property (weak) IBOutlet NSLayoutConstraint *cenX;
@property (weak) IBOutlet NSLayoutConstraint *cenY;
@property (weak) IBOutlet NSLayoutConstraint *width;
@property (weak) IBOutlet NSLayoutConstraint *height;


- (IBAction)buttonPush:(UIButton *)sender;



@end

NS_ASSUME_NONNULL_END
