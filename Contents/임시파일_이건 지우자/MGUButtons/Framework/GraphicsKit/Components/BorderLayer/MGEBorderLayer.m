//
//  MGEBorderLayer.m
//  Empty Project
//
//  Created by Kwan Hyun Son on 2021/10/07.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEBorderLayer.h"
#import "MGENoise.h"
#import "MGEPathHelper.h"

@interface MGEBorderLayer ()
@end

@implementation MGEBorderLayer
@dynamic borderWidths;
@dynamic borderColors;
@dynamic borderRadius;
@dynamic startPoint;
@dynamic endPoint;
@dynamic startColors;
@dynamic endColors;

// 어떤 속성이 애니메이션화 가능한지 정의
// 초기화될때. 자신의 모든 프라퍼티를 여기에 넣어서 자동으로 검사한다.
// key는 자신의 모든 프라퍼티가 검사된다. 사용유무와 관계없다.
// [CABasicAnimation animationWithKeyPath:@"U"]; 이렇게 조정하고 싶은 키가 있다면,
// 반드시 needsDisplayForKey:가 YES여야한다. 기존에 없는 속성을 사용하려면, 이러한 다듬음이 필요하다.
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"borderWidths"] ||
        [key isEqualToString:@"borderColors"] ||
        [key isEqualToString:@"borderRadius"] ||
        [key isEqualToString:@"startPoint"] ||
        [key isEqualToString:@"endPoint"] ||
        [key isEqualToString:@"startColors"] ||
        [key isEqualToString:@"endColors"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        CommonInit(self);
    }
    return self;
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

// 프리젠테이션 레이어를 생성하는데 이용된다.
// 프리젠테이션 레이어란, 현재 애니메이션 진행 중일때, 화면상에 나타나는 자신의 솔직한 값을 알려준다.
// 애니메이션이 작동하면 들어온다.
- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[MGEBorderLayer class]]) {
            MGEBorderLayer *borderLayer = (MGEBorderLayer *)layer;
            self.borderWidths = borderLayer.borderWidths;
            self.borderColors = borderLayer.borderColors;
            self.borderRadius = borderLayer.borderRadius;
            self.startPoint = borderLayer.startPoint;
            self.endPoint = borderLayer.endPoint;
            self.startColors = borderLayer.startColors;
            self.endColors = borderLayer.endColors;
            
            self.fillType = borderLayer.fillType;
            self.radiusType = borderLayer.radiusType;
            
            self.noiseOpacity = borderLayer.noiseOpacity;
            self.noiseBlendMode = borderLayer.noiseBlendMode;
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setMaskedCorners:(CACornerMask)maskedCorners {
    [super setMaskedCorners:maskedCorners];
    [self setNeedsDisplay];
}


- (void)drawInContext:(CGContextRef)ctx {
    /// 원하는 클립 패스를 그리고 패스를 컨텍스트에 더한 후, CGContextClip을 하면 잘린다. 이후 부터는 잘린 면에서 노는 것이다.
   /** CGMutablePathRef clipPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(clipPath, NULL, self.bounds);
    CGContextAddPath(ctx, clipPath);
    CGContextClip(ctx);
    CGPathRelease(clipPath);*/
    
    if (self.borderWidths.count < 1) { // 표현할 path가 없다면 그냥 나가라.
        return;
    } else if (self.borderWidths.count != self.borderColors.count &&
               self.fillType == MGEBorderFillTypeFlat) {
        NSCAssert(FALSE, @"borderWidths과 borderColors의 갯수는 동일해야한다. %lu %lu", (unsigned long)self.borderWidths.count, (unsigned long)self.borderColors.count);
    } else if ((self.borderWidths.count != self.startColors.count || self.startColors.count != self.endColors.count) &&
               self.fillType == MGEBorderFillTypeLinearGradient) {
        NSCAssert(FALSE, @"borderWidths과 startColors의 갯수는 동일해야한다. %lu %lu", (unsigned long)self.borderWidths.count, (unsigned long)self.startColors.count);
    }
    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:self.borderWidths.count];
    NSMutableArray <NSValue *>*rects = [NSMutableArray array];
    CGRect rect = self.bounds;
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius]; 1/3 에서 그냥 점프해서 최대치로 줄여버리는 버그가 존재함.
//    CGPathRef path_CG = CGPathCreateWithRoundedRect(rect, self.borderRadius, self.borderRadius, NULL); // 버그는 없지만 특정 코너만 노릴 수 없음.
//    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:path_CG];
//    CGPathRelease(path_CG);
    
    CGPathRef path = MGECGPathCreateWithRect(rect, self.maskedCorners, self.borderRadius);
    [paths addObject:(id)CFBridgingRelease(path)];
