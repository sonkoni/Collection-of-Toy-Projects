//
//  UIView+Drawing.m
//  DrawTEST
//
//  Created by Kwan Hyun Son on 2020/07/26.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIView+Drawing.h"

typedef NS_ENUM(NSInteger, UIViewDrawingGradientType) {
    UIViewDrawingGradientTypeAxialHorizontal = 1,
    UIViewDrawingGradientTypeAxialVertical,
    UIViewDrawingGradientTypeRadial
};

@implementation UIView (Drawing)

- (void)mgrDrawVerticalGradientRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors {
    [self mgrDrawGradientRect:rect colors:colors gradientType:UIViewDrawingGradientTypeAxialVertical];
}

- (void)mgrDrawHorizontalGradientRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors {
    [self mgrDrawGradientRect:rect colors:colors gradientType:UIViewDrawingGradientTypeAxialHorizontal];
}

- (void)mgrDrawRadialGradientLayerRect:(CGRect)rect colors:(NSArray <UIColor *>*)colors {
    [self mgrDrawGradientRect:rect colors:colors gradientType:UIViewDrawingGradientTypeRadial];
}


#pragma mark - Private
- (void)mgrDrawGradientRect:(CGRect)rect
                     colors:(NSArray <UIColor *>*)colors
               gradientType:(UIViewDrawingGradientType)gradientType {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    NSMutableArray *colorArr = [NSMutableArray array];
    for (UIColor *color in colors) {
        id cgColor = (__bridge id)color.CGColor;
        [colorArr addObject:cgColor];
    }
    
    colors = colorArr.copy;

// 보통은 균등이다.
//    NSArray *locations =  @[@(0.0), @(1.0)];
//    CGFloat colorLocation[locations.count];
//    for (NSInteger i = 0; i < locations.count; i++) {
//        NSNumber *number = locations[i];
//        colorLocation[i] = number.doubleValue;
//    }
//
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorLocation);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    
    CGPoint startPoint, endPoint;
    
    if (gradientType == UIViewDrawingGradientTypeAxialHorizontal ||
        gradientType == UIViewDrawingGradientTypeAxialVertical) {
        
        if (gradientType == UIViewDrawingGradientTypeAxialHorizontal) {
            startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
        } else {
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        }
        // kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    }
    
    if (gradientType == UIViewDrawingGradientTypeRadial) {
        startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        CGContextDrawRadialGradient(context, gradient, startPoint, 0.0, startPoint, MAX(rect.size.width/2.0, rect.size.height/2.0), kCGGradientDrawsAfterEndLocation); // 끝이 난후에도 마지막 색을 연장시킨다.
    }
    
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
