//
//  MGUSimpleLineView.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-02
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NS_OPTIONS
typedef NS_OPTIONS(NSUInteger, MGUSimpleLineDirection) {
    MGUSimpleLineDirectionNone                     = 0,       // 0000 0000
    MGUSimpleLineDirectionHorizontal               = 1 << 0,  // 0000 0001
    MGUSimpleLineDirectionVertical                 = 1 << 1,  // 0000 0010
    MGUSimpleLineDirectionDiagonalClockwise        = 1 << 2,  // 0000 0100
    MGUSimpleLineDirectionDiagonalCounterClockwise = 1 << 3,  // 0000 1000
    MGUSimpleLineDirectionCross = MGUSimpleLineDirectionHorizontal | MGUSimpleLineDirectionVertical,
    MGUSimpleLineDirectionX = MGUSimpleLineDirectionDiagonalClockwise | MGUSimpleLineDirectionDiagonalCounterClockwise,
    MGUSimpleLineDirectionAll = MGUSimpleLineDirectionCross | MGUSimpleLineDirectionX
};

@interface MGUSimpleLineView : UIView

@property (nonatomic, assign) MGUSimpleLineDirection gridDirection;
@property (nonatomic, assign) CGFloat lineSpacing;
@end

NS_ASSUME_NONNULL_END