#if TARGET_OS_IPHONE
    [rects addObject:[NSValue valueWithCGRect:rect]];
#else
    [rects addObject:[NSValue valueWithRect:rect]];
#endif
    CGFloat borderWidth = 0.0;
    
    for (NSInteger i = 0; i < self.borderWidths.count; i++) {
        borderWidth = borderWidth + [self.borderWidths[i] doubleValue];
        
        if (self.radiusType == MGEBorderRadiusTypeScale) {
            CGFloat scaleW = (CGRectGetWidth(rect) - 2.0 * borderWidth) / CGRectGetWidth(rect);
            CGFloat scaleH = (CGRectGetHeight(rect) - 2.0 * borderWidth) / CGRectGetHeight(rect);
            CGAffineTransform affineTransform = CGAffineTransformMakeScale(scaleW, scaleH);
            CGPathRef newPath = CGPathCreateCopyByTransformingPath(path, &affineTransform);
            affineTransform = CGAffineTransformMakeTranslation(borderWidth, borderWidth);
            CGPathRef newPath2 = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(newPath),
                                                                    &affineTransform);
            [paths addObject:(id)CFBridgingRelease(newPath2)];
        } else { // MGEBorderRadiusTypeNormal - 디폴트
            CGFloat radius = MAX(0.0, self.borderRadius - borderWidth);
            CGRect newRect = CGRectInset(rect, borderWidth, borderWidth);
//            UIBezierPath *newPath = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:radius]; 1/3 에서 그냥 점프해서 최대치로 줄여버리는 버그가 존재함.
//            CGPathRef path_CG = CGPathCreateWithRoundedRect(newRect, radius, radius, NULL); // 버그는 없지만 특정 코너만 노릴 수 없음.
//            UIBezierPath *newPath = [UIBezierPath bezierPathWithCGPath:path_CG];
//            CGPathRelease(path_CG);
            CGPathRef newPath = MGECGPathCreateWithRect(newRect, self.maskedCorners, radius);
            [paths addObject:(id)CFBridgingRelease(newPath)];
        }
        
        CGRect newRect = CGRectInset(rect, borderWidth, borderWidth);
#if TARGET_OS_IPHONE
        [rects addObject:[NSValue valueWithCGRect:newRect]];
        // 마지막은 사용하지는 않을 것이다. linear gradient를 의 시작점과 끝점을 잡기 위해.
#else
        [rects addObject:[NSValue valueWithRect:newRect]];
#endif
    }
    
    CGContextSetShouldAntialias(ctx, YES);    // Anti aliasing - 층진 부분을 뭉개서 부드럽게. 둘 다 YES이어야함. 그런데 디폴트가 YES, 그러니깐 안써도 됨.
    CGContextSetAllowsAntialiasing(ctx, YES);

    for (NSInteger i = 0; i < self.borderWidths.count; i++) {
        CGMutablePathRef path =
            (CGMutablePathRef)CFAutorelease(CGPathCreateMutableCopy((__bridge CGPathRef)(paths[i])));
        CGPathRef path2 = CGPathCreateCopy((__bridge CGPathRef)(paths[i+1]));
        CGPathAddPath(path, NULL, (CGPathRef)CFAutorelease(path2));
        CGContextSaveGState(ctx); // <- Save
        CGContextSetLineWidth(ctx, 0.0);
        
        if (self.fillType == MGEBorderFillTypeFlat) {
            CGColorRef borderColor = (__bridge CGColorRef)self.borderColors[i]; // 메모리는 배열이 관리해준다.
            if (self.noiseOpacity > 0.0) { // 메모리는 배열이 관리해준다.
                borderColor = [[MGEColor colorWithCGColor:borderColor] mgrColorWithNoiseWithOpacity:self.noiseOpacity
                                                                                      andBlendMode:self.noiseBlendMode].CGColor;
            }
            
            CGContextSetFillColorWithColor(ctx, borderColor);
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, path);
            CGContextEOFillPath(ctx); // CGContextFillPath(ctx); 차집합인듯. Even - Odd
            CGContextRestoreGState(ctx);  // <- Restore
        } else if (self.fillType == MGEBorderFillTypeLinearGradient) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextBeginPath(ctx);
            CGContextAddPath(ctx, path);
            CGContextEOClip(ctx); // CGContextClip(ctx);
            CGContextSetInterpolationQuality(ctx, kCGInterpolationNone); // 보간품질, 디폴트는 kCGInterpolationDefault

            NSArray *colors = @[self.startColors[i], self.endColors[i]];
            NSArray *locations =  @[@(0.0), @(1.0)];
            CGFloat colorLocation[locations.count];
            for (NSInteger i = 0; i < locations.count; i++) {
                NSNumber *number = locations[i];
                colorLocation[i] = number.doubleValue;
            }
            
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorLocation);
            
