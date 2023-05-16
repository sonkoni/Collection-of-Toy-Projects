//
//  UIImage+Rotation.h
//
//  Created by Kwan Hyun Son on 2021/09/06.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Rotation)

//! clockWise
- (UIImage *)mgrImageRotatedByRadians:(CGFloat)radians;

- (UIImage *)mgrImageWithOrientation:(UIImageOrientation)imageOrientation;

@end

NS_ASSUME_NONNULL_END
