//
//  MGRTableViewCell.h
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//
//  - 
//
//

#import <UIKit/UIKit.h>
#import "MGRTableViewCellIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRTableViewCell1 : UITableViewCell

@property (nonatomic, assign) MGRTableViewCellIdentifier identifier;

@property (weak) IBOutlet UILabel *mainLabel;
@property (weak) IBOutlet UILabel *thumbLabel;
@property (weak) IBOutlet UILabel *trackLabel;
@property (weak) IBOutlet UIView  *switchContianerView;

@end

NS_ASSUME_NONNULL_END
