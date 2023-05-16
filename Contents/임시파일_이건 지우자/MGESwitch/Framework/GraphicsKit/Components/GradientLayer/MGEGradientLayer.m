//
//  MGEGradientLayer.m
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/10/12.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEGradientLayer.h"
#import "MGENoise.h"
#import "MGEGeometryHelper.h"
#import "MGEColorHelper.h"
#import "MGEAvailability.h"

@interface MGEGradientLayer ()
@property (nonatomic, assign) CGFloat radius; // Animatable. cornerRadius를 대신하는 프라퍼티이다. 애니메이션을 먹이려면 어쩔 수 없다.
@property (nonatomic, strong, readonly) NSArray <NSNumber *>*privateLocations; // @dynamic location nil 일 때, spread uniformly across the range
@end

@implementation MGEGradientLayer
@synthesize privateLocations = _privateLocations;
@dynamic colors;
@dynamic locations;
@dynamic startPoint;
@dynamic endPoint;
@dynamic radius;
@dynamic cornerRadius; // radius 를 대신 사용할 것이다.

// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"colors"] ||
        [key isEqualToString:@"locations"] ||
        [key isEqualToString:@"startPoint"] ||
        [key isEqualToString:@"endPoint"] ||
        [key isEqualToString:@"radius"]) {
        return YES;
    }
    
    if ([key isEqualToString:@"maskedCorners"] ||
        [key isEqualToString:@"cornerRadius"] || // 이건 지워도 될듯.
        [key isEqualToString:@"frame"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

// 최초에 들어온다.
- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        CommonInit(self);
    }
    return self;
}

// 프리젠테이션 레이어를 생성하는데 이용된다.
// 프리젠테이션 레이어란, 현재 애니메이션 진행 중일때, 화면상에 나타나는 자신의 솔직한 값을 알려준다.
// 애니메이션이 작동하면 들어온다.
- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[MGEGradientLayer class]]) {
            MGEGradientLayer *gradientLayer = (MGEGradientLayer *)layer;
            self.contentsScale = MGE_MAINSCREEN_SCALE;
            self.needsDisplayOnBoundsChange = YES;
            
            self.colors = gradientLayer.colors;
            self.locations = gradientLayer.locations;
            self.startPoint = gradientLayer.startPoint;
            self.endPoint = gradientLayer.endPoint;
            
            self.type = gradientLayer.type;
            self.noiseOpacity = gradientLayer.noiseOpacity;
            self.noiseBlendMode = gradientLayer.noiseBlendMode;
            self.radius = gradientLayer.radius;
        }
        
        if ([layer isKindOfClass:[CALayer class]]) {
            self.cornerRadius = ((CALayer *)layer).cornerRadius;
            self.frame = ((CALayer *)layer).frame;
            self.maskedCorners = ((CALayer *)layer).maskedCorners;
        }
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self setRadius:cornerRadius];
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.radius;
}

