//
//  MGUOnOffButtonLockSkinLockView.m
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUOnOffButtonLockSkinLockView.h"

@interface MGUOnOffButtonLockSkinLockView ()
@property (nonatomic, strong) CAShapeLayer *lockBodyLayer;
@property (nonatomic, strong) CAShapeLayer *lockArcLayer;
@property (nonatomic, assign) CGRect previousBounds;
@end

@implementation MGUOnOffButtonLockSkinLockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layer.bounds.size.width > 0.0 &&
        self.layer.bounds.size.height > 0.0 &&
        CGRectEqualToRect(self.previousBounds, self.layer.bounds) == NO) {
        self.previousBounds = self.layer.bounds;
        [self updateLockLayers];
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUOnOffButtonLockSkinLockView *self) {
    self.userInteractionEnabled = NO;
    self->_previousBounds = self.layer.bounds;
    self->_progress = 0.0;
    self->_lockBodyLayer = [CAShapeLayer layer];
    self->_lockArcLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.lockBodyLayer];
    [self.layer addSublayer:self.lockArcLayer];
    self.lockBodyLayer.frame = self.layer.bounds;
    self.lockArcLayer.frame = self.layer.bounds;
    
    self.lockBodyLayer.strokeColor = [UIColor systemBlueColor].CGColor;
    self.lockBodyLayer.fillColor = [UIColor systemBlueColor].CGColor;
    self.lockBodyLayer.lineJoin = kCALineJoinRound;
    self.lockBodyLayer.lineCap = kCALineCapRound;
    
    self.lockArcLayer.strokeColor = [UIColor systemBlueColor].CGColor;
    self.lockArcLayer.fillColor = [UIColor clearColor].CGColor;
    self.lockArcLayer.lineJoin = kCALineJoinRound;
    self.lockArcLayer.lineCap = kCALineCapRound;
    
    if (self.previousBounds.size.width > 0.0 && self.previousBounds.size.height > 0.0) {
        [self updateLockLayers];
    }
}


#pragma mark - 세터 & 게터
- (void)setColor:(UIColor *)color {
    _color = color;
    self.lockBodyLayer.strokeColor = color.CGColor;
    self.lockBodyLayer.fillColor = color.CGColor;
    self.lockArcLayer.strokeColor = color.CGColor;
}

- (void)setProgress:(CGFloat)progress {
    progress = MIN(MAX(0.0, progress), 1.0);
    if (_progress != progress) {
        _progress = progress;
        self.lockArcLayer.path = [self drawLockWithProgress:progress];
    }
}

#pragma mark - Actions
- (void)updateLockLayers {
    CGFloat length = self.layer.bounds.size.width;
    self.lockBodyLayer.frame = self.layer.bounds;
    self.lockArcLayer.frame = self.layer.bounds;
    self.lockBodyLayer.lineWidth = MAX(round((3.0 * length) / 44.0), 1.0);
    self.lockArcLayer.lineWidth = self.lockBodyLayer.lineWidth;
    self.lockBodyLayer.path = [self makeLockBodyPath];
    self.lockArcLayer.path = [self drawLockWithProgress:self.progress];
}

- (CGPathRef)makeLockBodyPath {
    // 정사각형을 가정한다.
    CGRect bounds = CGRectMake(0.0, 0.0, self.layer.bounds.size.width, self.layer.bounds.size.width);
    CGPoint boundsCenter = CGPointMake(bounds.size.width/2.0, bounds.size.height/2.0);
    CGFloat standardLength = bounds.size.width;
    CGFloat ratio = standardLength / 100.0;
    CGFloat bodyWidth = 30.0 * (ratio);
    CGFloat bodyHeight = 16.0 * (ratio);
    CGRect bodyFrame = MGERectCenteredInRectSize(bounds, CGSizeMake(bodyWidth, bodyHeight));
    bodyFrame.origin.y = boundsCenter.y;
    return (CGPathRef)CFAutorelease(CGPathCreateWithRect(bodyFrame, NULL));
}

- (CGPathRef)drawLockWithProgress:(CGFloat)progress {
    // 정사각형을 가정한다.
    CGRect bounds = CGRectMake(0.0, 0.0, self.layer.bounds.size.width, self.layer.bounds.size.width);
    CGPoint boundsCenter = CGPointMake(bounds.size.width/2.0, bounds.size.height/2.0);
    CGFloat standardLength = bounds.size.width;
    CGFloat ratio = standardLength / 100.0;
    
    CGFloat circleRadius = 10.0 * (ratio);
    CGPoint tempCircleCenter = CGPointMake(-circleRadius, 0.0);
    CGPoint anchorPoint = CGPointMake(boundsCenter.x + circleRadius, boundsCenter.y - circleRadius);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathAddArc(path1, NULL, tempCircleCenter.x, tempCircleCenter.y, circleRadius, 0.0, -M_PI, YES);
    CGPathAddLineToPoint(path1, NULL, tempCircleCenter.x-circleRadius, circleRadius);
    CGPathMoveToPoint(path1, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path1, NULL, 0.0, 2.0 * circleRadius);
    
    CGFloat rotationProgress = MGELerpDouble(MAX((progress - 0.5)*2.0, 0.0), 1.0, -1.0);
    CGFloat upProgress = MIN(MAX(0.0, progress * 2.0), 1.0);
    
    CGAffineTransform affineTransform = CGAffineTransformScale(CGAffineTransformIdentity, rotationProgress, 1.0);
    CGPathRef path2 = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(path1), &affineTransform);
    affineTransform =
    CGAffineTransformTranslate(CGAffineTransformIdentity, anchorPoint.x, anchorPoint.y - circleRadius * upProgress);
    
    CGPathRef path3 = CGPathCreateCopyByTransformingPath((CGPathRef)CFAutorelease(path2), &affineTransform);
    return (CGPathRef)CFAutorelease(path3);

}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
