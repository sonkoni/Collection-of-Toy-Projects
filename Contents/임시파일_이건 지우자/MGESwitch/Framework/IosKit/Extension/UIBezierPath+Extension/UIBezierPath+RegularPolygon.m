//
//  UIBezierPath+MGRRegularPolygon.m
//  BEZIERTEST
//
//  Created by Kwan Hyun Son on 15/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIBezierPath+RegularPolygon.h"
#import <GraphicsKit/GraphicsKit.h>

@implementation UIBezierPath (RegularPolygon)

+ (UIBezierPath *)bezierPathWithRegularPolygonAtCenter:(CGPoint)center
                                               radius:(CGFloat)radius
                                        numberOfSides:(NSUInteger)numberOfSides {
    if (numberOfSides < 3) {
        [NSException raise:NSInvalidArgumentException format:@"3각형 이상이다. 2각형, 1각형라는 것은 존재하지 않는다."];
    }
    
    CGFloat nRadian = (2.0 * M_PI) / numberOfSides; // CGFloat nRadian_2 = nRadian / 2.0;
    CGPoint firstPoint = CGPointMake(center.x, center.y - radius);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:firstPoint];  // 12시 방향의 원 끝점으로 옮긴다.
    
    for (NSInteger i = 1; i < numberOfSides; i++) {
        CGFloat movingRadian = i * nRadian;
        CGPoint targetPoint = MGERotatePointAboutCenter(center, firstPoint, movingRadian);
        [bezierPath addLineToPoint:targetPoint];
    }
    
    [bezierPath closePath];
    
    return bezierPath;
}

+ (UIBezierPath *)bezierPathWithBigRegularPolygonAtCenter:(CGPoint)center
                                                   radius:(CGFloat)radius
                                            numberOfSides:(NSUInteger)numberOfSides {
    if (numberOfSides < 3) {
        [NSException raise:NSInvalidArgumentException format:@"3각형 이상이다. 2각형, 1각형라는 것은 존재하지 않는다."];
    }
    
    CGFloat nRadian = (2.0 * M_PI) / numberOfSides;
    CGFloat nRadian_2 = nRadian / 2.0;    
    CGFloat BigRadius = radius / cosf(nRadian_2);
    
    return [UIBezierPath bezierPathWithRegularPolygonAtCenter:center radius:BigRadius numberOfSides:numberOfSides];
}

//! 심화 - 회전.
+ (UIBezierPath *)bezierPathWithRegularPolygonAtCenter:(CGPoint)center
                                                radius:(CGFloat)radius
                                         numberOfSides:(NSUInteger)numberOfSides
                                           rotateRatio:(CGFloat)rotateRatio {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRegularPolygonAtCenter:center
                                                                           radius:radius
                                                                    numberOfSides:numberOfSides];
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(-center.x, -center.y)];
    
    CGFloat rotateRadin = ((M_PI * 2.0) / numberOfSides) * rotateRatio;
    
    [bezierPath applyTransform:CGAffineTransformMakeRotation(rotateRadin)];
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(center.x, center.y)];
    
    return bezierPath;
}

+ (UIBezierPath *)bezierPathWithBigRegularPolygonAtCenter:(CGPoint)center
                                                   radius:(CGFloat)radius
                                            numberOfSides:(NSUInteger)numberOfSides
                                              rotateRatio:(CGFloat)rotateRatio {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithBigRegularPolygonAtCenter:center
                                                                              radius:radius
                                                                       numberOfSides:numberOfSides];
    
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(-center.x, -center.y)];
    CGFloat rotateRadin = ((M_PI * 2.0) / numberOfSides) * rotateRatio;
    
    [bezierPath applyTransform:CGAffineTransformMakeRotation(rotateRadin)];
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(center.x, center.y)];
    
    return bezierPath;
    
}

@end
