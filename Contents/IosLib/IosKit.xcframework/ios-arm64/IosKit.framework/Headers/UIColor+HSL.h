//
//  UIColor+HSL.h
//  LuminanceOfRGBTEST
//
//  Created by Kwan Hyun Son on 2020/10/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//! HSL : Hue(색상), 채도(Saturation), 명도(Lightness) VS HSB과 뜻은 인문학적인 뜻은 같으나, Hue 값만 동일하다.
//! 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100  H는 360 === 0 이다. iOS 에서는 모두 0.0 ~ 1.0으로 해석한다.
//! https://www.rapidtables.com/convert/color/hsl-to-rgb.html

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HSL)

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 대입하겠다. 단, 0.0 <= 알파 <= 1.0
+ (UIColor *)mgrColorWithHue:(NSInteger)hue
                  saturation:(NSInteger)saturation
                   lightness:(NSInteger)lightness
                       alpha:(CGFloat)alpha;

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 뽑아내겠다. 단, 0.0 <= 알파 <= 1.0
- (BOOL)mgrGetHue:(NSInteger * _Nullable)hue
       saturation:(NSInteger * _Nullable)saturation
        lightness:(NSInteger * _Nullable)lightness
            alpha:(CGFloat * _Nullable)alpha;

@end

NS_ASSUME_NONNULL_END
