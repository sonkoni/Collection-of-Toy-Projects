//
//  UIBezierPath+BasicShapePaths.h
//  BezierMorph
//
//  Created by Steven Barnegren on 21/11/2014.
//  Copyright (c) 2014 Steven Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (BasicShapes)

+ (UIBezierPath *)arrowPathWithCentre:(CGPoint)centre scale:(float)scale;
+ (UIBezierPath *)plusSignPathWithCentre:(CGPoint)centre scale:(float)scale;
+ (UIBezierPath *)tPathWithCentre:(CGPoint)centre scale:(float)scale;

@end
