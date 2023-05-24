//
//  MMTFavCell.h
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
@class MMTFavCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface MMTFavCell : MGUSwipeCollectionViewCell
- (void)setData:(MMTFavCellModel *)data;
@end

NS_ASSUME_NONNULL_END
