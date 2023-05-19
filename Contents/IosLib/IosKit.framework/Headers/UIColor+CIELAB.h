//
//  UIColor+CIELAB.h
//  color
//
//  Created by Matthew Smith on 2/11/13.
//  Copyright (c) 2013 Matthew Smith. All rights reserved.
//
//! CIE L*A*B* - 아래의 범위로 나오게 해놨다. 반올림해서 정수화 시켜서 사용하자.
//! Lightness value   : 0    <= L <= 100 L* 값은 밝기를 나타낸다. L* = 0 이면 검은색, L* = 100 이면 흰색을 나타낸다.
//! Red/Green value   : -128 <= A <= 127 a*이 음수이면 초록에 치우친 색, 양수이면 빨강/보라 쪽으로 치우친 색.
//! Blue/Yellow value : -128 <= B <= 127 b*이 음수이면 파랑 b*이 양수이면 노랑.
//!
//! [color getLightness:&L A:&A B:&B alpha:NULL];
//! [NSString stringWithFormat:@"LAB:%ld %ld %ld", (NSInteger)(round(L)), (NSInteger)(round(A)), (NSInteger)(round(B))];
// http://colormine.org/convert/rgb-to-lab
// 애플 피커가 잘 못나온다.

#import <UIKit/UIKit.h>

@interface UIColor (CIELAB)

+ (UIColor *)mgrColorWithLightness:(CGFloat)lightness
                                 A:(CGFloat)A
                                 B:(CGFloat)B
                             alpha:(CGFloat)alpha;

- (BOOL)mgrGetLightness:(CGFloat *)lightness
                      A:(CGFloat *)a
                      B:(CGFloat *)b
                  alpha:(CGFloat *)alpha;

- (UIColor *)mgrOffsetWithLightness:(CGFloat)lightness
                                  a:(CGFloat)a
                                  b:(CGFloat)b
                              alpha:(CGFloat)alpha;


#pragma mark - Intermediate Colorspace XYZ
- (void)mgrGetX:(CGFloat *)xOut
              Y:(CGFloat *)yOut
              Z:(CGFloat *)zOut
          alpha:(CGFloat *)alphaOut;

@end
