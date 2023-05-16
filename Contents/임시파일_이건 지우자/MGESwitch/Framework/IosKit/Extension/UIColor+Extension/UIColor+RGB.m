//
//  UIColor+RGB.m
//  LuminanceOfRGBTEST
//
//  Created by Kwan Hyun Son on 2020/10/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIColor+RGB.h"
#import "UIColor+HEX.h"
#import "UIColor+HSB.h"
#import "UIColor+HSL.h"
#import "UIColor+CIELAB.h"

extern const BOOL MGR_CGColorGetComponents(CGColorRef color,
                                           uint8_t * _Nullable red,
                                           uint8_t * _Nullable green,
                                           uint8_t * _Nullable blue,
                                           CGFloat * _Nullable alpha) {
    
    size_t getNumber = CGColorGetNumberOfComponents(color);
    if ( !(getNumber == 2 || getNumber == 4) ) {
        return NO;
    }
    
    uint8_t r = 0, g = 0, b = 0;
    CGFloat a = 0.0;
    CGFloat *rgbaComponents = (CGFloat *)CGColorGetComponents(color);
    if (getNumber == 2) {
        r = (uint8_t)round(MAX(MIN(rgbaComponents[0], 1.0), 0.0) * 0xff);
        g = (uint8_t)round(MAX(MIN(rgbaComponents[0], 1.0), 0.0) * 0xff);
        b = (uint8_t)round(MAX(MIN(rgbaComponents[0], 1.0), 0.0) * 0xff);
        a = MAX(MIN(rgbaComponents[1], 1.0), 0.0); // a = CGColorGetAlpha(color); 이걸 써도됨
    } else { // 4개다.
        r = (uint8_t)round(MAX(MIN(rgbaComponents[0], 1.0), 0.0) * 0xff);
        g = (uint8_t)round(MAX(MIN(rgbaComponents[1], 1.0), 0.0) * 0xff);
        b = (uint8_t)round(MAX(MIN(rgbaComponents[2], 1.0), 0.0) * 0xff);
        a = MAX(MIN(rgbaComponents[3], 1.0), 0.0); // a = CGColorGetAlpha(color); 이걸 써도됨
    }
    
    if (red != NULL) {
        *red = r;
    }
    if (green != NULL) {
        *green = g;
    }
    if (blue != NULL) {
        *blue = b;
    }
    if (alpha != NULL) {
        *alpha = a;
    }
    
    return YES;
}

@implementation UIColor (RGB)

+ (UIColor *)mgrColorWithRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue
                       alpha:(CGFloat)alpha {
    CGFloat RED, GREEN, BLUE;
    RED = MAX(MIN((red / 255.0), 1.0), 0.0);
    GREEN = MAX(MIN((green / 255.0), 1.0), 0.0);
    BLUE = MAX(MIN((blue / 255.0), 1.0), 0.0);
    return [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:alpha];
}

- (BOOL)mgrGetRed:(NSInteger * _Nullable)red
            green:(NSInteger * _Nullable)green
             blue:(NSInteger * _Nullable)blue
            alpha:(CGFloat * _Nullable)alpha {
    
    CGFloat RED, GREEN, BLUE, ALPHA;
    if ([self getRed:&RED green:&GREEN blue:&BLUE alpha:&ALPHA] == NO) {
        return NO;
    }
    
    if (red != NULL) {
        RED = MIN(MAX(RED * 255.0, 0.0), 255.0);
        *red = (NSInteger)(round(RED));
    }
    
    if (green != NULL) {
        GREEN = MIN(MAX(GREEN * 255.0, 0.0), 255.0);
        *green = (NSInteger)(round(GREEN));
    }
    
    if (blue != NULL) {
        BLUE = MIN(MAX(BLUE * 255.0, 0.0), 255.0);
        *blue = (NSInteger)(round(BLUE));
    }
    
    if (alpha != NULL) {
        *alpha = ALPHA;
    }
    
    return YES;
}

- (void)mgrDEBUGDescription {
    NSInteger RED, GREEN, BLUE;
    CGFloat ALPHA;
    
    if ([self mgrGetRed:&RED green:&GREEN blue:&BLUE alpha:&ALPHA] == NO) {
        printf("색을 추출하는 것에 실패하였다. \n");
        return;
    }
    
    printf("------------------------------------ \n");
    printf("HEX String: %s \n", [[UIColor mgrHexStringFromColor:self] cStringUsingEncoding:NSNonLossyASCIIStringEncoding]);
    printf("RED: %ld, GREEN: %ld, BLUE: %ld, ALPHA: %.1f \n", RED, GREEN, BLUE, ALPHA);
    
    NSInteger HUE, SAT, BRI;
    [self mgrGetHue:&HUE saturation:&SAT brightness:&BRI alpha:NULL];
    printf("HUE: %ld, SAT: %ld, BRI: %ld, ALPHA: %.1f \n", HUE, SAT, BRI, ALPHA);
    
    NSInteger LIG;
    [self mgrGetHue:NULL saturation:&SAT lightness:&LIG alpha:NULL];
    printf("HUE: %ld, SAT: %ld, LIG: %ld, ALPHA: %.1f \n", HUE, SAT, LIG, ALPHA);
    
    
    CGFloat L, A, B;
    //! 정수로 안바꿔놨다. ㅡㅡ;
    [self mgrGetLightness:&L A:&A B:&B alpha:NULL];
    printf("L: %d, A: %d, B: %d, ALPHA: %.1f \n", (int)round(L), (int)round(A), (int)round(B), ALPHA);
    printf("------------------------------------ \n");
}

@end
