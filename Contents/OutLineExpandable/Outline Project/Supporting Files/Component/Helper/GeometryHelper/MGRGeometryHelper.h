//
//  MGRGeometryHelper.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-04-23
//  ----------------------------------------------------------------------
//

#ifndef MGRGeometryHelper_h
#define MGRGeometryHelper_h
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_OSX
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

// CGPoint <---- 반환 : MGRRectGet___ : Rect로부터 얻어지는 어느 것을 반환할 때 Get
// CGRect  <---- 반환 : MGRRect______ : Rect 가 반환형일 때

#pragma mark - linear interpolation : MGRLerp_
CGFloat MGRLerpDouble(CGFloat progress, CGFloat from, CGFloat to);
CGPoint MGRLerpPoint(CGFloat progress, CGPoint from, CGPoint to);
CGPoint MGRLerpPointMid(CGPoint from, CGPoint to);
CGSize MGRLerpSize(CGFloat progress, CGSize from, CGSize to);
CGRect MGRLerpRect(CGFloat progress, CGRect from, CGRect to);

//! 사용 후 CGColorRelease(CGColorRef  _Nullable color) 해줘야한다.
CGColorRef MGRLerpCreateColor(CGFloat progress, CGColorRef from, CGColorRef to);


#pragma mark - Normalize : MGRNormalized_ // 단위 길이(크기)로 바꾼다.
//! 방향은 유지하면서 길이가 1인 벡터로 생각하고 만든다.
CGPoint MGRNormalizedPoint(CGPoint point);

//! 방향은 유지하면서 길이가 1인 벡터로 만든다.
CGVector MGRNormalizedVector(CGVector vector);


#pragma mark - linear distance : MGRDistance_
CGFloat MGRDistanceToDouble(CGFloat one, CGFloat theOther);
CGFloat MGRDistanceToCGPoint(CGPoint one, CGPoint theOther);
CGFloat MGRDistanceFromZeroToPoint(CGPoint theOther); // CGPointZero와의 거리


#pragma mark - 일반도형 : MGRRect_, MGRTriangle_
/// Rect의 중심 포인트를 반환
CGPoint MGRRectGetCenter(CGRect rect);

//! 삼각형의 무게중심을 반환한다.
CGPoint MGRTriangleGetCenterOfGravity(CGPoint a, CGPoint b, CGPoint c);

//! 배열로 주어진 포인트들의 평균 point를 반환한다. 인수 : 일반적으로 bezier path에 대한 잘게 쪼갠 point에 대한 배열
CGPoint MGRPointsGetAveragePoint(NSArray <NSValue *>*points);


#pragma mark - 사각형 구성 : MGRRect_
/// center 를 중심으로 하는 size 의 사각형 반환
CGRect MGRRectAroundCenter(CGPoint center, CGSize size);

/// 사각형의 중심점을 공유하는 사각형 반환 : destRect의 center를 sourceRect center로 옮긴 rect를 반환한다.
CGRect MGRRectCenteredInRect(CGRect sourceRect, CGRect destRect);

/// 사각형의 중심점을 공유하는 사각형 반환 : destSize의 center를 sourceRect center로 옮긴 rect를 반환한다.
CGRect MGRRectCenteredInRectSize(CGRect sourceRect, CGSize destSize);

/// sourceRect와 중심점이 같으면서 크기의 변화를 준 rect 반환. MGRRectPercent(sourceRect, 0.5, 0.5); 이면 크기가 반이며 중심이 같다.
CGRect MGRRectPercent(CGRect sourceRect, CGFloat percentWidth, CGFloat percentHeight);


#pragma mark - 배율 : MGRSize_, MGRAspect_ MGRPoint_
/// factor 배율의 size 를 반환
CGSize MGRSizeScaleByFactor(CGSize aSize, CGFloat factor);

/// source 크기 대비 dest 크기는 몇 배율의 사이즈인지 반환
CGSize MGRSizeScaleBothRect(CGRect sourceRect, CGRect destRect);

/// factor 배율의 point 를 반환 : 단순 곱이다.
CGPoint MGRPointScaleByFactor(CGPoint point, CGFloat factor);

/// sourceRect를 destRect로 fill 하기 위한 scale 값 반환
/// @discussion fill 은 destRect를 sourceRect로 완전히 덮는다는 뜻이다. 따라서 destRect 의 긴축이 sourceRect 의 짧은축이 된다. 만약 프레임이 destRect 로 제한되어 있다면, sourceRect는 짧은축 부분은 다 보이지만 긴축 부분은 짤리게 된다.
CGFloat MGRAspectScaleFill(CGSize sourceSize, CGRect destRect);

/// sourceRect를 destRect에 fit 하기 위한 scale 값 반환
/// @discussion fit 은 destRect 내부에 sourceRect를 넣는다는 뜻이다. 따라서 destRect 의 짧은축이 sourceRect 의 긴축이 된다.
CGFloat MGRAspectScaleFit(CGSize sourceSize, CGRect destRect);


#pragma mark - 피팅 : MGRRect_
/// sourceRect 를 destRect 의 센터에 맞춰 fill 해준 Rect 를 반환
/// @discussion fill 은 destRect를 sourceRect로 완전히 덮는다는 뜻이다. 따라서 destRect 의 긴축이 sourceRect 의 짧은축이 된다. 만약 프레임이 destRect 로 제한되어 있다면, sourceRect는 짧은축 부분은 다 보이지만 긴축 부분은 짤리게 된다.
CGRect MGRRectByFillingRect(CGRect sourceRect, CGRect destRect);

