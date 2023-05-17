//
//  UIBezierPath+Differentiation.m
//  BezierMorph
//
//  Created by Kwan Hyun Son on 2020/11/28.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIBezierPath+Differentiation.h"
@import GraphicsKit;

#define MGRDefaultLengthSamplingDivisions 10 // 10등분 : 커브의 길이에 대한 근삿값을 구하기 위해 분해하는 갯수.

static NSMutableArray <NSValue *>* MGRCalculateAllPointsOnLine(CGPoint p1,
                                                               CGPoint p2,
                                                               MGEPathSegmentPointsAccuracy accuracy);

static NSMutableArray <NSValue *>* MGRCalculatePointsOnCubicBezier(CGPoint origin,
                                                                   CGPoint control1,
                                                                   CGPoint control2,
                                                                   CGPoint destination,
                                                                   MGEPathSegmentPointsAccuracy accuracy);

static NSMutableArray <NSValue *>* MGRCalculateAllPointsOnQuadBezier(MGEPathElementRef endPoint,
                                                                     MGEPathElementRef startPoint,
                                                                     MGEPathSegmentPointsAccuracy accuracy);


@implementation UIBezierPath (Differentiation)

- (NSMutableArray <NSValue *>*)mgrSegmentPointsWithAccuracy:(MGEPathSegmentPointsAccuracy)accuracy {
    accuracy = MAX(MIN(accuracy, MGEPathSegmentPointsAccuracyHigh), MGEPathSegmentPointsAccuracyLow);
    
    //! 원본 베지어 패스에서 실제 구성된 앵커포인트와 성질을 추출한다.
    NSMutableArray <MGEPathElementRef>*pathElements = [self mgrGetAllPathElements];

    // 가까운 점 사이에 선으로 path를 그린다.
    int index = 0;
    
    NSMutableArray <NSValue *>*segmentPoints = [NSMutableArray array];
    
    for (MGEPathElementRef pathElement in pathElements) {
        
        if (pathElement.elementType == kCGPathElementMoveToPoint) {
            // do nothing
        }
        else if (pathElement.elementType == kCGPathElementAddLineToPoint) { // 직선
            MGEPathElementRef prevPoint = [pathElements objectAtIndex:index - 1];
            NSMutableArray <NSValue /*CGPoint*/*>*segPointsArray =
            MGRCalculateAllPointsOnLine(prevPoint.loc, pathElement.loc, accuracy);
            for (NSValue *value in segPointsArray) {
                [segmentPoints addObject:value];
            }
        }
        else if (pathElement.elementType == kCGPathElementAddCurveToPoint){
            MGEPathElementRef prevPoint = [pathElements objectAtIndex:index-1];
            
            NSArray <NSValue *>*segPointsArray = MGRCalculatePointsOnCubicBezier(prevPoint.loc,
                                                                                 pathElement.cp1,
                                                                                 pathElement.cp2,
                                                                                 pathElement.loc,
                                                                                 accuracy);
            
            for (NSValue *value in segPointsArray) {
                [segmentPoints addObject:value];
            }
            
        }
        else if (pathElement.elementType == kCGPathElementAddQuadCurveToPoint){
            MGEPathElementRef prevPoint = [pathElements objectAtIndex:index-1];
            NSMutableArray <NSValue *>*segPointsArray = MGRCalculateAllPointsOnQuadBezier(pathElement,
                                                                                          prevPoint,
                                                                                          accuracy);
            
            for (NSValue *value in segPointsArray) {
                [segmentPoints addObject:value];
            }
        }
        else if (pathElement.elementType == kCGPathElementCloseSubpath){
            //close subpath is a line with no location, just connect the previous point to the first point
            CGPoint previousLoc = ([pathElements objectAtIndex:index-1]).loc;
            CGPoint firstLoc = ([pathElements firstObject]).loc;
            
            NSMutableArray <NSValue *>*segPointsArray = MGRCalculateAllPointsOnLine(previousLoc,
                                                                                    firstLoc,
                                                                                    accuracy);
            
            for (NSValue *value in segPointsArray) {
                [segmentPoints addObject:value];
            }
        }
        
        // increment
        index++;
    }
    
    return segmentPoints;
}


