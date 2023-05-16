//
//  NSBezierPath+Extension.m
//
//  Created by Kwan Hyun Son on 2022/04/01.
//

#import "NSBezierPath+Extension.h"

@implementation NSBezierPath (Extension)

- (CGPathRef)newMgrCGPath {
    NSInteger i, numElements;
    
    // Need to begin a path here.
    CGPathRef immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        NSPoint points[3];
        BOOL didClosePath = YES;
        
        for (i = 0; i < numElements; i++) {
            switch ([self elementAtIndex:i associatedPoints:points]) {
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
    
    return immutablePath;
}

- (CGPathRef)mgrCGPath {
    NSInteger i, numElements;
    
    // Need to begin a path here.
    CGPathRef immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = [self elementCount];
    if (numElements > 0) {
        CGMutablePathRef path = CGPathCreateMutable();
        NSPoint points[3];
        BOOL didClosePath = YES;
        
        for (i = 0; i < numElements; i++) {
            switch ([self elementAtIndex:i associatedPoints:points]) {
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
}


+ (instancetype)mgrBezierPathWithRoundedRect:(CGRect)rect
                           byRoundingCorners:(CACornerMask)corners
                                cornerRadius:(CGFloat)cornerRadius {
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
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftPoint.x, leftPoint.y + heightStraight_2)];
    [path lineToPoint:CGPointMake(leftPoint.x, leftPoint.y - heightStraight_2)];
    
    if (corners & kCALayerMinXMinYCorner) {
        [path appendBezierPathWithArcWithCenter:CGPointMake(leftPoint.x + maxRadius, leftPoint.y - heightStraight_2)
                                         radius:maxRadius
                                     startAngle:180.0
                                       endAngle:180+90.0
                                      clockwise:NO];
    } else {
        [path lineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
        [path lineToPoint:CGPointMake(bottomPoint.x - widthStraight_2, bottomPoint.y)];
    }
    [path lineToPoint:CGPointMake(bottomPoint.x + widthStraight_2, bottomPoint.y)];
    if (corners & kCALayerMaxXMinYCorner) {
        [path appendBezierPathWithArcWithCenter:CGPointMake(bottomPoint.x+widthStraight_2, bottomPoint.y+maxRadius)
                                         radius:maxRadius
                                     startAngle:-90.0
                                       endAngle:0
                                      clockwise:NO];
    } else {
        [path lineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
        [path lineToPoint:CGPointMake(rightPoint.x, rightPoint.y - heightStraight_2)];
    }
    [path lineToPoint:CGPointMake(rightPoint.x, rightPoint.y + heightStraight_2)];
    if (corners & kCALayerMaxXMaxYCorner) {
        [path appendBezierPathWithArcWithCenter:CGPointMake(rightPoint.x-maxRadius, rightPoint.y+heightStraight_2)
                                         radius:maxRadius
                                     startAngle:0
                                       endAngle:90.0
                                      clockwise:NO];
    } else {
        [path lineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
        [path lineToPoint:CGPointMake(topPoint.x + widthStraight_2, topPoint.y)];
    }
    [path lineToPoint:CGPointMake(topPoint.x - widthStraight_2, topPoint.y)];
    if (corners & kCALayerMinXMaxYCorner) {
        [path appendBezierPathWithArcWithCenter:CGPointMake(topPoint.x-widthStraight_2, topPoint.y-maxRadius)
                                         radius:maxRadius
                                     startAngle:90.0
                                       endAngle:180.0
                                      clockwise:NO];
    } else {
        [path lineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
        [path lineToPoint:CGPointMake(leftPoint.x, leftPoint.y + heightStraight_2)];
    }
    [path closePath];
    
    return path;
}
@end
