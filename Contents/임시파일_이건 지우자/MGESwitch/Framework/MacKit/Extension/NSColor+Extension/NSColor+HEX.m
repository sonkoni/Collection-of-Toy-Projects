//
//  NSColor+HEX.m
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSColor+HEX.h"

//! 정적 전역변수.
static NSMutableDictionary <NSString *, NSColor *>*hexColorCacheDictionary; // key : value

/** + colorFromHexString: 메서드를 돕는 함수. **/
NSString * cleanHexString(NSString *hexString);
CGFloat * normaliseColors(UInt32 *colors);


@implementation NSColor (HEX)

//! hex string(16진수 문자열)을 NSColor 객체로 변환한다. //! ex : [NSColor colorFromHexString:@"#B956B0"]; #은 생략가능하다.
+ (NSColor *)mgrColorFromHexString:(NSString *)hexString {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hexColorCacheDictionary = [NSMutableDictionary dictionary];
    });
    
    NSString *cleanedHexString = cleanHexString(hexString); // # 문자가 붙어 있을 경우에는 제거한다.
    
    NSColor *cachedColor = hexColorCacheDictionary[hexString];

    if (cachedColor != nil) {
        return cachedColor;
    } // 만약 cache dictionary 에 존재하지 않는다면(nil 이라면), 색상을 만들어 cache dictionary에 저장 후 반환하라.
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:cleanedHexString];
    uint32_t value = 0; // typedef unsigned int uint32_t;
    
    // We have the hex value, grab the red, green, blue and alpha values.
    // Have to pass value by reference, scanner modifies this directly as the result of scanning the hex string.
    if([scanner scanHexInt:&value] == YES) { // - scanHexInt: 메서드는 성공 또는 실패여부를 나타내는 BOOL 값을 반환한다.
        uint32_t mask = 0xFF;

        uint32_t red   = value >> 16 & mask;
        uint32_t green = value >> 8 & mask;
        uint32_t blue  = value & mask;
        
        uint32_t colors[3] = {red, green, blue};       // r, g, b, a 가 0   ~ 255 까지의 정수이다.
        CGFloat *normalised = normaliseColors(colors); // r, g, b, a 가 0.0 ~ 1.0 까지의 실수이다. + colorWithRed:green:blue:alpha: 메서드에서 이용위해
        
        NSColor *newColor = [NSColor colorWithRed:normalised[0] green:normalised[1] blue:normalised[2] alpha:1.f];
        free(normalised);
        
        storeColorInCache(cleanedHexString, newColor);
        return newColor;
    }
    else {
        printf("오류 : 16 진수 문자열을 숫자로 변환하지 못하고 대신 [NSColor whiteColor]를 반환했다.");
        return [NSColor whiteColor];
    }
    // intValue = 01010101 11110111 11101010    // binary
    // intValue = 55       F7       EA          // hexadecimal
    
    //                     r
    //   00000000 00000000 01010101 intValue >> 16
    // & 00000000 00000000 11111111 mask
    //   ==========================
    // = 00000000 00000000 01010101 red
    
    //            r        g
    //   00000000 01010101 11110111 intValue >> 8
    // & 00000000 00000000 11111111 mask
    //   ==========================
    // = 00000000 00000000 11110111 green
    
    //   r        g        b
    //   01010101 11110111 11101010 intValue
    // & 00000000 00000000 11111111 mask
    //   ==========================
    // = 00000000 00000000 11101010 blue
}

//! ex : [NSColor colorFromHexNumber:0xB956B0];
+ (NSColor *)mgrColorFromHexNumber:(int)hexNumber {
    return [NSColor mgrColorFromHexString:[NSString stringWithFormat:@"%x", hexNumber]];
}

+ (NSString *)mgrHexStringFromColor:(NSColor *)color {
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    int RED   = (int)round(255.0 * red);
    int GREEN = (int)round(255.0 * green);
    int BLUE  = (int)round(255.0 * blue);
    //! int ALPHA = (int)(255.0 * alpha);
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", RED, GREEN, BLUE];
}


#pragma mark - 지원

//! 첫 번째 문자가 # 이라면 이것을 삭제하여 문자열을 돌려주는 함수이다.
NSString * cleanHexString(NSString *hexString) {
    return [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
//    NSString *cleanedHexString;
//    NSString *firstCharacter = [hexString substringToIndex:1]; // 첫 번째 문자 1개를 뽑아낸다.
//    if ( [firstCharacter isEqualToString:@"#"] == YES ) {
//        cleanedHexString = [hexString substringFromIndex:1];    // 두 번째 문자부터 쭉 빼낸다.
//        return cleanedHexString;
//    } else {
//        return hexString;
//    }
}

CGFloat * normaliseColors(UInt32 *colors) {
    
    CGFloat *normalisedVersions = (CGFloat*)malloc(sizeof(CGFloat) * 3);
    
    for (int i = 0; i < 3 ; i++) {
        normalisedVersions[i] = ((CGFloat)(colors[i] % 256) / 255.f);
    }
    
    return normalisedVersions;
}

//! 해당 색을 저장한다. 기존에 가지고 있다면 그냥 나가고, 10만개 넘게 캐쉬하고 있다면 한번 비워준다.
void storeColorInCache(NSString *hexString, NSColor *color) {
    
    if ([hexColorCacheDictionary.allKeys containsObject:hexString] == YES) { // 이미 갖고 있다면 저장할 필요가 없다.
        return;
    } else if (hexColorCacheDictionary.allKeys.count > 100000) { // 10만개 넘게 저장되어 있다면 한번 비워주자.
        [hexColorCacheDictionary removeAllObjects];
        return;
    }
    
    hexColorCacheDictionary[hexString] = color;
}

@end
