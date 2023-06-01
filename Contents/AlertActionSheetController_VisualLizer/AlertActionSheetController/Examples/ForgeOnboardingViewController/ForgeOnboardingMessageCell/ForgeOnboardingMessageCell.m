//
//  ForgeOnboardingMessageCell.m
//  MGUAlertView_koni
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "ForgeOnboardingMessageCell.h"

@interface ForgeOnboardingMessageCell ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray <UILabel *>*labels;
@end

@implementation ForgeOnboardingMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messageLabel.adjustsFontSizeToFitWidth = YES;
    self.messageLabel.minimumScaleFactor = 0.1;
}

@end
