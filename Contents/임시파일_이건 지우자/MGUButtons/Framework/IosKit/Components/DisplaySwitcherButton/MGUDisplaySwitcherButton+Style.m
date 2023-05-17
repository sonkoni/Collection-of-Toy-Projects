//
//  MGUDisplaySwitcherButton+Style.m
//  MGUDisplaySwitcherButton
//
//  Created by Kwan Hyun Son on 11/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGUDisplaySwitcherButton+Style.h"
@import GraphicsKit;

#define GOLDEN_RATIO 1.618

@interface MGUDisplaySwitcherButton()
@property (nonatomic, assign, readonly) CGFloat dimension;
@property (nonatomic, assign, readonly) CGPoint offset;
@property (nonatomic, assign, readonly) CGPoint centerPoint; // 바운드의 중심이다.

@property (nonatomic, strong) UIView *containerView; // 레이어들을 여기에 담자. 회전도 담당하게 하자.

@property (nonatomic, strong) CALayer *maskLayer; // None 일때 주변으로 흩어지는 line layer의 path를 감추기 위함이다.
@property (nonatomic, strong) CAShapeLayer *line0Layer;
@property (nonatomic, strong) CAShapeLayer *line1Layer;
@property (nonatomic, strong) CAShapeLayer *line2Layer;
@property (nonatomic, strong) CAShapeLayer *line3Layer;
@property (nonatomic, strong) CAShapeLayer *line4Layer;
@property (nonatomic, strong) CAShapeLayer *line5Layer;
@property (nonatomic, strong, readonly) NSArray <CAShapeLayer *>*shapeLayers; // 위의 순서대로 들어있다.

@property (nonatomic, assign) BOOL highlightGuardActivated;
@property (nonatomic, assign) CGRect previousRect;
@end

@implementation MGUDisplaySwitcherButton (Style)

- (void)_setStyle:(MGUDisplaySwitcherButtonStyle)style animated:(BOOL)animated {
    CGPathRef newLine0Path = NULL;
    CGPathRef newLine1Path = NULL;
    CGPathRef newLine2Path = NULL;
    CGPathRef newLine3Path = NULL;
    CGPathRef newLine4Path = NULL;
    CGPathRef newLine5Path = NULL;

    // first compute the new paths for our 4 layers.
    if (style == MGUDisplaySwitcherButtonStyleHamburger) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 윗쪽
                                                    angle:0
                                                   offset:CGPointMake(0, -self.dimension/2.0f/GOLDEN_RATIO)];
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 윗쪽
                                                    angle:0
                                                   offset:CGPointMake(0, -self.dimension/2.0f/GOLDEN_RATIO)];

        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 가운데
                                                    angle:0
                                                   offset:CGPointMake(0, 0)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 가운데
                                                    angle:0
                                                   offset:CGPointMake(0, 0)];

        newLine4Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 아랫쪽
                                                    angle:0
                                                   offset:CGPointMake(0, self.dimension/2.0f/GOLDEN_RATIO)];
        newLine5Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 아랫쪽
                                                    angle:0
                                                   offset:CGPointMake(0, self.dimension/2.0f/GOLDEN_RATIO)];

    } else if (style == MGUDisplaySwitcherButtonStyleGrid) {
//        CGFloat hConstant = self.dimension / 2.2;
//        CGFloat vConstant = self.dimension / 1.4;
//        CGFloat lineWidth = self.line1Layer.lineWidth * 3.0;
        CGFloat hConstant = self.dimension / 2.5;
        CGFloat vConstant = self.dimension / 1.6;
        CGFloat lineWidth = self.line1Layer.lineWidth * 2.4;
        CGRect rect = CGRectMake(self.centerPoint.x - lineWidth / 2.0, self.centerPoint.y - lineWidth / 2.0, lineWidth, lineWidth);
//        UIBezierPath *midPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:lineWidth/2.0];
        UIBezierPath *centerPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0.0];
        UIBezierPath *path0 = centerPath.copy;
        UIBezierPath *path1 = centerPath.copy;
        UIBezierPath *path2 = centerPath.copy;
        UIBezierPath *path3 = centerPath.copy;
        UIBezierPath *path4 = centerPath.copy;
        UIBezierPath *path5 = centerPath.copy;
        [path0 applyTransform:CGAffineTransformMakeTranslation(- hConstant + lineWidth, -vConstant + lineWidth)];
        [path1 applyTransform:CGAffineTransformMakeTranslation(+ hConstant - lineWidth, -vConstant + lineWidth)];
        
        [path2 applyTransform:CGAffineTransformMakeTranslation(- hConstant + lineWidth, 0.0)];
        [path3 applyTransform:CGAffineTransformMakeTranslation(+ hConstant - lineWidth, 0.0)];
        
        [path4 applyTransform:CGAffineTransformMakeTranslation(- hConstant + lineWidth, +vConstant - lineWidth)];
        [path5 applyTransform:CGAffineTransformMakeTranslation(+ hConstant - lineWidth, +vConstant - lineWidth)];
                
        newLine0Path = path0.CGPath;
        newLine1Path = path1.CGPath;
        newLine2Path = path2.CGPath;
        newLine3Path = path3.CGPath;
        newLine4Path = path4.CGPath;
        newLine5Path = path5.CGPath;
    } else {
        NSAssert(FALSE, @"unknown type");
    }
    
    if (animated == YES) {
        NSArray *newLinePaths = @[(__bridge id)newLine0Path,
                                  (__bridge id)newLine1Path,
                                  (__bridge id)newLine2Path,
                                  (__bridge id)newLine3Path,
                                  (__bridge id)newLine4Path,
                                  (__bridge id)newLine5Path];
        
        for (NSInteger i = 0; i < self.shapeLayers.count; i++) {
            CABasicAnimation *pathAnimation = [self animationSetup];
            CAShapeLayer *lineLayer = self.shapeLayers[i];
            CGPathRef newLinePath = (__bridge CGPathRef)(newLinePaths[i]);
            if (lineLayer.presentationLayer != nil) {
                CAShapeLayer *shapeLayer = (CAShapeLayer *)lineLayer.presentationLayer;
                CGPathRef path  = shapeLayer.path;
                pathAnimation.fromValue = (__bridge id)path;
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                lineLayer.path = path;
                [CATransaction commit];
            }
            //pathAnimation.fromValue = (__bridge id)lineLayer.path;
            pathAnimation.toValue = (__bridge id)newLinePath;
            [CATransaction setCompletionBlock:^{
                lineLayer.path = newLinePath;
            }];
            [lineLayer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"PathAnimationKey%ld", i]];
        }
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.2
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveEaseInOut
                                                         animations:^{
            if (style == MGUDisplaySwitcherButtonStyleGrid) {
                self.containerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
            } else {
                self.containerView.transform = CGAffineTransformIdentity;
            }
        }
                                                         completion:nil];
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.line0Layer.path = newLine0Path;
        self.line1Layer.path = newLine1Path;
        self.line2Layer.path = newLine2Path;
        self.line3Layer.path = newLine3Path;
        self.line4Layer.path = newLine4Path;
        self.line5Layer.path = newLine5Path;
        if (style == MGUDisplaySwitcherButtonStyleGrid) {
            self.containerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        } else {
            self.containerView.transform = CGAffineTransformIdentity;
        }
        [CATransaction commit];
    }
}

