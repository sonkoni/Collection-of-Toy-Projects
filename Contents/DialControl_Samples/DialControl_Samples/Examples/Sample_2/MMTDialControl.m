//
//  MMTDialControl.m
//  DialControl Project
//
//  Created by Kwan Hyun Son on 2021/11/08.
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
@import IosKit;
#import "MMTDialControl.h"
#import "MMTRedView.h"
#import "MMTDialKnobView.h"
#import "MMTGageBackgroundView.h"
#import "MMTGaugeView.h"

@interface MMTDialControl ()
@property (nonatomic, assign) CATransform3D transformOfKnobLayerWhenTouchBegin;
@property (nonatomic, assign) CGFloat angleFromCenterWhenTouchBegan;  // 터치의 시작점과 센터와의 각이다. 레이어의 회전과 무관하며 터치 비긴에서 결정된다.
@property (nonatomic, assign) CGFloat standardAngleFromCenterWhenTouchBegan;  // 터치가 시작되었을 때의 섹션의 중심을 지나는 선의 각.
@property (nonatomic, assign) CGFloat standardAngleFromCenterAtCurrnetTime;

@property (nonatomic, strong) MMTRedView *redView;
@property (nonatomic, strong) MMTDialKnobView *knobView; // 움직일 바늘
@property (nonatomic, strong) MMTGageBackgroundView *gageBackgroundView; // 도넛 모양.
@property (nonatomic, strong) MMTGaugeView *gaugeView; // 라벨과 눈금이 표시된 뷰이다.

@property (nonatomic, assign, readwrite) BOOL full; // 지금 현재 12시 방향으로 바늘이 가르키고 있다면 이것이 한 바퀴 돈 상태라면 YES를 뱉는다.
@property (nonatomic, strong) MGEDisplayLink *displayLink;
@property (nonatomic, assign) BOOL halfOver;
@end

@implementation MMTDialControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

//! border 안 쪽에서만 터치를 먹겠다는 뜻이다.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.superview == nil) {
        return NO;
    }
    
    CGRect rect = [self borderInsideArea];
    if (CGRectContainsPoint(rect, point) == NO) {
        return NO;
    }

    return [super pointInside:point withEvent:event];
}


