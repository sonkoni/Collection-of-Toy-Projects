//
//  NSColor+Interpolate.h
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (Interpolate)
//! fraction은 (0.0 ... 1.0) 의 범위를 갖는다. 0.0이면 start color 이며, 1.0 이면 end color이다.
+ (NSColor *)mgrInterpolateRGBColorFrom:(NSColor *)start to:(NSColor *)end withFraction:(float)fraction;
+ (NSColor *)mgrInterpolateHSVColorFrom:(NSColor *)start to:(NSColor *)end withFraction:(float)fraction;
@end

NS_ASSUME_NONNULL_END
