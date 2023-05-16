//
//  MGERingProgressLayer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGERingProgressLayer.h"
#import "MGEGradientGenerator.h"
#import "MGEAvailability.h"

@interface MGERingProgressLayer ()
@property (nonatomic) MGEGradientGenerator *gradientGenerator;
@property (nonatomic, assign) CGFloat edgeAngle; // gradientGenerator에서도 사용될 것이다.

// drawInContext: 메서드에서의 사용을 위한 Dynamic 프라퍼티
@property (nonatomic, assign) CGRect squareRect;                                // 수퍼 뷰에 딱 맞는 정사각형(원점 0,0)
@property (nonatomic, assign) CGRect SquareRectConsistingOfIntegersForGradient; // gradient 적용을 위해 integer 로 깍인 squareRect
@property (nonatomic, assign) CGRect circleRect;                                // 원이 그려지는 사각형 원이 그려지고 두께로 인해 squareRect에 닿는다.
@property (nonatomic, assign) CGFloat circleRadius; // 중심으로부터 원의 반경이다. 주의!! - 두께를 고려하지 않은 선자체의 반경.
@property (nonatomic, assign) CGPoint boundsCenter; // bounds 의 size만을 고려하여 계산된 center
@property (nonatomic, assign) const CGFloat angleOffset; // M_PI / 2.0f; // 12시 방향에서 시작할 것이므로. 이걸 빼서 뒤로간다.
@property (nonatomic, assign) CGFloat angle;        // 현재 각을 의미한다. radian . 동쪽이 0도이며 그래프는 북에서 시작한다.
@property (nonatomic, assign) const CGFloat maxAngle;
@property (nonatomic, assign) CGFloat cuttingAngle; // maxAngle을 넘어가면 maxAngle을 반환한다.

@end

@implementation MGERingProgressLayer
@dynamic progress;

@dynamic squareRect;
@dynamic SquareRectConsistingOfIntegersForGradient;
@dynamic circleRect;
@dynamic angleOffset;
@dynamic angle;
@dynamic maxAngle;
@dynamic cuttingAngle;

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[MGERingProgressLayer class]]) {
            MGERingProgressLayer *progressLayer = (MGERingProgressLayer *)layer;

            self.gradientGenerator = progressLayer.gradientGenerator;
            self.ringWidth = progressLayer.ringWidth;
            self.progressStyle = progressLayer.progressStyle;
            self.endShadowOpacity = progressLayer.endShadowOpacity;
            self.hidesRingForZeroProgress = progressLayer.hidesRingForZeroProgress;
            self.startColor = progressLayer.startColor;
            self.endColor = progressLayer.endColor;
            self.backgroundRingColor = progressLayer.backgroundRingColor;
            self.gradientImageScale = progressLayer.gradientImageScale;
            
            self.progress = progressLayer.progress;
        }
    }
    return self;
    //
    // 프리젠테이션 레이어를 생성하는데 이용된다.
    // 프리젠테이션 레이어란, 현재 애니메이션 진행 중일때, 화면상에 나타나는 자신의 솔직한 값을 알려준다.
    // 애니메이션이 작동하면 들어온다.
}


