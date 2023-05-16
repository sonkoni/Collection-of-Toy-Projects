//
//  MGRXXX.h
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

CGColorRef MGECGColorCreateInterpolate(CGColorRef startColor, CGColorRef endColor, CGFloat fraction);

NS_ASSUME_NONNULL_END
