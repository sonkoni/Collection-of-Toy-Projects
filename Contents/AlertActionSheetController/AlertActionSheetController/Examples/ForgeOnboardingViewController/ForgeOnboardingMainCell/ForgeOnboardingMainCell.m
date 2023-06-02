//
//  ForgeOnboardingCell.m
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "ForgeOnboardingMainCell.h"

@interface ForgeOnboardingMainCell ()
@end

@implementation ForgeOnboardingMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.mainContentContainer.layer.cornerRadius = 15.0;
    self.mainContentContainer.layer.masksToBounds = YES;
    self.mainContentContainer.clipsToBounds = YES;
}

@end
