//
//  MGEGeometryHelper.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-03
//  ----------------------------------------------------------------------
//

#ifndef MGEGeometryHelper_h
#define MGEGeometryHelper_h
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

// 좌우 반전
#define CGAffineTransform_Reverse_Left_And_Right  (CGAffineTransformScale(CGAffineTransformIdentity, -1.0, 1.0))
#define CATransform3D_Reverse_Left_And_Right      (CATransform3DScale(CATransform3DIdentity, -1.0, 1.0, 1.0))

// 상하 반전
#define CGAffineTransform_Upside_Down             (CGAffineTransformScale(CGAffineTransformIdentity, 1.0, -1.0))
#define CATransform3D_Upside_Down                 (CATransform3DScale(CATransform3DIdentity, 1.0, -1.0, 1.0))
// CATransform3D     : layer.transform, view.transform3D
// CGAffineTransform : layer.affineTransform, view.transform


NS_ASSUME_NONNULL_BEGIN

#pragma mark - NSInteger CGFloat CGPoint - Null Extention
CG_EXTERN const NSInteger MGEIntegerNull;
CG_EXTERN const BOOL MGEIntegerIsNull(NSInteger value);
CG_EXTERN const CGFloat MGEFloatNull;
CG_EXTERN const BOOL MGEFloatIsNull(CGFloat value);
CG_EXTERN const CGPoint MGEPointNull;
CG_EXTERN const BOOL MGEPointIsNull(CGPoint point);

// CGPoint <---- 반환 : MGERectGet___ : Rect로부터 얻어지는 어느 것을 반환할 때 Get
// CGRect  <---- 반환 : MGERect______ : Rect 가 반환형일 때

#pragma mark - linear interpolation : MGELerp_
CGFloat MGELerpDouble(CGFloat progress, CGFloat from, CGFloat to);
CGPoint MGELerpPoint(CGFloat progress, CGPoint from, CGPoint to);
CGPoint MGELerpPointMid(CGPoint from, CGPoint to);
CGSize MGELerpSize(CGFloat progress, CGSize from, CGSize to);
CGRect MGELerpRect(CGFloat progress, CGRect from, CGRect to);
CATransform3D MGELerpTransform3D(CGFloat progress, CATransform3D from, CATransform3D to); // 선형적으로 변환한다.

//! 사용 후 CGColorRelease(CGColorRef  _Nullable color) 해줘야한다.
CGColorRef MGELerpCreateColor(CGFloat progress, CGColorRef from, CGColorRef to);

#pragma mark - 현재 Progress 추출. : MGEProgress_ from ~ to 까지의 범위에서 현재 current 값일 때의 progress [0.0 1.0]를 추출해준다.
CGFloat MGEProgressLerpDouble(CGFloat from, CGFloat to, CGFloat current);
CGFloat MGEProgressLerpPoint(CGPoint from, CGPoint to, CGPoint current);
CGFloat MGEProgressLerpSize(CGSize from, CGSize to, CGSize current);
CGFloat MGEProgressLerpRect(CGRect from, CGRect to, CGRect current);
CGFloat MGEProgressLerpColor(CGColorRef from, CGColorRef to, CGColorRef current);


#pragma mark - Normalize : MGENormalized_ // 단위 길이(크기)로 바꾼다.
//! 방향은 유지하면서 길이가 1인 벡터로 생각하고 만든다.
CGPoint MGENormalizedPoint(CGPoint point);

//! 방향은 유지하면서 길이가 1인 벡터로 만든다.
CGVector MGENormalizedVector(CGVector vector);


#pragma mark - linear distance : MGEDistance_
CGFloat MGEDistanceToDouble(CGFloat one, CGFloat theOther);
CGFloat MGEDistanceToCGPoint(CGPoint one, CGPoint theOther);
CGFloat MGEDistanceFromZeroToPoint(CGPoint theOther); // CGPointZero와의 거리


#pragma mark - 일반도형 : MGERect_, MGETriangle_
/// Rect의 중심 포인트를 반환
CGPoint MGERectGetCenter(CGRect rect);

//! 삼각형의 무게중심을 반환한다.
CGPoint MGETriangleGetCenterOfGravity(CGPoint a, CGPoint b, CGPoint c);

//! 배열로 주어진 포인트들의 평균 point를 반환한다. 인수 : 일반적으로 bezier path에 대한 잘게 쪼갠 point에 대한 배열
CGPoint MGEPointsGetAveragePoint(NSArray <NSValue *>*points);


