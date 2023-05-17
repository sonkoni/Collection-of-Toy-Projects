//
//  MGEGradientLayer.h
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/10/12.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGEGradientLayer : CALayer

@property (nonatomic, assign) CGFloat noiseOpacity;       // [0.0 ~ 1.0] 디폴트 0.0
@property (nonatomic, assign) CGBlendMode noiseBlendMode; // 디폴트 BlendMode kCGBlendModeScreen

@property (nonatomic, copy, nullable) NSArray *colors; // id CGColor @dynamic Animatable.

// The gradient stops are specified as values between 0 and 1.
// The values must be monotonically increasing. If nil, the stops are spread uniformly across the range. Defaults to nil.
@property (nonatomic, copy, nullable) NSArray <NSNumber *>*locations; // CGFloat @dynamic Animatable. nil이면 균등하게 뽑아버린다.

//! 시작 점을 의미한다.
// kCAGradientLayerAxial
// kCAGradientLayerRadial : 원의 중심을 의미한다.
// kCAGradientLayerConic
@property (nonatomic, assign) CGPoint startPoint; // @dynamic Animatable.

//! 끝 점을 의미한다.
// kCAGradientLayerAxial
// kCAGradientLayerRadial : 타원을 포함하는 직사각형의 꼭지점 좌표(4개 중 1개)
// kCAGradientLayerConic
@property (nonatomic, assign) CGPoint endPoint; // @dynamic Animatable.

// kCAGradientLayerAxial
// kCAGradientLayerRadial
// kCAGradientLayerConic
@property (nonatomic, copy) CAGradientLayerType type; // 디폴트 kCAGradientLayerAxial

@end

NS_ASSUME_NONNULL_END

//! CAGradientLayer 에는 다음과 같은 5가지의 새로운 프라퍼티만 존재한다.
//self.gradientLayer.colors = @[(id)_startColor.CGColor, (id)_endColor.CGColor];
//self.gradientLayer.startPoint = CGPointMake(0.5, 0.0);
//self.gradientLayer.endPoint = CGPointMake(0.5, 1.0);
//self.gradientLayer.locations = @[@(0.0), @(1.0)];
//self.gradientLayer.type = kCAGradientLayerAxial; // Linear를 의미한다.