//! 암묵적 애니메이션을 발생시켜준다.
- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"colors"] ||
        [event isEqualToString:@"locations"] ||
        [event isEqualToString:@"startPoint"] ||
        [event isEqualToString:@"endPoint"] ||
        [event isEqualToString:@"radius"]) {

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        if (self.presentationLayer != nil) {
            animation.fromValue = [self.presentationLayer valueForKey:event];
        }
        return animation;
    }

    return [super actionForKey:event];
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key {
    CAPropertyAnimation *animation = (CAPropertyAnimation *)anim;
    if ([animation isKindOfClass:[CAPropertyAnimation class]] == YES &&
        [animation.keyPath isEqualToString:@"cornerRadius"] == YES) {
        animation.keyPath = @"radius";
        [self addAnimation:animation forKey:key];
    } else {
        [super addAnimation:anim forKey:key];
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEGradientLayer *self) {
    self->_noiseOpacity = 0.0;
    self->_noiseBlendMode = kCGBlendModeScreen;
    self->_type = kCAGradientLayerAxial; // Linear
    
    self.needsDisplayOnBoundsChange = YES;
    self.startPoint = CGPointMake(0.5, 0.0);
    self.endPoint = CGPointMake(0.5, 1.0);
    
    CGFloat redColorComponents[4] = { 1.0, 0.0, 0.0, 1.0};
    CGFloat blueColorComponents[4] = { 0.0, 0.0, 1.0, 1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef redColor = CGColorCreate(colorSpace, redColorComponents);
    CGColorRef blueColor = CGColorCreate(colorSpace, blueColorComponents);
    CGColorSpaceRelease(colorSpace);
    self.colors = @[(__bridge_transfer id)(redColor), (__bridge_transfer id)(blueColor)];
    self.locations = nil;
    self.radius = 0.0;
    self.cornerRadius = 0.0;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGRect rect = self.bounds;

    // 코너 라디어스 설정.
    CGPathRef clipPath = MGEPathCreateWithRoundedRect(rect, self.radius, self.maskedCorners, NULL);
    CGContextSetLineWidth(ctx, 0.0);
    CGContextAddPath(ctx, clipPath);
    CGContextClip(ctx);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(ctx);
    
    NSMutableArray <NSNumber *>*locations = [self privateLocations].mutableCopy; // self.location 값이 nil이면, 균등하게 만든다.
    NSMutableArray *colors = [self.colors subarrayWithRange:NSMakeRange(0, locations.count)].mutableCopy;
    if ([locations.firstObject doubleValue] != 0.0) {
        [locations insertObject:@(0.0) atIndex:0];
        [colors insertObject:colors.firstObject atIndex:0];
    }
    if ([locations.lastObject doubleValue] != 1.0) {
        [locations addObject:@(1.0)];
        [colors addObject:colors.lastObject];
    }
    
    CGFloat colorLocation[locations.count];
    for (NSInteger i = 0; i < locations.count; i++) {
        NSNumber *number = locations[i];
        colorLocation[i] = number.doubleValue;
    }
    
//    둘 중 적당한 함수를 쓰면된다.
//    CGGradientRef CGGradientCreateWithColorComponents(CGColorSpaceRef space,
//                                                      const CGFloat *components,
//                                                      const CGFloat *locations,
//                                                      size_t count);
//    CGGradientRef CGGradientCreateWithColors(CGColorSpaceRef space,
//                                             CFArrayRef colors,
//                                             const CGFloat *locations);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorLocation);
    
    if ([self.type isEqualToString:kCAGradientLayerAxial] == YES) {
        if (CGPointEqualToPoint(self.startPoint, self.endPoint) == YES) {
            CGContextSetFillColorWithColor(ctx, (CGColorRef)(colors.firstObject));
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, clipPath);
            CGContextFillPath(ctx);
        } else {
            //! CAGradientLayer와 같이 사용하려면 다음과 같은 처리 과정이 필요하다.
            //! self.bounds 가 정사각형임을 가정한다.
            CGFloat squareValue = MAX(self.bounds.size.width, self.bounds.size.height);
            rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, squareValue, squareValue);
            CGFloat startPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * self.startPoint.x + CGRectGetMinX(rect);
            CGFloat startPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * self.startPoint.y + CGRectGetMinY(rect);
            CGFloat endPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * self.endPoint.x + CGRectGetMinX(rect);
            CGFloat endPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * self.endPoint.y + CGRectGetMinY(rect);
            CGPoint startPoint = CGPointMake(startPoint_X, startPoint_Y);
            CGPoint endPoint = CGPointMake(endPoint_X, endPoint_Y);
            
            if (self.bounds.size.width < self.bounds.size.height) {
                CGContextScaleCTM(ctx,
                                  self.bounds.size.width / self.bounds.size.height,
                                  1.0);
            } else {
                CGContextScaleCTM(ctx,
                                  1.0,
                                  self.bounds.size.height / self.bounds.size.width);
            }
            
            CGContextDrawLinearGradient(ctx,
                                        gradient,
                                        startPoint,
                                        endPoint,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        }
    } else if ([self.type isEqualToString:kCAGradientLayerRadial] == YES) {
        if (self.startPoint.x == self.endPoint.x || self.startPoint.y == self.endPoint.y) { // 너비가 한쪽이 0.0가되면 최종색으로 채운다.
            CGContextSetFillColorWithColor(ctx, (CGColorRef)(colors.lastObject));
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, clipPath);
            CGContextFillPath(ctx);
        } else {
            //! 본 함수는 완벽한 원(타원 아님)으로 만든다. 따라서 위에서 적절하게 처리했다.
            //! 원이 완전 원임을 가정한다.(함수 자체가 완전원을 그린다.)
            CGFloat sX = (CGRectGetMaxX(self.bounds) - CGRectGetMinX(self.bounds)) * self.startPoint.x + CGRectGetMinX(self.bounds);
            CGFloat sY = (CGRectGetMaxY(self.bounds) - CGRectGetMinY(self.bounds)) * self.startPoint.y + CGRectGetMinY(self.bounds);
            CGFloat eX = (CGRectGetMaxX(self.bounds) - CGRectGetMinX(self.bounds)) * self.endPoint.x + CGRectGetMinX(self.bounds);
            CGFloat eY = (CGRectGetMaxY(self.bounds) - CGRectGetMinY(self.bounds)) * self.endPoint.y + CGRectGetMinY(self.bounds);
            CGSize size = CGSizeMake(ABS(eX - sX), ABS(eY - sY));
            CGFloat squareValue = MAX(size.width, size.height);
            
            CGContextTranslateCTM(ctx, sX, sY); // 중심축을 이동한다.
            if (size.width < size.height) {
                CGContextScaleCTM(ctx,
                                  size.width / size.height,
                                  1.0);
            } else {
                CGContextScaleCTM(ctx,
                                  1.0,
                                  size.height / size.width);
            }
            
            CGContextDrawRadialGradient(ctx,
                                        gradient,
                                        CGPointZero,
                                        0.0,
                                        CGPointZero,
                                        squareValue,
                                        kCGGradientDrawsAfterEndLocation);
        }
    } else if ([self.type isEqualToString:kCAGradientLayerConic] == YES) {
        if (CGPointEqualToPoint(self.startPoint, self.endPoint) == YES) {
            CGContextSetFillColorWithColor(ctx, (CGColorRef)(colors.firstObject));
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, clipPath);
            CGContextFillPath(ctx);
        } else {
            //! CAGradientLayer와 같이 사용하려면 다음과 같은 처리 과정이 필요하다.
            //! self.bounds 가 정사각형임을 가정한다.
            //! 최초 각을 구해보자.
            CGFloat startRadian = MGERotationAngleAboutCenter(self.startPoint, self.endPoint);
//            CGContextSetShouldAntialias(ctx, YES);    // Anti aliasing - 층진 부분을 뭉개서 부드럽게. 둘 다 YES이어야함. 그런데 디폴트가 YES, 그러니깐 안써도 됨.
//            CGContextSetAllowsAntialiasing(ctx, YES);
            
            //! 실제 중심축의 위치로 옮긴다.
            CGFloat sX = (CGRectGetMaxX(self.bounds) - CGRectGetMinX(self.bounds)) * self.startPoint.x + CGRectGetMinX(self.bounds);
            CGFloat sY = (CGRectGetMaxY(self.bounds) - CGRectGetMinY(self.bounds)) * self.startPoint.y + CGRectGetMinY(self.bounds);
            CGContextTranslateCTM(ctx, sX, sY); // 중심축을 이동한다. 0.0 이 원의 중심이다.
            if (self.bounds.size.width < self.bounds.size.height) {
                CGContextScaleCTM(ctx,
                                  self.bounds.size.width / self.bounds.size.height,
                                  1.0);
            } else {
                CGContextScaleCTM(ctx,
                                  1.0,
                                  self.bounds.size.height / self.bounds.size.width);
            }
                        
            CGFloat longerSide = MAX(self.bounds.size.width, self.bounds.size.height);
            CGFloat radius = longerSide * sqrt(2);
            
            //! 원뿔의 호, 반지름, 각(라디안)의 공식 : Θ = L / R
            //! 즉, 반지름을 곱하면 호의 길이가 나온다. 아래와 같이 'CGFloat step = M_PI_2 / radius;' 정의한다면
            //! 반지름을 radius로 하면 1.57...(= M_PI_2) 정도하는 호의 길이가 나오게 되는 각을 의미한다.
            //! 실제 여기에서의 radius는 큰 정사각형의 두 배에 해당하는 정사각형을 외접하는 원의 반지름이 된다.
            //! step이 이루는 호의 길이는 1.57 이며 선의 굵기가 1.0(디폴트)이므로 아주 큰 원에서는 둘레에서 약간씩 벌어지게 되지만
            //! 원의 둘레를 두 배나 크게 잡았으므로 결과적으로 빈틈없이 면을 채우게 된다.
            //! 다시 한번 정밀한 계산을 위해 딱 들어맞는 반지름으로 했다면, 호는 0.785가 된다. 그런데 굵기가 1.0이므로 양쪽에서 충분히 커버하고도 남는다.
            //! 딱 커버하는 원이라면 CGFloat step = M_PI_4 / R; 가 된다.(R = (longerSide / 2.0) * √2)
            __unused CGFloat step = M_PI_2 / radius; // 1.57 포인트에 해당하는 호(반지름=radius)를 이루는 각(step-라디안) 선으로 할때는 촘촘해야한다.
            //step = M_PI / 180; // 1도.
            step = 1.0/50.0; // 부하를 줄이기 위해. 면으로 사용하자. 좆같다. 선으로 할거면 여기를 가리면된다.
//            step = 1.0/10.0; // 분모를 높이면 층지는 효과를 얻을 수 있다.
            
            CGFloat currentRadian = startRadian;
            CGFloat endRadian = startRadian + (M_PI * 2.0);
            CGContextSetLineWidth(ctx, 1.0/MGE_MAINSCREEN_SCALE);
//            CGContextSetLineWidth(ctx, 1.0);
            for (NSInteger i = 0; i < locations.count - 1; i++) { // locations = @[@(0.0), @(0.5), @(1.0)]; 라면 2개의 구간이 나온다.
                CGFloat locationA = [locations[i] doubleValue];
                CGFloat locationB = [locations[i + 1] doubleValue];
                CGFloat radinA = startRadian + (locationA * M_PI * 2.0);
                CGFloat radinB = startRadian + (locationB * M_PI * 2.0);
                while (currentRadian <= radinB ) {
                    CGFloat progress = MGEProgressLerpDouble(radinA, radinB, currentRadian);
                    CGColorRef color = MGECGColorCreateInterpolate((__bridge CGColorRef)colors[i],
                                                                   (__bridge CGColorRef)colors[i + 1],
                                                                   progress);
                    CGPoint endPoint = MGERotatePoint(CGPointMake(longerSide * 2.0, 0.0), currentRadian);
                    
                    CGMutablePathRef path = CGPathCreateMutable();
                    CGPathMoveToPoint(path, NULL, 0.0, 0.0); // 중심을 옮겼다.
                    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
                    
                    /** 면을 위해 추가함. */
                    CGPoint endPoint2 = MGERotatePoint(CGPointMake(longerSide * 2.0, 0.0), MIN(endRadian, currentRadian + step));
                    CGPathAddLineToPoint(path, NULL, endPoint2.x, endPoint2.y); // 부하때문에 면으로 만들었다.
                    CGPathCloseSubpath(path);
                    /** 면을 위해 추가함. */
                    
                    CGContextBeginPath(ctx);
                    CGContextAddPath(ctx, path); // 여기서 부하가 엄청나다.
                    CGContextClosePath(ctx);
                    CGContextSetStrokeColorWithColor(ctx, color);
                    CGContextStrokePath(ctx);
                    
                    /** 면을 위해 추가함. */
                    CGContextBeginPath(ctx);
                    CGContextAddPath(ctx, path); // 여기서 부하가 엄청나다.
                    CGContextClosePath(ctx);
                    CGContextSetFillColorWithColor(ctx, color);
                    CGContextFillPath(ctx);
                    /** 면을 위해 추가함. */
                    
                    CGPathRelease(path);
                    CGColorRelease(color);
                    
                    currentRadian = currentRadian + step;
                }
            }
        }
    }
    
    CGGradientRelease(gradient); gradient = NULL;
    CGColorSpaceRelease(colorSpace); colorSpace = NULL;
    CGPathRelease(clipPath);
    CGContextRestoreGState(ctx);
    
    if (self.noiseOpacity > 0.0) { // 메모리는 배열이 관리해준다.
        MGRDrawNoiseWithOpacityBlendMode(self.noiseOpacity, self.noiseBlendMode, ctx);
    }
}