#pragma mark - UIControl beginTrack, continueTrack, endTrack 삼종세트
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL begins = [super beginTrackingWithTouch:touch withEvent:event];
    if (begins == YES) {
        CGPoint touchPoint = [touch locationInView:self];
        CGFloat dist = [self calculateDistanceFromCenter:touchPoint];
        
        if ( dist < [self minTouchRadius] ||
            dist > [self maxTouchRadius]) {
            return NO; // 너무 센터로 붙거나, 멀리 떨어져서 터치가 시작되면 무시한다.
        }
        
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); // self.center로 구해서는 안된다.
        CGFloat dx = touchPoint.x - center.x;
        CGFloat dy = touchPoint.y - center.y;
        self.angleFromCenterWhenTouchBegan = atan2(dy,dx);
        _transformOfKnobLayerWhenTouchBegin = self.knobView.layer.transform;
    }
    return begins;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat dist = [self calculateDistanceFromCenter:touchPoint];
    if (CGRectContainsPoint(self.bounds, touchPoint) == NO || dist < [self minTouchRadius]) {
        [self endTrackingWithTouch:touch withEvent:event];
        return NO;
    }
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)); // self.center로 구해서는 안된다.
    CGFloat dx    = touchPoint.x  - center.x;
    CGFloat dy    = touchPoint.y  - center.y;
    CGFloat angle = atan2(dy,dx); // real Angle.
    
    //! 손가락에 대한 동쪽을 기준으로한 스탠다드 앵글을 의미한다.
    CGFloat oldAngle = self.standardAngleFromCenterAtCurrnetTime;
    CGFloat newAngle = [self standardAngleFromActualAngle:angle];
    
    if (oldAngle != newAngle) {
        self.standardAngleFromCenterAtCurrnetTime = newAngle;
        CATransform3D newTransform = CATransform3DRotate(self.transformOfKnobLayerWhenTouchBegin,
                                                         newAngle - self.standardAngleFromCenterWhenTouchBegan,
                                                         0.0, 0.0, 1.0);
        CATransform3D oldTransform = CATransform3DRotate(self.transformOfKnobLayerWhenTouchBegin,
                                                         oldAngle - self.standardAngleFromCenterWhenTouchBegan,
                                                         0.0, 0.0, 1.0);
        
        //! newAngle oldAngle 과는 다르다. newRadian oldRadian은 게이지 뷰 및 레드 뷰가 얼마만큼 회전했는지를 의미한다.
        //! newAngle oldAngle 은 동쪽으로 부터의 손가락 각을 의미한다.
        CGFloat oldRadian = MGETransform3DGetZRotationAngle(oldTransform);
        CGFloat newRadian = MGETransform3DGetZRotationAngle(newTransform);
        BOOL testBool = [self possibleTestWithOldRadian:oldRadian newRadian:newRadian];
        
        if (testBool == NO) {  // 불가능한 것을 제시했다.
            self.angleFromCenterWhenTouchBegan = angle; // 현재의 리얼 앵글.(no standard)
            _transformOfKnobLayerWhenTouchBegin = CATransform3DIdentity;
            newTransform = CATransform3DIdentity;
            newRadian = 0.0; // newRadian = MGRTransform3DGetZRotationAngle(newTransform);
            if (ABS(oldRadian - 0.0) < FLT_EPSILON) { // 기존 방향이 이미 12이다. 그럼 옮기지말고 설정만 초기화하자.
                return YES; //! 애니메이션 없이 흘리는 경우이다.
            } else { // 이 때에는 12 시 방향으로 옮겨야한다. 통과한 것이다. 12시 까지는 땡겨줘야한다.
                // 사실 둘다 동일하다. 따라서 의미가 없다.
//                newTransform = CATransform3DIdentity; oldRadian < 0.0, A 사 분면에서 12 시로 이동한다.
//                newTransform = CATransform3DRotate(CATransform3DIdentity, M_PI * 2.0, 0.0, 0.0, 1.0);  oldRadian >= 0.0 B 사 분면에서 12 시로 이동한다.
            }
        }
        
        CGFloat redViewEndRadian;
        /** 디스플레이 링크를 써서 이 상황을 해결할 때, 사용한다.
        BOOL previosuFull = _full;
        */
        if (ABS(newRadian - 0.0) < FLT_EPSILON &&
            oldRadian > 0.0) { // 12 시 방향으로 이동하는데, 반 시계방향으로 움직이는 것이라면 이것은 full 이다.
            _full = YES;
            redViewEndRadian = M_PI * 2.0;
        } else {
            _full = NO;
            if (ABS(newRadian - 0.0) < FLT_EPSILON) {
                redViewEndRadian = 0.0;
            } else if (newRadian < 0.0) {
                redViewEndRadian = - newRadian;
            } else {
                redViewEndRadian = (M_PI * 2.0) - newRadian;
            }
        }
        
        CGFloat duration = 0.05;
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        self.redView.maskLayer.endRadian = redViewEndRadian;
        [CATransaction commit];
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveLinear
                                                         animations:^{ self.knobView.transform3D = newTransform; }
                                                         completion:^(UIViewAnimatingPosition finalPosition) {}];
        
        if (self.normalSoundPlayBlock != nil) {
            self.normalSoundPlayBlock();
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    [super endTrackingWithTouch:touch withEvent:event];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self endTrackingWithTouch:nil withEvent:event];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MMTDialControl *self) {
    self->_full = NO;
    self->_redView = [MMTRedView new];
    self.redView.maskLayer.endRadian = 0.0;
    [self addSubview:self.redView];
    [self.redView mgrPinEdgesToSuperviewEdges];
    
    self->_knobView = [MMTDialKnobView new];
    [self addSubview:self.knobView];
    [self.knobView mgrPinEdgesToSuperviewEdges];
    
    self->_gageBackgroundView = [MMTGageBackgroundView new];
    [self addSubview:self.gageBackgroundView];
    [self.gageBackgroundView mgrPinEdgesToSuperviewEdges];
    
    self->_gaugeView = [MMTGaugeView new];
    [self addSubview:self.gaugeView];
    [self.gaugeView mgrPinEdgesToSuperviewEdges];
    self->_displayLink = [MGEDisplayLink displayLinkWithDuration:0.10
                                              easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                   progressBlock:nil
                                                 completionBlock:nil];
    self->_halfOver = NO;
}


#pragma mark - 세터 & 게터
- (void)setAngleFromCenterWhenTouchBegan:(CGFloat)angleFromCenterWhenTouchBegan {
    _angleFromCenterWhenTouchBegan = angleFromCenterWhenTouchBegan;
    self.standardAngleFromCenterWhenTouchBegan = [self standardAngleFromActualAngle:angleFromCenterWhenTouchBegan];
    self.standardAngleFromCenterAtCurrnetTime  = self.standardAngleFromCenterWhenTouchBegan;
}


