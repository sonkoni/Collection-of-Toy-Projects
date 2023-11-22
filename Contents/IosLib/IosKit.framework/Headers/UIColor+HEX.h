//
//  UIColor+HEX.h
//
//  Created by Kwan Hyun Son on 06/09/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HEX)

+ (UIColor *)mgrColorFromHexString:(NSString *)hexString; //! hex string(16진수 문자열)을 UIColor 객체로 변환한다.
+ (UIColor *)mgrColorFromHexNumber:(int)hexNumber; //! hex (16진수 )를 UIColor 객체로 변환한다.

+ (NSString *)mgrHexStringFromColor:(UIColor *)color;

- (NSInteger)mgrHexNumber;
@end

NS_ASSUME_NONNULL_END
//
// ex : [UIColor mgrColorFromHexString:@"#B956B0"]; #은 생략가능하다.
// ex : [UIColor mgrColorFromHexNumber:0xB956B0];
