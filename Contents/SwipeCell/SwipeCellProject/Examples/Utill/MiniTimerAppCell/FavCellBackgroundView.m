//
//  FavCellBackgroundView.m
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2021/11/04.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
@import IosKit;
#import "FavCellBackgroundView.h"

@interface FavCellBackgroundView ()
@property (nonatomic, strong) UIView *outContainer;
@property (nonatomic, strong) UIView *inContainer;

//! Inner Part
@property (nonatomic, strong) UIView *noiseView;
@property (nonatomic, strong) MGEGradientView *gradientView;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer2;
@end

@implementation FavCellBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.outContainer layoutIfNeeded];
    [self.inContainer layoutIfNeeded];
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    self.innerShadowLayer2.frame = self.inContainer.layer.bounds;
//    [self updateOuterShadowPath];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    
    [self setupOutContainer];
    [self setupInContainer];
}

- (void)setupOutContainer {
    _outContainer = [UIView new];
    self.outContainer.backgroundColor = [UIColor clearColor]; // clear 하고 path 로 그려야 삐져나오는 일이 발생하지 않는다.
    self.outContainer.clipsToBounds = NO;
    self.outContainer.layer.masksToBounds = NO;
    [self insertSubview:self.outContainer atIndex:0];
    [self.outContainer mgrPinEdgesToSuperviewEdges];

//    self.outContainer.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.outContainer.layer.shadowOffset = CGSizeMake(-1.0, 1.0);
//    self.outContainer.layer.shadowRadius = 1.0;
//    self.outContainer.layer.shadowOpacity = 0.5;
//    [self updateOuterShadowPath];
}

- (void)setupInContainer {
    _inContainer = [UIView new];
    self.inContainer.backgroundColor = [UIColor clearColor];
    self.inContainer.clipsToBounds = YES;
    self.inContainer.layer.masksToBounds = YES;
    [self addSubview:self.inContainer];
    [self.inContainer mgrPinEdgesToSuperviewEdges];
    
    _noiseView = [UIView new]; // 노이즈
    self.noiseView.backgroundColor = [[UIColor whiteColor] mgrColorWithNoiseWithOpacity:0.05
                                                                           andBlendMode:kCGBlendModeNormal];
    [self.inContainer addSubview:self.noiseView];
    [self.noiseView mgrPinEdgesToSuperviewEdges];
    
    _gradientView = [MGEGradientView new];
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:0.5]; // white
    UIColor *endColor = [UIColor colorWithWhite:0.0 alpha:0.5]; // black
    self.gradientView.colors = @[startColor, endColor];
    
    self.gradientView.gradientLayer.startPoint = CGPointMake(1.0, 0.0);
    self.gradientView.gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    self.gradientView.alpha = 0.1;
    
    [self.inContainer addSubview:self.gradientView];
    [self.gradientView mgrPinEdgesToSuperviewEdges];
    
    _innerShadowLayer1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.1].CGColor
                                                             innerShadowOffset:CGSizeMake(2.0, -2.0)
                                                         innerShadowBlurRadius:2.0];
    self.innerShadowLayer1.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    [self.inContainer.layer addSublayer:self.innerShadowLayer1];
    
    _innerShadowLayer2 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5].CGColor
                                                             innerShadowOffset:CGSizeMake(-2.0, 2.0)
                                                         innerShadowBlurRadius:1.0];
    self.innerShadowLayer2.contentsScale = [UIScreen mainScreen].scale;
    self.innerShadowLayer2.frame = self.inContainer.layer.bounds;
    [self.inContainer.layer addSublayer:self.innerShadowLayer2];
}


#pragma mark - 세터 & 게터
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        self.outContainer.layer.cornerRadius = cornerRadius;
        self.inContainer.layer.cornerRadius = cornerRadius;
        self.innerShadowLayer1.cornerRadius = cornerRadius;
        self.innerShadowLayer2.cornerRadius = cornerRadius;
        [self setNeedsLayout];
    }
}


#pragma mark - Helper
//- (void)updateOuterShadowPath {
//    self.outContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.outContainer.layer.bounds
//                                                               byRoundingCorners:UIRectCornerAllCorners
//                                                                     cornerRadii:CGSizeMake(self.outContainer.layer.cornerRadius,
//                                                                                            self.outContainer.layer.cornerRadius)].CGPath;
//}

@end
