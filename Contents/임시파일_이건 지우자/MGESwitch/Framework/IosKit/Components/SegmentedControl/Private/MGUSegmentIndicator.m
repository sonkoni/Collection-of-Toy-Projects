//
//  MGUSegmentIndicator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSegmentIndicator.h"
#import "MGUSegmentConfiguration.h"

@implementation MGUSegmentIndicator

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque                  = NO;
        self.layer.masksToBounds     = YES;
        
        MGUSegmentConfiguration *configuration = [MGUSegmentConfiguration defaultConfiguration];
        ///self.cornerRadius            = 4.0f;
        self.borderColor             = configuration.segmentIndicatorBorderColor;
        self.borderWidth             = configuration.segmentIndicatorBorderWidth;
        self.drawsGradientBackground = configuration.drawsGradientBackground;
        self.gradientTopColor        = configuration.segmentIndicatorGradientTopColor;
        self.gradientBottomColor     = configuration.segmentIndicatorGradientBottomColor;
        self.backgroundColor         = configuration.segmentIndicatorBackgroundColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if ( self.drawsGradientBackground == YES ) {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[ (__bridge id)[self.gradientTopColor    CGColor],
                                  (__bridge id)[self.gradientBottomColor CGColor] ];
    } else {
        self.layer.backgroundColor = [self.backgroundColor CGColor];
    }
    //
    // 아래는 디폴트 값이다. 그래디언트를 그릴 때에는 디폴트 값을 그대로 사용할 것이다.
    // gradientLayer.startPoint = CGPointMake(0.5,0.0);
    // gradientLayer.endPoint   = CGPointMake(0.5,1.0);
    // gradientLayer.type       = kCAGradientLayerAxial;
    // gradientLayer.frame      = rect;
    // 자신이 어딘가에 붙고 프레임이 zero가 아닐때, 발동된다.
    // setNeedsDisplay 메서드는 drawRect:를 강제로 호출한다.
    // layoutSubviews ~ setNeedsLayout 이고, drawRect: ~ setNeedsDisplay
}


#pragma mark - 세터 & 게터
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


#pragma mark - Gradient Background 관련.
- (void)setDrawsGradientBackground:(BOOL)drawsGradientBackground {
    _drawsGradientBackground = drawsGradientBackground;
    [self setNeedsDisplay]; // <- drawRect:를 호출한다.
}

- (void)setGradientTopColor:(UIColor *)gradientTopColor {
    _gradientTopColor = gradientTopColor;
    [self setNeedsDisplay]; // <- drawRect:를 호출한다.
}

- (void)setGradientBottomColor:(UIColor *)gradientBottomColor {
    _gradientBottomColor = gradientBottomColor;
    [self setNeedsDisplay]; // <- drawRect:를 호출한다.
}

@end
