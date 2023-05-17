//
//  UIBezierPath+MGRRegularPolygon.h
//  BEZIERTEST
//
//  Created by Kwan Hyun Son on 15/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (RegularPolygon)

/**
* 원이 주어졌을 때. 그 원 내부에서 딱 들어맞는 정다각형을 만든다.
* @param center  다각형의 중심.(가정한 가상의 원의 중심)
* @param radius  가정한 가상의 원의 반지름.
* @param numberOfSides  변의 갯수
* @return 다각형에 해당하는 bezier path를 반환한다.
*/
+ (UIBezierPath *)bezierPathWithRegularPolygonAtCenter:(CGPoint)center
                                                radius:(CGFloat)radius
                                         numberOfSides:(NSUInteger)numberOfSides;

/**
* 원이 주어졌을 때. 그 원 외부에서 딱 들어맞는 정다각형을 만든다.
* @param center  다각형의 중심.(가정한 가상의 원의 중심)
* @param radius  가정한 가상의 원의 반지름.
* @param numberOfSides  변의 갯수
* @return 다각형에 해당하는 bezier path를 반환한다.
*/
+ (UIBezierPath *)bezierPathWithBigRegularPolygonAtCenter:(CGPoint)center
                                                   radius:(CGFloat)radius
                                            numberOfSides:(NSUInteger)numberOfSides;


//! 심화 - 회전을 넣어본다. 360˚ 회전이 아니라. 원점을 중심으로 회전했을 때, 나올 수 있는 모양의 전부를 의미한다.
//! 꼭지점에서 다음 꼭지점까지의 회전이다. ratio(0.0 ~ 1.0)으로 표현한다.

+ (UIBezierPath *)bezierPathWithRegularPolygonAtCenter:(CGPoint)center
                                                radius:(CGFloat)radius
                                         numberOfSides:(NSUInteger)numberOfSides
                                           rotateRatio:(CGFloat)rotateRatio;

+ (UIBezierPath *)bezierPathWithBigRegularPolygonAtCenter:(CGPoint)center
                                                   radius:(CGFloat)radius
                                            numberOfSides:(NSUInteger)numberOfSides
                                              rotateRatio:(CGFloat)rotateRatio;

@end

NS_ASSUME_NONNULL_END
