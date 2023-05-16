//
//  MGUFavSwitchSparkLayer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFavSwitchSparkLayer.h"
@import GraphicsKit;

@interface MGUFavSwitchSparkLayer () <CAAnimationDelegate>

/*** line version ***/
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*lineLayers;
@property (nonatomic, strong) CAKeyframeAnimation *lineStrokeStartAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *lineStrokeEndAnimation;
@property (nonatomic, strong) CAKeyframeAnimation *lineOpacityAnimation;

/*** Shine version ***/
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*bigShineLayers;
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*smallShineLayers;
@property (nonatomic, strong, nullable) CADisplayLink *displaylink;
@property (nonatomic, strong) NSArray <UIColor *>*colorRandom;

@property (nonatomic, assign, readonly) CGPoint boundsCenter;

@end

@implementation MGUFavSwitchSparkLayer
//@dynamic lineFrameRatio;
@dynamic boundsCenter;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)setTimeDuration:(CGFloat)timeDuration {
    _timeDuration = timeDuration;
    self.lineStrokeStartAnimation.duration = 0.6 * timeDuration;
    self.lineStrokeEndAnimation.duration = 0.6 * timeDuration;
    self.lineOpacityAnimation.duration = timeDuration;
}

- (CGFloat)shineTimeDuration {
    return self.timeDuration - (self.timeDuration * 0.333);
}


- (void)commonInit {
    _useRandomColorOnShineMode = YES;
    _useFlashOnShineMode = YES;
    _sparkMode = MGUFavoriteSwitchSparkModeline;
    
    _lineLayers = @[].mutableCopy;
    for (NSInteger i = 0; i < 5; i++) { // 5 개로 구성됨.
        [self.lineLayers addObject:[CAShapeLayer layer]];
    }
    _lineStrokeStartAnimation     = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"]; // <- line
    _lineStrokeEndAnimation       = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];   // <- line
    _lineOpacityAnimation         = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];     // <- line

    [self animationBasicSetup:self.lineStrokeStartAnimation];
    [self animationBasicSetup:self.lineStrokeEndAnimation];
    [self animationBasicSetup:self.lineOpacityAnimation];
    
    _bigShineLayers   = @[].mutableCopy; // 7
    _smallShineLayers = @[].mutableCopy; // 7
    
    for (NSInteger i = 0; i < 7; i++) { // 5 개로 구성됨.
        [self.bigShineLayers addObject:[CAShapeLayer layer]];
        [self.smallShineLayers addObject:[CAShapeLayer layer]];
    }
    _colorRandom = @[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:153.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0],
                     
                     [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:102.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0],
                     
                     [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1.0],
                     [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0],
                     
                     [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0]];
}

