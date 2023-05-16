//
//  MGERingProgressView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGERingProgressView.h"

static NSString *ringProgressAnimationKey = @"ProgressAnimationKey";
static NSString *animationDidStopHandlerKey = @"animationDidStopHandlerKey";

@interface MGERingProgressView () <CAAnimationDelegate>
@property (nonatomic) MGERingProgressLayer *ringProgressLayer;
@property (nonatomic, nullable) NSString *overriddenAccessibilityValue;
@property (nonatomic, copy, nullable) void (^animationSuccessHandler)(void);
@end

@implementation MGERingProgressView
@dynamic ringWidth;
@dynamic progress;
@dynamic style;
@dynamic shadowOpacity;
@dynamic hidesRingForZeroProgress;
@dynamic gradientImageScale;

#if TARGET_OS_OSX
- (NSView *)hitTest:(NSPoint)point {
    return nil;
}

- (BOOL)isFlipped {
    return YES;
}
#endif

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)setAccessibilityValue:(NSString *)accessibilityValue {
    self.overriddenAccessibilityValue = accessibilityValue;
}

- (NSString *)accessibilityValue {
    NSString *str = self.overriddenAccessibilityValue;
    if (str != nil) {
        return str;
    } else {
        return [NSString stringWithFormat:@"%.f%%", self.progress * 100];
    }
}

#if TARGET_OS_IPHONE
- (void)layoutSubviews {
    [super layoutSubviews];
    self.ringProgressLayer.frame = self.layer.bounds;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self setStartColor:self.startColor];
        [self setEndColor:self.endColor];
        [self setBackgroundRingColor:self.backgroundRingColor];
        //
        // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
        // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
    }
}

#else
- (void)layout {
    [super layout];
    self.ringProgressLayer.frame = self.layer.bounds;
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    [self setStartColor:self.startColor];
    [self setEndColor:self.endColor];
    [self setBackgroundRingColor:self.backgroundRingColor];
    //
    // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
    // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
}
#endif


#pragma mark - 생성 & 소멸
static void CommonInit(MGERingProgressView *self) {
#if TARGET_OS_OSX
    self.wantsLayer = YES;
#endif
    self->_mediaTimingFunctionName = MGRMediaTimingFunctionEaseInOutCubic;
    self->_animationDuration = 0.5;
    self->_ringProgressLayer = [MGERingProgressLayer layer];
    self.ringProgressLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.ringProgressLayer];
    self.layer.drawsAsynchronously = YES; // 그리기 명령이 백그라운드 스레드에서 비동기적으로 지연되고(deferred) 처리되는지 여부
    self.layer.contentsScale = MGE_MAINSCREEN_SCALE;
    
#if TARGET_OS_IPHONE
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
#else
    self.accessibilityElement = YES;
    // self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently; <- AppKit에 대응하는 것을 못찾겠다.
#endif
    self.accessibilityLabel = @"Ring progress";
}


#pragma mark - 세터 & 게터
- (void)setRingWidth:(CGFloat)ringWidth {
    self.ringProgressLayer.ringWidth = ringWidth;
}

- (CGFloat)ringWidth {
    return self.ringProgressLayer.ringWidth;
}

- (CGFloat)progress { // 눈에 보이는데로 알려준다.
    if (self.ringProgressLayer.presentationLayer == nil) {
        return self.ringProgressLayer.progress;
    } else {
        return self.ringProgressLayer.presentationLayer.progress;
    }
}

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (MGERingProgressViewStyle)style {
    return self.ringProgressLayer.progressStyle;
}

- (void)setStyle:(MGERingProgressViewStyle)style {
    self.ringProgressLayer.progressStyle = style;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.ringProgressLayer.endShadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.ringProgressLayer.endShadowOpacity;
}

- (BOOL)hidesRingForZeroProgress {
    return self.ringProgressLayer.hidesRingForZeroProgress;
}

- (void)setHidesRingForZeroProgress:(BOOL)hidesRingForZeroProgress {
    self.ringProgressLayer.hidesRingForZeroProgress = hidesRingForZeroProgress;
}

- (void)setStartColor:(MGEColor *)startColor { // The start color of the progress ring.
    _startColor = startColor;
    __weak __typeof(self) weakSelf = self;
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        weakSelf.ringProgressLayer.startColor = startColor.CGColor;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        weakSelf.ringProgressLayer.startColor = startColor.CGColor;
    }];
#endif
}

- (void)setEndColor:(MGEColor *)endColor { // The end color of the progress ring.
    _endColor = endColor;
    __weak __typeof(self) weakSelf = self;
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        weakSelf.ringProgressLayer.endColor = endColor.CGColor;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        weakSelf.ringProgressLayer.endColor = endColor.CGColor;
    }];
#endif
}

- (void)setBackgroundRingColor:(MGEColor *)backgroundRingColor {
    _backgroundRingColor = backgroundRingColor;
    __weak __typeof(self) weakSelf = self;
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        weakSelf.ringProgressLayer.backgroundRingColor = backgroundRingColor.CGColor;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        weakSelf.ringProgressLayer.backgroundRingColor = backgroundRingColor.CGColor;
    }];
#endif
}

- (void)setGradientImageScale:(CGFloat)gradientImageScale {
    self.ringProgressLayer.gradientImageScale = gradientImageScale;
}

- (CGFloat)gradientImageScale {
    return self.ringProgressLayer.gradientImageScale;
}


#pragma mark - Action
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    if (animated == NO) {
        [self.ringProgressLayer removeAllAnimations];
        self.ringProgressLayer.progress = progress;
        return;
    }
    __weak __typeof(self) weakSelf = self;
    self.animationSuccessHandler = ^{
        weakSelf.ringProgressLayer.progress = progress;
    };
    
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"progress"];
    progressAnimation.duration = self.animationDuration;
    progressAnimation.timingFunction = [CAMediaTimingFunction functionWithCustomName:self.mediaTimingFunctionName];
    
    MGERingProgressLayer *presentationLayer = self.ringProgressLayer.presentationLayer;
    if (presentationLayer != nil) {
        self.ringProgressLayer.progress = presentationLayer.progress;
        progressAnimation.fromValue = @(presentationLayer.progress);
    } else {
        progressAnimation.fromValue = @(self.ringProgressLayer.progress);
    }
    
    progressAnimation.toValue   = @(progress);
    progressAnimation.removedOnCompletion = NO;
    progressAnimation.fillMode = kCAFillModeForwards;
    
    void (^completionBlock)(void) = ^(void) {};
    [CATransaction setCompletionBlock:completionBlock];
    progressAnimation.delegate = self;
    [progressAnimation setValue:ringProgressAnimationKey forKey:animationDidStopHandlerKey];
    [self.ringProgressLayer addAnimation:progressAnimation forKey:ringProgressAnimationKey];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


#pragma mark - 델리게이트 메서드 <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    //! 원래는 - updateProgress: 메서드 제일 아래 self.ringProgressLayer.progress = progress;를 넣었는데 아래 두 줄로 교체했다.
    if (flag == YES) {
        [self.ringProgressLayer removeAnimationForKey:ringProgressAnimationKey];
        if (self.animationSuccessHandler) {
            self.animationSuccessHandler();
        }
    } // else 일때는 애니메이션이 끝나기 전에 또 쳤다는 것이므로 자동으로 리무브가 된다. 또 리무브하면 파괴되버린다.
    
    if ([[anim valueForKey:animationDidStopHandlerKey] isEqualToString:ringProgressAnimationKey]) {
        if (self.animationCompletionHandler != nil) {
            self.animationCompletionHandler();
        }
    }
}

@end
