//
//  MGURulerView+DrawIndicator.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGURulerView+DrawIndicator.h"

@interface MGURulerView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *centerNiddleContainer;
@property (nonatomic, strong) MGURulerViewConfig *config;
@end


@implementation MGURulerView (DrawIndicator)

- (void)drawBallHeadIndicator {
    CAShapeLayer *centerNiddleShapeLayer = [CAShapeLayer layer];
    centerNiddleShapeLayer.contentsScale = UIScreen.mainScreen.scale;
    [self.centerNiddleContainer.layer addSublayer:centerNiddleShapeLayer];
    centerNiddleShapeLayer.frame = self.centerNiddleContainer.layer.bounds;
    
    CGFloat squareWith = centerNiddleShapeLayer.frame.size.width / 2.0;
    CGRect circleRect = CGRectMake(squareWith / 2.0, squareWith, squareWith, squareWith);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(squareWith, self.scrollView.frame.size.height / 2.0f)];
    [trianglePath addLineToPoint:CGPointMake(squareWith - 1.5, squareWith * 1.5)];
    [trianglePath addLineToPoint:CGPointMake(squareWith + 1.5, squareWith * 1.5)];
    [trianglePath closePath];
    [circlePath appendPath:trianglePath];
    
    centerNiddleShapeLayer.path = circlePath.CGPath;
    centerNiddleShapeLayer.fillColor = self.config.indicatorNiddleMainColor.CGColor;
    centerNiddleShapeLayer.strokeColor = UIColor.clearColor.CGColor;
}

- (void)drawWheelHeadIndicator {
    CAShapeLayer *centerNiddleShapeLayer  = [CAShapeLayer layer];
    CALayer *centerNiddleSmallCircleLayer = [CALayer layer];
    centerNiddleShapeLayer.contentsScale       = UIScreen.mainScreen.scale;
    centerNiddleSmallCircleLayer.contentsScale = UIScreen.mainScreen.scale;
    [self.centerNiddleContainer.layer addSublayer:centerNiddleShapeLayer];
    [self.centerNiddleContainer.layer addSublayer:centerNiddleSmallCircleLayer];
    centerNiddleShapeLayer.frame = self.centerNiddleContainer.layer.bounds;
    CGRect circleRect = (CGRect){(CGPoint)CGPointZero, CGSizeMake(centerNiddleShapeLayer.bounds.size.width,
                                                                  centerNiddleShapeLayer.bounds.size.width)};
    circleRect = CGRectOffset(circleRect, 0.0f, -circleRect.size.height / 2.0f);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:circleRect.size.width / 2.0];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(circleRect.size.width / 2.0f, self.scrollView.frame.size.height * 3.0f)];
    [trianglePath addLineToPoint:CGPointMake(circleRect.size.width * 0.425f, 0.0f)];
    [trianglePath addLineToPoint:CGPointMake(circleRect.size.width * 0.575f, 0.0f)];
    [trianglePath closePath];
    [circlePath appendPath:trianglePath];
    centerNiddleShapeLayer.path = circlePath.CGPath;
    centerNiddleShapeLayer.fillColor = self.config.indicatorNiddleMainColor.CGColor;
    centerNiddleShapeLayer.strokeColor = UIColor.clearColor.CGColor;
    centerNiddleSmallCircleLayer.frame = CGRectInset(circleRect, circleRect.size.width / 10.f, circleRect.size.width / 10.f);
    centerNiddleSmallCircleLayer.cornerRadius = centerNiddleSmallCircleLayer.bounds.size.width / 2.0f;
    centerNiddleSmallCircleLayer.backgroundColor = self.config.indicatorNiddleAssistantColor.CGColor;
}

- (void)drawLineIndicator {
    CAShapeLayer *centerNiddleShapeLayer = [CAShapeLayer layer];
    centerNiddleShapeLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.centerNiddleContainer.layer addSublayer:centerNiddleShapeLayer];
    centerNiddleShapeLayer.frame = self.centerNiddleContainer.layer.bounds;
    
    CGFloat height = centerNiddleShapeLayer.frame.size.height;
    CGFloat xPoint = centerNiddleShapeLayer.frame.size.width / 2.0;
    CGFloat yStartPoint = height * (2.0 / 10.0);
    CGFloat yEndPoint = height * (7.7 / 10.0);
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(xPoint, yStartPoint)];
    [linePath addLineToPoint:CGPointMake(xPoint, yEndPoint)];
    
    centerNiddleShapeLayer.lineWidth = 3.0f;
    centerNiddleShapeLayer.lineCap = kCALineCapRound;
    centerNiddleShapeLayer.lineJoin = kCALineJoinRound;
    centerNiddleShapeLayer.path = linePath.CGPath;
    centerNiddleShapeLayer.strokeColor = self.config.indicatorNiddleMainColor.CGColor;
}

@end
