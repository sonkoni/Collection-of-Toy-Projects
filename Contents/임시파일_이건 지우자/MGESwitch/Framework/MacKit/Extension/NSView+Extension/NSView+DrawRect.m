//
//  NSView+DrawRect.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSView+DrawRect.h"

@implementation NSView (DrawRect)

- (void)mgrDrawRect:(NSRect)dirtyRect
    backgroundColor:(NSColor * _Nullable)backgroundColor
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:cornerRadius yRadius:cornerRadius];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    if (backgroundColor != nil) {
        [backgroundColor set];
        [path fill];
    }
    if (borderColor != nil && borderWidth > 0.0) {
        [borderColor set];
        [path setLineWidth:(borderWidth * 2.0)];
        [path stroke];
    }
    
   /** Core Graphics 로도 해결가능하다. 이렇게 할줄도 알아야한다.
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGPathRef clipPath = CGPathCreateWithRoundedRect(dirtyRect, cornerRadius, cornerRadius, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context); // 영역 제한.
    
    if (backgroundColor != nil) {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextAddPath(context, clipPath);
        CGContextFillPath(context);
    }
    
    if (borderColor != nil && borderWidth > 0.0) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth * 2.0); // border는 안쪽으로 파고든다.
        CGContextAddPath(context, clipPath);
        CGContextStrokePath(context);
    }
    
    CGPathRelease(clipPath);
    */
}

- (void)mgrDrawRect:(NSRect)dirtyRect
linearGradientbackColors:(NSArray <NSColor *>* _Nullable)linearGradientbackColors
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:cornerRadius yRadius:cornerRadius];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    if (linearGradientbackColors != nil && linearGradientbackColors.count > 0) { // Draw gradient
        if (self.isFlipped == NO) {
            linearGradientbackColors = linearGradientbackColors.reverseObjectEnumerator.allObjects;
        }
        NSGradient *gradient = [[NSGradient alloc] initWithColors:linearGradientbackColors];
        [gradient drawInBezierPath:path angle:90.0];
    }
    if (borderColor != nil && borderWidth > 0.0) {
        [borderColor set];
        [path setLineWidth:(borderWidth * 2.0)]; // border는 안쪽으로 파고 들어야한다.
        [path stroke];
    }
    
    /** Core Graphics 로도 해결가능하다. 이렇게 할줄도 알아야한다.
    NSMutableArray <id>*gradientcolors = [NSMutableArray arrayWithCapacity:linearGradientbackColors.count];
    for (NSColor *color in linearGradientbackColors) {
        [gradientcolors addObject:(id)(color.CGColor)];
    }
    if (self.isFlipped == NO) {
        gradientcolors = gradientcolors.reverseObjectEnumerator.allObjects.mutableCopy;
    }

    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGPathRef clipPath = CGPathCreateWithRoundedRect(dirtyRect, cornerRadius, cornerRadius, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context); // 영역 제한.

    if (linearGradientbackColors != nil) {
        CGContextSaveGState(context);
        NSInteger divisor = gradientcolors.count - 1;
        CGFloat step = 1.0 / (CGFloat)divisor;
        NSMutableArray <NSNumber *>*locations = [NSMutableArray arrayWithCapacity:gradientcolors.count];
        for (NSInteger i = 0; i < gradientcolors.count - 1; i++) {
            [locations addObject:@((step * i))];
        }
        [locations addObject:@(1.0)]; // 오차를 줄이기 위해
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray <NSColor *>*colors =
        [gradientcolors subarrayWithRange:NSMakeRange(0, locations.count)].mutableCopy;
        
        if ([locations.firstObject doubleValue] != 0.0) {
            [locations insertObject:@(0.0) atIndex:0];
            [colors insertObject:colors.firstObject atIndex:0];
        }
        if ([locations.lastObject doubleValue] != 1.0) {
            [locations addObject:@(1.0)];
            [colors addObject:colors.lastObject];
        }
        
        CGFloat colorLocation[locations.count];
        for (NSInteger i = 0; i < locations.count; i++) {
            NSNumber *number = locations[i];
            colorLocation[i] = number.doubleValue;
        }
        
        CGGradientRef gradient = CGGradientCreateWithColors((CGColorSpaceRef)CFAutorelease(colorSpace),
                                                            (__bridge CFArrayRef)colors,
                                                            colorLocation);

        CGPoint initalStartPoint = CGPointMake(0.5, 0.0);
        CGPoint initalEndPoint = CGPointMake(0.5, 1.0);
        // CAGradientLayer와 같이 사용하려면 다음과 같은 처리 과정이 필요하다.
        // self.bounds 가 정사각형임을 가정한다.
        CGFloat squareValue = MAX(dirtyRect.size.width, dirtyRect.size.height);
        CGRect rect = CGRectMake(dirtyRect.origin.x, dirtyRect.origin.y, squareValue, squareValue);
        CGFloat startPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * initalStartPoint.x + CGRectGetMinX(rect);
        CGFloat startPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * initalStartPoint.y + CGRectGetMinY(rect);
        CGFloat endPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * initalEndPoint.x + CGRectGetMinX(rect);
        CGFloat endPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * initalEndPoint.y + CGRectGetMinY(rect);
        CGPoint startPoint = CGPointMake(startPoint_X, startPoint_Y);
        CGPoint endPoint = CGPointMake(endPoint_X, endPoint_Y);
        
        if (dirtyRect.size.width < dirtyRect.size.height) {
            CGContextScaleCTM(context,
                              dirtyRect.size.width / dirtyRect.size.height,
                              1.0);
        } else {
            CGContextScaleCTM(context,
                              1.0,
                              dirtyRect.size.height / dirtyRect.size.width);
        }

        CGContextDrawLinearGradient(context,
                                    (CGGradientRef)CFAutorelease(gradient),
                                    startPoint,
                                    endPoint,
                                    kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
    }

    if (borderColor != nil && borderWidth > 0.0) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth * 2.0); // border는 안쪽으로 파고든다.
        CGContextAddPath(context, clipPath);
        CGContextStrokePath(context);
    }

    CGPathRelease(clipPath);
    */
}

