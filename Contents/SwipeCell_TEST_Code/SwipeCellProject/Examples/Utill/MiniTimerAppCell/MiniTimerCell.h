//
//  MiniTimerCell.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
@class MiniTimerCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface MiniTimerCell : MGUSwipeCollectionViewCell
- (void)setData:(MiniTimerCellModel *)data;
@end

NS_ASSUME_NONNULL_END
