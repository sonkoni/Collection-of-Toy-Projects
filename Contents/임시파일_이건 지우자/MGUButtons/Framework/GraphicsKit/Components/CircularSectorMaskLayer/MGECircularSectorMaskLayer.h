//
//  MGECircularSectorMaskLayer.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-11-09
//  ----------------------------------------------------------------------
//

#import <GraphicsKit/MGEBorderLayer.h>

NS_ASSUME_NONNULL_BEGIN


/*!
 //east direction
 @enum       MGRCircularSectorMaskAxisDirection
 @abstract   0.0 라디안이 되는 방향과 숫자가 매겨지는 방향
 @constant   MGRCircularSectorMaskAxisDirectionEast 디폴트이다. 동쪽이 0.0 라디안이고 숫자는 시계방향으로 각이 증가한다.
 @constant   MGRCircularSectorMaskAxisDirectionEastInverse
 @constant   MGRCircularSectorMaskAxisDirectionNorth
 @constant   MGRCircularSectorMaskAxisDirectionNorthInverse // 북쪽이 0도가 되고 반 시계방향으로 각이 증가한다.
 @constant   MGRCircularSectorMaskAxisDirectionSouth
 @constant   MGRCircularSectorMaskAxisDirectionSouthInverse
 @constant   MGRCircularSectorMaskAxisDirectionWest
 @constant   MGRCircularSectorMaskAxisDirectionWestInverse
 */
typedef NS_ENUM(NSUInteger, MGRCircularSectorMaskAxisDirection) {
    MGRCircularSectorMaskAxisDirectionEast  = 0, // 디폴트
    MGRCircularSectorMaskAxisDirectionEastInverse,
    MGRCircularSectorMaskAxisDirectionNorth,
    MGRCircularSectorMaskAxisDirectionNorthInverse,
    MGRCircularSectorMaskAxisDirectionSouth,
    MGRCircularSectorMaskAxisDirectionSouthInverse,
    MGRCircularSectorMaskAxisDirectionWest,
    MGRCircularSectorMaskAxisDirectionWestInverse
};

/*!
 @class         MGECircularSectorMaskLayer
 @abstract      마스크로 사용할 호를 만들어준다. 단순한 피자모양보다 더 세부적인 설정이 가능하다. 안쪽을 파먹은 피자모양도 가능하다.
 @discussion    0.0 라디안은 동쪽이다. 시계방향으로 증가한다.
*/
@interface MGECircularSectorMaskLayer : CALayer

@property (nonatomic, assign) CGFloat startRadian; // @dynamic Animatable.
@property (nonatomic, assign) CGFloat endRadian;   // @dynamic Animatable.
@property (nonatomic, assign) BOOL clockWise;

//! Axis : 원래 동쪽이 0라디안이고 시계방향으로 증가하는 값으로 매겨져있다.
@property (nonatomic, assign) MGRCircularSectorMaskAxisDirection axisDirection;

@property (nonatomic, assign) CGRect rectForOutOval; // @dynamic Animatable.
@property (nonatomic, assign) CGRect rectForInOval; // @dynamic Animatable.

@property(nullable) CGColorRef borderColor __attribute__((unavailable("마스크로만 사용하는 클래스이다. 사용해서는 안된다.")));
@end

NS_ASSUME_NONNULL_END

// Mini Timer 는 다음과 같은 설정으로 사용한다.
// layer.clockWise = NO;
// layer.axisDirection = MGRCircularSectorMaskAxisDirectionNorthInverse;
// start radian 은 고정. end radian 360 도이면 꽉 찬거다.
