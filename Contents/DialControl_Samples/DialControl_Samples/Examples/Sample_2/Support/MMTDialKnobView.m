//
//  MMTKnobView.m
//  DialControl Project
//
//  Created by Kwan Hyun Son on 2021/11/08.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MMTDialKnobView.h"
@import GraphicsKit;
@import IosKit;

@interface MMTDialKnobView ()

@property (nonatomic, strong) UIView *mainContainer; // 여기 손잡이 특성상 mainContainer를 한번 더 잡아서 구성한다. 실제 컨텐츠의 레이아웃만 잡자.
@property (nonatomic, strong) UIView *outContainer;  // out Shadow만 담당한다.
@property (nonatomic, strong) UIView *inContainer;   //

//! outContainer Part
@property (nonatomic, strong) CAShapeLayer *outContainerMaskLayer;

//! inContainer Part
@property (nonatomic, strong) MGEGradientView *gradientView1;
@property (nonatomic, strong) MGEInnerShadowLayer *innerShadowLayer1;
@property (nonatomic, strong) CAShapeLayer *inContainerMaskLayer;

@property (nonatomic, strong, readonly) UIBezierPath *curretTrapezoidPath; // @dynamic 좌표계는 mainContainer가 잡아놓은 상태이다.
@end

@implementation MMTDialKnobView
@dynamic curretTrapezoidPath;

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
    self.mainContainer.frame = [self currentMainContainerFrame];
    self.outContainer.frame = self.mainContainer.bounds;
    self.inContainer.frame = self.mainContainer.bounds;
    self.outContainerMaskLayer.frame = self.outContainer.layer.bounds;
    self.inContainerMaskLayer.frame = self.inContainer.layer.bounds;
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    
    self.outContainer.layer.shadowPath = [self curretTrapezoidPath].CGPath;
    self.outContainerMaskLayer.path = [self outContainerMaskLayerPath].CGPath;
    self.inContainerMaskLayer.path = [self curretTrapezoidPath].CGPath;
    self.innerShadowLayer1.path = [self curretTrapezoidPath].CGPath;
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupMainContainer];
    [self setupOutContainer];
    [self setupInContainer];
}

- (void)setupMainContainer { // 여기는 틀만 잡는다.
    CGRect frame = [self currentMainContainerFrame];
    _mainContainer = [[UIView alloc] initWithFrame:frame];
    self.mainContainer.clipsToBounds = NO;
    self.mainContainer.layer.masksToBounds = NO;
    [self addSubview:self.mainContainer];
}

- (void)setupOutContainer { // out Shadow 만 담당.
    _outContainer = [[UIView alloc] initWithFrame:self.mainContainer.bounds];
    self.outContainer.clipsToBounds = NO;
    self.outContainer.layer.masksToBounds = NO;
    [self.mainContainer addSubview:self.outContainer];
    self.outContainer.backgroundColor = [UIColor clearColor];
    
    self.outContainer.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    self.outContainer.layer.shadowOpacity = 0.2;
    self.outContainer.layer.shadowOffset = CGSizeMake(-0.5, 0.0);
    self.outContainer.layer.shadowRadius = 1.0;
    self.outContainer.layer.shadowPath = [self curretTrapezoidPath].CGPath;
    
    _outContainerMaskLayer = [CAShapeLayer layer];
    self.outContainerMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.outContainer.layer.mask = self.outContainerMaskLayer;
    self.outContainerMaskLayer.frame = self.outContainer.layer.bounds;
    self.outContainerMaskLayer.fillColor = [UIColor blackColor].CGColor;
    self.outContainerMaskLayer.lineWidth = 0.0;
    self.outContainerMaskLayer.fillRule = kCAFillRuleEvenOdd;
    self.outContainerMaskLayer.path = [self outContainerMaskLayerPath].CGPath;
}

- (void)setupInContainer {
    _inContainer = [[UIView alloc] initWithFrame:self.mainContainer.bounds];
    self.inContainer.backgroundColor = [UIColor clearColor];
    self.inContainer.clipsToBounds = YES;
    self.inContainer.layer.masksToBounds = YES;
    [self.mainContainer addSubview:self.inContainer];
    
    _gradientView1 = [[MGEGradientView alloc] initWithFrame:self.inContainer.bounds];
    self.gradientView1.alpha = 1.0;
    self.gradientView1.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientView1.gradientLayer.locations = @[@0.0, @1.0];
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    UIColor *endColor = [UIColor colorWithRed:170.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:0.5];
    self.gradientView1.gradientLayer.startPoint = CGPointMake(0.32, 0.53);
    self.gradientView1.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    self.gradientView1.colors = @[startColor, endColor];
    [self.inContainer addSubview:self.gradientView1];
    [self.gradientView1 mgrPinEdgesToSuperviewEdges];
    
    _innerShadowLayer1 = [[MGEInnerShadowLayer alloc] initWithInnerShadowColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor
                                                             innerShadowOffset:CGSizeMake(-0.5, 0.0)
                                                         innerShadowBlurRadius:1.0];
    self.innerShadowLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.inContainer.layer addSublayer:self.innerShadowLayer1];
    self.innerShadowLayer1.frame = self.inContainer.layer.bounds;
    self.innerShadowLayer1.path = [self curretTrapezoidPath].CGPath;
    
    _inContainerMaskLayer = [CAShapeLayer layer];
    self.inContainerMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.inContainer.layer.mask = self.inContainerMaskLayer;
    self.inContainerMaskLayer.frame = self.inContainer.layer.bounds;
    self.inContainerMaskLayer.fillColor = [UIColor blackColor].CGColor;
    self.inContainerMaskLayer.lineWidth = 0.0;
    self.inContainerMaskLayer.path = [self curretTrapezoidPath].CGPath;
}


#pragma mark - Helper
- (UIBezierPath *)curretTrapezoidPath {
    CGRect bounds = self.mainContainer.bounds;
    CGPoint a = CGPointMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds)); // 사다리꼴 윗면 왼쪽 점.
    CGPoint b = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds)); // 사다리꼴 윗면 오른쪽 점.
    CGPoint c = CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds)); // 사다리꼴 아랫면 왼쪽 점.
    CGPoint d = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)); // 사다리꼴 아랫면 오른쪽 점.
    a.x = a.x + CGRectGetWidth(bounds) * (9.0 / 13.0);
    
    UIBezierPath *curretTrapezoidPath = [UIBezierPath bezierPath];
    [curretTrapezoidPath moveToPoint:a];
    [curretTrapezoidPath addLineToPoint:b];
    [curretTrapezoidPath addLineToPoint:d];
    [curretTrapezoidPath addLineToPoint:c];
    [curretTrapezoidPath closePath];
    
    return curretTrapezoidPath;
}

- (UIBezierPath *)outContainerMaskLayerPath {
    UIBezierPath *path = [self curretTrapezoidPath];
    UIBezierPath *rectPath  = [UIBezierPath bezierPathWithRect:self.outContainer.bounds];
    [path appendPath:rectPath];
    return path;
}

- (CGRect)currentMainContainerFrame {
    CGRect bounds = self.bounds;
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    
    CGFloat width = bounds.size.width * (13.0/ 375.0);
    CGFloat height = bounds.size.height * (128.0/ 375.0);
    CGFloat originX = center.x - width;
    CGFloat originY = center.y - height;
    return CGRectMake(originX, originY, width, height);
}

@end

