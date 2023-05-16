//
//  MGULivelyButton+Style.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGULivelyButton+Style.h"
@import GraphicsKit;

#define GOLDEN_RATIO 1.618

@interface MGULivelyButton()

@property (nonatomic, assign, readonly) CGFloat dimension;
@property (nonatomic, assign, readonly) CGPoint offset;
@property (nonatomic, assign, readonly) CGPoint centerPoint; // 바운드의 중심이다.

@property (nonatomic, strong) CALayer *maskLayer; // None 일때 주변으로 흩어지는 line layer의 path를 감추기 위함이다.
@property (nonatomic, strong) CAShapeLayer *line0Layer;
@property (nonatomic, strong) CAShapeLayer *line1Layer;
@property (nonatomic, strong) CAShapeLayer *line2Layer;
@property (nonatomic, strong) CAShapeLayer *line3Layer;
@property (nonatomic, strong, readonly) NSArray <CAShapeLayer *>*shapeLayers; // 위의 순서대로 들어있다.

@property (nonatomic, assign) BOOL highlightGuardActivated;
@property (nonatomic, assign) CGRect previousRect;
@end

@implementation MGULivelyButton (Style)

- (void)_setStyle:(MGULivelyButtonStyle)style animated:(BOOL)animated {
        
    CGPathRef newLine0Path = NULL;
    CGPathRef newLine1Path = NULL;
    CGPathRef newLine2Path = NULL;
    CGPathRef newLine3Path = NULL;
        
    // first compute the new paths for our 4 layers.
    if (style == MGULivelyButtonStyleHamburger) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 가운데 중복
                                                    angle:0
                                                   offset:CGPointMake(0, 0)];
        
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 가운데
                                                    angle:0
                                                   offset:CGPointMake(0, 0)];
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 윗쪽
                                                    angle:0
                                                   offset:CGPointMake(0, -self.dimension/2.0f/GOLDEN_RATIO)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f // 아랫쪽
                                                    angle:0
                                                   offset:CGPointMake(0, self.dimension/2.0f/GOLDEN_RATIO)];
            
    } else if (style == MGULivelyButtonStylePlus) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_2 offset:CGPointMake(0, 0)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:0 offset:CGPointMake(0, 0)]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_2 offset:CGPointMake(0, 0)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:0 offset:CGPointMake(0, 0)];
            
    } else if (style == MGULivelyButtonStyleCirclePlus) {
        newLine0Path = [self createCenteredCircleWithRadius:self.dimension/2.0f];
        newLine1Path = [self createCenteredCircleWithRadius:self.dimension/2.0f]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f/GOLDEN_RATIO angle:M_PI_2 offset:CGPointMake(0, 0)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f/GOLDEN_RATIO angle:0 offset:CGPointMake(0, 0)];
            
    } else if (style == MGULivelyButtonStyleClose) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_4 offset:CGPointMake(0, 0)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:-M_PI_4 offset:CGPointMake(0, 0)]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_4 offset:CGPointMake(0, 0)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:-M_PI_4 offset:CGPointMake(0, 0)];
            
    } else if (style == MGULivelyButtonStyleCircleClose) {
        newLine0Path = [self createCenteredCircleWithRadius:self.dimension/2.0f];
        newLine1Path = [self createCenteredCircleWithRadius:self.dimension/2.0f]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/2.0f/GOLDEN_RATIO angle:+M_PI_4 offset:CGPointMake(0, 0)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/2.0f/GOLDEN_RATIO angle:-M_PI_4 offset:CGPointMake(0, 0)];
        
    } else if (style == MGULivelyButtonStyleCaretUp) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f angle:M_PI_4 offset:CGPointMake(self.dimension/6.0f,0.0f)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f angle:3*M_PI_4 offset:CGPointMake(-self.dimension/6.0f,0.0f)]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f angle:M_PI_4 offset:CGPointMake(self.dimension/6.0f,0.0f)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f angle:3*M_PI_4 offset:CGPointMake(-self.dimension/6.0f,0.0f)];
            
    } else if (style == MGULivelyButtonStyleCaretDown) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-M_PI_4
                                                   offset:CGPointMake(self.dimension/6.0f,0.0f)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:-3*M_PI_4
                                                   offset:CGPointMake(-self.dimension/6.0f,0.0f)]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-M_PI_4
                                                   offset:CGPointMake(self.dimension/6.0f,0.0f)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:-3*M_PI_4
                                                   offset:CGPointMake(-self.dimension/6.0f,0.0f)];
    } else if (style == MGULivelyButtonStyleCaretLeft) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-3*M_PI_4
                                                   offset:CGPointMake(0.0f,self.dimension/6.0f)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:3*M_PI_4
                                                   offset:CGPointMake(0.0f,-self.dimension/6.0f)]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-3*M_PI_4
                                                   offset:CGPointMake(0.0f,self.dimension/6.0f)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:3*M_PI_4
                                                   offset:CGPointMake(0.0f,-self.dimension/6.0f)];
            
    } else if (style == MGULivelyButtonStyleCaretRight) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-M_PI_4
                                                   offset:CGPointMake(0.0f,self.dimension/6.0f)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:M_PI_4
                                                   offset:CGPointMake(0.0f,-self.dimension/6.0f)]; // 중복
        
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line2Layer.lineWidth/2.0f
                                                    angle:-M_PI_4
                                                   offset:CGPointMake(0.0f,self.dimension/6.0f)];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/4.0f - self.line3Layer.lineWidth/2.0f
                                                    angle:M_PI_4
                                                   offset:CGPointMake(0.0f,-self.dimension/6.0f)];
    } else if (style == MGULivelyButtonStyleCheckMark) {
        CGPoint dimensionCenter = CGPointMake(self.dimension / 2.0, self.dimension / 2.0);
        
        CGPoint headPoint = CGPointMake(dimensionCenter.x, dimensionCenter.y);
        CGPoint rightPoint = CGPointMake(self.dimension, 0.0);
        CGPoint leftPoint  = CGPointMake(self.dimension/4.0f, self.dimension/4.0f);
        CGPoint offsetPoint = CGPointMake(-self.dimension / 8.0, self.dimension / 4.0);
        headPoint  = CGPointMake(headPoint.x + offsetPoint.x, headPoint.y + offsetPoint.y);
        rightPoint = CGPointMake(rightPoint.x + offsetPoint.x, rightPoint.y + offsetPoint.y);
        leftPoint  = CGPointMake(leftPoint.x + offsetPoint.x, leftPoint.y + offsetPoint.y);
        
        newLine0Path = [self createLineFromPoint:rightPoint toPoint:headPoint]; // 중복
        newLine1Path = [self createLineFromPoint:leftPoint toPoint:headPoint]; // 중복
            
        newLine2Path = [self createLineFromPoint:rightPoint toPoint:headPoint];
        newLine3Path = [self createLineFromPoint:leftPoint toPoint:headPoint];
                
    } else if (style == MGULivelyButtonStyleArrowLeft) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:M_PI offset:CGPointMake(0, 0)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:M_PI offset:CGPointMake(0, 0)];
        newLine2Path = [self createLineFromPoint:CGPointMake(0, self.dimension/2.0f)
                                         toPoint:CGPointMake(self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO)];
        newLine3Path = [self createLineFromPoint:CGPointMake(0, self.dimension/2.0f)
                                         toPoint:CGPointMake(self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO)];
            
    } else if (style == MGULivelyButtonStyleArrowRight) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:0 offset:CGPointMake(0, 0)]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:0 offset:CGPointMake(0, 0)];
        newLine2Path = [self createLineFromPoint:CGPointMake(self.dimension, self.dimension/2.0f)
                                         toPoint:CGPointMake(self.dimension - self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO)];
        newLine3Path = [self createLineFromPoint:CGPointMake(self.dimension, self.dimension/2.0f)
                                         toPoint:CGPointMake(self.dimension - self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO)];
            
    } else if (style == MGULivelyButtonStyleArrowUp) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:-M_PI_2 offset:CGPointZero]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:-M_PI_2 offset:CGPointZero];
        newLine2Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, 0.0)
                                         toPoint:CGPointMake(self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2.0f/GOLDEN_RATIO)];
            
        newLine3Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, 0.0)
                                         toPoint:CGPointMake(self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension/2.0f/GOLDEN_RATIO)];
    } else if (style == MGULivelyButtonStyleArrowDown) {
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_2 offset:CGPointZero]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_2 offset:CGPointZero];
        newLine2Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, self.dimension)
                                         toPoint:CGPointMake(self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension - self.dimension/2.0f/GOLDEN_RATIO)];
            
        newLine3Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, self.dimension)
                                         toPoint:CGPointMake(self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension - self.dimension/2.0f/GOLDEN_RATIO)];
    } else if (style == MGULivelyButtonStyleDownLoad) {
        newLine0Path = [self createLineFromPoint:CGPointMake(self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO,
                                                              self.dimension)
                                          toPoint:CGPointMake(self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO,
                                                              self.dimension)];
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/2.0f angle:+M_PI_2 offset:CGPointZero];
        newLine2Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, self.dimension)
                                         toPoint:CGPointMake(self.dimension/2+self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension - self.dimension/2.0f/GOLDEN_RATIO)];
                
        newLine3Path = [self createLineFromPoint:CGPointMake(self.dimension/2.0f, self.dimension)
                                         toPoint:CGPointMake(self.dimension/2-self.dimension/2.0f/GOLDEN_RATIO,
                                                             self.dimension - self.dimension/2.0f/GOLDEN_RATIO)];
    } else if (style == MGULivelyButtonStylePause) {
        CGPoint leftOffset  = CGPointMake(-self.dimension/6.0f, 0.0);
        CGPoint rightOffset = CGPointMake(self.dimension/6.0f, 0.0);
        
        newLine0Path = [self createCenteredLineWithRadius:self.dimension/3.0f angle:+M_PI_2 offset:leftOffset]; // 중복
        newLine1Path = [self createCenteredLineWithRadius:self.dimension/3.0f angle:+M_PI_2 offset:rightOffset]; // 중복
        newLine2Path = [self createCenteredLineWithRadius:self.dimension/3.0f angle:+M_PI_2 offset:leftOffset];
        newLine3Path = [self createCenteredLineWithRadius:self.dimension/3.0f angle:+M_PI_2 offset:rightOffset];
        
    } else if (style == MGULivelyButtonStylePlay) {
        
        //! 삼각형의 무게중심.
        CGFloat thirdSize = self.dimension / 3.0;
        CGFloat sixthSize = self.dimension / 6.0;
        CGPoint dimensionCenter = CGPointMake(self.dimension / 2.0, self.dimension / 2.0);
        CGPoint a = CGPointMake(dimensionCenter.x - sixthSize, dimensionCenter.y - thirdSize);
        CGPoint b = CGPointMake(dimensionCenter.x - sixthSize, dimensionCenter.y + thirdSize);
        CGPoint c = CGPointMake(dimensionCenter.x + thirdSize, dimensionCenter.y);
        
        newLine0Path = [self createLineFromPoint:a toPoint:b];
        newLine1Path = [self createLineFromPoint:a toPoint:b];
        newLine2Path = [self createLineFromPoint:c toPoint:a];
        newLine3Path = [self createLineFromPoint:c toPoint:b];
        
    } else if (style == MGULivelyButtonStyleStop) {
        CGFloat thirdSize = self.dimension / 3.0;
        CGPoint dimensionCenter = CGPointMake(self.dimension / 2.0, self.dimension / 2.0);
        CGPoint a = CGPointMake(dimensionCenter.x - thirdSize, dimensionCenter.y - thirdSize);
        CGPoint b = CGPointMake(dimensionCenter.x - thirdSize, dimensionCenter.y + thirdSize);
        CGPoint c = CGPointMake(dimensionCenter.x + thirdSize, dimensionCenter.y + thirdSize);
        CGPoint d = CGPointMake(dimensionCenter.x + thirdSize, dimensionCenter.y - thirdSize);
        newLine0Path = [self createLineFromPoint:a toPoint:b];
        newLine1Path = [self createLineFromPoint:b toPoint:c];
        newLine2Path = [self createLineFromPoint:c toPoint:d];
        newLine3Path = [self createLineFromPoint:d toPoint:a];
            
    } else if (style == MGULivelyButtonStyleRewind) {
        CGFloat thirdSize = self.dimension / 3.0;
        CGFloat sixthSize = self.dimension / 6.0;
        CGFloat ninthSize = self.dimension / 9.0;
        CGPoint dimensionCenter = CGPointMake(self.dimension / 2.0, self.dimension / 2.0);
        CGPoint a = CGPointMake(dimensionCenter.x - ninthSize * 2.0, dimensionCenter.y);
        CGPoint b = CGPointMake(dimensionCenter.x + ninthSize, dimensionCenter.y + thirdSize);
        CGPoint c = CGPointMake(dimensionCenter.x + ninthSize, dimensionCenter.y - thirdSize);
        
        newLine0Path = [self createLineFromPoint:CGPointMake(a.x + sixthSize, a.y) toPoint:CGPointMake(b.x+ sixthSize, b.y)];
        newLine1Path = [self createLineFromPoint:CGPointMake(a.x + sixthSize, a.y) toPoint:CGPointMake(c.x+ sixthSize, c.y)];
        newLine2Path = [self createLineFromPoint:CGPointMake(a.x - sixthSize, a.y) toPoint:CGPointMake(b.x - sixthSize, b.y)];
        newLine3Path = [self createLineFromPoint:CGPointMake(a.x - sixthSize, a.y) toPoint:CGPointMake(c.x - sixthSize, c.y)];
    } else if (style == MGULivelyButtonStyleFastForward) {
        
        //! 삼각형의 무게중심.
        CGFloat thirdSize = self.dimension / 3.0;
        CGFloat sixthSize = self.dimension / 6.0;
        CGFloat ninthSize = self.dimension / 9.0;
        CGPoint dimensionCenter = CGPointMake(self.dimension / 2.0, self.dimension / 2.0);
        CGPoint a = CGPointMake(dimensionCenter.x + ninthSize * 2.0, dimensionCenter.y);
        CGPoint b = CGPointMake(dimensionCenter.x - ninthSize, dimensionCenter.y + thirdSize);
        CGPoint c = CGPointMake(dimensionCenter.x - ninthSize, dimensionCenter.y - thirdSize);
        
        newLine0Path = [self createLineFromPoint:CGPointMake(a.x + sixthSize, a.y) toPoint:CGPointMake(b.x+ sixthSize, b.y)];
        newLine1Path = [self createLineFromPoint:CGPointMake(a.x + sixthSize, a.y) toPoint:CGPointMake(c.x+ sixthSize, c.y)];
        newLine2Path = [self createLineFromPoint:CGPointMake(a.x - sixthSize, a.y) toPoint:CGPointMake(b.x - sixthSize, b.y)];
        newLine3Path = [self createLineFromPoint:CGPointMake(a.x - sixthSize, a.y) toPoint:CGPointMake(c.x - sixthSize, c.y)];
    } else if (style == MGULivelyButtonStyleDot) {
        CGFloat lineWidth = self.line1Layer.lineWidth;
        CGRect rect = CGRectMake(self.centerPoint.x - lineWidth / 2, self.centerPoint.y - lineWidth / 2, lineWidth, lineWidth);
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:lineWidth/2.0].CGPath;
        newLine0Path = path;
        newLine1Path = path;
        newLine2Path = path;
        newLine3Path = path;
    } else if (style == MGULivelyButtonStyleHorizontalMoreOptions) {
        
        CGFloat midSize = self.dimension / 2.0;
        CGFloat lineWidth = self.line1Layer.lineWidth;
        CGRect rect = CGRectMake(self.centerPoint.x - lineWidth / 2.0, self.centerPoint.y - lineWidth / 2.0, lineWidth, lineWidth);
        UIBezierPath *midPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:lineWidth/2.0];
        UIBezierPath *leftPath = midPath.copy;
        UIBezierPath *rightPath = midPath.copy;
        [leftPath applyTransform:CGAffineTransformMakeTranslation(- midSize + lineWidth, 0.0)];
        [rightPath applyTransform:CGAffineTransformMakeTranslation(+ midSize - lineWidth, 0.0)];
        
        newLine0Path = midPath.CGPath;
        newLine1Path = midPath.CGPath;
        newLine2Path = leftPath.CGPath;
        newLine3Path = rightPath.CGPath;
        
    } else if (style == MGULivelyButtonStyleVerticalMoreOptions) {
                    
        CGFloat midSize = self.dimension / 2.0;
        CGFloat lineWidth = self.line1Layer.lineWidth;
        CGRect rect = CGRectMake(self.centerPoint.x - lineWidth / 2.0, self.centerPoint.y - lineWidth / 2.0, lineWidth, lineWidth);
        UIBezierPath *midPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:lineWidth/2.0];
        UIBezierPath *topPath = midPath.copy;
        UIBezierPath *bottomPath = midPath.copy;
        [topPath applyTransform:CGAffineTransformMakeTranslation(0.0, - midSize + lineWidth)];
        [bottomPath applyTransform:CGAffineTransformMakeTranslation(0.0, + midSize - lineWidth)];
        
        newLine0Path = midPath.CGPath;
        newLine1Path = midPath.CGPath;
        newLine2Path = topPath.CGPath;
        newLine3Path = bottomPath.CGPath;
    } else if (style == MGULivelyButtonStyleHorizontalLine) {
        CGFloat midSize = self.dimension / 2.0 - self.line1Layer.lineWidth;
        CGPathRef path = [self createCenteredLineWithRadius:midSize angle:0 offset:CGPointMake(0, 0)];
        
        newLine0Path = path;
        newLine1Path = path;
        newLine2Path = path;
        newLine3Path = path;
        
    } else if (style == MGULivelyButtonStyleVerticalLine) {
        CGFloat midSize = self.dimension / 2.0 - self.line1Layer.lineWidth;
        CGPathRef path = [self createCenteredLineWithRadius:midSize angle:M_PI_2 offset:CGPointMake(0, 0)];
        
        newLine0Path = path;
        newLine1Path = path;
        newLine2Path = path;
        newLine3Path = path;
    } else if (style == MGULivelyButtonStyleReload) {
        
        CGFloat sixthSize = self.dimension / 6.0;
        CGFloat fifthPi   = M_PI / 5.5;
        CGFloat endAngle = (3.0 * M_PI_2) - fifthPi;
        CGFloat radius = self.dimension / 2.0 - self.line1Layer.lineWidth;
        CGPoint endPoint = MGERotatePointAboutCenter(self.centerPoint,
                                                     CGPointMake(self.centerPoint.x + radius, self.centerPoint.y),
                                                     endAngle);
        UIBezierPath *curveBezierPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint
                                                                       radius:radius
                                                                   startAngle:-fifthPi
                                                                     endAngle:endAngle
                                                                    clockwise:YES];
        
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:endPoint];
        [path1 addLineToPoint:CGPointMake(endPoint.x - sixthSize, endPoint.y)];
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:endPoint];
        [path2 addLineToPoint:CGPointMake(endPoint.x, endPoint.y + sixthSize)];
        
        newLine0Path = curveBezierPath.CGPath;
        newLine1Path = curveBezierPath.CGPath;
        newLine2Path = path1.CGPath;
        newLine3Path = path2.CGPath;
        
    } else if (style == MGULivelyButtonStyleLocation) {
        CGFloat smallCircleYOffset = self.dimension * (7.0f / 60.0f);
        CGFloat lineWidth = self.line1Layer.lineWidth;
        CGPoint smallCircleCenter = CGPointMake(self.centerPoint.x, self.centerPoint.y - smallCircleYOffset);
        UIBezierPath *smallCirPath = [UIBezierPath bezierPathWithArcCenter:smallCircleCenter
                                                                    radius:self.dimension / 5 - lineWidth
                                                                startAngle:0.0
                                                                  endAngle:M_PI * 2.0
                                                                 clockwise:YES];
        
        CGFloat bigCirCleRadius = self.dimension * (21.0f / 60.0f);
        CGFloat controlpointLength = (2761.0 / 5000.0) * bigCirCleRadius;
        
        UIBezierPath *p1 = [UIBezierPath bezierPath];
        [p1 moveToPoint:CGPointMake(self.centerPoint.x, self.centerPoint.y - self.dimension * (28.0f / 60.0f))];
        [p1 addArcWithCenter:smallCircleCenter radius:bigCirCleRadius startAngle:-M_PI_2 endAngle:0.0 clockwise:YES];
        
        CGPoint controlPoint1 = CGPointMake(smallCircleCenter.x + bigCirCleRadius, smallCircleCenter.y + controlpointLength);
        CGPoint southPoint = CGPointMake(self.centerPoint.x, self.centerPoint.y + (28.0f/60.0f) * self.dimension);
        
        [p1 addCurveToPoint:southPoint controlPoint1:controlPoint1 controlPoint2:southPoint];
        
        CGPoint westPoint = CGPointMake(smallCircleCenter.x - bigCirCleRadius, smallCircleCenter.y);
        controlPoint1 = CGPointMake(westPoint.x, westPoint.y + controlpointLength);
        
        [p1 addCurveToPoint:westPoint controlPoint1:southPoint controlPoint2:controlPoint1];
        
        [p1 addArcWithCenter:smallCircleCenter radius:bigCirCleRadius startAngle:M_PI endAngle:M_PI_2 * 3.0 clockwise:YES];
        [p1 closePath];

        newLine0Path = p1.CGPath;
        newLine1Path = smallCirPath.CGPath;
        newLine2Path = smallCirPath.CGPath;
        newLine3Path = smallCirPath.CGPath;
        
    } else if (style == MGULivelyButtonStyleNone) {
        UIBezierPath * p1 =
        [UIBezierPath bezierPathWithRect:CGRectMake(self.centerPoint.x - self.dimension,
                                                    self.centerPoint.y - self.dimension, 0.0, 0.0)];
        UIBezierPath * p2 =
        [UIBezierPath bezierPathWithRect:CGRectMake(self.centerPoint.x + self.dimension,
                                                    self.centerPoint.y - self.dimension, 0.0, 0.0)];
        UIBezierPath * p3 =
        [UIBezierPath bezierPathWithRect:CGRectMake(self.centerPoint.x - self.dimension,
                                                    self.centerPoint.y + self.dimension, 0.0, 0.0)];
        UIBezierPath * p4 =
        [UIBezierPath bezierPathWithRect:CGRectMake(self.centerPoint.x + self.dimension,
                                                    self.centerPoint.y + self.dimension, 0.0, 0.0)];
        newLine0Path = p1.CGPath;
        newLine1Path = p2.CGPath;
        newLine2Path = p3.CGPath;
        newLine3Path = p4.CGPath;
            
    } else {
        NSAssert(FALSE, @"unknown type");
    }
    
    if (animated == YES) {
        NSArray *newLinePaths = @[(__bridge id)newLine0Path,
                                  (__bridge id)newLine1Path,
                                  (__bridge id)newLine2Path,
                                  (__bridge id)newLine3Path];
        
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
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.line0Layer.path = newLine0Path;
        self.line1Layer.path = newLine1Path;
        self.line2Layer.path = newLine2Path;
        self.line3Layer.path = newLine3Path;
        [CATransaction commit];
    }
}

- (CABasicAnimation *)animationSetup {
    CASpringAnimation *pathAnimation = [CASpringAnimation animationWithKeyPath:@"path"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = pathAnimation.settlingDuration;
    pathAnimation.damping  = 10.0f;
    pathAnimation.mass = 1.0;
    pathAnimation.initialVelocity  = 0.0f;
    pathAnimation.stiffness  = 100.f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//!   spring 이 부담스럽다면 아래의 주석으로 값을 변경하라.
//    pathAnimation.initialVelocity  = 15.0f;
//    pathAnimation.damping  = 20.0f;
    return pathAnimation;
}

- (CGPathRef)createCenteredCircleWithRadius:(CGFloat)radius {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, self.centerPoint.x + radius, self.centerPoint.y);
    // note: if clockwise is set to true, the circle will not draw on an actual device,
    // event hough it is fine on the simulator...
    CGPathAddArc(path, NULL, self.centerPoint.x, self.centerPoint.y, radius, 0, 2 * M_PI, false);
    
   return (CGPathRef)CFAutorelease(path); // path;
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

@end
