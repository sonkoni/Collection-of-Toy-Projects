//
//  MGRTableViewCell3.h
//  MGUMaterialSwitch
//
//  Created by Kwan Hyun Son on 25/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRTableViewCellIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRTableViewCell3 : UITableViewCell

@property (nonatomic, assign) MGRTableViewCellIdentifier identifier;

@property (weak) IBOutlet UIView  *leftSwitchContianerView;
@property (weak) IBOutlet UIView  *centerSwitchContianerView;
@property (weak) IBOutlet UIView  *rightSwitchContianerView;

@end

NS_ASSUME_NONNULL_END
