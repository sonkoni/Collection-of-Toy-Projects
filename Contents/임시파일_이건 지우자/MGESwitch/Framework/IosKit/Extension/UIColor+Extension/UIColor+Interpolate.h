//
//  UIColor+MGRInterpolate.h
//  HashTEST
//
//  Created by Kwan Hyun Son on 2020/10/13.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Interpolate)
//! fraction은 (0.0 ... 1.0) 의 범위를 갖는다. 0.0이면 start color 이며, 1.0 이면 end color이다.
+ (UIColor *)mgrInterpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)fraction;
+ (UIColor *)mgrInterpolateHSVColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)fraction;
@end

NS_ASSUME_NONNULL_END
