//
//  UIColor+HSB.m
//  MGRRegularPolygon
//
//  Created by Kwan Hyun Son on 17/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIColor+HSB.h"

@implementation UIColor (HSB)

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 대입하겠다. 단, 0.0 <= 알파 <= 1.0
+ (UIColor *)mgrColorWithHue:(NSInteger)hue
                  saturation:(NSInteger)saturation
                  brightness:(NSInteger)brightness
                       alpha:(CGFloat)alpha {
    CGFloat HUE, SAT, BRI;
    HUE = (CGFloat)(MAX(MIN(hue, 360.0), 0.0));
    SAT = (CGFloat)(MAX(MIN(saturation, 100.0), 0.0));
    BRI = (CGFloat)(MAX(MIN(brightness, 100.0), 0.0));
    HUE = fmod(HUE / 360.0, 1.0); // 1.0은 0.0과 동일하다.
    SAT = SAT / 100.0;
    BRI = BRI / 100.0;
    
    return [UIColor colorWithHue:HUE saturation:SAT brightness:BRI alpha:alpha];
}

- (BOOL)mgrGetHue:(NSInteger * _Nullable)hue
       saturation:(NSInteger * _Nullable)saturation
       brightness:(NSInteger * _Nullable)brightness
            alpha:(CGFloat * _Nullable)alpha {
    
    CGFloat HUE, SAT, BRI, ALP;
    if ([self getHue:&HUE saturation:&SAT brightness:&BRI alpha:&ALP] == NO) {
        return NO;
    }
    
    if (hue != NULL) {
        HUE = MIN(MAX(HUE * 360.0, 0.0), 360.0);
        HUE = (HUE == 360.0) ? 0.0 : HUE;
        *hue = (NSInteger)(round(HUE));
    }
    
    if (saturation != NULL) {
        SAT = MIN(MAX(SAT * 100.0, 0.0), 100.0);
        *saturation = (NSInteger)(round(SAT));
    }
    
    if (brightness != NULL) {
        BRI = MIN(MAX(BRI * 100.0, 0.0), 100.0);
        *brightness = (NSInteger)(round(BRI));
    }
    
    if (alpha != NULL) {
        *alpha = ALP;
    }
    
    return YES;
}

- (NSArray <UIColor *>*)mgrColorsNearMainColorWithRange:(NSArray <NSNumber *>*)range {
    CGFloat hueRange        = range[0].doubleValue;
    CGFloat saturationRange = range[1].doubleValue;
    CGFloat brightnessRange = range[2].doubleValue;
    hueRange        = MIN(MAX(hueRange, 0.0), 1.0);
    saturationRange = MIN(MAX(saturationRange, 0.0), 1.0);
    brightnessRange = MIN(MAX(brightnessRange, 0.0), 1.0);
    
    UIColor *mainColor = self.copy;
    
    UIColor *MAXColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        CGFloat hue, saturation, brightness, alpha;
        [mainColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        CGFloat MAXHue        = hue + hueRange;
        CGFloat MAXSaturation = saturation + saturationRange;
        CGFloat MAXBrightness = brightness + brightnessRange;
        MAXHue        = MIN(MAX(MAXHue, 0.0), 1.0);
        MAXSaturation = MIN(MAX(MAXSaturation, 0.0), 1.0);
        MAXBrightness = MIN(MAX(MAXBrightness, 0.0), 1.0);
        return [UIColor colorWithHue:MAXHue saturation:MAXSaturation brightness:MAXBrightness alpha:alpha];
    }];
    
    UIColor *MINColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        CGFloat hue, saturation, brightness, alpha;
        [mainColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        CGFloat MINHue        = hue - hueRange;
        CGFloat MINSaturation = saturation - saturationRange;
        CGFloat MINBrightness = brightness - brightnessRange;
        MINHue        = MIN(MAX(MINHue, 0.0), 1.0);
        MINSaturation = MIN(MAX(MINSaturation, 0.0), 1.0);
        MINBrightness = MIN(MAX(MINBrightness, 0.0), 1.0);
        return [UIColor colorWithHue:MINHue saturation:MINSaturation brightness:MINBrightness alpha:alpha];
    }];
    
    return @[MINColor, MAXColor];
}

- (UIColor *)MGETransformedColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    CGFloat h = 0.0;
    CGFloat s = 0.0;
    CGFloat b = 0.0;
    CGFloat a = 0.0;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    
    s = MAX(MIN(s * saturation, 1.0), 0.0);
    b = MAX(MIN(b * brightness, 1.0), 0.0);
    
    return [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
}

@end
