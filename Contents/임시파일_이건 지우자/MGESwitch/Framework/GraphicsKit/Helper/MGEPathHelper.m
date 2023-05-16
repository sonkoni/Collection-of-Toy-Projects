//
//  MGRXXX.m
//  MGRGradientProject
//
//  Created by Kwan Hyun Son on 2022/11/16.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEPathHelper.h"

CGPathRef MGECGPathGetPath(MGEBezierPath *myPath) {
#if TARGET_OS_IPHONE
    return myPath.CGPath;
#else
    NSInteger i, numElements;
    // Need to begin a path here.
    CGPathRef immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = [myPath elementCount];
    if (numElements > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        NSPoint points[3];
        BOOL didClosePath = YES;
        
        for (i = 0; i < numElements; i++) {
            switch ([myPath elementAtIndex:i associatedPoints:points]) {
                case NSBezierPathElementMoveTo:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                case NSBezierPathElementLineTo:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                case NSBezierPathElementCurveTo:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                case NSBezierPathElementClosePath:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
        
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath) {
            CGPathCloseSubpath(path);
        }
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    if (immutablePath == NULL) {
        return nil;
    } else {
        return (CGPathRef)CFAutorelease(immutablePath); // path;
    }
#endif
}

CGPathRef MGECGPathCreateWithRect(CGRect rect, CACornerMask corners, CGFloat cornerRadius) {
    CGPoint topPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint bottomPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint leftPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPoint rightPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    CGFloat maxRadius = MIN(rect.size.width, rect.size.height) / 2.0;
    maxRadius = MIN(maxRadius, cornerRadius);
    CGFloat widthStraight_2 = (rect.size.width / 2.0) - maxRadius;
    CGFloat heightStraight_2 = (rect.size.height / 2.0) - maxRadius;
    
    // iOS 시계.
    // macOS 반시계.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, leftPoint.x, leftPoint.y + heightStraight_2);
    CGPathAddLineToPoint(path, NULL, leftPoint.x, leftPoint.y - heightStraight_2);
    if (corners & kCALayerMinXMinYCorner) {
        CGPathAddArc(path,
                     NULL,
                     leftPoint.x + maxRadius,
                     leftPoint.y - heightStraight_2,
                     maxRadius,
                     M_PI,
                     M_PI + M_PI_2,
                     NO);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGPathAddLineToPoint(path, NULL, bottomPoint.x - widthStraight_2, bottomPoint.y);
    }
    CGPathAddLineToPoint(path, NULL, bottomPoint.x + widthStraight_2, bottomPoint.y);
    
    if (corners & kCALayerMaxXMinYCorner) {
        CGPathAddArc(path,
                     NULL,
                     bottomPoint.x+widthStraight_2,
                     bottomPoint.y+maxRadius,
                     maxRadius,
                     -M_PI_2,
                     0.0,
                     NO);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGPathAddLineToPoint(path, NULL, rightPoint.x, rightPoint.y - heightStraight_2);
    }
    CGPathAddLineToPoint(path, NULL, rightPoint.x, rightPoint.y + heightStraight_2);

    if (corners & kCALayerMaxXMaxYCorner) {
        CGPathAddArc(path,
                     NULL,
                     rightPoint.x-maxRadius,
                     rightPoint.y+heightStraight_2,
                     maxRadius,
                     0.0,
                     M_PI_2,
                     NO);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        CGPathAddLineToPoint(path, NULL, topPoint.x + widthStraight_2, topPoint.y);
    }
    CGPathAddLineToPoint(path, NULL, topPoint.x - widthStraight_2, topPoint.y);
    if (corners & kCALayerMinXMaxYCorner) {
        CGPathAddArc(path,
                     NULL,
                     topPoint.x-widthStraight_2,
                     topPoint.y-maxRadius,
                     maxRadius,
                     M_PI_2,
                     M_PI,
                     NO);
    } else {
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGPathAddLineToPoint(path, NULL, leftPoint.x, leftPoint.y + heightStraight_2);
    }
    
    CGPathCloseSubpath(path);
    return path;
}
