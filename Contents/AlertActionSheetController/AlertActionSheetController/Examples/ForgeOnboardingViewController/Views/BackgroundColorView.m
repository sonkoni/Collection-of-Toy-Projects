//
//  BackgroundColorView.m
//  AlertActionSheetController
//
//  Created by Kwan Hyun Son on 01/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "BackgroundColorView.h"

@interface BackgroundColorView ()
@end

@implementation BackgroundColorView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

static void CommonInit(BackgroundColorView *self) {
    self.userInteractionEnabled = NO;
    [self setColors:[UIColor blackColor] bottom:[UIColor blackColor]];
}

- (void)setColors:(UIColor *)top bottom:(UIColor *)bottom {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = @[(id)top.CGColor, (id)bottom.CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.locations = @[@(0.0), @(1.0)];
    
    [CATransaction commit];
}

- (CAKeyframeAnimation *)backgroundColorAnimationWithColors:(NSArray <NSArray <UIColor *>*>*)arrayColorArray {
    NSInteger count = arrayColorArray.count;
    CAKeyframeAnimation *gradientColorsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"colors"];
    gradientColorsAnimation.fillMode             = kCAFillModeForwards;
    gradientColorsAnimation.removedOnCompletion  = NO;
    gradientColorsAnimation.duration             = (CFTimeInterval)(count - 1);
    gradientColorsAnimation.timingFunction       = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:count];
    for (NSArray <UIColor *>*arr in arrayColorArray) {
        UIColor *startColor = arr.firstObject;
        UIColor *endColor   = arr.lastObject;
        [colorArr addObject:@[(id)startColor.CGColor, (id)endColor.CGColor]];
    }
    gradientColorsAnimation.values = colorArr.copy;
    
    return gradientColorsAnimation;
}

@end
