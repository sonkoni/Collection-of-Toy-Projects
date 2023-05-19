//
//  MGRDialControl.m
//  DialControl
//
//  Created by Kwan Hyun Son on 20/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

@import IosKit;
#import "MGRDialControl.h"
#import "MGRDialGaugeView.h"

@interface MGRDialControl ()
@property (nonatomic, assign) BOOL allowCreate; // bounds 생성 및 변할때. layoutSubView에서 만들자.

@property (nonatomic, strong) UIView *circleBackgroundView;

@property (nonatomic, strong) CAShapeLayer *knobBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *knobLayer;
@property (nonatomic, assign) CATransform3D transformOfKnobLayerWhenTouchBegin;
@property (nonatomic, assign) CGFloat angleFromCenterWhenTouchBegan;  // 터치의 시작점과 센터와의 각이다. 레이어의 회전과 무관하며 터치 비긴에서 결정된다.
@property (nonatomic, assign) CGFloat standardAngleFromCenterWhenTouchBegan;  // 터치가 시작되었을 때의 섹션의 중심을 지나는 선의 각.
@property (nonatomic, assign) CGFloat standardAngleFromCenterAtCurrnetTime;

@property (nonatomic, strong) UIColor *knobNormalColor;
@property (nonatomic, strong) UIColor *knobHighlightColor;
@property (nonatomic, strong) UIColor *mainCircleColor;
@property (nonatomic, strong) UIColor *secondCircleColor;
@property (nonatomic, strong) UIColor *thirdCircleColor;

@property (nonatomic, strong) MGRDialGaugeView *dialGaugeView;
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation MGRDialControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    NSAssert(false, @"- initWithCoder: 사용금지.");
    return self;
}

- (void)setBounds:(CGRect)bounds {
    if (CGRectEqualToRect(self.bounds, bounds) == NO) {
        self.allowCreate = YES;
    }
    [super setBounds:bounds];
}

- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(self.frame, frame) == NO) {
        self.allowCreate = YES;
    }
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(CGRectZero, self.bounds) == NO) {
        if (self.allowCreate == YES || self.isFirst == YES) {
            self.isFirst = NO;
            self.allowCreate = NO;
            [self makeSubItem];
        }
    }
}


