//
//  MGUDropSegCell.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-16
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Standard Cell
@interface MGUDropSegCell : UITableViewCell

@property (nonatomic, strong, nullable) id <NSObject>dropdownData;

@end

NS_ASSUME_NONNULL_END

