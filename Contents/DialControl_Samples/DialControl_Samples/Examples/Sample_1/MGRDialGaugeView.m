//
//  MGRDialGaugeView.m
//  DialControl
//
//  Created by Kwan Hyun Son on 20/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGRDialGaugeView.h"

@interface MGRDialGaugeView ()
@property (nonatomic, strong) CAShapeLayer *orangeLampLayer;
@end

@implementation MGRDialGaugeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)drawRect:(CGRect)rect { // [super drawRect:rect]; UIView를 직접 상속 받았으므로 호출할 필요가 없다.
// 처음에는 여기에 만들려고 했다. 그런데, background로 가면 날라가 버린다.
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGRDialGaugeView *self) {
    self.orangeLampLayer = [CAShapeLayer layer];
    self.orangeLampLayer.contentsScale = UIScreen.mainScreen.scale;
    self.orangeLampLayer.frame = self.layer.bounds;
    self.orangeLampLayer.opacity = 0.0f;
    [self.layer addSublayer:self.orangeLampLayer];
}

- (void)setupDialGaugeView {
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.backgroundColor = UIColor.clearColor;
    [self drawDialGauge];
    [self setupOrangeLamp];
}

- (void)drawDialGauge {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, UIScreen.mainScreen.scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGContextTranslateCTM(currentContext, center.x, center.y); // 좌표 번역
    
    for(int i = 0; i < 12 ; i++) {
        CGFloat theta = i * (2 * M_PI / 12.0);
        
        CGContextSaveGState(currentContext); // 각각의 컨텍스트 저장
        CGContextRotateCTM(currentContext, theta); // 각각의 컨텍스트 회전
        CGContextTranslateCTM(currentContext, 0.0f, -[self gaugeRadius]); // 각각의 좌표 번역
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound; // 둥글한 선, 정확한 시작선과 끝선에서 선의 굵기의 1/2만큼 반지름으로 양방향으로 원을 만듬
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = self.bounds.size.width * 0.006;
        
        CGPoint A = CGPointMake(0.0, -self.bounds.size.width * 0.008);
        CGPoint C = CGPointMake(0.0, self.bounds.size.width * 0.008);
        [path moveToPoint:A];
        [path addLineToPoint:C];
        [path closePath];

        UIColor *strokeColor = [UIColor colorWithWhite:1.0 alpha:0.03];
        [strokeColor setStroke];
        [path stroke];
        
        CGContextRestoreGState(currentContext);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // 하나의 이미지로 받아오기
    UIGraphicsEndImageContext(); // 이미지 컨텍스트 종류
    self.image = image;
}

- (void)setupOrangeLamp {
    self.orangeLampLayer.frame = self.layer.bounds;
    CGFloat width =  self.layer.bounds.size.width;
    
    CGRect knobRect = {CGPointZero, [self orangeLampSize]};
    knobRect = CGRectOffset(knobRect, (-[self orangeLampSize].width / 2.0), (-[self orangeLampSize].height / 2.0)); // 회전축이 0,0
    
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobRect
                                                        cornerRadius:(knobRect.size.width / 2.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(width / 2.0, 0.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(0.0, [self fullRadius] - [self gaugeRadius])];
    self.orangeLampLayer.path = knobPath.CGPath;
    self.orangeLampLayer.fillColor = UIColor.whiteColor.CGColor;
    self.orangeLampLayer.lineWidth = 0.0;
    self.orangeLampLayer.strokeColor = UIColor.clearColor.CGColor;

    self.orangeLampLayer.shadowColor   = UIColor.whiteColor.CGColor;
    self.orangeLampLayer.shadowOpacity = 1.0;
    self.orangeLampLayer.shadowOffset  = CGSizeMake(0.0, 0.0);
    self.orangeLampLayer.shadowRadius  = 3.0; //  디폴트 3.0 블러되는 반경
}

- (void)rotatePositionOfOrangeLampAt:(MGROrangeLampPosition)position {
    CATransform3D transform;
    switch (position) {
        case MGROrangeLampPosition12: {
            transform = CATransform3DIdentity;
            break;
        }
        case MGROrangeLampPosition1: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(30.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition2: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(60.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition3: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(90.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition4: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(120.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition5: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(150.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition6: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(180.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition7: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(210.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition8: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(240.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition9: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(270.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition10: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(300.0), 0.0, 0.0, 1.0);
            break;
        }
        case MGROrangeLampPosition11: {
            transform = CATransform3DRotate(CATransform3DIdentity, radianFromDegree(330.0), 0.0, 0.0, 1.0);
            break;
        }
        default: {
            return;
            break;
        }
    }
    
    [self.orangeLampLayer removeAllAnimations];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.orangeLampLayer.transform = transform;
    [CATransaction commit];
    
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        self.orangeLampLayer.opacity = 0.0f;
        [CATransaction commit];
    }];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    self.orangeLampLayer.opacity = 1.0;
    [CATransaction commit];
}

- (void)beginningAnimation { // 그냥 쇼. 한번하고 지워버리자.
    static CAReplicatorLayer *replicatorLayer;
    static CAShapeLayer *instanceLayer;
    [replicatorLayer removeFromSuperlayer];
    
    replicatorLayer = [CAReplicatorLayer layer];
    instanceLayer   = [CAShapeLayer layer];
    replicatorLayer.contentsScale = UIScreen.mainScreen.scale;
    instanceLayer.contentsScale   = UIScreen.mainScreen.scale;
    [self.layer addSublayer:replicatorLayer];
    [replicatorLayer addSublayer:instanceLayer];
    replicatorLayer.frame = self.layer.bounds;
    instanceLayer.frame   = replicatorLayer.bounds;
    
    replicatorLayer.preservesDepth = NO;
    replicatorLayer.instanceColor  = UIColor.whiteColor.CGColor;
    replicatorLayer.instanceCount = 13;
    replicatorLayer.instanceDelay = 0.015;
    replicatorLayer.instanceTransform   = CATransform3DMakeRotation(radianFromDegree(30.0), 0.0, 0.0, 1.0);

    CGFloat width =  self.layer.bounds.size.width;
    
    CGRect knobRect = {CGPointZero, [self orangeLampSize]};
    knobRect = CGRectOffset(knobRect, (-[self orangeLampSize].width / 2.0), (-[self orangeLampSize].height / 2.0)); // 회전축이 0,0
    
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobRect
                                                        cornerRadius:(knobRect.size.width / 2.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(width / 2.0, 0.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(0.0, [self fullRadius] - [self gaugeRadius])];
    instanceLayer.path = knobPath.CGPath;
    instanceLayer.fillColor = UIColor.whiteColor.CGColor;
    instanceLayer.lineWidth = 0.0;
    instanceLayer.strokeColor = UIColor.clearColor.CGColor;
    instanceLayer.shadowColor   = UIColor.whiteColor.CGColor;
    instanceLayer.shadowOpacity = 1.0;
    instanceLayer.shadowOffset  = CGSizeMake(0.0, 0.0);
    instanceLayer.shadowRadius  = 3.0; //  디폴트 3.0 블러되는 반경
    
    [instanceLayer removeAnimationForKey:@"FadeAnimationKey"];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    instanceLayer.opacity =  0.0;
    [CATransaction commit];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue   = @(1.0);
    fadeAnimation.toValue     = @(0.0);
    fadeAnimation.repeatCount = 1;
    fadeAnimation.duration    = 0.4;
    
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.fillMode            = kCAFillModeForwards;
    
    [CATransaction setCompletionBlock:^{
        instanceLayer.opacity =  0.0;
    }];
    [instanceLayer addAnimation:fadeAnimation forKey:@"FadeAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


#pragma mark - Helper
- (CGSize)orangeLampSize {
    CGSize baseSize = self.bounds.size;
    return CGSizeMake(baseSize.width / 75.0, baseSize.width / 35.0);
}

- (CGFloat)fullRadius { // 전체 정사각형을 내부에서 꽉 채우는 원의 반지름.
    return MIN(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0); // 어차피 정사각형이지만.
}

- (CGFloat)gaugeRadius { // 짧은 선(orange knob 포함하여)들이 모여서 이루어지는 원의 반지름 - 선들의 중심과 큰 원의 중심과의 거리.
    return [self fullRadius] * 0.92;
}

CGFloat radianFromDegree(CGFloat degree) {
    return (CGFloat)(degree * M_PI / 180.0);
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
