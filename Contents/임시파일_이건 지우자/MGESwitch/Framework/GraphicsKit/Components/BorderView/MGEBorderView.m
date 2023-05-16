//
//  MGEBorderView.m
//  MGEBorderLayer Project
//
//  Created by Kwan Hyun Son on 2021/10/10.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGEBorderView.h"

@interface MGEBorderView ()
@end

@implementation MGEBorderView
@dynamic borderLayer;

#if TARGET_OS_OSX
- (NSView *)hitTest:(NSPoint)point {
    return nil; // userInteractionEnabled -- NO
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    [self setBorderColors:self.borderColors];
    [self setStartColors:self.startColors];
    [self setEndColors:self.endColors];
    //
    // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
    // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
}

#elif TARGET_OS_IPHONE
+ (Class)layerClass {
    return [MGEBorderLayer class];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection]; // 최초에 반드시 호출!

    //! 색깔.
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self setBorderColors:self.borderColors];
        [self setStartColors:self.startColors];
        [self setEndColors:self.endColors];
        //
        // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
        // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
    }
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
static void CommonInit(MGEBorderView *self) {
#if TARGET_OS_OSX
    self.layer = [MGEBorderLayer layer];
    self.wantsLayer = YES;
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
#elif TARGET_OS_IPHONE
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
#endif
}


#pragma mark - 세터 & 게터
- (MGEBorderLayer *)borderLayer {
    return (MGEBorderLayer *)self.layer;
}

- (void)setBorderColors:(NSArray <MGEColor *>*)borderColors {
    _borderColors = borderColors;
    MGEBorderLayer *borderLayer = [self borderLayer];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:borderColors.count];
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        for (MGEColor *color in borderColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.borderColors = mArr.copy;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        for (MGEColor *color in borderColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.borderColors = mArr.copy;
    }];
#endif
}

- (void)setStartColors:(NSArray <MGEColor *>*)startColors {
    _startColors = startColors;
    MGEBorderLayer *borderLayer = [self borderLayer];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:startColors.count];
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        for (MGEColor *color in startColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.startColors = mArr.copy;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        for (MGEColor *color in startColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.startColors = mArr.copy;
    }];
#endif
}

- (void)setEndColors:(NSArray<MGEColor *> *)endColors {
    _endColors = endColors;
    MGEBorderLayer *borderLayer = [self borderLayer];
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:endColors.count];
#if TARGET_OS_OSX
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        for (MGEColor *color in endColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.endColors = mArr.copy;
    }];
#elif TARGET_OS_IPHONE
    [self.traitCollection performAsCurrentTraitCollection:^{
        for (MGEColor *color in endColors) {
            [mArr addObject:(id)(color.CGColor)];
        }
        borderLayer.endColors = mArr.copy;
    }];
#endif
}

@end
