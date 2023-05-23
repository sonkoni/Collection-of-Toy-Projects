//
//  FavCell.h
//  MGUFlowView
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//


@import IosKit;
@class FavCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface FavCell : MGUFlowCell
- (void)setData:(FavCellModel *)data;
@end

NS_ASSUME_NONNULL_END