/// sourceRect 를 destRect 의 센터에 맞춰 fit 해준 Rect 를 반환
/// @discussion fit 은 destRect 내부에 sourceRect를 넣는다는 뜻이다. 따라서 destRect 의 짧은축이 sourceRect 의 긴축이 된다.
CGRect MGRRectByFittingRect(CGRect sourceRect, CGRect destRect);

/// sourceRect에 내부에 접하는 정사각형. 센터가 동일하다.
CGRect MGRRectSquareByFittingRect(CGRect destRect);


#pragma mark - 트랜스폼 : MGRTransform_ CGAffineTransform - view, CATransform3D - layer
/// 트랜스폼으로부터 x scale 을 추출
CGFloat MGRTransformGetXScale(CGAffineTransform t);

/// 트랜스폼으로부터 y scale 을 추출
CGFloat MGRTransformGetYScale(CGAffineTransform t);

/// 트랜스폼으로부터 x scale 을 추출
CGFloat MGRTransformGetRotation(CGAffineTransform t);

//------------------------------------------------------------------------------------------
/**
* 주어진 transform의 스케일을 반환한다.
* @param transform CATransform3D 형의 구조체
* @code
 if (self.layer.presentationLayer != nil) {
     CATransform3D transform  = self.layer.presentationLayer.transform;
     expandAnimation.fromValue = @(transform.m11); // <- 현재 스케일에 해당한다.
 }
 @endcode
* @return 주어진 transform의 스케일을 반환한다.
*/
CGFloat MGRTransform3DGetScale(CATransform3D transform);

/**
* 주어진 transform의 회전각을 반환한다.
* @param transform CATransform3D 형의 구조체
* @code
 if (self.layer.presentationLayer != nil) {
     CATransform3D transform  = self.layer.presentationLayer.transform;
     expandAnimation.fromValue = @(atan2(transform.m12, transform.m11));
 }
 @endcode
* @return 주어진 transform의 회전각을 반환한다.
*/
CGFloat MGRTransform3DGetRotationAngle(CATransform3D transform);


#pragma mark - Rotate Point About Origin : MGRRotatePoint_
//! 원점(0.0, 0.0)을 중심으로 회전. x축 위에 있는 점을 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGRRotatePoint(CGPoint endPoint, CGFloat radian);

//! center를 중심으로 회전. 점 A를 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGRRotatePointAboutCenter(CGPoint center, CGPoint A, CGFloat radian);

//! x축과의 각. center를 중심으로 x축(양의 방향)과 점 A의 각(radian)을 알려준다.
CGFloat MGRRotationAngleAboutCenter(CGPoint center, CGPoint A);


#pragma mark - Random Function : MGRRandom_
CGPoint MGRRandomPositionForSize(CGSize size);


#pragma mark - Etc
//! 단순히 CGPoint를 CGVector로 바꾼다.
CGVector MGRVectorFromPoint(CGPoint point);

//! 단순히 CGVector를 CGPoint로 바꾼다.
CGPoint MGRPointFromVector(CGVector vector);

//! Degree를 Radian으로 바꾼다.
CGFloat MGRRadianFromDegree(CGFloat degree);

//! Radian을 Degree으로 바꾼다.
CGFloat MGRDegreeFromRadian(CGFloat radian);

NS_ASSUME_NONNULL_END
#endif /* MGRGeometryHelper_h */
/* ----------------------------------------------------------------------
 * 2021-04-23 : CGRect MGRRectCenteredInRectSize(CGRect sourceRect, CGSize destSize) 추가
 */



/*
[m11 m12 m13 m14]
[m21 m22 m23 m24]
[m31 m32 m33 m34]
[m41 m42 m43 m44]
*/

/*
Rotation about the z-axis is represented as:
a  = angle in radians
x' = x*cos.a - y*sin.a
y' = x*sin.a + y*cos.a
z' = z

( cos.a  sin.a  0  0)
(-sin.a  cos.a  0  0)
( 0        0    1  0)
( 0        0    0  1)
 
 a = atan2(transform.m12, transform.m11);
*/

/*
Rotation about the x-axis is represented as:
a  = angle in radians
y' = y*cos.a - z*sin.a
z' = y*sin.a + z*cos.a
x' = x

(1    0      0    0)
(0  cos.a  sin.a  0)
(0 -sin.a  cos.a  0)
(0    0     0     1)
 
*/

/*
Rotation about the y-axis is represented as:
a  = angle in radians
z' = z*cos.a - x*sin.a
x' = z*sin.a + x*cos.a
y' = y

(cos.a  0  -sin.a   0)
(0      1    0      0)
(sin.a  0  cos.a    0)
(0      0    0      1)

 
 _transformIdentity = (CATransform3D){.m11 = 1, .m12 = 0, .m13 = 0, .m14 = 0,
                                      .m21 = 0, .m22 = 1, .m23 = 0, .m24 = 0,
                                      .m31 = 0, .m32 = 0, .m33 = 1, .m34 = 0,
                                      .m41 = 0, .m42 = 0, .m43 = 0, .m44 = 1};
 
 - (void)setEyePosition:(CGFloat)eyePosition {
     _eyePosition = eyePosition;
     CATransform3D transform = CATransform3DIdentity;
     transform.m34 = -1 / eyePosition;
     self.collectionView.layer.sublayerTransform = transform;
     //
     // m34는 객체의 원근감을 준다.
     // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AdvancedAnimationTricks/AdvancedAnimationTricks.html#//apple_ref/doc/uid/TP40004514-CH8-SW13
 }
*/
