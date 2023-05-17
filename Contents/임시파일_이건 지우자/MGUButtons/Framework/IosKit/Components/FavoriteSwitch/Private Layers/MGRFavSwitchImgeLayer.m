//
//  MGUFavSwitchImgeLayer.m
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 21/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUFavSwitchImgeLayer.h"

@interface MGUFavSwitchImgeLayer ()
@property (nonatomic, strong) CAShapeLayer *imageMaskLayer;
@property (nonatomic, strong) CAKeyframeAnimation *imageTransformAnimation;
@end

@implementation MGUFavSwitchImgeLayer

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
    self.imageTransformAnimation.duration = timeDuration;
}

- (void)commonInit {
    _selected = NO;
    _imageMaskLayer = [CAShapeLayer layer];
    self.mask       = self.imageMaskLayer;
    self.contentsGravity = kCAGravityResizeAspect;
    _imageTransformAnimation      = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];   // <- image
    [self animationBasicSetup:self.imageTransformAnimation];
}

- (void)animationBasicSetup:(CAKeyframeAnimation *)animation {
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.calculationMode = kCAAnimationLinear;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

- (void)setupImgeLayerAnimationWith:(UIImage *)mainImage image:(UIImage * _Nullable)secondaryOnImage {
    if (secondaryOnImage == nil) {
        self.images = @[mainImage];
        self.mask.contents = (__bridge id)(mainImage.CGImage); // UIImage는 이렇게 넣는다.
        self.mask.frame = self.bounds;
    } else {
        self.mask = nil;
        self.images = @[mainImage, secondaryOnImage];
        self.backgroundColor = UIColor.clearColor.CGColor;
        
        if (self.selected == YES) {
            self.contents = (__bridge id)(secondaryOnImage.CGImage); // UIImage는 이렇게 넣는다.
        } else {
            self.contents = (__bridge id)(mainImage.CGImage); // UIImage는 이렇게 넣는다.
        }
    }
    
    self.imageTransformAnimation.values = @[
        @(0.0),   //  0/30
        @(0.0),   //  3/30
        @(1.2),   //  9/30
        @(1.25),  // 10/30
        @(1.2),   // 11/30
        @(0.9),   // 14/30
        @(0.875), // 15/30
        @(0.875), // 16/30
        @(0.9),   // 17/30
        @(1.013), // 20/30
        @(1.025), // 21/30
        @(1.013), // 22/30
        @(0.96),  // 25/30
        @(0.95),  // 26/30
        @(0.96),  // 27/30
        @(0.99),  // 29/30
        @(1.0)    // 30/30
    ];
    
    self.imageTransformAnimation.keyTimes = @[
        @(0.0),    //  0/30
        @(0.1),    //  3/30
        @(0.3),    //  9/30
        @(0.333),  // 10/30
        @(0.367),  // 11/30
        @(0.467),  // 14/30
        @(0.5),    // 15/30
        @(0.533),  // 16/30
        @(0.567),  // 17/30
        @(0.667),  // 20/30
        @(0.7),    // 21/30
        @(0.733),  // 22/30
        @(0.833),  // 25/30
        @(0.867),  // 26/30
        @(0.9),    // 27/30
        @(0.967),  // 29/30
        @(1.0)     // 30/30
    ];
    
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (self.images.count == 2) {
        if (selected == YES) {
            self.contents = (__bridge id)(self.images.lastObject.CGImage); // UIImage는 이렇게 넣는다.
        } else {
            self.contents = (__bridge id)(self.images.firstObject.CGImage); // UIImage는 이렇게 넣는다.
        }
        self.backgroundColor = UIColor.clearColor.CGColor;
    } else {
        if (selected == YES) {
            self.backgroundColor = self.imageColorOn.CGColor;
        } else {
            NSLog(@"안뇽!! %@", self.imageColorOff);
            NSLog(@"--> %@", self.mask);
            self.backgroundColor = self.imageColorOff.CGColor;
        }
    }
}
//
//- (void)setImageColorOn:(UIColor *)imageColorOn {
//    
//}

- (void)startImgeAnimation {
    [self addAnimation:self.imageTransformAnimation forKey:@"ImageTransformAnimationKey"];
}

- (void)stopImgeAnimation {
    [self removeAllAnimations];
}

@end
