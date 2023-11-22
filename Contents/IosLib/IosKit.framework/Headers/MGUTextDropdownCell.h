//
//  MGUTextDropdownCell.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-09-05
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUDropdownCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUTextDropdownCell : MGUDropdownCell
@property (nonatomic, assign) NSTextAlignment textAlignment; // @dynamic
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@end

NS_ASSUME_NONNULL_END