- (CABasicAnimation *)animationSetup {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = 0.2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return pathAnimation;
}

- (CGPathRef)createCenteredLineWithRadius:(CGFloat)radius
                                    angle:(CGFloat)angle
                                   offset:(CGPoint)offset {
    CGMutablePathRef path = CGPathCreateMutable();
    
    float c = cosf(angle);
    float s = sinf(angle);
    
    CGPathMoveToPoint(path, NULL,
                      self.centerPoint.x + offset.x + radius * c,
                      self.centerPoint.y + offset.y + radius * s);
    CGPathAddLineToPoint(path, NULL,
                         self.centerPoint.x + offset.x - radius * c,
                         self.centerPoint.y + offset.y - radius * s);
    
    return (CGPathRef)CFAutorelease(path); // path;
}

@end

/*
- (CGPathRef)createCenteredCircleWithRadius:(CGFloat)radius {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, self.centerPoint.x + radius, self.centerPoint.y);
    // note: if clockwise is set to true, the circle will not draw on an actual device,
    // event hough it is fine on the simulator...
    CGPathAddArc(path, NULL, self.centerPoint.x, self.centerPoint.y, radius, 0, 2 * M_PI, false);
    
   return (CGPathRef)CFAutorelease(path); // path;
}


//! origin을 내부의 정사각형으로 간주한다.
- (CGPathRef)createLineFromPoint:(CGPoint)p1
                         toPoint:(CGPoint)p2 {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.offset.x + p1.x, self.offset.y + p1.y);
    CGPathAddLineToPoint(path, NULL, self.offset.x + p2.x, self.offset.y + p2.y);
    return (CGPathRef)CFAutorelease(path);
    
//    CGPathMoveToPoint(path, NULL, p1.x, p1.y);
//    CGPathAddLineToPoint(path, NULL, p2.x, p2.y);
//    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, self.offset.x, self.offset.y);
//    CGPathRef result = CGPathCreateCopyByTransformingPath(path, &transform);
//    CGPathRelease(path);
//    return (CGPathRef)CFAutorelease(result);
}
*/