#pragma mark - UIControl beginTrack, continueTrack, endTrack 삼종세트
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat dist = [self calculateDistanceFromCenter:touchPoint];
    
    if ( dist < ([self circleRadius] - 70.0f) || dist > ([self circleRadius] + 20.0f)) {
        return NO; // 너무 센터로 붙거나, 멀리 떨어져서 터치가 시작되면 무시한다.
    }
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); // self.center로 구해서는 안된다.
    CGFloat dx = touchPoint.x - center.x;
    CGFloat dy = touchPoint.y - center.y;
    self.angleFromCenterWhenTouchBegan = atan2(dy,dx);
    _transformOfKnobLayerWhenTouchBegin = self.knobBackgroundLayer.transform;
    [self turnOnKonbLight];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat dist = [self calculateDistanceFromCenter:touchPoint];

    if ( dist < ([self circleRadius] - 100.0f) || dist > ([self circleRadius] + 20.0f)) {
        [self endTrackingWithTouch:touch withEvent:event];
        return NO;
    }
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); // self.center로 구해서는 안된다.
    CGFloat dx    = touchPoint.x  - center.x;
    CGFloat dy    = touchPoint.y  - center.y;
    CGFloat angle = atan2(dy,dx); // real Angle.
    
    CGFloat oldAngle = self.standardAngleFromCenterAtCurrnetTime;
    CGFloat newAngle = [self standardAngleFromActualAngle:angle];
    
    if (oldAngle != newAngle) {
        self.standardAngleFromCenterAtCurrnetTime = newAngle;
        CGFloat variationOfAngle = self.standardAngleFromCenterAtCurrnetTime - self.standardAngleFromCenterWhenTouchBegan;
        CATransform3D transform = CATransform3DRotate(self.transformOfKnobLayerWhenTouchBegin, variationOfAngle, 0.0f, 0.0f, 1.0f);
        
        [CATransaction begin];
        [CATransaction setDisableActions:NO]; // NO이다.
        [CATransaction setAnimationDuration:0.15];
        self.knobBackgroundLayer.transform = transform;
        [CATransaction commit];
        
        MGROrangeLampPosition orangeLampPosition = [self orangeLampPositionFromKnobLayerTransform:transform];
        [self.dialGaugeView rotatePositionOfOrangeLampAt:orangeLampPosition];
        
        if (self.normalSoundPlayBlock != nil) {
            self.normalSoundPlayBlock();
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    [self turnOffKonbLight];
}


#pragma mark - 생성 & 소멸
- (void)commonInit {
    self.userInteractionEnabled = YES;
    _allowCreate = NO;
    _isFirst = YES;
    self.circleBackgroundView = [UIView new];
    self.dialGaugeView        = [MGRDialGaugeView new];
    self.knobBackgroundLayer  = [CAShapeLayer layer];
    self.knobLayer            = [CAShapeLayer layer];
    self.circleBackgroundView.userInteractionEnabled = NO;
    self.dialGaugeView.userInteractionEnabled = NO;
    
    [self addSubview:self.circleBackgroundView];
    [self addSubview:self.dialGaugeView];
    [self.layer addSublayer:self.knobBackgroundLayer];
    [self.knobBackgroundLayer addSublayer:self.knobLayer];
    
    [self.circleBackgroundView mgrPinEdgesToSuperviewEdges];
    [self.dialGaugeView mgrPinEdgesToSuperviewEdges];
    
    _knobNormalColor    = [UIColor.blackColor colorWithAlphaComponent:0.15];
    _knobHighlightColor = UIColor.whiteColor;
    
    _mainCircleColor = [UIColor colorWithRed:5.0/255.0 green:30.0/255.0 blue:64.0/255.0 alpha:1.0];
    _secondCircleColor = [UIColor colorWithRed:8.0/255.0 green:48.0/255.0 blue:102.0/255.0 alpha:1.0];
    _thirdCircleColor = [UIColor colorWithRed:12.0/255.0 green:68.0/255.0 blue:146.0/255.0 alpha:1.0];
}

- (void)makeSubItem {
    [self setupCircleBackgroundView];
    [self setupKnobLayer];
    [self.dialGaugeView setupDialGaugeView];
}

- (void)setupCircleBackgroundView {
    CALayer *largeCircleLayer    = [CALayer layer];
    CALayer *smallCircleLayer    = [CALayer layer];
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    CAShapeLayer *maskShapeLayerForsmallCircle = [CAShapeLayer layer]; //! smallCircleGradientLayer의 서브로 붙는다.
    
    largeCircleLayer.contentsScale             = UIScreen.mainScreen.scale;
    smallCircleLayer.contentsScale             = UIScreen.mainScreen.scale;
    maskShapeLayer.contentsScale               = UIScreen.mainScreen.scale;
    maskShapeLayerForsmallCircle.contentsScale = UIScreen.mainScreen.scale;
    
    largeCircleLayer.frame = self.circleBackgroundView.layer.bounds;
    smallCircleLayer.frame = self.circleBackgroundView.layer.bounds;
    maskShapeLayer.frame = self.circleBackgroundView.layer.bounds;
    maskShapeLayerForsmallCircle.frame = smallCircleLayer.bounds;
    
    [self.circleBackgroundView.layer addSublayer:largeCircleLayer];
    [self.circleBackgroundView.layer addSublayer:smallCircleLayer];
    self.circleBackgroundView.layer.mask = maskShapeLayer;
    smallCircleLayer.mask                = maskShapeLayerForsmallCircle;
    
    largeCircleLayer.backgroundColor = self.mainCircleColor.CGColor;
    smallCircleLayer.backgroundColor = self.secondCircleColor.CGColor;
    
    CGRect insetRect  = CGRectInset(self.bounds, 0, 0);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:insetRect];
    maskShapeLayer.path      = circlePath.CGPath;
    maskShapeLayer.fillColor = UIColor.blackColor.CGColor;
    maskShapeLayer.lineWidth = 0.0f;
    
    insetRect  = CGRectInset(self.bounds,
                            self.bounds.size.width /2.0 - ([self secondRadius]),
                            self.bounds.size.width /2.0 - ([self secondRadius]));
    circlePath = [UIBezierPath bezierPathWithOvalInRect:insetRect];
    maskShapeLayerForsmallCircle.path      = circlePath.CGPath;
    maskShapeLayerForsmallCircle.fillColor = UIColor.blackColor.CGColor;
    maskShapeLayerForsmallCircle.lineWidth = 0.0f;
}