//! 최초에 들어온다.
- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentsScale = MGE_MAINSCREEN_SCALE;
        _gradientGenerator = [[MGEGradientGenerator alloc] init];
        _ringWidth = 20.0;
        _progressStyle = MGERingProgressViewStyleRound;
        _endShadowOpacity = 1.0f;
        _hidesRingForZeroProgress = NO;
        _startColor = CGColorCreateCopy(MGEColor.redColor.CGColor);  // 수동으로 메모리를 관리하기 위해
        _endColor   = CGColorCreateCopy(MGEColor.blueColor.CGColor); // 수동으로 메모리를 관리하기 위해
        _gradientImageScale = 1.0f;

        self.progress = 0.0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context {
    CGContextSetShouldAntialias(context, YES);    // Anti aliasing - 층진 부분을 뭉개서 부드럽게. 둘 다 YES이어야함. 그런데 디폴트가 YES, 그러니깐 안써도 됨.
    CGContextSetAllowsAntialiasing(context, YES);
    
    //! 뒤에 배경이 되는 희미한 원을 그린다.
    CGPathRef circlePath = CGPathCreateWithEllipseInRect(self.circleRect, NULL);
    
    CGContextSetLineWidth(context, self.ringWidth);
    CGContextSetLineCap(context, [self lineCap:self.progressStyle]);
    CGContextAddPath(context, circlePath);
    if (self.backgroundRingColor != nil) { // 어지간하면 nil로 하는 것이 자연스러울듯하다.
        CGContextSetStrokeColorWithColor(context, self.backgroundRingColor);
    } else {
        CGColorRef color = CGColorCreateCopyWithAlpha(self.startColor, 0.15);
        CGContextSetStrokeColorWithColor(context, color);
        CGColorRelease(color);
    }
    CGContextStrokePath(context);
    
    //! Draw solid arc, 맥스 앵글은 225 도. 12시부터 시작하지만, 3시부터 0도이다. 따라서 12시에서 시계방향으로 11시정도까지는 발동하지 않는다.
    CGFloat angle = self.angle;
    CGFloat maxAngle = self.maxAngle;
    if (angle > maxAngle) {
        CGFloat offset = angle - maxAngle;
//        UIBezierPath *solidArcPath = [UIBezierPath bezierPathWithArcCenter:self.boundsCenter
//                                                                 radius:self.circleRadius
//                                                             startAngle:-self.angleOffset
//                                                               endAngle:offset
//                                                              clockwise:YES];
        CGMutablePathRef solidArcPath = CGPathCreateMutable();
        CGPathAddArc(solidArcPath, NULL, self.boundsCenter.x, self.boundsCenter.y, self.circleRadius, -self.angleOffset, offset, NO);
        CGContextAddPath(context, solidArcPath);
        CGContextSetStrokeColorWithColor(context, self.startColor);
        CGContextStrokePath(context);
        CGContextTranslateCTM(context, CGRectGetMidX(self.circleRect), CGRectGetMidY(self.circleRect));   // 회전을 위해 회전축으로 옮긴다.
        CGContextRotateCTM(context, offset);                                                              // context를 회전시킨다.
        CGContextTranslateCTM(context, -CGRectGetMidX(self.circleRect), -CGRectGetMidY(self.circleRect)); // 원래대로 갖다 놓는다.
        CGPathRelease(solidArcPath);
    }
    
    //! Draw shadow and Zero progress Showing 결정한다. 언제나 그래디언트 패스에 의해 덮힌다.
    if (self.progress > 0.0 || self.hidesRingForZeroProgress == NO) {
        CGContextSaveGState(context); // <- Save
        if (self.endShadowOpacity > 0.0) {
            CGPathRef path = CGPathCreateCopyByStrokingPath(circlePath, // 선을 면으로 만들고 면을 둘러싼 선을 반환한다.완전 원.
                                                            NULL,
                                                            self.ringWidth,
                                                            kCGLineCapRound,
                                                            kCGLineJoinRound,
                                                            0.f);
            CGContextAddPath(context, path);
            CGContextClip(context); // 우선자른다. 여기서 놀라는 뜻이다.
            CGSize shadowOffset = CGSizeMake((self.ringWidth / 10.0) * cos(angle + self.angleOffset), // 항상 그림자가 진행방향으로 향하게 한다.
                                             (self.ringWidth / 10.0) * sin(angle + self.angleOffset));
            CGContextSetShadowWithColor(context,
                                        shadowOffset,
                                        self.ringWidth / 3.0, // blur
                                        [MGEColor colorWithWhite:0.f alpha:self.endShadowOpacity].CGColor);
            CGPathRelease(path); // CGPathCreateCopyByStrokingPath로 반환된 path는 프로그래머가 해제할 의무가 있다.
        }
        
        CGPoint arcEndCenter = CGPointMake(self.boundsCenter.x + (self.circleRadius * cos(self.cuttingAngle)),
                                     self.boundsCenter.y + (self.circleRadius * sin(self.cuttingAngle)));
        
        // UIBezierPath *shadowPath; // shadow 만을 위해 존재하는 것이 아니다. zero 상태일 때, 표기할 필요가 있다면 모양을 만든다.
        CGPathRef shadowPath = NULL;
        switch (self.progressStyle) {
            case MGERingProgressViewStyleRound:  {
                CGRect rect = CGRectMake(arcEndCenter.x - self.ringWidth / 2,
                                         arcEndCenter.y - self.ringWidth / 2,
                                         self.ringWidth,
                                         self.ringWidth);
                shadowPath = CGPathCreateWithEllipseInRect(rect, NULL);
//                shadowPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(arcEndCenter.x - self.ringWidth / 2,
//                                                                               arcEndCenter.y - self.ringWidth / 2,
//                                                                               self.ringWidth,
//                                                                               self.ringWidth)];
                break;
            }
            case MGERingProgressViewStyleSquare:  {
//                shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(arcEndCenter.x - self.ringWidth / 2,
//                                                                         arcEndCenter.y - 2.0,
//                                                                         self.ringWidth,
//                                                                         2.0)];
                
//                [shadowPath applyTransform:CGAffineTransformMakeTranslation(-arcEndCenter.x, -arcEndCenter.y)];
//                [shadowPath applyTransform:CGAffineTransformMakeRotation(self.cuttingAngle)];
//                [shadowPath applyTransform:CGAffineTransformMakeTranslation(arcEndCenter.x, arcEndCenter.y)];
                CGAffineTransform transform1 = CGAffineTransformMakeTranslation(-arcEndCenter.x, -arcEndCenter.y);
                CGAffineTransform transform2 = CGAffineTransformMakeRotation(self.cuttingAngle);
                CGAffineTransform transform3 = CGAffineTransformMakeTranslation(arcEndCenter.x, arcEndCenter.y);
                CGRect rect = CGRectMake(arcEndCenter.x - self.ringWidth / 2,
                                         arcEndCenter.y - 2.0,
                                         self.ringWidth,
                                         2.0);
                shadowPath = CGPathCreateWithRect(rect, NULL);
                shadowPath = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(shadowPath), &transform1);
                shadowPath = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(shadowPath), &transform2);
                shadowPath = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(shadowPath), &transform3);
                break;
            }
            default:
                break;
        }
        
        
        CGColorRef shadowFillColor;
        CGFloat fadeStartProgress = 0.02;
        if ( (self.hidesRingForZeroProgress == NO) || (self.progress > fadeStartProgress) ) {
            shadowFillColor = self.startColor;
            CGContextAddPath(context, (CGPathRef)CFAutorelease(shadowPath));
            CGContextSetFillColorWithColor(context, shadowFillColor);
        } else {
            shadowFillColor = CGColorCreateCopyWithAlpha(self.startColor, self.progress / fadeStartProgress);
            CGContextAddPath(context, (CGPathRef)CFAutorelease(shadowPath));
            CGContextSetFillColorWithColor(context, shadowFillColor);
            CGColorRelease(shadowFillColor);
        }
        
        CGContextFillPath(context);
        CGContextRestoreGState(context);  // <- Restore
    }
    
    //! Draw gradient arc
    if (self.progress > 0.0) {
        CGMutablePathRef gradientableArcPath = CGPathCreateMutable();
        CGPathAddArc(gradientableArcPath, NULL, self.boundsCenter.x, self.boundsCenter.y, self.circleRadius, -self.angleOffset, self.cuttingAngle, NO);
//        UIBezierPath *gradientableArcPath = [UIBezierPath bezierPathWithArcCenter:self.boundsCenter
//                                                                           radius:self.circleRadius
//                                                                       startAngle:-self.angleOffset
//                                                                         endAngle:self.cuttingAngle
//                                                                        clockwise:YES];
        
        if (CGColorEqualToColor(self.startColor, self.endColor) == NO) {
            CGContextSaveGState(context);
            CGPathRef path = CGPathCreateCopyByStrokingPath(gradientableArcPath, // 선분자체를 면으로 만들고 그 면을 둘러싼 선을 반환한다.
                                                            NULL,
                                                            self.ringWidth,
                                                            [self lineCap:self.progressStyle],
                                                            [self lineJoin:self.progressStyle],
                                                            0.0f);
            CGContextAddPath(context, path);
            CGContextClip(context);
            CGContextSetInterpolationQuality(context, kCGInterpolationNone); // 보간품질, 디폴트는 kCGInterpolationDefault
            CGContextDrawImage(context, self.SquareRectConsistingOfIntegersForGradient, [self gradientImage]);
            CGContextRestoreGState(context);
            CGPathRelease(path); // CGPathCreateCopyByStrokingPath로 만든 path는 프로그래머가 해제할 의무가 있다.
        } else {
            CGContextSetStrokeColorWithColor(context, self.startColor);
            CGContextSetLineWidth(context, self.ringWidth);
            CGContextSetLineCap(context, [self lineCap:self.progressStyle]);
            CGContextAddPath(context, gradientableArcPath); // gradient 하지 못한다.
            CGContextStrokePath(context);
        }
        CGPathRelease(gradientableArcPath);
    }
    
    if (circlePath != NULL) {
        CGPathRelease(circlePath);
    }
    //
    // CGPathCreateCopyByStrokingPath 위키를 참고하라. path를 면으로 놓고 그 면을 둘러싼 선분을 반환한다.
    // path는 프로그래머가 해제할 의무가 있다.
}


