//
//  MGEInvertStrokeMaskLayer.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-03
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/38729101/invert-calayer-mask-that-is-based-on-a-stroke-no-fill

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGEInvertStrokeMaskLayer
 @abstract      선분을 그리고 선분의 여집합을 마스크로 사용할 수 있도록 만든 레이어이다.
 @discussion    ...
*/
@interface MGEInvertStrokeMaskLayer : CALayer

@property (nonatomic, assign) CGPathRef path;
@property (nonatomic, assign) CGColorRef fillColor;
@property (nonatomic, assign) CGColorRef strokeColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGLineCap lineCap; // 디폴트 kCGLineCapRound
@property (nonatomic, assign) CGLineJoin lineJoin; // 디폴트 kCGLineJoinRound
@end

NS_ASSUME_NONNULL_END