- (void)setupKnobLayer {
    self.knobBackgroundLayer.contentsScale = UIScreen.mainScreen.scale;
    self.knobLayer.contentsScale           = UIScreen.mainScreen.scale;
    self.knobBackgroundLayer.frame = self.layer.bounds;
    self.knobLayer.frame           = self.knobBackgroundLayer.bounds;
    
    CGFloat width =  self.layer.bounds.size.width;
    
    CGRect knobRect = {CGPointZero, [self knobStickSize]};
    knobRect = CGRectOffset(knobRect, -([self knobStickSize].width / 2.0f), -([self knobStickSize].height / 2.0f)); // 회전축이 0,0
//    CGRect knobRect = {CGPointZero, CGSizeMake([self knobRadius] * 2.0, [self knobRadius] * 2.0)};
//    knobRect = CGRectOffset(knobRect, -[self knobRadius], -[self knobRadius]); // 회전축이 0,0
    
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobRect
                                                        cornerRadius:(knobRect.size.width / 2.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(width / 2.0, 0.0)];
    [knobPath applyTransform:CGAffineTransformMakeTranslation(0.0, [self distance2])];
    //[knobPath applyTransform:CGAffineTransformMakeTranslation(0.0, (width / 2.0) - [self knobLengthRadius])];
    
    CGRect smallRect = {CGPointZero, CGSizeMake([self forthRadius] * 2.0, [self forthRadius] * 2.0)};
    smallRect = CGRectOffset(smallRect, ([self radius] - [self forthRadius]), ([self radius] - [self forthRadius]));
    UIBezierPath *smallRectPath = [UIBezierPath bezierPathWithOvalInRect:smallRect];
    [knobPath appendPath:smallRectPath];
    
    self.knobLayer.path = knobPath.CGPath;
    self.knobLayer.fillColor = self.knobNormalColor.CGColor;
    self.knobLayer.fillRule = kCAFillRuleNonZero;
    self.knobLayer.lineWidth = 0.0f;
    self.knobLayer.strokeColor = UIColor.clearColor.CGColor;
    
    self.knobLayer.shadowColor   = UIColor.whiteColor.CGColor;
    self.knobLayer.shadowOpacity = 0.0f; // 우선 끈다.
    self.knobLayer.shadowOffset  = CGSizeMake(0.0, 0.0);
    self.knobLayer.shadowRadius  = 3.0; //  디폴트 3.0 블러되는 반경
    
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    maskShapeLayer.contentsScale = UIScreen.mainScreen.scale;
    maskShapeLayer.frame = self.knobBackgroundLayer.bounds;
    self.knobBackgroundLayer.mask = maskShapeLayer;
    CGRect insetRect  = CGRectInset(self.knobBackgroundLayer.bounds,
                                    [self radius] - [self thirdRadius],
                                    [self radius] - [self thirdRadius]);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:insetRect];
    maskShapeLayer.path      = circlePath.CGPath;
    maskShapeLayer.fillColor = UIColor.blackColor.CGColor;
    maskShapeLayer.lineWidth = 0.0f;
    self.knobBackgroundLayer.backgroundColor = [self thirdCircleColor].CGColor;
    self.knobBackgroundLayer.strokeColor = self.mainCircleColor.CGColor;
    self.knobBackgroundLayer.lineWidth = [self thirdCircleBorderWidth] * 2.0;
    self.knobBackgroundLayer.path = circlePath.CGPath;
    self.knobBackgroundLayer.fillColor = UIColor.clearColor.CGColor;
    
    UIGraphicsBeginImageContextWithOptions(self.knobBackgroundLayer.bounds.size, NO, UIScreen.mainScreen.scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(self.knobBackgroundLayer.bounds.size.width / 2.0f, self.knobBackgroundLayer.bounds.size.height / 2.0f);
    CGContextTranslateCTM(currentContext, center.x, center.y); // 좌표 번역
    
    for(int i = 0; i < 12 ; i++) {
        CGFloat theta = i * (2 * M_PI / 12.0);
        if (i == 0) {
            continue;
        }
        CGContextSaveGState(currentContext); // 각각의 컨텍스트 저장
        CGContextRotateCTM(currentContext, theta); // 각각의 컨텍스트 회전
        CGContextTranslateCTM(currentContext, 0.0f, -[self innerGageRadius]); // 각각의 좌표 번역
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound; // 둥글한 선, 정확한 시작선과 끝선에서 선의 굵기의 1/2만큼 반지름으로 양방향으로 원을 만듬
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = self.knobBackgroundLayer.bounds.size.width * 0.006;
        
        CGPoint A = CGPointMake(0.0, -self.knobBackgroundLayer.bounds.size.width * 0.008);
        CGPoint C = CGPointMake(0.0, self.knobBackgroundLayer.bounds.size.width * 0.008);
        [path moveToPoint:A];
        [path addLineToPoint:C];
        [path closePath];
        
        UIColor *strokeColor = [UIColor.blackColor colorWithAlphaComponent:0.15];
        [strokeColor setStroke];
        [path stroke];
        
        CGContextRestoreGState(currentContext);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // 하나의 이미지로 받아오기
    UIGraphicsEndImageContext(); // 이미지 컨텍스트 종류
    self.knobBackgroundLayer.contents = (__bridge id)image.CGImage;
}


#pragma mark - 세터 & 게터

- (void)setAngleFromCenterWhenTouchBegan:(CGFloat)angleFromCenterWhenTouchBegan {
    _angleFromCenterWhenTouchBegan = angleFromCenterWhenTouchBegan;
    self.standardAngleFromCenterWhenTouchBegan = [self standardAngleFromActualAngle:angleFromCenterWhenTouchBegan];
    self.standardAngleFromCenterAtCurrnetTime  = self.standardAngleFromCenterWhenTouchBegan;
}

#pragma mark - 컨트롤

- (void)turnOnKonbLight {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.knobLayer.fillColor = self.knobHighlightColor.CGColor;
    self.knobLayer.shadowOpacity = 1.0f;
    [CATransaction commit];
}

- (void)turnOffKonbLight {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.knobLayer.fillColor = self.knobNormalColor.CGColor;
    self.knobLayer.shadowOpacity = 0.0f;
    [CATransaction commit];
}

- (void)beginningAnimation { // 그냥 쇼
    [self.dialGaugeView beginningAnimation];
}

#pragma mark - Helper

- (CGFloat)radius { // 정사각형 한변의 길이의 반.
    return MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
}

- (CGFloat)secondRadius {
    return [self radius] * 0.85;
}

- (CGFloat)thirdRadius {
    return [self radius] * 0.83;
}

- (CGFloat)forthRadius {
    return [self radius] * 0.23;
}

- (CGFloat)thirdCircleBorderWidth {
    return [self radius] * 0.007;
}

- (CGFloat)innerGageRadius {
    return [self radius] * 0.78;
}

- (CGFloat)distance1 { // 내부의 가장 작은 원의 둘래의 임의의 한점에서 그 원을 포함하는 가장 작은원의 둘레의 점까지의 최소거리. 옴니 그래플 참고
    return [self radius] * 0.3;
}

- (CGFloat)distance2 { // 옴니 그래플 참고
    return [self radius] * 0.47;
}

- (CGSize)knobStickSize {
    return CGSizeMake(0.02 * [self radius], 0.37 * [self radius]);
}

//! FIXME: 삭제 예정.
- (CGFloat)circleRadius { // circleBackgroundView에 그려질 큰원의 반지름.
    return [self radius] * 0.9;
}

- (CGFloat)knobRadius { // 손잡이에 해당하는 작은 원의 반경
    CGFloat radius = [self circleRadius];
    radius = radius / 28.0f;
    return radius;
}

- (CGFloat)knobLengthRadius { // 손잡이에 해당하는 작은 원의 중심과 큰 원의 중심과의 거리.
    CGFloat radius = [self circleRadius];
    radius = radius * 0.85;
    return radius;
}

- (CGFloat)calculateDistanceFromCenter:(CGPoint)point { // 터치하고 있는 손가락과 센터의 거리를 알아내기 위한 메서드이다.
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return hypot(dx, dy);
}

- (CGFloat)standardAngleFromActualAngle:(CGFloat)actualAngle {
    if (((-M_PI * 3.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ( (-M_PI * 3.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (-M_PI * 3.0 / 6.0); // 12시
    } else if (((-M_PI * 2.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((-M_PI * 2.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (-M_PI * 2.0 / 6.0); // 1시
    } else if (((-M_PI * 1.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((-M_PI * 1.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (-M_PI * 1.0 / 6.0); // 2시
    } else if (((+M_PI * 0.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 0.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 0.0 / 6.0); // 3시
    } else if (((+M_PI * 1.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 1.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 1.0 / 6.0); // 4시
    } else if (((+M_PI * 2.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 2.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 2.0 / 6.0); // 5시
    } else if (((+M_PI * 3.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 3.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 3.0 / 6.0); // 6시
    } else if (((+M_PI * 4.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 4.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 4.0 / 6.0); // 7시
    } else if (((+M_PI * 5.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((+M_PI * 5.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (+M_PI * 5.0 / 6.0); // 8시
    } else if ((M_PI - (M_PI / 12.0) <= actualAngle) || (-M_PI + (M_PI / 12.0) > actualAngle)) {
        return (M_PI); // 9시
    } else if (((-M_PI * 5.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((-M_PI * 5.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (-M_PI * 5.0 / 6.0); // 10시
    } else if (((-M_PI * 4.0 / 6.0) - (M_PI / 12.0) <= actualAngle) && ((-M_PI * 4.0 / 6.0) + (M_PI / 12.0) > actualAngle)) {
        return (-M_PI * 4.0 / 6.0); // 11시
    }
    NSAssert(false, @"이 문자열이 출력되어서는 안된다.");
    return 0.0;
}

- (MGROrangeLampPosition)orangeLampPositionFromKnobLayerTransform:(CATransform3D)transform {
    CGFloat theta = atan2(transform.m12, transform.m11);
    CATransform3D rotationZ0   = CATransform3DIdentity;
    if (ABS(theta - atan2(rotationZ0.m12, rotationZ0.m11)) < 0.000001) {
        return MGROrangeLampPosition12; // 12시
    }
    
    CATransform3D rotationZ30  = CATransform3DMakeRotation((30. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ30.m12, rotationZ30.m11)) < 0.000001) {
        return MGROrangeLampPosition1; // 1시
    }
    
    CATransform3D rotationZ60  = CATransform3DMakeRotation((60. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ60.m12, rotationZ60.m11)) < 0.000001) {
        return MGROrangeLampPosition2; // 2시
    }
    
    CATransform3D rotationZ90  = CATransform3DMakeRotation((90. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ90.m12, rotationZ90.m11)) < 0.000001) {
        return MGROrangeLampPosition3; // 3시
    }

    CATransform3D rotationZ120  = CATransform3DMakeRotation((120. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ120.m12, rotationZ120.m11)) < 0.000001) {
        return MGROrangeLampPosition4; // 4시
    }
    
    CATransform3D rotationZ150  = CATransform3DMakeRotation((150. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ150.m12, rotationZ150.m11)) < 0.000001) {
        return MGROrangeLampPosition5; // 5시
    }
    
    CATransform3D rotationZ210  = CATransform3DMakeRotation((210. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ210.m12, rotationZ210.m11)) < 0.000001) {
        return MGROrangeLampPosition7; // 7시
    }
    
    CATransform3D rotationZ240  = CATransform3DMakeRotation((240. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ240.m12, rotationZ240.m11)) < 0.000001) {
        return MGROrangeLampPosition8; // 8시
    }
    
    CATransform3D rotationZ270  = CATransform3DMakeRotation((270. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ270.m12, rotationZ270.m11)) < 0.000001) {
        return MGROrangeLampPosition9; // 9시
    }
    
    CATransform3D rotationZ300  = CATransform3DMakeRotation((300. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ300.m12, rotationZ300.m11)) < 0.000001) {
        return MGROrangeLampPosition10; // 10시
    }
    
    CATransform3D rotationZ330  = CATransform3DMakeRotation((330. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ330.m12, rotationZ330.m11)) < 0.000001) {
        return MGROrangeLampPosition11; // 11시
    }
    
    CATransform3D rotationZ180  = CATransform3DMakeRotation((180. * M_PI / 180), 0.0, 0.0, 1.0);
    if (ABS(theta - atan2(rotationZ180.m12, rotationZ180.m11)) < 0.000001) {
        return MGROrangeLampPosition6; // 6시
    }

    return MGROrangeLampPosition6; // 6시 - M_PI 로 인식할 경우.
    //
    // 아주 미세한 오차가 존재한다. 비순환 무한소수 컴퓨터 오차로 인식된다.
    // 또한 0.0과 -0.0이 인식될 수 있다. 이것은 큰 문제가 되지 않으나, - M_PI, M_PI가 불규칙적으로 인식되므로, 마지막으로 빼서 처리하는 것이 좋다.
}

@end

/*
[m11 m12 m13 m14]
[m21 m22 m23 m24]
[m31 m32 m33 m34]
[m41 m42 m43 m44]
*/

/*
Rotation about the z-axis is represented as:
a  = angle in radians
x' = x*cos.a - y*sin.a
y' = x*sin.a + y*cos.a
z' = z

( cos.a  sin.a  0  0)
(-sin.a  cos.a  0  0)
( 0        0    1  0)
( 0        0    0  1)
 
 a = atan2(transform.m12, transform.m11);
*/

/*
Rotation about the x-axis is represented as:
a  = angle in radians
y' = y*cos.a - z*sin.a
z' = y*sin.a + z*cos.a
x' = x

(1    0      0    0)
(0  cos.a  sin.a  0)
(0 -sin.a  cos.a  0)
(0    0     0     1)
 
*/

/*
Rotation about the y-axis is represented as:
a  = angle in radians
z' = z*cos.a - x*sin.a
x' = z*sin.a + x*cos.a
y' = y

(cos.a  0  -sin.a   0)
(0      1    0      0)
(sin.a  0  cos.a    0)
(0      0    0      1)

*/
