//
//  UIBezierPath+BezierCreator.m
//  BezierMorph
//
//  Created by Steven Barnegren on 20/06/2014.
//  Copyright (c) 2014 Steven Barnegren. All rights reserved.
//

#import "UIBezierPath+Transform.h"
@import GraphicsKit;

@implementation UIBezierPath (Transform)

- (void)mgrApplyTransformScaleXY:(CGFloat)xy frameSize:(CGSize)size {
    [self applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, -size.width/2.0, -size.height/2.0)];
    [self applyTransform:CGAffineTransformScale(CGAffineTransformIdentity, xy, xy)];
    [self applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, +size.width/2.0, +size.height/2.0)];
}

- (void)mgrApplyTransformRotateAngle:(CGFloat)angle frameSize:(CGSize)size; {
    [self applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, -size.width/2.0, -size.height/2.0)];
    [self applyTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    [self applyTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, +size.width/2.0, +size.height/2.0)];
}

- (void)mgrApplyTransformFromPaintSize:(CGSize)paintSize toFrameSize:(CGSize)toFrameSize {
    CGAffineTransform transform =
    CGAffineTransformScale(CGAffineTransformIdentity,
                           toFrameSize.width/paintSize.width,
                           toFrameSize.height/paintSize.height);
    [self applyTransform:transform];
}

- (UIBezierPath *)mgrBezierPathWithScale:(float)scale
                             aroundPoint:(CGPoint)centerPoint {
    NSMutableArray <MGEPathElementRef>*points = [self mgrGetAllPathElements];

    UIBezierPath *outputPath = [UIBezierPath bezierPath];

    for (MGEPathElementRef point in points) {
        // scale loc
        {
            float xDiff = point.loc.x - centerPoint.x;
            xDiff = xDiff * scale;
            float yDiff = point.loc.y - centerPoint.y;
            yDiff = yDiff * scale;
            point.loc = CGPointMake(centerPoint.x + xDiff, centerPoint.y + yDiff);
        }
        // scale control point 1
        {
            float xDiff = point.cp1.x - centerPoint.x;
            xDiff *= scale;
            float yDiff = point.cp1.y - centerPoint.y;
            yDiff *= scale;
            point.cp1 = CGPointMake(centerPoint.x + xDiff, centerPoint.y + yDiff);
        }
        // scale control point 2
        {
            float xDiff = point.cp2.x - centerPoint.x;
            xDiff *= scale;
            float yDiff = point.cp2.y - centerPoint.y;
            yDiff *= scale;
            point.cp2 = CGPointMake(centerPoint.x + xDiff, centerPoint.y + yDiff);
        }

        // add to the output path
        if (point.elementType == kCGPathElementMoveToPoint) {
            [outputPath moveToPoint:point.loc];
        }
        else if (point.elementType == kCGPathElementAddLineToPoint){
            [outputPath addLineToPoint:point.loc];
        }
        else if (point.elementType == kCGPathElementAddCurveToPoint){
            [outputPath addCurveToPoint:point.loc controlPoint1:point.cp1 controlPoint2:point.cp2];
        }
        else if (point.elementType == kCGPathElementAddQuadCurveToPoint){
            [outputPath addQuadCurveToPoint:point.loc controlPoint:point.cp1];
        }
        else if (point.elementType == kCGPathElementCloseSubpath){
            [outputPath closePath];
        }
    }

    return outputPath;
}
@end

/** 애플 메서드 - bezierPathByReversingPath;가 존재하므로 주석처리한다.
- (UIBezierPath *)mgrReverseBezierPath {
    NSMutableArray <MGEPathElementRef>*points = [self mgrGetAllPathElements];
    NSLog(@"num points to reverse = %lu", (unsigned long)points.count);
    UIBezierPath *outputPath = [UIBezierPath bezierPath];
    BOOL shouldClosePath = NO;
    
    MGEPathElementRef prevPoint = nil;
    CGPathElementType prevCurveType = kCGPathElementCloseSubpath;
    
    for (MGEPathElementRef point in [points reverseObjectEnumerator]) {
        BOOL savePoint = YES;
        // complete the previous move
        if (point.elementType == kCGPathElementCloseSubpath){
            shouldClosePath = YES;
            savePoint = NO;
        }
        else if (!prevPoint) {
            [outputPath moveToPoint:point.loc];
        }
        else if (prevCurveType == kCGPathElementMoveToPoint) {
            [outputPath moveToPoint:point.loc];
        }
        else if (prevCurveType == kCGPathElementAddLineToPoint){
            [outputPath addLineToPoint:point.loc];
        }
        else if (prevCurveType == kCGPathElementAddCurveToPoint){
            [outputPath addCurveToPoint:point.loc controlPoint1:prevPoint.cp2 controlPoint2:prevPoint.cp1];
        }
        else if (prevCurveType == kCGPathElementAddQuadCurveToPoint){
            [outputPath addQuadCurveToPoint:prevPoint.loc controlPoint:prevPoint.cp1];
        }
        
        if (savePoint) {
            prevPoint = point;
            prevCurveType = point.elementType;
        }
    }
    
    if (shouldClosePath) {
        [outputPath closePath];
    }

    return outputPath;
}
*/