#pragma mark - 사각형 구성 : MGERect_
/// center 를 중심으로 하는 size 의 사각형 반환
CGRect MGERectAroundCenter(CGPoint center, CGSize size);

/// 사각형의 중심점을 공유하는 사각형 반환 : destRect의 center를 sourceRect center로 옮긴 rect를 반환한다.
CGRect MGERectCenteredInRect(CGRect sourceRect, CGRect destRect);

/// 사각형의 중심점을 공유하는 사각형 반환 : destSize의 center를 sourceRect center로 옮긴 rect를 반환한다.
CGRect MGERectCenteredInRectSize(CGRect sourceRect, CGSize destSize);

/// sourceRect와 중심점이 같으면서 크기의 변화를 준 rect 반환. MGERectPercent(sourceRect, 0.5, 0.5); 이면 크기가 반이며 중심이 같다.
CGRect MGERectPercent(CGRect sourceRect, CGFloat percentWidth, CGFloat percentHeight);

//! iOS의 frame을 MacOS의 frame으로 바꿔준다.
CGRect MGERectForMacFromIosRect(CGRect iosRect, CGFloat superHeight);

//! MacOS의 frame을 iOS의 frame으로 바꿔준다.
CGRect MGERectForIosFromMacRect(CGRect macRect, CGFloat superHeight);


#pragma mark - 배율 : MGESize_, MGEAspect_ MGEPoint_
/// factor 배율의 size 를 반환
CGSize MGESizeScaleByFactor(CGSize aSize, CGFloat factor);

/// source 크기 대비 dest 크기는 몇 배율의 사이즈인지 반환
CGSize MGESizeScaleBothRect(CGRect sourceRect, CGRect destRect);

/// factor 배율의 point 를 반환 : 단순 곱이다.
CGPoint MGEPointScaleByFactor(CGPoint point, CGFloat factor);

/// sourceRect를 destRect로 fill 하기 위한 scale 값 반환
/// @discussion fill 은 destRect를 sourceRect로 완전히 덮는다는 뜻이다. 따라서 destRect 의 긴축이 sourceRect 의 짧은축이 된다. 만약 프레임이 destRect 로 제한되어 있다면, sourceRect는 짧은축 부분은 다 보이지만 긴축 부분은 짤리게 된다.
CGFloat MGEAspectScaleFill(CGSize sourceSize, CGRect destRect);

/// sourceRect를 destRect에 fit 하기 위한 scale 값 반환
/// @discussion fit 은 destRect 내부에 sourceRect를 넣는다는 뜻이다. 따라서 destRect 의 짧은축이 sourceRect 의 긴축이 된다.
CGFloat MGEAspectScaleFit(CGSize sourceSize, CGRect destRect);


#pragma mark - 피팅 : MGERect_
/// sourceRect 를 destRect 의 센터에 맞춰 fill 해준 Rect 를 반환
/// @discussion fill 은 destRect를 sourceRect로 완전히 덮는다는 뜻이다. 따라서 destRect 의 긴축이 sourceRect 의 짧은축이 된다. 만약 프레임이 destRect 로 제한되어 있다면, sourceRect는 짧은축 부분은 다 보이지만 긴축 부분은 짤리게 된다.
CGRect MGERectByFillingRect(CGRect sourceRect, CGRect destRect);

/// sourceRect 를 destRect 의 센터에 맞춰 fit 해준 Rect 를 반환
/// @discussion fit 은 destRect 내부에 sourceRect를 넣는다는 뜻이다. 따라서 destRect 의 짧은축이 sourceRect 의 긴축이 된다.
CGRect MGERectByFittingRect(CGRect sourceRect, CGRect destRect);

/// sourceRect에 내부에 접하는 정사각형. 센터가 동일하다.
CGRect MGERectSquareByFittingRect(CGRect destRect);


#pragma mark - 트랜스폼 : MGETransform_ CGAffineTransform - view, MGETransform3D_ CATransform3D - layer
/// 트랜스폼으로부터 x scale 을 추출. 음수도 추출하는 방법을 메모해 두었다.
CGFloat MGETransformGetXScale(CGAffineTransform t);

/// 트랜스폼으로부터 y scale 을 추출. 음수도 추출하는 방법을 메모해 두었다.
CGFloat MGETransformGetYScale(CGAffineTransform t);

/// 트랜스폼으로부터 회전각 추출
CGFloat MGETransformGetRotation(CGAffineTransform t);

/// 트랜스폼으로부터 이동량 추출
CGPoint MGETransformGetTranslation(CGAffineTransform t);