- (void)animationBasicSetup:(CAKeyframeAnimation *)animation {
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.calculationMode = kCAAnimationLinear;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

- (void)setupSparkLayerAnimation {
    for (CAShapeLayer *layer in self.sublayers.reverseObjectEnumerator) {
        [layer removeFromSuperlayer];
    }
    
    if (self.sparkMode == MGUFavoriteSwitchSparkModeline) {
        [self setupLineLayerAnimation];
    } else {
        [self setupShineLayerAnimation];
    }
}

- (void)setupLineLayerAnimation {
    for (NSInteger i = 0; i < 5; i++) { // 5 개로 구성됨.
        CAShapeLayer *line = self.lineLayers[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        line.transform = CATransform3DIdentity;
        [CATransaction commit];
    
        line.frame = self.bounds;
    
        line.strokeColor = self.sparkColor.CGColor;
        line.lineWidth  = (2.0/44.0) * self.bounds.size.width;
        line.miterLimit = (2.0/44.0) * self.bounds.size.width;
    
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, CGRectGetMidX(line.bounds), CGRectGetMidY(line.bounds));
        CGPathAddLineToPoint(path, NULL, CGRectGetMidX(line.bounds), CGRectGetMaxY(line.bounds) * (5.0/4.0));
        line.path = path;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.strokeStart = 0.0;
        line.strokeEnd = 0.0;
        line.opacity = 0.0;
    
        //! i = 0 일 때, 6 시 방향이다.
        line.transform = CATransform3DMakeRotation((M_PI * 2 / 5) * i, 0.0, 0.0, 1.0);
        [self addSublayer:line];
    }
    
    
    //! line stroke animation --------------------------------------------
    self.lineStrokeStartAnimation.values = @[
        @(0.0),    //  0/18
        @(0.0),    //  1/18
        @(0.18),   //  2/18
        @(0.2),    //  3/18
        @(0.26),   //  4/18
        @(0.32),   //  5/18
        @(0.4),    //  6/18
        @(0.6),    //  7/18
        @(0.71),   //  8/18
        @(0.89),   // 17/18
        @(0.92)    // 18/18
    ];
    self.lineStrokeStartAnimation.keyTimes = @[
        @(0.0),    //  0/18
        @(0.056),  //  1/18
        @(0.111),  //  2/18
        @(0.167),  //  3/18
        @(0.222),  //  4/18
        @(0.278),  //  5/18
        @(0.333),  //  6/18
        @(0.389),  //  7/18
        @(0.444),  //  8/18
        @(0.944),  // 17/18
        @(1.0),    // 18/18
    ];
    
    self.lineStrokeEndAnimation.values = @[
        @(0.0),    //  0/18
        @(0.0),    //  1/18
        @(0.32),   //  2/18
        @(0.48),   //  3/18
        @(0.64),   //  4/18
        @(0.68),   //  5/18
        @(0.92),   // 17/18
        @(0.92)    // 18/18
    ];
    self.lineStrokeEndAnimation.keyTimes = @[
        @(0.0),    //  0/18
        @(0.056),  //  1/18
        @(0.111),  //  2/18
        @(0.167),  //  3/18
        @(0.222),  //  4/18
        @(0.278),  //  5/18
        @(0.944),  // 17/18
        @(1.0),    // 18/18
    ];
    
    self.lineOpacityAnimation.values = @[
        @(1.0),    //  0/30
        @(1.0),    // 12/30
        @(0.0)     // 17/30
    ];
    self.lineOpacityAnimation.keyTimes = @[
        @(0.0),    //  0/30
        @(0.4),    // 12/30
        @(0.567)   // 17/30
    ];
}

- (void)setupShineLayerAnimation {
    CGFloat angle = (M_PI * 2.0) / 7.0;
    CGFloat startAngle = M_PI * 2.0 - (angle / 7.0);  // 크게 의미가 없다. 그냥 임의로 약간 비뚤게 하는 것 뿐이다.
    CGFloat radius = self.frame.size.width / 2.0 * (1.5);
    
    for (NSInteger i = 0; i < 7; i++) {
        CAShapeLayer *bigShine   = self.bigShineLayers[i];
        CAShapeLayer *smallShine = self.smallShineLayers[i];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        bigShine.opacity = 0.0f;
        smallShine.opacity = 0.0f;
        [CATransaction commit];
        bigShine.frame = self.bounds;
        smallShine.frame = self.bounds;
        
        CGFloat bigWidth = self.frame.size.width * 0.15;
        
        CGPoint xanchoxis = CGPointMake(self.boundsCenter.x, self.boundsCenter.y - radius);
        CGPoint center = MGERotatePointAboutCenter(self.boundsCenter, xanchoxis, startAngle + angle * i);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:bigWidth
                                                        startAngle:0.0
                                                          endAngle:M_PI * 2.0
                                                         clockwise:NO];
        bigShine.path = path.CGPath;
//        NSInteger index = (NSInteger)(arc4random_uniform((uint32_t)(7)));
//        bigShine.fillColor = self.colorRandom[index].CGColor;
        [self addSublayer:bigShine];
            
        CGFloat smallWidth = bigWidth * 0.66;
        CGFloat centerAngle = startAngle + (angle * i) - (20.0 * M_PI / 180.0); // 20˚ 차이가 나게 만든다.
        
        xanchoxis = CGPointMake(self.boundsCenter.x, self.boundsCenter.y - (radius-bigWidth));
        CGPoint smallCenter = MGERotatePointAboutCenter(self.boundsCenter, xanchoxis, centerAngle);
        
        UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:smallCenter
                                                                 radius:smallWidth
                                                             startAngle:0.0
                                                               endAngle:M_PI * 2.0
                                                              clockwise:NO];
        
        smallShine.path = smallPath.CGPath;
        
//        index = (NSInteger)(arc4random_uniform((uint32_t)(self.colorRandom.count)));
//        smallShine.fillColor = self.colorRandom[index].CGColor;
        
        [self addSublayer:smallShine];
        [self.smallShineLayers addObject:smallShine];
    }
}