#pragma mark - DEBUG
//! UIView 에서는 [path stroke]; 로 확인하고, CAShapeLayer에서는 path 프라퍼티에 대입해서 확인한다.
- (UIBezierPath *)mgrReconstructOriginalUIBezierPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSMutableArray <MGEPathElementRef>*pathElements = [self mgrGetAllPathElements];
    
    for (MGEPathElementRef pathElement in pathElements) {
        
        if (pathElement.elementType == kCGPathElementMoveToPoint) {
            [path moveToPoint:pathElement.loc];
        }
        else if (pathElement.elementType == kCGPathElementAddLineToPoint){
            [path addLineToPoint:pathElement.loc];
        }
        
        else if (pathElement.elementType == kCGPathElementAddCurveToPoint){
            [path addCurveToPoint:pathElement.loc controlPoint1:pathElement.cp1 controlPoint2:pathElement.cp2];
        }
        else if (pathElement.elementType == kCGPathElementAddQuadCurveToPoint){
            [path addQuadCurveToPoint:pathElement.loc controlPoint:pathElement.cp1];
        }
    }
    
    //! [path stroke]; <- 뷰에서는 이렇게 확인 원본에서는 이거였고, return 타입이 void였음.
    return path;
}

@end

//! 직선에서 사용 CGPoint( = NSValue)에 대한 배열.
static NSMutableArray <NSValue *>* MGRCalculateAllPointsOnLine(CGPoint p1,
                                                               CGPoint p2,
                                                               MGEPathSegmentPointsAccuracy accuracy) {
    
    //! 정수로 바꾼다.
    int numSamples = sqrt(((p2.x-p1.x) * (p2.x-p1.x)) + ((p2.y-p1.y) * (p2.y-p1.y))) * accuracy;
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:numSamples];
    
    for (int i = 0; i < numSamples; i++) {
        
        float t = (1.0f / numSamples) * i;

        [array addObject:@(CGPointMake(p1.x + ((p2.x - p1.x)*t), p1.y + ((p2.y - p1.y)*t)))];
    }
    
    return array;

}

static NSMutableArray <NSValue *>* MGRCalculatePointsOnCubicBezier(CGPoint origin,
                                                                   CGPoint control1,
                                                                   CGPoint control2,
                                                                   CGPoint destination,
                                                                   MGEPathSegmentPointsAccuracy accuracy) {
    float t;
    double length = 0;
    CGPoint prevPoint;
    BOOL firstPoint = YES;
    t = 0;
    
    for (int i = 0; i < MGRDefaultLengthSamplingDivisions; i++) {
        float x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        float y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        t = t + (1.0f / MGRDefaultLengthSamplingDivisions);

        if (firstPoint == NO) {
            length += sqrt(((x-prevPoint.x) * (x-prevPoint.x)) + ((y-prevPoint.y) * (y-prevPoint.y)));
        }

        prevPoint = CGPointMake(x, y);
        firstPoint = NO;
    }

    int segments = (int)length;
    segments = (float)segments * accuracy;
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:segments];

    t = 0; // reuse t from above
    for(NSUInteger i = 0; i < segments; i++) {
        float x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        float y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        t = t + (1.0f / segments);

        [points addObject:@(CGPointMake(x, y))];
    }

    return points;
}

static NSMutableArray <NSValue *>* MGRCalculateAllPointsOnQuadBezier(MGEPathElementRef endPoint,
                                                                     MGEPathElementRef startPoint,
                                                                     MGEPathSegmentPointsAccuracy accuracy) {
    double length = 0;

    CGPoint prevPoint;
    BOOL firstPoint = YES;

    for (int i = 0; i < MGRDefaultLengthSamplingDivisions; i++) {

        float t = (1.0f/MGRDefaultLengthSamplingDivisions) * i;
        float x = (1 - t) * (1 - t) * endPoint.loc.x + 2 * (1 - t) * t * endPoint.cp1.x + t * t * startPoint.loc.x;
        float y = (1 - t) * (1 - t) * endPoint.loc.y + 2 * (1 - t) * t * endPoint.cp1.y + t * t * startPoint.loc.y;

        if (firstPoint == NO) {
            length += sqrt(((x-prevPoint.x) * (x-prevPoint.x)) + ((y-prevPoint.y) * (y-prevPoint.y)));
        }

        prevPoint = CGPointMake(x, y);
        firstPoint = NO;
    }

    int numSamples = (int)length;
    numSamples = (float)numSamples * accuracy;
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:numSamples];

    for (int i = 0; i < numSamples; i++) {

        float t = (1.0f/numSamples) * i;
        float x = (1 - t) * (1 - t) * endPoint.loc.x + 2 * (1 - t) * t * endPoint.cp1.x + t * t * startPoint.loc.x;
        float y = (1 - t) * (1 - t) * endPoint.loc.y + 2 * (1 - t) * t * endPoint.cp1.y + t * t * startPoint.loc.y;

        [array addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }

    return array;
}