#if TARGET_OS_IPHONE
            CGRect rect = [rects[i] CGRectValue];
#else
            CGRect rect = [rects[i] rectValue];
#endif
            //! CAGradientLayer와 같은 behavior를 보여주기 위해...
            CGContextTranslateCTM(ctx, ABS(rect.origin.x), ABS(rect.origin.y)); // 원점을 옮긴다.
            if (self.bounds.size.width < self.bounds.size.height) { // 스케일을 줄여서 정사각형을 만든다.
                CGContextScaleCTM(ctx,
                                  rect.size.width / rect.size.height,
                                  1.0);
            } else {
                CGContextScaleCTM(ctx,
                                  1.0,
                                  rect.size.height / rect.size.width);
            }
            CGFloat squareValue = MAX(rect.size.width, rect.size.height);
            rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, squareValue, squareValue); // 이미 원점은 옮기진 상태이다.
            //! CAGradientLayer와 같은 behavior를 보여주기 위해...
        
            CGFloat startPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * self.startPoint.x + CGRectGetMinX(rect);
            CGFloat startPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * self.startPoint.y + CGRectGetMinY(rect);
        
            CGFloat endPoint_X = (CGRectGetMaxX(rect) - CGRectGetMinX(rect)) * self.endPoint.x + CGRectGetMinX(rect);
            CGFloat endPoint_Y = (CGRectGetMaxY(rect) - CGRectGetMinY(rect)) * self.endPoint.y + CGRectGetMinY(rect);

            CGPoint startPoint = CGPointMake(startPoint_X, startPoint_Y);
            CGPoint endPoint = CGPointMake(endPoint_X, endPoint_Y);
            CGContextDrawLinearGradient(ctx,
                                        gradient,
                                        startPoint,
                                        endPoint,
                                        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);
            CGContextRestoreGState(ctx);  // <- Restore
            
            if (self.noiseOpacity > 0.0) { // 메모리는 배열이 관리해준다.
                MGRDrawNoiseWithOpacityBlendMode(self.noiseOpacity, self.noiseBlendMode, ctx);
            }
        }
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEBorderLayer *self) {
    self.borderWidths = @[@(10.0), @(15.0), @(10.0)];
    self.borderColors = @[(id)(MGEColor.redColor.CGColor), (id)(MGEColor.blueColor.CGColor), (id)(MGEColor.greenColor.CGColor)];
    self.borderRadius = 40.0;
    self.startPoint = CGPointMake(0.5, 0.0);
    self.endPoint = CGPointMake(0.5, 1.0);
    self.startColors = @[(id)(MGEColor.redColor.CGColor), (id)(MGEColor.blueColor.CGColor), (id)(MGEColor.greenColor.CGColor)];
    self.endColors = @[(id)(MGEColor.blackColor.CGColor), (id)(MGEColor.purpleColor.CGColor), (id)(MGEColor.brownColor.CGColor)];
    self->_fillType = MGEBorderFillTypeFlat;
    self->_radiusType = MGEBorderRadiusTypeNormal;
    self->_noiseOpacity = 0.0; // 노이즈가 없는 상태.
    self->_noiseBlendMode = kCGBlendModeScreen;
}


#pragma mark - 세터 & 게터
- (void)setFillType:(MGEBorderFillType)fillType {
    _fillType = fillType;
    [self setNeedsDisplay];
}

- (void)setRadiusType:(MGEBorderRadiusType)radiusType {
    _radiusType = radiusType;
    [self setNeedsDisplay];
}

- (void)setNoiseOpacity:(CGFloat)noiseOpacity {
    _noiseOpacity = noiseOpacity;
    [self setNeedsDisplay];
}

- (void)setNoiseBlendMode:(CGBlendMode)noiseBlendMode {
    _noiseBlendMode = noiseBlendMode;
    [self setNeedsDisplay];
}

#pragma mark - Helper
@end

//- (UIRectCorner)rectCorner {
//    UIRectCorner rectCorner = 0;
//    if (self.maskedCorners & kCALayerMinXMinYCorner) {
//        rectCorner = rectCorner + UIRectCornerTopLeft;
//    }
//    if (self.maskedCorners & kCALayerMaxXMinYCorner) {
//        rectCorner = rectCorner + UIRectCornerTopRight;
//    }
//    if (self.maskedCorners & kCALayerMaxXMaxYCorner) {
//        rectCorner = rectCorner + UIRectCornerBottomRight;
//    }
//    if (self.maskedCorners & kCALayerMinXMaxYCorner) {
//        rectCorner = rectCorner + UIRectCornerBottomLeft;
//    }
//
//    return rectCorner;
//}
