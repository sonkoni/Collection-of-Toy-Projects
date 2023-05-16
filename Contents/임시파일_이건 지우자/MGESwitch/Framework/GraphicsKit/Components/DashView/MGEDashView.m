//
//  MGEDashView.m
//  MGRFlow Project
//
//  Created by Kwan Hyun Son on 2021/12/21.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEDashView.h"
#import "MGEPathHelper.h"

@interface MGEDashView ()
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer; // @dynamic
@end

@implementation MGEDashView
@dynamic shapeLayer;

#if TARGET_OS_IPHONE
+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection]; // 최초에 반드시 호출!

    //! 색깔.
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.shapeLayer.strokeColor = self.dashColor.CGColor;
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateDashPath];
}
#else
- (NSView *)hitTest:(NSPoint)point {
    return nil; // userInteractionEnabled -- NO
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    NSAppearance *effectiveAppearance = self.effectiveAppearance; // OR [NSApp effectiveAppearance];
    [effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        self.shapeLayer.strokeColor = self.dashColor.CGColor;
    }];
}

- (void)layout {
    [super layout];
    [self updateDashPath];
}
#endif

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEDashView *self) {
#if TARGET_OS_IPHONE
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
#else
    self.layer = [CAShapeLayer layer];
    self.wantsLayer = YES;
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
#endif
    
    self->_dashColor = [MGEColor redColor];
    self->_dashLineWidth = 1.0;
    self->_lineCap = kCALineCapButt;
    self->_lineJoin = kCALineJoinMiter;
    self->_lineDashPattern = @[@(5), @(5)];
    self->_lineDashPhase = 0.0;
    self->_cornerRadius = 0.0;
    self->_visibleWhenAnimation = NO;
    self->_duration = 0.5;
    
    self.shapeLayer.fillColor = [MGEColor clearColor].CGColor;
    self.shapeLayer.strokeColor = self.dashColor.CGColor;
    self.shapeLayer.lineWidth = self.dashLineWidth;
    self.shapeLayer.lineCap = self.lineCap;
    self.shapeLayer.lineJoin = self.lineJoin;
    self.shapeLayer.lineDashPattern = self.lineDashPattern;
    self.shapeLayer.lineDashPhase = self.lineDashPhase;
}


#pragma mark - 세터 & 게터
- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)(self.layer);
}

- (void)setDashColor:(MGEColor *)dashColor {
    _dashColor = dashColor;
    __weak __typeof(self) weakSelf = self;
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        weakSelf.shapeLayer.strokeColor = dashColor.CGColor;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        weakSelf.shapeLayer.strokeColor = dashColor.CGColor;
    }];
#endif
}

- (void)setLineCap:(CAShapeLayerLineCap)lineCap {
    _lineCap = lineCap;
    self.shapeLayer.lineCap = lineCap;
}

- (void)setLineJoin:(CAShapeLayerLineJoin)lineJoin {
    _lineJoin = lineJoin;
    self.shapeLayer.lineJoin = lineJoin;
}

- (void)setDashLineWidth:(CGFloat)dashLineWidth {
    _dashLineWidth = dashLineWidth;
    self.shapeLayer.lineWidth = dashLineWidth;
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
    _lineDashPattern = lineDashPattern;
    self.shapeLayer.lineDashPattern = lineDashPattern;
}

- (void)setLineDashPhase:(CGFloat)lineDashPhase {
    _lineDashPhase = lineDashPhase;
    self.shapeLayer.lineDashPhase = lineDashPhase;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateDashPath];
}

- (void)setVisibleWhenAnimation:(BOOL)visibleWhenAnimation {
    _visibleWhenAnimation = visibleWhenAnimation;
    if ([self.shapeLayer animationForKey:@"InfiniteAnimationKey"] == nil &&
        visibleWhenAnimation == YES) { // 애니메이션이 진행중이 아니라면.
        self.shapeLayer.opacity = 0.0;
    }
}

- (void)setDashPath:(MGEBezierPath *)dashPath {
    _dashPath = dashPath;
    [self updateDashPath];
}


#pragma mark - Action
- (void)dashAnimationActive:(BOOL)active {
    if (active == YES && [self.shapeLayer animationForKey:@"InfiniteAnimationKey"] == nil) { // 애니메이션을 생성하기 위해.
        CGFloat startLineDashPhase = self.lineDashPhase;
        CGFloat endLineDashPhase = startLineDashPhase;
        for (NSNumber *number in self.lineDashPattern) {
            endLineDashPhase = endLineDashPhase + [number doubleValue];
        }
        
        CABasicAnimation *infiniteAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        infiniteAnimation.fromValue = @(startLineDashPhase);
        infiniteAnimation.toValue = @(endLineDashPhase);
        infiniteAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        infiniteAnimation.duration = self.duration;
        infiniteAnimation.repeatCount = INFINITY; // #define INFINITY    HUGE_VALF
        infiniteAnimation.removedOnCompletion = NO;
        infiniteAnimation.fillMode = kCAFillModeForwards;
        
        [CATransaction setCompletionBlock:^{}];
        [self.shapeLayer addAnimation:infiniteAnimation forKey:@"InfiniteAnimationKey"];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
        
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionFade];
        [transition setDuration:0.15];
        [self.shapeLayer addAnimation:transition forKey:nil];
        self.shapeLayer.opacity = 1.0;
    } else if (active == NO && [self.shapeLayer animationForKey:@"InfiniteAnimationKey"] != nil) { // 애니메이션을 없애기 위해.
        CATransition *transition = [CATransition animation];
        [transition setType:kCATransitionFade];
        [transition setDuration:0.15];
        [CATransaction setCompletionBlock:^{
            [self.shapeLayer removeAllAnimations];
        }];
        [self.shapeLayer addAnimation:transition forKey:nil];
        if (self.visibleWhenAnimation == YES) {
            self.shapeLayer.opacity = 0.0;
        }
        
    }
}


#pragma mark - Helper
- (void)updateDashPath {
    if (self.dashPath == nil) {
        CGPathRef path = CGPathCreateWithRoundedRect(self.bounds, self.cornerRadius, self.cornerRadius, NULL);
        self.shapeLayer.path = (CGPathRef)CFAutorelease(path);
    } else {
#if TARGET_OS_IPHONE
        self.shapeLayer.path = self.dashPath.CGPath;
#else
        self.shapeLayer.path = MGECGPathGetPath(self.dashPath);
#endif
    }
}

@end