#pragma mark - 세터 & 게터
- (void)setNoiseOpacity:(CGFloat)noiseOpacity {
    _noiseOpacity = noiseOpacity;
    [self setNeedsDisplay];
}

- (void)setNoiseBlendMode:(CGBlendMode)noiseBlendMode {
    _noiseBlendMode = noiseBlendMode;
    [self setNeedsDisplay];
}

- (void)setType:(CAGradientLayerType)type {
    _type = type;
    [self setNeedsDisplay];
}

#pragma mark - Helper
- (NSArray <NSNumber *>*)privateLocations {
    if (self.locations != nil) {
        return self.locations;
    } else {
        if (_privateLocations.count != self.colors.count) {
            NSInteger divisor = self.colors.count - 1;
            CGFloat step = 1.0 / (CGFloat)divisor;
            NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.colors.count];
            for (NSInteger i = 0; i < self.colors.count - 1; i++) {
                [result addObject:@((step * i))];
            }
            [result addObject:@(1.0)]; // 오차를 줄이기 위해
            _privateLocations = result.copy;
        }
       
        return _privateLocations;
    }
}
@end

/* https://stackoverflow.com/questions/6913208/is-there-a-way-to-draw-a-cgcontextdrawradialgradient-as-an-oval-instead-of-a-per
 타원으로 radial gradient를 그리는 방법. CGContextDrawRadialGradient(..) 함수는 완벽한 원으로만 그린다. CAGradientLayer는 제공하지만...
 
You can change the transform of the context to draw an ellipse (for example, apply CGContextScaleCTM(context, 2.0, 1.0) just before calling CGContextDrawRadialGradient () to draw an elliptical gradient that's twice as wide as it is high). Just remember to apply the inverse transform to your start and end points, though.

 타원을 그리도록 컨텍스트의 변환을 변경할 수 있습니다. 하지만 시작점과 끝점에 역변환을 적용하는 것을 잊지 마십시오.

 
 - (void)drawRect:(CGRect)rect {

     CGContextRef ctx = UIGraphicsGetCurrentContext();

     // Create gradient
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     CGFloat locations[] = {0.0, 1.0};

     UIColor *centerColor = [UIColor orangeColor];
     UIColor *edgeColor = [UIColor purpleColor];

     NSArray *colors = [NSArray arrayWithObjects:(__bridge id)centerColor.CGColor, (__bridge id)edgeColor.CGColor, nil];
     CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);

     // Scaling transformation and keeping track of the inverse
     CGAffineTransform scaleT = CGAffineTransformMakeScale(2, 1.0);
     CGAffineTransform invScaleT = CGAffineTransformInvert(scaleT);

     // Extract the Sx and Sy elements from the inverse matrix
     // (See the Quartz documentation for the math behind the matrices)
     CGPoint invS = CGPointMake(invScaleT.a, invScaleT.d);

     // Transform center and radius of gradient with the inverse
     CGPoint center = CGPointMake((self.bounds.size.width / 2) * invS.x, (self.bounds.size.height / 2) * invS.y);
     CGFloat radius = (self.bounds.size.width / 2) * invS.x;

     // Draw the gradient with the scale transform on the context
     CGContextScaleCTM(ctx, scaleT.a, scaleT.d);
     CGContextDrawRadialGradient(ctx, gradient, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation);

     // Reset the context
     CGContextScaleCTM(ctx, invS.x, invS.y);

     // Continue to draw whatever else ...

     // Clean up the memory used by Quartz
     CGGradientRelease(gradient);
     CGColorSpaceRelease(colorSpace);
 }
 
*/

