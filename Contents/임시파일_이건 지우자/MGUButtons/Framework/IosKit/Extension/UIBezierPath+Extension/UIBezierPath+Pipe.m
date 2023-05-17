//
//  UIBezierPath+Pipe.m
//  PipeBezierTEST
//
//  Created by Kwan Hyun Son on 2021/01/30.
//

#import "UIBezierPath+Pipe.h"

@implementation UIBezierPath (Pipe)

+ (UIBezierPath *)mgrPipePathWithStartPoint:(CGPoint)startPoint
                                   EndPoint:(CGPoint)endPoint
                                    upStyle:(BOOL)isUpStyle
                                     radius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint newStartPoint = startPoint;
    CGPoint newEndPoint = endPoint;
    
    if (startPoint.x == endPoint.x || startPoint.y == endPoint.y) { // 직선일 수 밖에 없는 경우.
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        return path; //! 직선이면 바로 그리고 나간다.
    }
    
    CGFloat xLength = ABS(startPoint.x - endPoint.x);
    CGFloat yLength = ABS(startPoint.y - endPoint.y);
    radius = MIN(radius, MIN(xLength, yLength));
    
    CGPoint poin1 = CGPointMake(startPoint.x, endPoint.y);
    CGPoint poin2 = CGPointMake(endPoint.x, startPoint.y);
    
    CGPoint middlePoint;
    if (isUpStyle == YES) {
        if (poin1.y < poin2.y) {
            middlePoint = poin1;
        } else {
            middlePoint = poin2;
        }
    } else {
        if (poin1.y < poin2.y) {
            middlePoint = poin2;
        } else {
            middlePoint = poin1;
        }
    }
    
    //! start point를 왼쪽으로 놓자.
    if (newStartPoint.x > newEndPoint.x) {
        CGPoint temp = newEndPoint;
        newEndPoint = newStartPoint;
        newStartPoint = temp;
    }
    
    [path moveToPoint:newStartPoint];
    
    UIBezierPath *circularSectorPath;
    if (isUpStyle == YES) { // ⎡ ⎤
        if (newStartPoint.y > newEndPoint.y) { // ⎡
            [path addLineToPoint:CGPointMake(middlePoint.x, middlePoint.y + radius)];
            
            CGPoint radiusCenter = CGPointMake(middlePoint.x + radius, middlePoint.y + radius);
            circularSectorPath =
            [UIBezierPath bezierPathWithArcCenter:radiusCenter
                                           radius:radius
                                       startAngle:M_PI
                                         endAngle:M_PI_2 * 3.0
                                        clockwise:YES];
        } else { // ⎤
            [path addLineToPoint:CGPointMake(middlePoint.x - radius, middlePoint.y)];
            
            CGPoint radiusCenter = CGPointMake(middlePoint.x - radius, middlePoint.y + radius);
            circularSectorPath =
            [UIBezierPath bezierPathWithArcCenter:radiusCenter
                                           radius:radius
                                       startAngle:M_PI_2 * 3.0
                                         endAngle:M_PI_2 * 3.0 + M_PI_2
                                        clockwise:YES];
        }
    } else { // ⎣ ⎦
        if (newStartPoint.y < newEndPoint.y) { // ⎣
            [path addLineToPoint:CGPointMake(middlePoint.x, middlePoint.y - radius)];
            
            CGPoint radiusCenter = CGPointMake(middlePoint.x + radius, middlePoint.y - radius);
            circularSectorPath =
            [UIBezierPath bezierPathWithArcCenter:radiusCenter
                                           radius:radius
                                       startAngle:M_PI
                                         endAngle:M_PI - M_PI_2
                                        clockwise:NO];
        } else { // ⎦
            [path addLineToPoint:CGPointMake(middlePoint.x - radius, middlePoint.y)];
            CGPoint radiusCenter = CGPointMake(middlePoint.x - radius, middlePoint.y - radius);
            circularSectorPath =
            [UIBezierPath bezierPathWithArcCenter:radiusCenter
                                           radius:radius
                                       startAngle:M_PI_2
                                         endAngle:0.0
                                        clockwise:NO];
        }
    }
    
    [path appendPath:circularSectorPath];
    [path addLineToPoint:newEndPoint];

    if (CGPointEqualToPoint(startPoint, newStartPoint) == YES) {
        return path;
    } else {
        return [path bezierPathByReversingPath];;
    }
}

@end
