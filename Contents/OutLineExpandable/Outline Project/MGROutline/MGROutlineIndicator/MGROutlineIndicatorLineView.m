//
//  MGROutlineIndicatorLineView.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/08/26.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGROutlineIndicatorLineView.h"

@interface MGROutlineIndicatorLineView ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
#if DEBUG && TARGET_OS_SIMULATOR
@property (nonatomic, strong) CAShapeLayer *deBugShapeLayer;
#endif
@end

@implementation MGROutlineIndicatorLineView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame strokeColor:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect layerFrame = self.layer.bounds;
#if DEBUG && TARGET_OS_SIMULATOR
    self.deBugShapeLayer.frame = layerFrame;
    self.deBugShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:layerFrame cornerRadius:0.0].CGPath;
    self.deBugShapeLayer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor; // dashed line의 색깔.
    self.deBugShapeLayer.lineWidth = 4.0f;    // dased line의 굵기
    self.deBugShapeLayer.lineDashPattern = @[@(5.0), @(5.0)]; // dased line 길이, space line 길이. 설명은 MGRProject1 참고하라.
    self.deBugShapeLayer.lineCap = kCALineCapRound;
    self.deBugShapeLayer.fillColor = [UIColor clearColor].CGColor;
#endif
    self.shapeLayer.frame = layerFrame;
    self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [self strokeColor].CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.lineCap = kCALineCapRound;

    self.shapeLayer.shadowColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.shadowRadius = 2.0;
    self.shapeLayer.shadowOffset = CGSizeMake(1.0, 3.0);
    self.shapeLayer.shadowOpacity = 0.5;
    
    CGPoint startKnobCenterPoint = CGPointMake(self.knobPosition.xOrigin,
                                               (self.knobPosition.isBottom == NO) ? 0.0 : self.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:startKnobCenterPoint
                                                        radius:self.knobRadius
                                                    startAngle:0.0
                                                      endAngle:(M_PI * 2.0)
                                                     clockwise:YES];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, startKnobCenterPoint.y)];
    self.shapeLayer.path = path.CGPath;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                  strokeColor:(UIColor *)strokeColor {
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = strokeColor;
        if (strokeColor == nil) {
            _strokeColor = [UIColor blueColor];
        }
        
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit {
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    _lineWidth = 2.0;
    _knobRadius = 5.0;
    _knobPosition = MGROutlineIndicatorKnobPositionMake(YES, 20.0); // 크게 의미없다.
    _shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.shapeLayer];
#if DEBUG && TARGET_OS_SIMULATOR // 필요하면 켜자.
//    _deBugShapeLayer = [CAShapeLayer layer];
//    [self.layer insertSublayer:self.deBugShapeLayer atIndex:0];
#endif
}


#pragma mark - 세터 & 게터
- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsLayout];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsLayout];
}

- (void)setKnobRadius:(CGFloat)knobRadius {
    _knobRadius = knobRadius;
    [self setNeedsLayout];
}

- (void)setKnobPosition:(MGROutlineIndicatorKnobPosition)knobPosition {
    _knobPosition = knobPosition;
    [self setNeedsLayout];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder {
//    self = [super initWithCoder:coder];
    NSAssert(FALSE, @"- initWithCoder: 사용금지.");
    return self;
}

@end
