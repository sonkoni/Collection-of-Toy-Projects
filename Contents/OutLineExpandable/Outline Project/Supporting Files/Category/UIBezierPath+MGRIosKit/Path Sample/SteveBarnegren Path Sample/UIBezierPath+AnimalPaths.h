//
//  UIBezierPath+AnimalPaths.h
//  BezierMorph
//
//  Created by Steven Barnegren on 21/11/2014.
//  Copyright (c) 2014 Steven Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (AnimalPaths)

+ (UIBezierPath*)rhinoPathWithFrame:(CGRect)frame;
+ (UIBezierPath*)elephantPathInFrame:(CGRect)frame;
+ (UIBezierPath*)chickPathInFrame:(CGRect)frame;
+ (UIBezierPath*)chickenPathInFrame:(CGRect)frame;

@end
