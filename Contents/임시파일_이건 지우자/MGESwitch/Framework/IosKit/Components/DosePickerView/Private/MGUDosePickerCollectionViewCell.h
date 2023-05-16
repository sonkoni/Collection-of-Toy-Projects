//
//  MGRDoseCollectionViewCell.h
//  PickerView
//
//  Created by Kwan Hyun Son on 11/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUDosePickerCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *highlightedFont;

@property (nonatomic, strong) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
