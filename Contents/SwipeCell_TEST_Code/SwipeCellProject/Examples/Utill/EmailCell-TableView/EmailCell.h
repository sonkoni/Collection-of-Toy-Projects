//
//  EmailCell.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/04/23.
//

@import IosKit;
#import "SharedUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmailCell : MGUSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImageView;

@property (nonatomic, strong, nullable) id animator;
@property (nonatomic, assign) BOOL unread; // 디폴트 NO

@property (nonatomic, strong) IndicatorView *indicatorView;

- (void)setUnread:(BOOL)unread animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