#pragma mark - drawInContext: 메서드에서의 사용을 위한 Dynamic Private 게터
- (CGRect)squareRect {
    CGFloat lengthOfOneSide = MIN(self.bounds.size.width, self.bounds.size.height);
    return CGRectMake(0.f, 0.f, lengthOfOneSide, lengthOfOneSide);
}

- (CGRect)SquareRectConsistingOfIntegersForGradient {
    return  CGRectIntegral(self.squareRect);
}

- (CGRect)circleRect {
    return CGRectInset(self.squareRect, self.ringWidth / 2.0, self.ringWidth / 2.0);
}

- (CGFloat)circleRadius {
    return (MIN(self.bounds.size.width, self.bounds.size.height) / 2.0) - (self.ringWidth / 2.0);
    //
    // 원의 반경이다. 원의 두께는 고려하지 않는다. 원이 딱 닿아있다. 따라서, 원의 선 두께의 반을 빼야한다.
}

- (CGPoint)boundsCenter {
    return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (CGFloat)angleOffset {
    return M_PI_2;
    //
    // 12시 방향에서 시작할 것이므로. 이걸 빼서 뒤로간다.
}

- (CGFloat)angle {
    return (2 * M_PI * self.progress) - self.angleOffset;
}

- (CGFloat)maxAngle {
    CGFloat base = [self circleRadius]; // 주어지는 큰 원의 반경. 굵기 고려하지 않고 선만 고려. 삼각형의 밑변
    CGFloat height = self.ringWidth / 2.0; // 소세지 끝부분의 원의 반경. 삼각형의 높이.
    _edgeAngle = atan(height / base); // 소세지 끝부분에 튀어나오는 길이에 대응 하는 각.
    return (2 * M_PI) - self.angleOffset - (3.0 * _edgeAngle * 1.1); // 그림자 삐져나오는 것을 막기위해 1.1곱함.
    //
    // 삼각 방정식 12시에 edgeAngle 만큼 반시계방향에서 부터 image가 시계방향으로 그려지게 될 것이다.
}

- (CGFloat)cuttingAngle {
    CGFloat maxAngle = self.maxAngle;
    CGFloat angle = self.angle;
    if (angle > maxAngle) {
        return maxAngle;
    } else {
        return angle;
    }
}


#pragma mark - 세터 & 게터
- (void)setRingWidth:(CGFloat)ringWidth {
    if (_ringWidth != ringWidth) {
        _ringWidth = ringWidth;
        [self setNeedsDisplay];
    }
}

- (void)setProgressStyle:(MGERingProgressViewStyle)progressStyle {
    if (_progressStyle != progressStyle) {
        _progressStyle = progressStyle;
        [self setNeedsDisplay];
    }
}

- (void)setEndShadowOpacity:(CGFloat)endShadowOpacity  {
    endShadowOpacity = MIN(MAX(endShadowOpacity, 0.0), 1.0);
    if (_endShadowOpacity != endShadowOpacity) {
        _endShadowOpacity = endShadowOpacity;
        [self setNeedsDisplay];
    }
}

- (void)setHidesRingForZeroProgress:(BOOL)hidesRingForZeroProgress {
    if (_hidesRingForZeroProgress != hidesRingForZeroProgress) {
        _hidesRingForZeroProgress = hidesRingForZeroProgress;
        [self setNeedsDisplay];
    }
}

- (void)setStartColor:(CGColorRef)startColor {
    if (CGColorEqualToColor(_startColor, startColor) == NO) {
        CGColorRef oldColor = _startColor;
        CGColorRelease(oldColor);
        _startColor = startColor;
        CGColorRetain(startColor);
        [self setNeedsDisplay];
    }
}

/// The progress ring end color.
- (void)setEndColor:(CGColorRef)endColor {
    if (CGColorEqualToColor(_endColor, endColor) == NO) {
        CGColorRef oldColor = _endColor;
        CGColorRelease(oldColor);
        _endColor = endColor;
        CGColorRetain(endColor);
        [self setNeedsDisplay];
    }
}

- (void)setBackgroundRingColor:(CGColorRef)backgroundRingColor {
    if (CGColorEqualToColor(_backgroundRingColor, backgroundRingColor) == NO) {
        CGColorRef oldColor = _backgroundRingColor;
        CGColorRelease(oldColor);
        _backgroundRingColor = backgroundRingColor;
        CGColorRetain(backgroundRingColor);
        [self setNeedsDisplay];
    }
}

- (void)setGradientImageScale:(CGFloat)gradientImageScale {
    if (_gradientImageScale != gradientImageScale) {
        _gradientImageScale = gradientImageScale;
        [self setNeedsDisplay];
    }
}


#pragma mark - 지원 메서드
- (CGLineCap)lineCap:(MGERingProgressViewStyle)style {
    
    switch (style) {
        case MGERingProgressViewStyleRound: {
            return kCGLineCapRound;
            break;
        }
        case MGERingProgressViewStyleSquare: {
            return kCGLineCapButt;
            break;
        }
        default:
            break;
    }
}

- (CGLineJoin)lineJoin:(MGERingProgressViewStyle)style {
    
    switch (style) {
        case MGERingProgressViewStyleRound: {
            return kCGLineJoinRound;
            break;
        }
        case MGERingProgressViewStyleSquare: {
            return kCGLineJoinMiter;
            break;
        }
        default:
            break;
    }
}

- (CGImageRef )gradientImage {
    self.gradientGenerator.scale      = self.gradientImageScale; //! 1.0으로 해서 퍼포먼스에 지장을 덜주게 만든다.
    self.gradientGenerator.size       = self.SquareRectConsistingOfIntegersForGradient.size;
    self.gradientGenerator.startColor = self.startColor;
    self.gradientGenerator.endColor   = self.endColor;
    self.gradientGenerator.edgeAngle  = _edgeAngle;
    
    return [self.gradientGenerator image]; // 한번 만들면 다시 만들지 않는다. 물론, 색이 변하거나 프라퍼티가 변하면 변할 수 있다.
    
    /*** 사실 다음과 같은 명령문으로 MGEGradientGenerator 클래스를 통으로 제거할 수 있으나, kCAGradientLayerConic 버그가 존재한다.
    CGRect baseRect = self.SquareRectConsistingOfIntegersForGradient;
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame      = baseRect;
    layer.type       = kCAGradientLayerConic; // kCAGradientLayerAxial, kCAGradientLayerRadial 는 정상이다.
    layer.colors     = @[(id)self.startColor, (id)self.startColor, (id)self.endColor, (id)self.endColor];
    layer.locations  = @[@(0.f), @(3.f/16.f), @(13.f/16.f), @(1.f)];
    layer.startPoint = CGPointMake(0.5, 0.5);
    layer.endPoint   = CGPointMake(1.f - (sqrt(2) / 2.f), 0.f);
    
    UIGraphicsBeginImageContext(baseRect.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage.CGImage; ***/
}
@end
