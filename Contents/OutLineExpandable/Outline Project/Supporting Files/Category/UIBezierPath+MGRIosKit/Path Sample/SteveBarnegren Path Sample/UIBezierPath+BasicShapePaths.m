//
//  UIBezierPath+BasicShapePaths.m
//  BezierMorph
//
//  Created by Steven Barnegren on 21/11/2014.
//  Copyright (c) 2014 Steven Barnegren. All rights reserved.
//

#import "UIBezierPath+BasicShapePaths.h"

@implementation UIBezierPath (BasicShapes)

+ (UIBezierPath*)arrowPathWithCentre:(CGPoint)centre scale:(float)scale{
    /*
     UIBezierPath *path = [[UIBezierPath alloc]init];
     
     [path moveToPoint:CGPointMake(centre.x, centre.y - (2*scale))];
     [path addLineToPoint:CGPointMake(centre.x, centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x + (2*scale), centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x + (2*scale), centre.y + (scale))];
     [path addLineToPoint:CGPointMake(centre.x, centre.y + (scale))];
     [path addLineToPoint:CGPointMake(centre.x, centre.y + (2*scale))];
     [path addLineToPoint:CGPointMake(centre.x -(2 * scale), centre.y)];
     [path closePath];
     
     return path;
     */
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    [path moveToPoint:CGPointMake(centre.x -(2 * scale), centre.y)];
    [path addLineToPoint:CGPointMake(centre.x, centre.y + (2*scale))];
    [path addLineToPoint:CGPointMake(centre.x, centre.y + (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (2*scale), centre.y + (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (2*scale), centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x, centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x, centre.y - (2*scale))];
    
    [path closePath];
    
    return path;
}

+ (UIBezierPath*)plusSignPathWithCentre:(CGPoint)centre scale:(float)scale{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centre.x - (3 * scale), centre.y + (scale))];
    [path addLineToPoint:CGPointMake(centre.x - (3 * scale), centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x - (scale), centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x - (scale), centre.y - (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x + (scale), centre.y - (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x + (scale), centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (3 * scale), centre.y - (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (3 * scale), centre.y + (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (scale), centre.y + (scale))];
    [path addLineToPoint:CGPointMake(centre.x + (scale), centre.y + (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x - (scale), centre.y + (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x - (scale), centre.y + (scale))];
    [path closePath];
    return path;
    
    
    /*
     UIBezierPath *path = [[UIBezierPath alloc]init];
     [path moveToPoint:CGPointMake(centre.x -(scale), centre.y + (scale))];
     [path addLineToPoint:CGPointMake(centre.x -(scale), centre.y + (3*scale))];
     [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y + (3*scale))];
     [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y + (scale))];
     [path addLineToPoint:CGPointMake(centre.x +(3*scale), centre.y + (scale))];
     [path addLineToPoint:CGPointMake(centre.x +(3*scale), centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y - (3*scale))];
     [path addLineToPoint:CGPointMake(centre.x -(scale), centre.y - (3*scale))];
     [path addLineToPoint:CGPointMake(centre.x -(scale), centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x -(3*scale), centre.y - (scale))];
     [path addLineToPoint:CGPointMake(centre.x -(3*scale), centre.y + (scale))];
     [path closePath];
     return path;
     */

}

+ (UIBezierPath*)tPathWithCentre:(CGPoint)centre scale:(float)scale{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(centre.x -(3*scale), centre.y + (2*scale))];
    [path addLineToPoint:CGPointMake(centre.x -(3*scale), centre.y)];
    [path addLineToPoint:CGPointMake(centre.x -(scale), centre.y)];
    [path addLineToPoint:CGPointMake(centre.x -(scale), centre.y - (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y - (3*scale))];
    [path addLineToPoint:CGPointMake(centre.x +(scale), centre.y)];
    [path addLineToPoint:CGPointMake(centre.x +(3*scale), centre.y)];
    [path addLineToPoint:CGPointMake(centre.x +(3*scale), centre.y + (2*scale))];
    [path closePath];
    return path;
}

@end

