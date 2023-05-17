//
//  CRFlatSwitch.m
//  MGUFlatSwitch
//
//  Created by Kwan Hyun Son on 24/07/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGUFlatSwitch.h"

// 일반적인 자료형에서는 const int num과 int const num이 완벽하게 동일하다.
static const CGFloat finalStrokeStartForCheckmark = 0.30f;
static const CGFloat finalStrokeEndForCheckmark   = 0.85f;
static const CGFloat checkmarkBounceAmount        = 0.10f;

static void basicSettingForCAAnimation(CAAnimation * animation);

@interface MGUFlatSwitch () <CAAnimationDelegate>
@property (nonatomic)  CAShapeLayer *baseCircleLayer;
@property (nonatomic)  CAShapeLayer *checkMarkCircleLayer;
@property (nonatomic)  CAShapeLayer *checkMarkLayer;
@property (nonatomic)  CGPoint checkMarkMidPoint;
@property (nonatomic)  BOOL selected_internal;
@end

@implementation MGUFlatSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

// UIView override 메서드, <CALayerDelegate> 프로토콜 메서드로 UIView와 MTKView 가 따르는 프로토콜
// 스위치는 그려야하므로 크기가 변할 때마 갱신해야한다.
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    if ([layer isEqual:self.layer]) {
        CGPoint offset = CGPointZero;
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
        offset.x = (self.bounds.size.width  / 2.0) - radius;
        offset.y = (self.bounds.size.height / 2.0) - radius;
        
        // 좌 상방에서 시작하여 한바퀴 도는 원이이다.
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
                        radius:radius
                    startAngle:(CGFloat)(212 * M_PI / 180.0)
                      endAngle:M_PI * 2.0 + (CGFloat)(212 * M_PI / 180.0)
                     clockwise:YES];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        //------------------------------------------------
        self.baseCircleLayer.frame      = self.bounds;
        self.baseCircleLayer.path       = path.CGPath;
        
        //------------------------------------------------
        self.checkMarkCircleLayer.frame = self.bounds;
        self.checkMarkCircleLayer.path  = path.CGPath;

        //------------------------------------------------
        self.checkMarkLayer.frame = self.bounds;
        CGPoint circleCenterPoint = CGPointMake(offset.x + radius, offset.y + radius);
        CGPoint checkStartPoint   = CGPointZero; // 단순 메모리 확보.
        checkStartPoint.x         = circleCenterPoint.x + radius * cos(212 * M_PI / 180.0); // <- 좌상방의 원과 만나는 점
        checkStartPoint.y         = circleCenterPoint.y + radius * sin(212 * M_PI / 180.0); // <- 좌상방의 원과 만나는 점
        
        UIBezierPath *checkmarkPath = [UIBezierPath bezierPath];
        [checkmarkPath moveToPoint:checkStartPoint];
        
        self.checkMarkMidPoint = CGPointMake(offset.x + radius * 0.9, offset.y + radius * 1.4);
        [checkmarkPath addLineToPoint:self.checkMarkMidPoint];
        
        CGPoint checkEndPoint = CGPointZero;
        checkEndPoint.x = circleCenterPoint.x + radius * cos(320 * M_PI / 180.0);
        checkEndPoint.y = circleCenterPoint.y + radius * sin(320 * M_PI / 180.0);
        [checkmarkPath addLineToPoint:checkEndPoint];
        
        // 실제 선은 원과 닿아있다. setSelected:animated: 에서 적당히 그린다.
        self.checkMarkLayer.path = checkmarkPath.CGPath;
        
        [CATransaction commit];
    }
}

// UIControl override
- (BOOL)isSelected {
    return self.selected_internal;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    // private 내가 만든 컨트롤 메서드
    [self setSelected:selected animated:NO];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.baseCircleLayer.strokeColor      = self.baseCircleStrokeColor.CGColor;
            self.checkMarkCircleLayer.strokeColor = self.checkMarkNCircleStrokeColor.CGColor;
            self.checkMarkLayer.strokeColor       = self.checkMarkNCircleStrokeColor.CGColor;
            [self setSelected:_selected_internal animated:NO];
        }];
    }
}


