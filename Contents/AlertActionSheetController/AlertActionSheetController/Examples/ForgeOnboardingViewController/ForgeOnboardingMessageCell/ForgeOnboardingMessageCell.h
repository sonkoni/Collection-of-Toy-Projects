//
//  ForgeOnboardingMessageCell.h
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2021/07/23.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForgeOnboardingMessageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel2;
@end

NS_ASSUME_NONNULL_END
