//
//  MGEBorderLayer.h
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/10/07.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGEBorderFillType
 @abstract   border를 어떻게 채울 것인가.
 @constant   MGEBorderFillTypeFlat           단색으로 채운다.
 @constant   MGEBorderFillTypeLinearGradient 그래디언트로 채운다.
 */
typedef NS_ENUM(NSUInteger, MGEBorderFillType) {
    MGEBorderFillTypeFlat = 1,
    MGEBorderFillTypeLinearGradient
} ;

/*!
 @enum       MGEBorderRadiusType
 @abstract   corner Radius를 어떻게 그릴 것인가.
 @constant   MGEBorderRadiusTypeNormal  일반적인 layer의 corner radius의 방식대로 그린다.
 @constant   MGEBorderRadiusTypeScale   스케일을 줄인다.
 */
typedef NS_ENUM(NSUInteger, MGEBorderRadiusType) {
    MGEBorderRadiusTypeNormal = 1,
    MGEBorderRadiusTypeScale
} ;

/*!
 @class         MGEBorderLayer
 @abstract      멀티 border를 표현하기 위한 CALayer의 서브클래스이다. 노이즈 및 gradient 도 지원한다.
 @discussion    border를 겹치는 것은 border만의 개념만으로는 표현하기에는 표현하기에는 문제가 존재한다. border의 width가 커지면 내부가 직사각형이 되기 때문이다. path의 scale을 줄여 표현하는게 가장 적합하다고 판단되어 그렇게 만들었다. 노이즈 지원, gradient 지원
*/
@interface MGEBorderLayer : CALayer

@property (nonatomic, assign) MGEBorderFillType fillType;     // 디폴트 MGEBorderFillTypeFlat
@property (nonatomic, assign) MGEBorderRadiusType radiusType; // 디폴트 MGEBorderRadiusTypeNormal

@property (nonatomic, assign) CGFloat noiseOpacity;       // [0.0 ~ 1.0] 디폴트 0.0
@property (nonatomic, assign) CGBlendMode noiseBlendMode; // 디폴트 BlendMode kCGBlendModeScreen

//! Animatable. @dynamic
@property (nonatomic, strong) NSArray <NSNumber *>*borderWidths; // 바깥쪽에서부터 차례로 보내준다. CGFloat, @dynamic 디폴트:@[@(10.0), @(15.0), @(10.0)]
@property (nonatomic, strong) NSArray <id>*borderColors; // 바깥쪽에서부터 차례로 보내준다. CGColorRef, @dynamic 디폴트:redColor  blueColor greenColor
@property (nonatomic, assign) CGFloat borderRadius; // @dynamic : 기존의 cornerRadius와 충돌하지 않기 위해 borderRadius 이름 지음. 디폴트 40.0

//! Animatable. @dynamic. Linear Gradient
@property (nonatomic, assign) CGPoint startPoint; // @dynamic : 디폴트 CGPointMake(0.5, 0.0)
@property (nonatomic, assign) CGPoint endPoint; // @dynamic : 디폴트 CGPointMake(0.5, 1.0);
@property (nonatomic, strong) NSArray <id>*startColors; // 바깥쪽에서부터 차례로 보내준다. CGColorRef, @dynamic 디폴트:redColor blueColor greenColor
@property (nonatomic, strong) NSArray <id>*endColors; // 바깥쪽에서부터 차례로 보내준다. CGColorRef, @dynamic 디폴트:blackColor purpleColor brownColor

// @property CACornerMask maskedCorners; <- CALayer 프라퍼티 그대로 이용. 특정 코너만 선택적으로 radius를 줄 수 있다.
// @property(copy) CALayerCornerCurve cornerCurve; <- CALayer 프라퍼티. 무시하겠다.

@end

NS_ASSUME_NONNULL_END