#pragma mark - 생성 소멸 메서드
- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    self.baseCircleLayer             = [CAShapeLayer layer]; // <- 기본 레이어 바로 위에
    self.checkMarkCircleLayer        = [CAShapeLayer layer]; // <- 그 위에
    self.checkMarkLayer              = [CAShapeLayer layer]; // <- 그 위에
    
    self.baseCircleStrokeColor       = [UIColor.blackColor colorWithAlphaComponent:0.5];
    self.checkMarkNCircleStrokeColor = [UIColor blackColor];
    
    self.checkMarkMidPoint = CGPointZero;
    
    _lineWidth = 2.0;
    self.animationDuration           = 0.3;
    self.selected_internal           = NO;
    
    [self configureShapeLayer:self.baseCircleLayer];
    [self configureShapeLayer:self.checkMarkCircleLayer];
    [self configureShapeLayer:self.checkMarkLayer];
    
    self.baseCircleLayer.strokeColor      = self.baseCircleStrokeColor.CGColor;
    self.checkMarkCircleLayer.strokeColor = self.checkMarkNCircleStrokeColor.CGColor;
    self.checkMarkLayer.strokeColor       = self.checkMarkNCircleStrokeColor.CGColor;
    
    [self setSelected:NO animated:NO];
    [self addTarget:self action:@selector(didTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)configureShapeLayer: (CAShapeLayer *)shapeLayer {
    shapeLayer.lineJoin  = kCALineJoinRound;
    shapeLayer.lineCap   = kCALineCapRound;
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:shapeLayer];
}


#pragma mark - 세터 게터 메서드
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.baseCircleLayer.lineWidth      = lineWidth;
    self.checkMarkCircleLayer.lineWidth = lineWidth;
    self.checkMarkLayer.lineWidth       = lineWidth;
}

- (void)setBaseCircleStrokeColor:(UIColor *)baseCircleStrokeColor {
    _baseCircleStrokeColor = baseCircleStrokeColor;
    self.baseCircleLayer.strokeColor = baseCircleStrokeColor.CGColor;
}

- (void)setCheckMarkNCircleStrokeColor:(UIColor *)checkMarkNCircleStrokeColor {
    _checkMarkNCircleStrokeColor = checkMarkNCircleStrokeColor;
    self.checkMarkCircleLayer.strokeColor = checkMarkNCircleStrokeColor.CGColor;
    self.checkMarkLayer.strokeColor       = checkMarkNCircleStrokeColor.CGColor;
}