- (CGPoint)boundsCenter {
    return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}

- (void)startSparkAnimation {
    for (CAShapeLayer *layer in self.sublayers) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer.opacity = 1.0f;
        [CATransaction commit];
    }
    
    if (self.sparkMode == MGUFavoriteSwitchSparkModeline) {
        [self startLineLayerAnimation];
    } else {
        [self startShineLayerAnimation];
    }
}

- (void)startLineLayerAnimation {
    for (NSInteger i = 0; i < 5; i++) {
        [self.lineLayers[i] addAnimation:self.lineStrokeStartAnimation forKey:@"StrokeStartAnimationKey"];
        [self.lineLayers[i] addAnimation:self.lineStrokeEndAnimation forKey:@"StrokeEndAnimationKey"];
        [self.lineLayers[i] addAnimation:self.lineOpacityAnimation forKey:@"OpacityAnimationKey"];
    }
}

- (void)startShineLayerAnimation {
    CGFloat radius = self.frame.size.width / 2.0 * (1.5 * 1.4);
    CGFloat angle = (M_PI * 2.0 / 7);
    CGFloat startAngle = M_PI * 2.0 - (angle / 7.0f);
    
    for (NSInteger i = 0; i < 7; i++) {
        CAShapeLayer *bigShineLayer = self.bigShineLayers[i];
        CABasicAnimation *bigPathAnimation = [self getAngleAnimShine:bigShineLayer
                                                               angle:startAngle + (angle * i)
                                                              radius:radius];
        
        CAShapeLayer *smallShineLayer = self.smallShineLayers[i];
        CGFloat radiusSub = self.frame.size.width * 0.15 * 0.66;
        
        CGFloat angleX = startAngle + (angle * i) - (20.0f * M_PI / 180.0); // smallShineOffsetAngle 20˚
        CABasicAnimation *smallPathAnimation = [self getAngleAnimShine:smallShineLayer
                                                                 angle:angleX
                                                                radius:radius-radiusSub];
        [bigShineLayer addAnimation:bigPathAnimation forKey:@"BigPathAnimationKey"];
        [smallShineLayer addAnimation:smallPathAnimation forKey:@"SmallPathAnimationKey"];
        
        
        if (self.useRandomColorOnShineMode == YES) {
            NSInteger index = (NSInteger)(arc4random_uniform((uint32_t)(7)));
            bigShineLayer.fillColor = self.colorRandom[index].CGColor;
            index = (NSInteger)(arc4random_uniform((uint32_t)(self.colorRandom.count)));
            smallShineLayer.fillColor = self.colorRandom[index].CGColor;
        }
        
        if (self.useFlashOnShineMode == YES) {
            CABasicAnimation *bigOpacityAnimation   = [self getFlashAnimation];
            CABasicAnimation *smallOpacityAnimation = [self getFlashAnimation];
            [bigShineLayer addAnimation:bigOpacityAnimation forKey:@"BigOpacityAnimationKey"];
            [smallShineLayer addAnimation:smallOpacityAnimation forKey:@"SmallOpacityAnimationKey"];
        }
    }
    
    
    CABasicAnimation *angleAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    angleAnim.duration = [self shineTimeDuration];
    angleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    angleAnim.fromValue = @(0.0);
    
    angleAnim.toValue = @((20.0f * M_PI / 180.0)); // shineTurnAngle 20.0f
    angleAnim.delegate = self;
    [self addAnimation:angleAnim forKey:@"rotate"];
    
    if (self.useFlashOnShineMode == YES) {
        [self startFlash];
    }
}

