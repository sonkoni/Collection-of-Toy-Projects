//
//  MGRXXX.m
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEColorHelper.h"

static CGFloat * MGECGColorGetComponents(CGColorRef color);

CGColorRef MGECGColorCreateInterpolate(CGColorRef startColor, CGColorRef endColor, CGFloat fraction) {
    fraction = MIN(1.0, MAX(0.0, fraction));
    CGFloat *c1 = MGECGColorGetComponents(startColor);
    CGFloat *c2 = MGECGColorGetComponents(endColor);

    CGFloat r = c1[0] + (c2[0] - c1[0]) * fraction;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * fraction;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * fraction;
    CGFloat a = c1[3] + (c2[3] - c1[3]) * fraction;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat arr[4] = {r, g, b, a};
    CGColorRef result = CGColorCreate(colorSpace, arr);
    free(c1);
    free(c2);
    CGColorSpaceRelease(colorSpace);
    return result;
    //
//     CGFloat a = ... 라인부터는 아래 주석의 식으로 교체해도 가능하다.
//    CGFloat a =
//    CGColorGetAlpha(start.CGColor) + (CGColorGetAlpha(end.CGColor) - CGColorGetAlpha(start.CGColor)) * fraction;
//
//    CGColorRef color = CGColorCreateSRGB(r, g, b, a);
//    UIColor *returnColor = [UIColor colorWithCGColor:color];
//    CGColorRelease(color);
//    return returnColor;
}

#pragma mark - Private
//! 사용 후 free가 필요하다.
static CGFloat * MGECGColorGetComponents(CGColorRef color) {
    switch (CGColorGetNumberOfComponents(color)) {
        case 2:  {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            const CGFloat *c = CGColorGetComponents(color);
            colors[0] = c[0];
            colors[1] = c[0];
            colors[2] = c[0];
            colors[3] = c[1];
            return colors;
            break;
        }
        case 4:  {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            const CGFloat *c = CGColorGetComponents(color);
            colors[0] = c[0];
            colors[1] = c[1];
            colors[2] = c[2];
            colors[3] = c[3];
            return colors;
            break;
        }
        default: {
            CGFloat *colors = (CGFloat *)malloc(sizeof(CGFloat) * 4);
            colors[0] = 0.0;
            colors[1] = 0.0;
            colors[2] = 0.0;
            colors[3] = 1.0;
            return colors;
            break;
        }
    }
}