#pragma mark - Helper
- (CGFloat)calculateDistanceFromCenter:(CGPoint)point { // 터치하고 있는 손가락과 센터의 거리를 알아내기 위한 메서드이다.
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return hypot(dx, dy);
}

- (CGFloat)maxTouchRadius {
    CGFloat standardLength = self.bounds.size.width;
    CGFloat diameter = standardLength * (328.0/375.0); // 도넛의 가장 큰 가장자리.
    return diameter / 2.0;
}

- (CGFloat)minTouchRadius {
    CGFloat standardLength = self.bounds.size.width;
    CGFloat diameter = standardLength * (63.0/375.0); // 중앙의 버튼에 대한 지름.
    return diameter / 2.0;
}

//! 시계방향으로 채운다.
- (CGFloat)standardAngleFromActualAngle:(CGFloat)actualAngle {
    CGFloat interval = (M_PI * 2.0) / 60.0;
    CGFloat halfInterval = interval / 2.0;
    
    //! 12시 <= ~~ < 3시 // 총 15개.
    for (NSInteger i = 0; i < 15; i++) {
        if ( (-M_PI_2 - halfInterval + (interval * i) <= actualAngle) &&
             (-M_PI_2 + halfInterval + (interval * i) > actualAngle) ) {
            return -M_PI_2 + (interval * i);
        }
    }
    
    //! 3시 <= ~~ < 9시 // 총 30개.
    for (NSInteger i = 0; i < 30; i++) {
        if ( (- halfInterval + (interval * i) <= actualAngle) &&
             (+ halfInterval + (interval * i) > actualAngle) ) {
            return interval * i;
        }
    }
    
    // 9시 1개. 음수와 양수가 양존하므로 따로 처리해야한다.
    if ( (M_PI - halfInterval <= actualAngle) ||
         (-M_PI + halfInterval > actualAngle)) {
        return M_PI; // 9시
    }
    //! 9시 < ~~ < 12시. 14 개.
    for (NSInteger i = 1; i < 15; i++) { // 1부터 시작한다.
        if ( (-M_PI - halfInterval + (interval * i) <= actualAngle) &&
             (-M_PI + halfInterval + (interval * i) > actualAngle) ) {
            return -M_PI + (interval * i);
        }
    }
    
    NSCAssert(FALSE, @"이 문자열이 출력되어서는 안된다.");
    return 0.0;
}

- (CGRect)borderInsideArea {
    CGRect rect = self.bounds;
    CGFloat standardLength = rect.size.width;
    CGFloat longBoarderWidth = standardLength * (37.0 / 750.0);
    return CGRectInset(rect, longBoarderWidth, longBoarderWidth);
}

//! Pan 에서 사용한다. 변화가 감지되었을 경우에만 호출된다. 이 변화(oldRadian과 newRadian 차이)는 충분히 큰 변화이므로 입실론 오차가 발생하지 않는다.
- (BOOL)possibleTestWithOldRadian:(CGFloat)oldRadian newRadian:(CGFloat)newRadian {
    if (newRadian >= M_PI_2 && newRadian <= M_PI) {
        _halfOver = YES;
    } else if (newRadian <= -M_PI_2 && newRadian > -M_PI) {
        _halfOver = NO;
    }
        
    //! 오차 때문에 반드시 이걸 먼저 사용해야한다.
    if (ABS(newRadian - 0.0) < FLT_EPSILON) { // 새로운 방향이 12 시이다. 언제나 허용이다.
        return YES;
    } else if (ABS(oldRadian - 0.0) < FLT_EPSILON) { // 기존 방향이 12 시 일 경우.
        if (_full == NO) { // 이 12시 방향은 한 바퀴를 돌지 않은 디폴트 상태이다.
            if (newRadian > 0.0) { // 불가능한 전개이다.
                return NO; // 디폴트 12시 상태에서 백으로 가는 경우이다.
            }
        } else { // 기존 방향이 12시 방향인데 한 바퀴 풀로 돈 상태이다.
            if (newRadian < 0.0) { // 불가능한 전개이다.
                return NO; // 한 바퀴 돌고 더 전진하는 상태이다.
            }
        }
    } else { // 기존 방향과 새로운 방향이 모두 12시 를 가리키는 경우가 아닐 때.
        if (newRadian * oldRadian < 0.0 &&
            ABS(newRadian) < M_PI_2 &&
            ABS(oldRadian) < M_PI_2) { // A -> B 또는 B -> A 의 경우를 의미한다.
            return NO; //! 이 때가 중요하다. 불가능하다고 하더라도 12 시 방향까지는 움직여줘야한다.
        }
    }
    return YES;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
