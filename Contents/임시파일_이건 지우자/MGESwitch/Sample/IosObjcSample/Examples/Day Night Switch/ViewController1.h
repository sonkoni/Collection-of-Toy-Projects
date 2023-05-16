//
//  ViewController1.h
//  MGRButtons
//
//  Created by Kwan Hyun Son on 13/07/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController1 : UIViewController

- (IBAction)onWithAnimated:(id)sender;
- (IBAction)offWithAnimated:(id)sender;

- (IBAction)onWithNoAnimated:(id)sender;
- (IBAction)offWithNoAnimated:(id)sender;

@end

NS_ASSUME_NONNULL_END
