//
//  MGEGradientView.m
//
//  Created by Kwan Hyun Son on 2020/07/23.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGEGradientView.h"
#import "MGEGradientLayer.h"
#import "MGENoise.h"

@interface MGEGradientView ()
@end

#if TARGET_OS_IPHONE

@implementation MGEGradientView
@dynamic gradientLayer;

+ (Class)layerClass {
    return [MGEGradientLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection]; // 최초에 반드시 호출!

    //! 색깔.
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self setColors:self.colors];
        //
        // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
        // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
    }
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    UIColor *startColor = [UIColor colorWithRed:79.0/255.0 green:30.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:46.0/255.0 green:12.0/255.0 blue:80.0/255.0 alpha:1.0];
    self.gradientLayer.contentsScale = UIScreen.mainScreen.scale;
    
    self.gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    self.gradientLayer.locations = nil;
    self.gradientLayer.type = kCAGradientLayerAxial; // Linear를 의미한다.
}

#pragma mark - 세터 & 게터
- (MGEGradientLayer *)gradientLayer {
    return (MGEGradientLayer *)self.layer;
}

- (void)setColors:(NSArray <UIColor *>*)colors {
    _colors = colors;
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:colors.count];
    __weak __typeof(self) weakSelf = self;
    [self.traitCollection performAsCurrentTraitCollection:^{
        for (UIColor *color in colors) {
            [colorArr addObject:(id)color.CGColor];
        }
        weakSelf.gradientLayer.colors = colorArr.copy;
    }];
}

/** drawRect:를 이용해도 가능하다.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect]; // 사실 UIView를 직접 상속 받았을 때에는 구현 안해도 된다.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor *startColor = [UIColor colorWithRed:79.0/255.0 green:30.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:46.0/255.0 green:12.0/255.0 blue:80.0/255.0 alpha:1.0];
    
    NSArray *colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    
    NSArray *locations =  @[@(0.0), @(1.0)];
    CGFloat colorLocation[locations.count];
    for (NSInteger i = 0; i < locations.count; i++) {
        NSNumber *number = locations[i];
        colorLocation[i] = number.doubleValue;
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorLocation);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}
 */


@end
#else

@implementation MGEGradientView
@dynamic gradientLayer;

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

- (void)viewDidChangeEffectiveAppearance { // 다크모드 & 라이트모드 변경 감지
    [super viewDidChangeEffectiveAppearance];
    [self setColors:self.colors];
    //
    // set 메서드 내부에서 현재 모드를 Detecting 하는 코드를 넣었다.
    // 초기화 단계에서도 설정을 적절하게 해야하기 때문이다.
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGEGradientView *self) {
    self.layer = [MGEGradientLayer layer];
    self.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.wantsLayer = YES;
    NSColor *startColor = [NSColor colorWithRed:79.0/255.0 green:30.0/255.0 blue:122.0/255.0 alpha:1.0];
    NSColor *endColor = [NSColor colorWithRed:46.0/255.0 green:12.0/255.0 blue:80.0/255.0 alpha:1.0];
    self.gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    self.gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    self.gradientLayer.locations = nil;
    self.gradientLayer.type = kCAGradientLayerAxial; // Linear를 의미한다.
}


#pragma mark - 세터 & 게터
- (MGEGradientLayer *)gradientLayer {
    return (MGEGradientLayer *)self.layer;
}

- (void)setColors:(NSArray <NSColor *>*)colors {
    _colors = colors;
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:colors.count];
    __weak __typeof(self) weakSelf = self;
    [self.effectiveAppearance performAsCurrentDrawingAppearance:^{ // macOS 11.0+
        for (NSColor *color in colors) {
            [colorArr addObject:(id)color.CGColor];
        }
        weakSelf.gradientLayer.colors = colorArr.copy;
    }];
}

/** drawRect:를 이용해도 가능하다.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect]; // 사실 UIView를 직접 상속 받았을 때에는 구현 안해도 된다.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor *startColor = [UIColor colorWithRed:79.0/255.0 green:30.0/255.0 blue:122.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:46.0/255.0 green:12.0/255.0 blue:80.0/255.0 alpha:1.0];
    
    NSArray *colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    
    NSArray *locations =  @[@(0.0), @(1.0)];
    CGFloat colorLocation[locations.count];
    for (NSInteger i = 0; i < locations.count; i++) {
        NSNumber *number = locations[i];
        colorLocation[i] = number.doubleValue;
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, colorLocation);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}
 */


@end
#endif
