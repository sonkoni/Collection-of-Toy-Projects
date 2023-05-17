//
//  UIBezierPath+BezierCreator.h
//  BezierMorph
//
//  Created by Steven Barnegren on 20/06/2014.
//  Copyright (c) 2014 Steven Barnegren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Transform)

/**
* UIBezierPath를 원하는 스케일로 바꿔준다. (자신의 센터 중심)
* @param xy 늘어나거나 줄어들 비율. ex) 1.0이면 그대로.
* @param frameSize 리시버가 그려진 프레임의 사이즈에 해당한다. 원래 그려져있던.
* @discussion 우선은 정사각형을 가정한다.
*/
- (void)mgrApplyTransformScaleXY:(CGFloat)xy frameSize:(CGSize)frameSize;

/**
* UIBezierPath를 원하는 각으로 회전한다. (자신의 센터 중심)
* @param angle 회전가는 각. 라디안
* @param frameSize 리시버가 그려진 프레임의 사이즈에 해당한다. 원래 그려져있던.
* @discussion 우선은 정사각형을 가정한다.
*/
- (void)mgrApplyTransformRotateAngle:(CGFloat)angle frameSize:(CGSize)frameSize;

/**
* Paint Code 앱에서 만든 UIBezierPath를 이식한다. 프레임 자체의 차이에 따른 transform을 해준다.
* @param paintSize Paint Code 앱에서 만든 사이즈를 의미한다.
* @param toFrameSize 리시버가 이제 그려질 프레임의 사이즈를 의미한다.
* @discussion 우선은 정사각형을 가정한다. 리시버는 Paint Code 앱에서 만든 UIBezierPath이며, 메서드를 실행하면, 변화된다.
 선의 굵기는 변하지 않는다.
*/
- (void)mgrApplyTransformFromPaintSize:(CGSize)paintSize toFrameSize:(CGSize)toFrameSize;

/**
 * @brief 리시버(UIBezierPath 인스턴스)를 주어진 스케일로 줄이거나 늘린다. 이때, 늘리거나 줄이는 중심점은 centerPoint이다.
 * @param scale 늘리거나 줄여야할 비율을 의미한다.
 * @param centerPoint 늘리거나 줄일때의 앵커 포인트이다.
 * @discussion 원하는 앵커포인트를 중심으로 리시버(UIBezierPath 인스턴스)를 늘리거나 줄인다.
 * @code
    [self mgrBezierPathWithScale:0.7 aroundPoint:CGPointMake(35.0, 55.0)];
 * @endcode
 * @remark 내가 만든 메서드가 아니다.
 * @return 반환 값은 앵커포인트(centerPoint) 를 중심으로 주어진 스케일로 줄이거나 늘린려서 만들어진 베지어 패스이다.
*/
- (UIBezierPath *)mgrBezierPathWithScale:(float)scale
                             aroundPoint:(CGPoint)centerPoint;

@end
//
// - (UIBezierPath *)mgrReverseBezierPath; 애플 메서드(- bezierPathByReversingPath) 존재하므로 주석처리한다.
