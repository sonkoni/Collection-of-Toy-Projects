//
//  NSColor+HEX.h
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (HEX)
+ (NSColor *)mgrColorFromHexString:(NSString *)hexString; //! hex string(16진수 문자열)을 UIColor 객체로 변환한다.
+ (NSColor *)mgrColorFromHexNumber:(int)hexNumber; //! hex (16진수 )를 UIColor 객체로 변환한다.

+ (NSString *)mgrHexStringFromColor:(NSColor *)color;
@end

NS_ASSUME_NONNULL_END
//
// ex : [NSColor mgrColorFromHexString:@"#B956B0"]; #은 생략가능하다.
// ex : [NSColor mgrColorFromHexNumber:0xB956B0];