- (CABasicAnimation *)getAngleAnimShine:(CAShapeLayer *)shine angle:(CGFloat)angle radius:(CGFloat)radius {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
//    anim.duration = self.timeDuration;
    anim.duration = [self shineTimeDuration];
    anim.fromValue = (__bridge id)shine.path;
    
    CGPoint xanchoxis = CGPointMake(self.boundsCenter.x, self.boundsCenter.y - radius);
    CGPoint center = MGERotatePointAboutCenter(self.boundsCenter, xanchoxis, angle);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:0.1
                                                    startAngle:0.0
                                                      endAngle:M_PI *2.0
                                                     clockwise:NO];
    anim.toValue = (__bridge id)path.CGPath;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

//! Shine Mode에서 Flash 사용
- (void)startFlash {
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(flashAction)];
    self.displaylink.preferredFramesPerSecond = 10;
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    // <- NSRunLoopCommonModes 해야 인터렉션 딜레이 방지할 수 있다.
}

- (void)flashAction { //! 랜덤으로 색을 변하게 한다.
    for (NSInteger i = 0; i < 7; i++) {
        CAShapeLayer *bigShine = self.bigShineLayers[i];
        CAShapeLayer *smallShine = self.smallShineLayers[i];
        NSInteger index = (NSInteger)(arc4random_uniform((uint32_t)(self.colorRandom.count)));
        bigShine.fillColor = self.colorRandom[index].CGColor;
        index = (NSInteger)(arc4random_uniform((uint32_t)(self.colorRandom.count)));
        smallShine.fillColor =  self.colorRandom[index].CGColor;
    }
}

- (CABasicAnimation *)getFlashAnimation {
    CABasicAnimation *flashAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashAnimation.fromValue = @(1.0);
    flashAnimation.toValue = @(0.0);
    NSTimeInterval duration = (NSTimeInterval)(arc4random() % 20 + 60.0) / 1000.0; //! 굉장히 빠르게 변한다.
    flashAnimation.duration = duration;
    flashAnimation.repeatCount = MAXFLOAT;
    flashAnimation.removedOnCompletion = NO;
    flashAnimation.autoreverses = YES;
    flashAnimation.fillMode = kCAFillModeForwards;
    return flashAnimation;
}

- (void)stopSparkAnimation {
    if (self.displaylink != nil) {
        [self.displaylink invalidate];
    }
    
    self.displaylink = nil;
    
    for (CAShapeLayer *layer in self.sublayers) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer.opacity = 0.0f;
        [CATransaction commit];
        [layer removeAllAnimations];
    }
    [self removeAllAnimations];
}

- (void)setSparkColor:(UIColor *)sparkColor {
    _sparkColor = sparkColor;
    for (CAShapeLayer *layer in self.lineLayers) {
        layer.strokeColor = sparkColor.CGColor;
        layer.strokeColor = UIColor.redColor.CGColor;
    }
    
    for (CAShapeLayer *layer in self.bigShineLayers) {
        layer.strokeColor = sparkColor.CGColor;
        layer.fillColor = sparkColor.CGColor;
    }
}

- (void)setSparkColor2:(UIColor *)sparkColor2 {
    for (CAShapeLayer *layer in self.smallShineLayers) {
        layer.strokeColor = sparkColor2.CGColor;
        layer.fillColor = sparkColor2.CGColor;
    }
}


#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        [self stopSparkAnimation];
    }
}

@end
