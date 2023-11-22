//
//  MGUDropdownCell.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-09-05
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Standard Cell
@interface MGUDropdownCell : UITableViewCell

@property (nonatomic, strong) UIView *contentContainer;
@property (nonatomic, assign, getter=isCellMode) BOOL cellMode; // 디폴트 YES
@property (nonatomic, strong, nullable) id <NSObject>dropdownData;

@end

NS_ASSUME_NONNULL_END