- (void)mgrDrawRect:(NSRect)dirtyRect
radialGradientbackColors:(NSArray <NSColor *>* _Nullable)radialGradientbackColors
       cornerRadius:(CGFloat)cornerRadius
        borderColor:(NSColor * _Nullable)borderColor
        borderWidth:(CGFloat)borderWidth {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:cornerRadius yRadius:cornerRadius];
    [path addClip]; // 모든 드로잉 클립을 이 라운드 영역에 만든다.
    if (radialGradientbackColors != nil && radialGradientbackColors.count > 0) { // Draw gradient
        NSGradient *gradient = [[NSGradient alloc] initWithColors:radialGradientbackColors];
        [gradient drawInRect:dirtyRect relativeCenterPosition:NSZeroPoint];
    }
    if (borderColor != nil && borderWidth > 0.0) {
        [borderColor set];
        [path setLineWidth:(borderWidth * 2.0)]; // border는 안쪽으로 파고 들어야한다.
        [path stroke];
    }
    
    /** Core Graphics 로도 해결가능하다. 이렇게 할줄도 알아야한다. 짜부가 되게 만들었다. 약간 차이가 있지만, 나중에 생각하자.
    NSMutableArray <id>*gradientcolors = [NSMutableArray arrayWithCapacity:radialGradientbackColors.count];
    for (NSColor *color in radialGradientbackColors) {
        [gradientcolors addObject:(id)(color.CGColor)];
    }

    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGPathRef clipPath = CGPathCreateWithRoundedRect(dirtyRect, cornerRadius, cornerRadius, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context); // 영역 제한.

    if (radialGradientbackColors != nil) {
        CGContextSaveGState(context);
        NSInteger divisor = gradientcolors.count - 1;
        CGFloat step = 1.0 / (CGFloat)divisor;
        NSMutableArray <NSNumber *>*locations = [NSMutableArray arrayWithCapacity:gradientcolors.count];
        for (NSInteger i = 0; i < gradientcolors.count - 1; i++) {
            [locations addObject:@((step * i))];
        }
        [locations addObject:@(1.0)]; // 오차를 줄이기 위해
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray <NSColor *>*colors =
        [gradientcolors subarrayWithRange:NSMakeRange(0, locations.count)].mutableCopy;
        
        if ([locations.firstObject doubleValue] != 0.0) {
            [locations insertObject:@(0.0) atIndex:0];
            [colors insertObject:colors.firstObject atIndex:0];
        }
        if ([locations.lastObject doubleValue] != 1.0) {
            [locations addObject:@(1.0)];
            [colors addObject:colors.lastObject];
        }
        
        CGFloat colorLocation[locations.count];
        for (NSInteger i = 0; i < locations.count; i++) {
            NSNumber *number = locations[i];
            colorLocation[i] = number.doubleValue;
        }
        
        CGGradientRef gradient = CGGradientCreateWithColors((CGColorSpaceRef)CFAutorelease(colorSpace),
                                                            (__bridge CFArrayRef)colors,
                                                            colorLocation);
        CGPoint startPoint = CGPointMake(0.5, 0.5);
        CGPoint endPoint = CGPointMake(1.0, 1.0);
        
        //! 본 함수는 완벽한 원(타원 아님)으로 만든다. 따라서 위에서 적절하게 처리했다.
        //! 원이 완전 원임을 가정한다.(함수 자체가 완전원을 그린다.)
        CGFloat sX = (CGRectGetMaxX(dirtyRect) - CGRectGetMinX(dirtyRect)) * startPoint.x + CGRectGetMinX(dirtyRect);
        CGFloat sY = (CGRectGetMaxY(dirtyRect) - CGRectGetMinY(dirtyRect)) * startPoint.y + CGRectGetMinY(dirtyRect);
        CGFloat eX = (CGRectGetMaxX(dirtyRect) - CGRectGetMinX(dirtyRect)) * endPoint.x + CGRectGetMinX(dirtyRect);
        CGFloat eY = (CGRectGetMaxY(dirtyRect) - CGRectGetMinY(dirtyRect)) * endPoint.y + CGRectGetMinY(dirtyRect);
        CGSize size = CGSizeMake(ABS(eX - sX), ABS(eY - sY));
        CGFloat squareValue = MAX(size.width, size.height);
        
        CGContextTranslateCTM(context, sX, sY); // 중심축을 이동한다.
        if (size.width < size.height) {
            CGContextScaleCTM(context,
                              size.width / size.height,
                              1.0);
        } else {
            CGContextScaleCTM(context,
                              1.0,
                              size.height / size.width);
        }
        
        CGContextDrawRadialGradient(context,
                                    (CGGradientRef)CFAutorelease(gradient),
                                    CGPointZero,
                                    0.0,
                                    CGPointZero,
                                    squareValue,
                                    kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
    }

    if (borderColor != nil && borderWidth > 0.0) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth * 2.0); // border는 안쪽으로 파고든다.
        CGContextAddPath(context, clipPath);
        CGContextStrokePath(context);
    }

    CGPathRelease(clipPath);
    */
}


#pragma mark - Shadow
- (void)mgrDrawShadowPath:(NSBezierPath *)path
              shadowColor:(NSColor *)shadowColor
             shadowOffset:(CGSize)shadowOffset
         shadowBlurRadius:(CGFloat)shadowBlurRadius {
    NSShadow *shadow = [NSShadow new];
    shadow.shadowBlurRadius = shadowBlurRadius;
    shadow.shadowOffset = shadowOffset;
    shadow.shadowColor = shadowColor;
    [shadow set];

    path.lineWidth = 1.0 / [NSScreen mainScreen].backingScaleFactor;
    [path stroke]; // 선을 그려야지 shadow가 등장한다.

    /** Core Graphics 로도 해결가능하다. 이렇게 할줄도 알아야한다.
    CGContextRef context = [NSGraphicsContext currentContext].CGContext;
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetLineWidth(context, (1.0/[NSScreen mainScreen].backingScaleFactor));
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
    CGContextAddPath(context, path); // CGPath로 넣어라. CGPath Release 신경써야한다.
    CGContextStrokePath(context);
    */
}



@end
