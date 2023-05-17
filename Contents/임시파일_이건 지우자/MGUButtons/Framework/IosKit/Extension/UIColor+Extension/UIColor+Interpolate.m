//
//  UIColor+MGRInterpolate.m
//  HashTEST
//
//  Created by Kwan Hyun Son on 2020/10/13.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIColor+Interpolate.h"

@implementation UIColor (Interpolate)

+ (UIColor *)mgrInterpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)fraction {
    
    fraction = MIN(1.0, MAX(0.0, fraction));
    
    __block CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    UIColor *(^dynamicProvider)(UITraitCollection * _Nullable) =
    ^UIColor *(UITraitCollection * _Nullable traitCollection){
        [start getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [end getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        CGFloat r = r1 + (r2 - r1) * fraction;
        CGFloat g = g1 + (g2 - g1) * fraction;
        CGFloat b = b1 + (b2 - b1) * fraction;
        CGFloat a = a1 + (a2 - a1) * fraction;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    };
    
    if (@available(iOS 13, *)) {
        return [UIColor colorWithDynamicProvider:dynamicProvider];
    } else {
        return dynamicProvider(NULL);
    }
}

+ (UIColor *)mgrInterpolateHSVColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)fraction {

    fraction = MIN(1.0, MAX(0.0, fraction));
    
    __block CGFloat h1, s1, v1, a1, h2, s2, v2, a2;
    UIColor *(^dynamicProvider)(UITraitCollection * _Nullable) =
    ^UIColor *(UITraitCollection * _Nullable traitCollection){
        [start getHue:&h1 saturation:&s1 brightness:&v1 alpha:&a1];
        [end getHue:&h2 saturation:&s2 brightness:&v2 alpha:&a2];
        CGFloat h = h1 + (h2 - h1) * fraction;
        CGFloat s = s1 + (s2 - s1) * fraction;
        CGFloat v = v1 + (v2 - v1) * fraction;
        CGFloat a = a1 + (a2 - a1) * fraction;
        return [UIColor colorWithHue:h saturation:s brightness:v alpha:a];
    };
    
    if (@available(iOS 13, *)) {
        return [UIColor colorWithDynamicProvider:dynamicProvider];
    } else {
        return dynamicProvider(NULL);
    }
}

@end


/***
// static CGFloat * MGRCGColorGetComponents(CGColorRef color);
 
+ (UIColor *)interpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)fraction {
    
    fraction = MIN(1.0, MAX(0.0, fraction));
    CGFloat *c1 = MGRCGColorGetComponents(start.CGColor);
    CGFloat *c2 = MGRCGColorGetComponents(end.CGColor);

    CGFloat r = c1[0] + (c2[0] - c1[0]) * fraction;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * fraction;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * fraction;
    CGFloat a = c1[3] + (c2[3] - c1[3]) * fraction;
    
    UIColor *result = [UIColor colorWithRed:r green:g blue:b alpha:a];
    free(c1);
    free(c2);
    return result;
    //
//     CGFloat a = ... 라인부터는 아래 주석의 식으로 교체해도 가능하다.
//    CGFloat a =
//    CGColorGetAlpha(start.CGColor) + (CGColorGetAlpha(end.CGColor) - CGColorGetAlpha(start.CGColor)) * fraction;
//
//    CGColorRef color = CGColorCreateSRGB(r, g, b, a);
//    UIColor *returnColor = [UIColor colorWithCGColor:color];
//    CGColorRelease(color);
//    return returnColor;
}

//! 사용 후 free가 필요하다.
static CGFloat * MGRCGColorGetComponents(CGColorRef color) {
    switch (CGColorGetNumberOfComponents(color)) {
        case 2:  {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            const CGFloat *c = CGColorGetComponents(color);
            colors[0] = c[0];
            colors[1] = c[0];
            colors[2] = c[0];
            colors[3] = c[1];
            return colors;
            break;
        }
        case 4:  {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            const CGFloat *c = CGColorGetComponents(color);
            colors[0] = c[0];
            colors[1] = c[1];
            colors[2] = c[2];
            colors[3] = c[3];
            return colors;
            break;
        }
        default: {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            colors[0] = 0.0;
            colors[1] = 0.0;
            colors[2] = 0.0;
            colors[3] = 1.0;
            return colors;
            break;
        }
    }
}
*/
