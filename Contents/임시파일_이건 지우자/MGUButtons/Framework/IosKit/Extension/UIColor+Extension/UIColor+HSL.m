//
//  UIColor+HSL.m
//  LuminanceOfRGBTEST
//
//  Created by Kwan Hyun Son on 2020/10/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIColor+HSL.h"

@implementation UIColor (HSL)

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 대입하겠다. 단, 0.0 <= 알파 <= 1.0
+ (UIColor *)mgrColorWithHue:(NSInteger)hue
                  saturation:(NSInteger)saturation
                   lightness:(NSInteger)lightness
                       alpha:(CGFloat)alpha {
    hue = MAX(MIN(hue, 359), 0);
    saturation = MAX(MIN(saturation, 100), 0);
    lightness = MAX(MIN(lightness, 100), 0);
    
    CGFloat C = (1.0 - ABS(2.0 * (lightness / 100.0f) - 1.0)) * (saturation / 100.0f);
    CGFloat X = C * (1.0 - ABS(fmod(hue/60.0, 2.0) - 1.0));
    CGFloat m = (lightness / 100.0f) - C/2.0;
    
    CGFloat _R, _G, _B;
    if (hue >= 0 && hue < 60) {
        _R = C;
        _G = X;
        _B = 0.0;
    } else if (hue < 120) {
        _R = X;
        _G = C;
        _B = 0.0;
    } else if (hue < 180) {
        _R = 0.0;
        _G = C;
        _B = X;
    } else if (hue < 240) {
        _R = 0.0;
        _G = X;
        _B = C;
    } else if (hue < 300) {
        _R = X;
        _G = 0.0;
        _B = C;
    } else {
        _R = C;
        _G = 0.0;
        _B = X;
    }
    
    return [UIColor colorWithRed:(_R + m) green:(_G + m) blue:(_B + m) alpha:alpha];
}

- (BOOL)mgrGetHue:(NSInteger *)hue
       saturation:(NSInteger *)saturation
        lightness:(NSInteger *)lightness
            alpha:(CGFloat *)alpha {
    
    CGFloat RED, GREEN, BLUE, ALPHA;
    if ([self getRed:&RED green:&GREEN blue:&BLUE alpha:&ALPHA] == NO) {
        return NO;
    }
    
    if (alpha != NULL) {
        *alpha = ALPHA;
    }
    
    CGFloat HUE, SAT, LIG;
    if (hue != NULL) {
        [self getHue:&HUE saturation:NULL brightness:NULL alpha:NULL];
        HUE = MIN(MAX(HUE * 360.0, 0.0), 359.0);
        *hue = (NSInteger)(round(HUE));
    }
    
    CGFloat CMax = MAX(RED, MAX(GREEN, BLUE));
    CGFloat CMIN = MIN(RED, MIN(GREEN, BLUE));
    CGFloat Delta = CMax - CMIN;
    
    LIG = (CMax + CMIN) / 2.0;
    if (Delta == 0.0) {
        SAT = 0.0;
    } else {
        SAT = (Delta) / (1 - ABS(2*LIG - 1));
    }
    
    if (saturation != NULL) {
        SAT = MIN(MAX(SAT * 100.0, 0.0), 100.0);
        *saturation = (NSInteger)(round(SAT));
    }
    
    if (lightness != NULL) {
        LIG = MIN(MAX(LIG * 100.0, 0.0), 100.0);
        *lightness = (NSInteger)(round(LIG));
    }
    
    return YES;
}

@end
