//
//  LogCell.h
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
@class LogCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface LogCell : MGUFlowFoldCell
- (void)setData:(LogCellModel *)data;
@end

NS_ASSUME_NONNULL_END
