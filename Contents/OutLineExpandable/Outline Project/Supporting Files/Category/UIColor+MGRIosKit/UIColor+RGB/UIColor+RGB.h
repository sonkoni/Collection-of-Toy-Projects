//
//  UIColor+RGB.h
//  LuminanceOfRGBTEST
//
//  Created by Kwan Hyun Son on 2020/10/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//! typedef unsigned char uint8_t;
//! unsigned char : 0 <= <= 255 즉, 0x00 <= <= 0xff
// uint8_t red, green, blue;
// CGFloat alpha;
// BOOL isOK = MGR_CGColorGetComponents(color.CGColor, &red, &green, &blue, &alpha);
extern const BOOL MGR_CGColorGetComponents(CGColorRef color,
                                           uint8_t * _Nullable red,
                                           uint8_t * _Nullable green,
                                           uint8_t * _Nullable blue,
                                           CGFloat * _Nullable alpha);

@interface UIColor (RGB)

//! 나는 정수로 0 <= R <= 255, 0 <= G <= 255, 0 <= B <= 255 로 대입하겠다. 단, 0.0 <= 알파 <= 1.0
+ (UIColor *)mgrColorWithRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue
                       alpha:(CGFloat)alpha;

//! 나는 정수로 0 <= R <= 255, 0 <= G <= 255, 0 <= B <= 255 로 뽑아내겠다. 단, 0.0 <= 알파 <= 1.0
- (BOOL)mgrGetRed:(NSInteger * _Nullable)red
            green:(NSInteger * _Nullable)green
             blue:(NSInteger * _Nullable)blue
            alpha:(CGFloat * _Nullable)alpha;

//! DEBUG 용으로 현재 칼라의 HEX, RGB, HSB, HSL, LAB를 로그로 뽑아서 보여준다. printf사용.
- (void)mgrDEBUGDescription;

@end

NS_ASSUME_NONNULL_END
