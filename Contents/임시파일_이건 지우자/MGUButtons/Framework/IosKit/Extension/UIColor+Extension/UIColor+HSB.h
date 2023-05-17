//
//  UIColor+HSB.h
//  MGRRegularPolygon
//
//  Created by Kwan Hyun Son on 17/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//! HSB : Hue(색상), 채도(Saturation), 밝기(Brightness) VS HSL과 뜻은 인문학적인 뜻은 같으나, Hue 값만 동일하다.
//! 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100  H는 360 === 0 이다. iOS 에서는 모두 0.0 ~ 1.0으로 해석한다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HSB)

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 대입하겠다. 단, 0.0 <= 알파 <= 1.0
+ (UIColor *)mgrColorWithHue:(NSInteger)hue
                  saturation:(NSInteger)saturation
                  brightness:(NSInteger)brightness
                       alpha:(CGFloat)alpha;

//! 나는 정수로 0 <= H < 360, 0 <= S <= 100, 0 <= B <= 100 로 뽑아내겠다. 단, 0.0 <= 알파 <= 1.0
- (BOOL)mgrGetHue:(NSInteger * _Nullable)hue
       saturation:(NSInteger * _Nullable)saturation
       brightness:(NSInteger * _Nullable)brightness
            alpha:(CGFloat * _Nullable)alpha;

/**
* 자신(self)의 색깔에서 H, S, B 근방의 색 2개를 만들어서 반환한다.
* @param range  H, S, B의 범의(반경)를 담은 배열(요소 갯수 3개)이다. CGFloat을 싸고 있는 NSNumber객체가 들어있다.
* @return 첫 번째 요소는 자신의 색에서 가장 낮은 범위에 있는 색(min color), 두 번째 요소는 max color
* @discussion 인수로 들어오는 배열요소는 0.0 ~ 1.0 범위에 존재하는 CGFloat을 싸고 있는 NSNumer 객체이다.
* @code
 NSArray <UIColor *>*minMaxColors = [self.mainColor mgrColorsNearMainColorWithRange:@[@(0.1), @(0.07), @(0.03)]];
 @endcode
*/
- (NSArray <UIColor *>*)mgrColorsNearMainColorWithRange:(NSArray <NSNumber *>*)range;

/**
* 자신(self)의 색깔에서 S, B 인자를 곱해서 반환한다.
* @param saturation saturation에 곱할 상수.
* @param brightness brightness에 곱할 상수.
* @return H, S, B 로 분해하여 인수에 해당하는 값을 곱한 후 반환한다.
* @discussion 곱해서 넘치는 것은 자른다. EMTNeumorphicView 에서 존재하던 것을 그냥 가져왔다. 솔직히 필요성은 못느끼겠다.
* @code
 UIColor *color = [self.mainColor MGETransformedColorWithSaturation:1.0 brightness:0.9];
 @endcode
*/
- (UIColor *)MGETransformedColorWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness;

@end

NS_ASSUME_NONNULL_END
