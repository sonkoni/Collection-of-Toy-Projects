//
//  MMTRedView.m
//  DialControl Project
//
//  Created by Kwan Hyun Son on 2021/11/09.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MMTRedView.h"
@import GraphicsKit;

@implementation MMTRedView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskLayer.frame = self.layer.bounds;
    self.maskLayer.rectForInOval = [self rectForInOval];
    self.maskLayer.rectForOutOval = [self rectForOutOval];
}


#pragma mark - 생성 & 소멸
- (void)_commonInit {
    self.userInteractionEnabled = NO;
    UIColor *startColor = [UIColor colorWithRed:214.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:171.0/255.0 green:5.0/255.0 blue:5.0/255.0 alpha:1.0];
    self.colors = @[startColor, endColor];    
    self.gradientLayer.startPoint = CGPointMake(0.36, 0.82);
    self.gradientLayer.endPoint = CGPointMake(0.81, 0.20);
    self.gradientLayer.type = kCAGradientLayerAxial;
    self.gradientLayer.locations = nil;
    self.gradientLayer.noiseOpacity = 0.05;
    self.gradientLayer.noiseBlendMode = kCGBlendModeNormal; // 디폴트 BlendMode kCGBlendModeScreen
    
    _maskLayer = [MGECircularSectorMaskLayer layer];
    self.maskLayer.contentsScale = [UIScreen mainScreen].scale;
    self.maskLayer.clockWise = NO;
    self.maskLayer.axisDirection = MGRCircularSectorMaskAxisDirectionNorthInverse; // 0 라디안 12시. 반시계방향으로 한 바퀴 돌면 M_PI * 2.0
    self.maskLayer.startRadian = 0.0; // 12시가 0.0
    self.maskLayer.endRadian = M_PI * 2.0; // 반 시계 방향으로 꽉 채웠다.
    
    self.maskLayer.rectForInOval = [self rectForInOval];
    self.maskLayer.rectForOutOval = [self rectForOutOval];
    
    self.maskLayer.frame = self.layer.bounds;
    self.layer.mask = self.maskLayer;
}

- (CGRect)rectForInOval {
    CGRect rect = self.bounds;
    CGFloat standardLengh = rect.size.width;
    CGFloat buttonDiameter = standardLengh * (63.0/375.0);
    return MGERectCenteredInRectSize(self.bounds, CGSizeMake(buttonDiameter, buttonDiameter));
}

- (CGRect)rectForOutOval {
    CGRect rect = self.bounds;
    CGFloat standardLengh = rect.size.width;
    CGFloat inset = standardLengh / 6.0;
    return CGRectInset(rect, inset, inset);
}

@end
