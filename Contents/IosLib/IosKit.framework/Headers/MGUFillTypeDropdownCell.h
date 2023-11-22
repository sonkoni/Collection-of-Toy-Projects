//
//  MGUFillTypeDropdownCell.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-03
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUDropdownCell.h>

NS_ASSUME_NONNULL_BEGIN


typedef NSString * MGUDropdownCellFillType NS_TYPED_EXTENSIBLE_ENUM;
static MGUDropdownCellFillType const MGUDropdownCellFillTypeEmpty  = @"none";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeHorizontal = @"horizontal";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeVerical = @"verical";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeCross = @"cross";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeDiagonalClockwise  = @"diagonalClockwise";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeDiagonalCounterClockwise  = @"diagonalCounterClockwise";
static MGUDropdownCellFillType const MGUDropdownCellFillTypeX   = @"x";

@interface MGUFillTypeDropdownCell : MGUDropdownCell

@end

NS_ASSUME_NONNULL_END

