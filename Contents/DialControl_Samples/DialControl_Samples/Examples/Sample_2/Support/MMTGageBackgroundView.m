//
//  MMTGageBackgroundView.m
//  DialControl_Samples
//
//  Created by Kwan Hyun Son on 2021/11/04.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MMTGageBackgroundView.h"
@import GraphicsKit;
@import IosKit;

@interface MMTGageBackgroundView ()

@property (nonatomic, strong) UIView *donutContainer;

@property (nonatomic, strong) MGEBorderMaskLayer *donutMaskLayer;

//! Donut Shadow Part // donutContainer에 서브로 올라간다.
@property (nonatomic, strong) UIView *largeShadowContainer;
@property (nonatomic, strong) UIView *smallShadowContainer;
@property (nonatomic, strong) MGEInnerShadowLayer *largeShadowLayer1; // largeShadowContainer 에 붙는다.
@property (nonatomic, strong) MGEInnerShadowLayer *largeShadowLayer2; // largeShadowContainer 에 붙는다.
@property (nonatomic, strong) CALayer *smallShadowLayer1; // smallShadowContainer 에 붙는다.
@property (nonatomic, strong) CALayer *smallShadowLayer2; // smallShadowContainer 에 붙는다.


@property (nonatomic, assign, readonly) CGRect largeCircleRect; // @dynamic
@property (nonatomic, assign, readonly) CGRect smallCircleRect; // @dynamic
@end

@implementation MMTGageBackgroundView
@dynamic largeCircleRect;
@dynamic smallCircleRect;

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

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.donutContainer layoutIfNeeded];
    self.donutContainer.layer.mask.frame = self.donutContainer.layer.bounds;
    [self updateDonutMaskLayer];
    
    self.largeShadowContainer.frame = self.largeCircleRect;
    self.smallShadowContainer.frame = self.smallCircleRect;
    [self updateDonutShadow];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MMTGageBackgroundView *self) {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    [self setupDonutView];
}

- (void)setupDonutView {
    CGRect frame = self.bounds;
    _donutContainer = [[UIView alloc] initWithFrame:frame];
    self.donutContainer.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    
    _largeShadowContainer = [[UIView alloc] initWithFrame:self.largeCircleRect];
    _smallShadowContainer = [[UIView alloc] initWithFrame:self.smallCircleRect];
    [self.donutContainer addSubview:self.largeShadowContainer];
    [self.donutContainer addSubview:self.smallShadowContainer];
    self.largeShadowContainer.clipsToBounds = NO;
    self.smallShadowContainer.clipsToBounds = NO;
    self.largeShadowContainer.layer.masksToBounds = NO;
    self.smallShadowContainer.layer.masksToBounds = NO;
    
    _smallShadowLayer1 = [CALayer layer];
    _smallShadowLayer2 = [CALayer layer];
    self.smallShadowLayer1.masksToBounds = NO;
    self.smallShadowLayer2.masksToBounds = NO;
    self.smallShadowLayer1.frame = self.smallShadowContainer.layer.bounds;
    self.smallShadowLayer2.frame = self.smallShadowContainer.layer.bounds;
    [self.smallShadowContainer.layer addSublayer:self.smallShadowLayer1];
    [self.smallShadowContainer.layer addSublayer:self.smallShadowLayer2];
    
    self.smallShadowLayer1.shadowColor = [UIColor blackColor].CGColor;
    self.smallShadowLayer1.shadowOpacity = 0.2;
    self.smallShadowLayer1.shadowRadius = 0.0;
    self.smallShadowLayer1.shadowOffset = CGSizeMake(1.0, -1.0);
    self.smallShadowLayer1.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.smallShadowLayer1.bounds].CGPath;
    
    self.smallShadowLayer2.shadowColor = [UIColor whiteColor].CGColor;
    self.smallShadowLayer2.shadowOpacity = 0.1;
    self.smallShadowLayer2.shadowRadius = 0.0;
    self.smallShadowLayer2.shadowOffset = CGSizeMake(-1.0, 1.0);
    self.smallShadowLayer2.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.smallShadowLayer2.bounds].CGPath;

    
    _largeShadowLayer1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.2].CGColor
                                                             innerShadowOffset:CGSizeMake(1.0, -1.0)
                                                         innerShadowBlurRadius:0.0];
    _largeShadowLayer2 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:1.0 alpha:0.1].CGColor
                                                             innerShadowOffset:CGSizeMake(-1.0, 1.0)
                                                         innerShadowBlurRadius:0.0];

    self.largeShadowLayer1.contentsScale = [UIScreen mainScreen].scale;
    self.largeShadowLayer2.contentsScale = [UIScreen mainScreen].scale;
    self.largeShadowLayer1.masksToBounds = NO;
    self.largeShadowLayer2.masksToBounds = NO;
    self.largeShadowLayer1.frame = self.largeShadowContainer.layer.bounds;
    self.largeShadowLayer2.frame = self.largeShadowContainer.layer.bounds;
    [self.largeShadowContainer.layer addSublayer:self.largeShadowLayer1];
    [self.largeShadowContainer.layer addSublayer:self.largeShadowLayer2];
    self.largeShadowLayer1.cornerRadius = self.largeCircleRect.size.width / 2.0;
    self.largeShadowLayer2.cornerRadius = self.largeCircleRect.size.width / 2.0;
    [self updateDonutShadow];
    
    _donutMaskLayer = [MGEBorderMaskLayer layer];
    self.donutMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.donutMaskLayer.frame = self.donutContainer.layer.bounds;
    self.donutContainer.layer.mask = self.donutMaskLayer;
    [self addSubview:self.donutContainer];
    [self.donutContainer mgrPinEdgesToSuperviewEdges];
    [self updateDonutMaskLayer];
}


#pragma mark - 세터 & 게터
- (CGRect)largeCircleRect {
    CGRect rect = self.bounds;
    CGFloat standardLengh = rect.size.width;
    CGFloat inset = standardLengh * ( 47.0 / 750.0);
    return CGRectInset(rect, inset, inset);
}

- (CGRect)smallCircleRect {
    CGRect rect = self.bounds;
    CGFloat standardLengh = rect.size.width;
    CGFloat inset = standardLengh / 6.0;
    return CGRectInset(rect, inset, inset);
}


#pragma mark - Helper
- (void)updateDonutMaskLayer {
    CGFloat standardLengh = self.bounds.size.width;
    self.donutMaskLayer.cornerRadius = standardLengh / 2.0;
    self.donutMaskLayer.borderInset = self.bounds.size.width * ( 47.0 / 750.0);
    self.donutMaskLayer.borderWidth = standardLengh / 6.0;
}

- (void)updateDonutShadow {
    self.smallShadowLayer1.frame = self.smallShadowLayer1.superlayer.bounds;
    self.smallShadowLayer2.frame = self.smallShadowLayer2.superlayer.bounds;
    self.largeShadowLayer1.frame = self.largeShadowLayer1.superlayer.bounds;
    self.largeShadowLayer2.frame = self.largeShadowLayer2.superlayer.bounds;
    self.smallShadowLayer1.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.smallShadowLayer1.bounds].CGPath;
    self.smallShadowLayer2.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.smallShadowLayer2.bounds].CGPath;
    self.largeShadowLayer1.cornerRadius = self.largeCircleRect.size.width / 2.0;
    self.largeShadowLayer2.cornerRadius = self.largeCircleRect.size.width / 2.0;
}

@end
