//
//  MGUShapeView.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-01-16
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUShapeView : UIView
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer; // @dynamic
@end

NS_ASSUME_NONNULL_END
