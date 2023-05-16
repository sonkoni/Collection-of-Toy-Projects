//
//  UIColor+MGERandom.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIColor+Random.h"
#import <BaseKit/BaseKit.h>

@implementation UIColor (Random)

+ (UIColor *)mgrRandomColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(arc4random() % 256) / 255.0
                           green:(arc4random() % 256) / 255.0
                            blue:(arc4random() % 256) / 255.0
                           alpha:MAX(MIN(alpha, 1.0), 0.0)];
}

+ (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 {
    __block CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    CGFloat progress = MGRRandomFloatRange(0.0, 1.0);

    UIColor *(^dynamicProvider)(UITraitCollection * _Nullable) =
    ^UIColor *(UITraitCollection * _Nullable traitCollection){
        [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        CGFloat r = r1 + (r2 - r1) * progress;
        CGFloat g = g1 + (g2 - g1) * progress;
        CGFloat b = b1 + (b2 - b1) * progress;
        CGFloat a = a1 + (a2 - a1) * progress;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    };
    
    if (@available(iOS 13, *)) {
        return [UIColor colorWithDynamicProvider:dynamicProvider];
    } else {
        return dynamicProvider(NULL);
    }
}

+ (UIColor *)mgrRandomHSBColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 {
    __block CGFloat h1, s1, b1, a1, h2, s2, b2, a2;
    CGFloat progress = MGRRandomFloatRange(0.0, 1.0);

    UIColor *(^dynamicProvider)(UITraitCollection * _Nullable) =
    ^UIColor *(UITraitCollection * _Nullable traitCollection){
        [color1 getHue:&h1 saturation:&s1 brightness:&b1 alpha:&a1];
        [color2 getHue:&h2 saturation:&s2 brightness:&b2 alpha:&a2];
        CGFloat h = h1 + (h2 - h1) * progress;
        CGFloat s = s1 + (s2 - s1) * progress;
        CGFloat b = b1 + (b2 - b1) * progress;
        CGFloat a = a1 + (a2 - a1) * progress;
        return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
    };
    
    if (@available(iOS 13, *)) {
        return [UIColor colorWithDynamicProvider:dynamicProvider];
    } else {
        return dynamicProvider(NULL);
    }
}

//! focus는 1, 2, 3 단계만 존재한다.
+ (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 foucus:(NSInteger)foucus {
    __block CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    CGFloat progress = MGRRandomFocus3(foucus);
    
    UIColor *(^dynamicProvider)(UITraitCollection * _Nullable) =
    ^UIColor *(UITraitCollection * _Nullable traitCollection){
        [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
        CGFloat r = r1 + (r2 - r1) * progress;
        CGFloat g = g1 + (g2 - g1) * progress;
        CGFloat b = b1 + (b2 - b1) * progress;
        CGFloat a = a1 + (a2 - a1) * progress;
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    };
    
    if (@available(iOS 13, *)) {
        return [UIColor colorWithDynamicProvider:dynamicProvider];
    } else {
        return dynamicProvider(NULL);
    }
}

@end

/**
// #import "MGEGeometryHelper.h"
// - whiteColor, - blackColor, - colorWithWhite:alpha: 에서는 components 의 갯수가 2개이다.
 + (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 {
     const CGFloat *color1Components = CGColorGetComponents(color1.CGColor);
     const CGFloat *color2Components = CGColorGetComponents(color2.CGColor);
     
     CGFloat color1Alpha, color2Alpha, r, g, b, a;
     color1Alpha = CGColorGetAlpha(color1.CGColor);
     color2Alpha = CGColorGetAlpha(color2.CGColor);
     
     CGFloat progress = MGRRandomFloatRange(0.0, 1.0);
     
     r = MGELerpDouble(progress, color1Components[0], color2Components[0]);
     
     CGFloat color1Green = color1Components[1];
     CGFloat color1Blue = color1Components[2];
     CGFloat color2Green = color2Components[1];
     CGFloat color2Blue = color2Components[2];
     if (CGColorGetNumberOfComponents(color1.CGColor) == 2) {
         color1Green = color1Components[0];
         color1Blue  = color1Components[0];
     }
     if (CGColorGetNumberOfComponents(color2.CGColor) == 2) {
         color2Green = color2Components[0];
         color2Blue  = color2Components[0];
     }
     g = MGELerpDouble(progress, color1Green, color2Green);
     b = MGELerpDouble(progress, color1Blue, color2Blue);
     
     a = MGELerpDouble(progress, color1Alpha, color2Alpha);
     
     CGColorRef color = CGColorCreateSRGB(r, g, b, a);
     UIColor *returnColor = [UIColor colorWithCGColor:color];
     CGColorRelease(color);

     return returnColor;
 }

 //! focus는 1, 2, 3 단계만 존재한다.
 + (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 foucus:(NSInteger)foucus {
     const CGFloat *color1Components = CGColorGetComponents(color1.CGColor);
     const CGFloat *color2Components = CGColorGetComponents(color2.CGColor);
     
     CGFloat color1Alpha, color2Alpha, r, g, b, a;
     color1Alpha = CGColorGetAlpha(color1.CGColor);
     color2Alpha = CGColorGetAlpha(color2.CGColor);
     
 //    CGFloat progress = MGRRandomFloatRange(0.0, 1.0);
     CGFloat progress = MGRRandomFocus3(foucus);
     
     r = MGELerpDouble(progress, color1Components[0], color2Components[0]);
     
     CGFloat color1Green = color1Components[1];
     CGFloat color1Blue = color1Components[2];
     CGFloat color2Green = color2Components[1];
     CGFloat color2Blue = color2Components[2];
     if (CGColorGetNumberOfComponents(color1.CGColor) == 2) {
         color1Green = color1Components[0];
         color1Blue  = color1Components[0];
     }
     if (CGColorGetNumberOfComponents(color2.CGColor) == 2) {
         color2Green = color2Components[0];
         color2Blue  = color2Components[0];
     }
     g = MGELerpDouble(progress, color1Green, color2Green);
     b = MGELerpDouble(progress, color1Blue, color2Blue);
     
     a = MGELerpDouble(progress, color1Alpha, color2Alpha);
     
     CGColorRef color = CGColorCreateSRGB(r, g, b, a);
     UIColor *returnColor = [UIColor colorWithCGColor:color];
     CGColorRelease(color);

     return returnColor;
 }

 **/