/**
* 주어진 transform로 인하여 기존의 벡터가 어떻게 변화되는가
* @param t CGAffineTransform 형의 구조체
* @param vector 기존의 벡터
* @code
  CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
  CGVector vector = MGETransformGetVector(transform, CGVectorMake(0.0, 1.0)); // y 축이 어떻게 변화되는가.
  NSLog(@"변화된 벡터 좌표: %f %f", vector.dx, vector.dy);
 @endcode
* @return 주어진 transform의 따라 변화된 벡터를 반환한다.
*/
CGVector MGETransformGetVector(CGAffineTransform t, CGVector vector);

//------------------------------------------------------------------------------------------
/**
* 주어진 transform의 스케일을 반환한다.
* @param transform CATransform3D 형의 구조체
* @code
 if (self.layer.presentationLayer != nil) { // x 스케일에 관하여
     CATransform3D transform  = self.layer.presentationLayer.transform;
     expandAnimation.fromValue = @(transform.m11); // <- 현재 스케일에 해당한다.
 }
 @endcode
* @return 주어진 transform의 스케일을 반환한다.
*/
CGFloat MGETransform3DGetXScale(CATransform3D transform);
CGFloat MGETransform3DGetYScale(CATransform3D transform);
CGFloat MGETransform3DGetZScale(CATransform3D transform);

CGFloat MGETransform3DGetXTranslation(CATransform3D transform);
CGFloat MGETransform3DGetYTranslation(CATransform3D transform);
CGFloat MGETransform3DGetZTranslation(CATransform3D transform);

/**
* 주어진 transform의 회전각을 반환한다.
* @param transform CATransform3D 형의 구조체
* @code
 if (self.layer.presentationLayer != nil) { // z 축에 관하여
     CATransform3D transform  = self.layer.presentationLayer.transform;
     expandAnimation.fromValue = @(atan2(transform.m12, transform.m11));
 }
 @endcode
* @return 주어진 transform의 회전각을 반환한다.
*/
CGFloat MGETransform3DGetZRotationAngle(CATransform3D transform);
CGFloat MGETransform3DGetXRotationAngle(CATransform3D transform);
CGFloat MGETransform3DGetYRotationAngle(CATransform3D transform);

/**
* 주어진 transform로 인하여 기존의 벡터가 어떻게 변화되는가
* @param t CATransform3D 형의 구조체
* @param vector 기존의 벡터
* @discussion x, y, z를 담을 자료형이 필요해서 CIVector(객체)를 사용했다. 별다른 이유는 없다.
* @code
  CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0.0, 0.0, 1.0); // z 축을 중심으로 돌릴때
  CIVector *vector = MGETransform3DGetVector(transform, [CIVector vectorWithX:0.0 Y:1.0 Z:0.0]); // y 축이 어떻게 변화되는가.
  NSLog(@"변화된 벡터 좌표: %f %f %f", vector.X, vector.Y, vector.Z);
 @endcode
* @return 주어진 transform의 따라 변화된 벡터를 반환한다.
*/
CIVector * MGETransform3DGetVector(CATransform3D t, CIVector *vector);


#pragma mark - Rotate Point About Origin : MGERotatePoint_
//! 원점(0.0, 0.0)을 중심으로 회전. x축 위에 있는 점을 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGERotatePoint(CGPoint endPoint, CGFloat radian);

//! center를 중심으로 회전. 점 A를 시계방향(radian이 양수이면)으로 회전시킴.
CGPoint MGERotatePointAboutCenter(CGPoint center, CGPoint A, CGFloat radian);

//! x축과의 각. center를 중심으로 x축(양의 방향)과 점 A의 각(radian)을 알려준다.
CGFloat MGERotationAngleAboutCenter(CGPoint center, CGPoint A);


#pragma mark - Random Function : MGERandom_
CGPoint MGERandomPositionForSize(CGSize size);


#pragma mark - Etc
//! 단순히 CGPoint를 CGVector로 바꾼다.
CGVector MGEVectorFromPoint(CGPoint point);

//! 단순히 CGVector를 CGPoint로 바꾼다.
CGPoint MGEPointFromVector(CGVector vector);

//! Degree를 Radian으로 바꾼다.
CGFloat MGERadianFromDegree(CGFloat degree);

//! Radian을 Degree으로 바꾼다.
CGFloat MGEDegreeFromRadian(CGFloat radian);

