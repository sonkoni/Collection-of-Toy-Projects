//
//  CAGradientLayer+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-01
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>
#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAGradientLayer (Create)

/**
 * @brief 모든 걸 다 만들 수 있다.
 * @param gradientLayerType kCAGradientLayerAxial(디폴트), kCAGradientLayerConic, kCAGradientLayerRadial
 * @param startPoint (0.5,0.0) 디폴트
 * @param endPoint (0.5,1.0) 디폴트
 * @param colors  nil 디폴트
 * @param locations ...
 * @discussion ...
 * @remark ...
 * @code
            glayer.colors = @[ (__bridge id)[UIColor   cyanColor].CGColor,
                               (__bridge id)[UIColor orangeColor].CGColor,
                               (__bridge id)[UIColor   blueColor].CGColor];
 * @endcode
*/
- (void)mgrGradientLayer:(CAGradientLayerType)gradientLayerType
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint
                  colors:(NSArray *)colors
               locations:(nullable NSArray<NSNumber *> *)locations;


//#if TARGET_OS_OSX

//#elif TARGET_OS_IPHONE
- (void)mgrAxialVerticalGradientLayerWithColors:(NSArray <MGEColor *>*)colors;   // 위에서 아래로
- (void)mgrAxialHorizontalGradientLayerWithColors:(NSArray <MGEColor *>*)colors; // 좌에서 우로
- (void)mgrConicGradientLayerWithColors:(NSArray <MGEColor *>*)colors; // 12시에서 한 바퀴
- (void)mgrRadialGradientLayerWithColors:(NSArray <MGEColor *>*)colors; // 가운데서 퍼짐.

- (void)mgrFaintlyAtBothEnds; // 양쪽끝을 희미하게 만드는 mask layer를 만들기 위해

//#endif

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-04-01 : 라이브러리 정리됨
 */