#pragma mark - 컨트롤 메서드
- (void)didTouchUpInside:(id)sender {
    [self setSelected:!self.selected animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

//! 내가 만든 컨트롤 메서드이면서, private이다.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.selected_internal = selected;
    [self.checkMarkLayer       removeAllAnimations];
    [self.baseCircleLayer      removeAllAnimations];
    [self.checkMarkCircleLayer removeAllAnimations];
    
    [self resetValues:animated];
    
    if (animated == YES) {
        [self addAnimationsForSelected:self.selected_internal];
    }
}


#pragma mark - 지원 메서드(only Private)
//! 내가 만든 컨트롤 메서드인 - setSelected:animated: 에서만 호출되는 지원 메서드이다.
- (void)resetValues:(BOOL)animated{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    //! 이곳의 핵심논리는 헷갈릴 수 있다. 본 메서드는 - setSelected:animated:에서만 호출되며
    //! 만약 animated가 NO 라면, - addAnimationsForSelected: 메서드가 호출되지 않으므로 여기서 모든 설정이 이루어져야한다.
    //! 그러나, animated가 YES 라면, 여기에서는 실제로 원하는 설정의 반대가 설정이되고, 실제의 원하는 설정은
    //! - addAnimationsForSelected: 에서 처리되어야한다.
    if (((self.selected_internal == NO) && (animated == NO)) || ((self.selected_internal == YES) && (animated == YES))) {
        //! 따라서 이 내부(if 문)은 v 표시가 없는 상태를 의미한다.
        self.baseCircleLayer.opacity          = 0.0;
        
        self.checkMarkCircleLayer.strokeStart = 0.0;
        self.checkMarkCircleLayer.strokeEnd   = 1.0;
        
        self.checkMarkLayer.strokeEnd         = 0.0;
        self.checkMarkLayer.strokeStart       = 0.0;
    } else {
        self.baseCircleLayer.opacity          = 1.0;
        
        self.checkMarkCircleLayer.strokeStart = 0.0;
        self.checkMarkCircleLayer.strokeEnd   = 0.0;
        
        self.checkMarkLayer.strokeEnd         = finalStrokeEndForCheckmark;
        self.checkMarkLayer.strokeStart       = finalStrokeStartForCheckmark;
    }
    [CATransaction commit];
}

//! 내가 만든 컨트롤 메서드인 - setSelected:animated: 에서만 호출되는 지원 메서드이다.
//! 게다가 두 번째 인수가 YES일때만 호출된다.
- (void)addAnimationsForSelected:(BOOL)selected {
    CAKeyframeAnimation *checkmarkStrokeEnd = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    checkmarkStrokeEnd.duration = self.animationDuration;
    basicSettingForCAAnimation(checkmarkStrokeEnd);
    
    /// Api:Core Animation/CAAnimationCalculationMode/kCAAnimationPaced 참고
    /// 키프레임 애니메이션에서 calculationMode가 kCAAnimationPaced이면,
    /// keyTimes(CAKeyframeAnimation 프라퍼티) 과 timingFunction(CAAnimation 프라퍼티) 이 무시된다.
    checkmarkStrokeEnd.calculationMode = kCAAnimationPaced;

    if (selected == YES) {
        checkmarkStrokeEnd.values = @[@(0.0f), @(finalStrokeEndForCheckmark + checkmarkBounceAmount), @(finalStrokeEndForCheckmark)];
    } else {
        checkmarkStrokeEnd.values = @[@(finalStrokeEndForCheckmark), @(finalStrokeEndForCheckmark + checkmarkBounceAmount), @(-0.1f)];
    }
    
    CAKeyframeAnimation *checkmarkStrokeStart = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    checkmarkStrokeStart.duration            = self.animationDuration * 0.5; // <- startStorke point의 duration은 언제나 0.5이다.
    basicSettingForCAAnimation(checkmarkStrokeStart);
    checkmarkStrokeStart.calculationMode     = kCAAnimationPaced;
    
    if (selected == YES) {
        checkmarkStrokeStart.values = @[@(0.0f), @(finalStrokeStartForCheckmark + checkmarkBounceAmount), @(finalStrokeStartForCheckmark)];
    } else {
        checkmarkStrokeStart.values = @[@(finalStrokeStartForCheckmark), @(finalStrokeStartForCheckmark + checkmarkBounceAmount), @(0.0f)];
    }
    
    if (selected == YES) {
        checkmarkStrokeStart.beginTime = self.animationDuration * 0.5;
    }
    
    CAAnimationGroup *checkmarkAnimationGroup   = [CAAnimationGroup animation];
    checkmarkAnimationGroup.duration       = self.animationDuration;
    basicSettingForCAAnimation(checkmarkAnimationGroup);
    checkmarkAnimationGroup.animations     = @[checkmarkStrokeEnd, checkmarkStrokeStart];
    [self.checkMarkLayer addAnimation:checkmarkAnimationGroup forKey:@"CheckmarkAnimationAnimation"];
    
    /************************************************************/
    CABasicAnimation *circleStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (selected == YES) { // 이때가 사라지는 애니메이션, v 가 나타나는 애니메이션에서 나타남
        circleStrokeEnd.fromValue = @(1.0f);
        circleStrokeEnd.toValue   = @(-0.1f);
    } else { // 이때가 나타나는 애니메이션, v 가 지워지는 애니메이션에서 나타남. v의 시작점이 도착할 때, 그리기 시작해야한다.
        circleStrokeEnd.beginTime = CACurrentMediaTime() + (self.animationDuration * 0.5); // 그룹 애니메이션이 아닐때, 딜레이를 주려면 이렇게 해야한다.
        circleStrokeEnd.fromValue = @(0.0f);
        circleStrokeEnd.toValue   = @(1.0f);
    }
    circleStrokeEnd.duration = self.animationDuration * 0.5;
    basicSettingForCAAnimation(circleStrokeEnd);
    [self.checkMarkCircleLayer addAnimation:circleStrokeEnd forKey:@"CircleStrokeEndAnimation"];
    
    /************************************************************/
    CABasicAnimation *trailCircleColor = [CABasicAnimation animationWithKeyPath:@"opacity"];
    if (selected == YES) {
        trailCircleColor.fromValue = @(0.0f);
        trailCircleColor.toValue   = @(1.0f);
    } else {
        trailCircleColor.fromValue = @(1.0f);
        trailCircleColor.toValue   = @(0.0f);
    }
    trailCircleColor.duration = self.animationDuration;
    basicSettingForCAAnimation(trailCircleColor);
    trailCircleColor.delegate = self; // duration 전반에 걸쳐 작동하므로 이녀석이 하는게 맞다.
    [trailCircleColor setValue:@"TrailCircleColorAnimationKey" forKey:@"HandlerKey"];
    [self.baseCircleLayer addAnimation:trailCircleColor forKey:@"TrailCircleColorAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


#pragma mark - 델리게이트 메서드 <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"HandlerKey"] isEqualToString:@"TrailCircleColorAnimationKey"]) {
        if (_selected_internal == YES && self.didSelectAnimationCompletionHandler != nil) {
            self.didSelectAnimationCompletionHandler();
        } else if (self.didUnselectAnimationCompletionHandler != nil) {
            self.didUnselectAnimationCompletionHandler();
        }
    }
}

@end

static void basicSettingForCAAnimation(CAAnimation * animation) {
    animation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode            = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}