//! CGPath 관련.
/**
 * @brief               CGPathCreateWithRoundedRect 함수의 부족한점을 보완하기 위해 만들어졌다. CACornerMask를 설정할 수 있다.
 * @param rect          ...
 * @param cornerRadius  ...
 * @param maskedCorners ...
 * @param transform     ...
 * @discussion          CACornerMask 가 존재하는 함수가 없어서 직접 만들었다.
 * @remark ...
 * @code
    ....
    // 사용 후 릴리즈 필수
    self.shapeLayer.path = myCGPath;
    CGPathRelease(myCGPath); /// 반드시 Release 해야한다. 그리는 주체가 C이다.
 
 * @endcode
 * @return 원하는 방향에 주어진 라디어스를 적용한 Rounded Rect Path를 반환한다.
*/
extern const CGPathRef MGEPathCreateWithRoundedRect(CGRect rect,
                                                    CGFloat cornerRadius,
                                                    CACornerMask maskedCorners,
                                                    const CGAffineTransform * __nullable transform);

/* Swift Standard Library의 Stride 함수의 Objective - C 버전이다. 사용법은 Swift - Document 참고하라.
func stride<T>(
    from start: T,
    to end: T,
    by stride: T.Stride
) -> StrideTo<T> where T : Strideable
*/
NSArray <NSNumber *>* MGEStrideFloat(CGFloat from, CGFloat to, CGFloat by);
NSArray <NSNumber *>*MGEStrideInt(NSInteger from, NSInteger to, NSInteger by);

NS_ASSUME_NONNULL_END
#endif /* MGEGeometryHelper_h */
/* ----------------------------------------------------------------------
 
 * 2021-10-08 : MGEPathCreateWithRoundedRect 추가
 * 2021-04-23 : CGRect MGERectCenteredInRectSize(CGRect sourceRect, CGSize destSize) 추가
 */


/** https://developer.apple.com/documentation/coregraphics/cgaffinetransform?language=objc
                ┌ a  b  0 ┐
    [ x y 1 ] * │ c  d  0 │ = [ x′ y′ 1 ]
                └ tx ty 1 ┘
coordinate  CGAffineTransform  transformed coordinate
 */

/** https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html
    https://www.icode9.com/content-4-24811.html
               ┌ m11 m12 m13 m14 ┐
 [ x y z 1 ] * │ m21 m22 m23 m24 │ = [ x′ y′ z′ 1 ]
               │ m31 m32 m33 m34 │
               └ m41 m42 m43 m44 ┘
 coordinate       CATransform3D       transformed coordinate
*/

/*
Rotation about the z-axis is represented as:
a  = angle in radians
x' = x*cos.a - y*sin.a
y' = x*sin.a + y*cos.a
z' = z

 ┌ cos.a  sin.a  0  0 ┐
 │-sin.a  cos.a  0  0 │
 │ 0        0    1  0 │
 └ 0        0    0  1 ┘
 
 a = atan2(transform.m12, transform.m11);
*/

/*
Rotation about the x-axis is represented as:
a  = angle in radians
y' = y*cos.a - z*sin.a
z' = y*sin.a + z*cos.a
x' = x

 ┌ 1    0      0    0 ┐
 │ 0  cos.a  sin.a  0 │
 │ 0 -sin.a  cos.a  0 │
 └ 0    0     0     1 ┘
 
 a = atan2(transform.m23, transform.m22);
*/

/*
Rotation about the y-axis is represented as:
a  = angle in radians
z' = z*cos.a - x*sin.a
x' = z*sin.a + x*cos.a
y' = y

 ┌ cos.a  0  -sin.a   0 ┐
 │ 0      1    0      0 │
 │ sin.a  0  cos.a    0 │
 └ 0      0    0      1 ┘
 
 a = atan2(transform.m31, transform.m11);
*/

/*
 Scale:
 ┌ sx  0  0  0 ┐
 │ 0  sy  0  0 │
 │ 0  0  sz  0 │
 └ 0  0  0   1 ┘
*/

/*
 Translation:
 ┌ 1  0  0   0 ┐
 │ 0  1  0   0 │
 │ 0  0  1   0 │
 └ tx ty tz  1 ┘
*/

/*
 _transformIdentity = (CATransform3D){.m11 = 1, .m12 = 0, .m13 = 0, .m14 = 0,
                                      .m21 = 0, .m22 = 1, .m23 = 0, .m24 = 0,
                                      .m31 = 0, .m32 = 0, .m33 = 1, .m34 = 0,
                                      .m41 = 0, .m42 = 0, .m43 = 0, .m44 = 1};
*/

/*
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
