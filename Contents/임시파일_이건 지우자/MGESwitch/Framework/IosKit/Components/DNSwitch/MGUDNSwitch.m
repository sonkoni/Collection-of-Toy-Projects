//
//  MGUDNSwitch.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUDNSwitch.h"
#import "MGUDNKnobView.h"
#import <BaseKit/BaseKit.h>
#import "UIFeedbackGenerator+Extension.h"

@interface MGUDNSwitch ()
@property (nonatomic) MGUDNKnobView *knobView; // 손잡이에 해당하는 동그란 뷰이다.

//! 터치가 시작된 후 움직임이 있느냐 없느냐(ON -> OFF or OFF -> ON)를 판단한다. 움직임이 없다면, 단순 탭으로 인식한다.
//! moved가 없다면(움직이 없다면 = 탭으로 인식하면) 기존 위치에서 반대 방향으로 이동한다.
@property (nonatomic) BOOL moved;
@property (nonatomic, assign) BOOL startSwitchState;        // 터치가 시작될 때, 스위치의 ON OFF 상태
@property (nonatomic, assign, readonly) CGFloat borderWidth; // @dynamic

//! Dark Jungle Green 칼라 검은색에 가까움.
//! 보더의 색을 위해 존재한다. <- OFF 상태 일때.
//! onBorder 레이어는 self.layer 바로 위에 서브로 있고,
//! offBorder는 onBorder 위에 있다. 물론 offBorder도 self.layer의 서브이다.
@property (nonatomic, nonnull) CAShapeLayer *offBorderLayer; // <- 보더를 위해 존재한다.

//! Half Baked 칼라. 하늘색(라이트 블루정도의 색) 비슷함.
//! 보더의 색을 위해 존재한다. <- ON 상태 일때.
//! onBorder 레이어는 self.layer 바로 위에 서브로 있고,
//! offBorder는 onBorder 위에 있다. 물론 offBorder도 self.layer의 서브이다.
@property (nonatomic, nonnull) CAShapeLayer *onBorderLayer; // <- 보더를 위해 존재한다.
@property (nonatomic, nullable) NSArray<UIView *> *stars; // OFF 상태에서 작은 흰색 점(별 - UIView)들을 배열로 표현할 것이다.
@property (nonatomic, nonnull) UIImageView *cloudImageView; // Cloud image visible on top of the on state knob
@property (nonatomic, assign) CGRect previousFrame;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@end

@implementation MGUDNSwitch
@dynamic borderWidth;

//! 터치가 시작되면, 계속 누르고 있던, 바로 때던 이 메서드가 쳐지고,
//! flag를 설정한다. self의 drag 프라퍼티를 YES로 설정하고 knobView의 expanded 프라퍼티를 YES로 설정한다.
//! knobView의 expanded 프라퍼티는 key - value - observing에 의하여 옵저빙 메서드를 발동 시킨다.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.knobView.expand = YES; // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
    self.startSwitchState = self.switchOn;
    self.moved = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    CGFloat x = [(UITouch *)touches.allObjects.lastObject locationInView:self].x;
    
    if ( (x > self.frame.size.width / 2) && (self.switchOn == NO) ) {          // off 상태인데 on  상태 영역을 넘어갔다면
        self.switchOn = YES;
        self.moved = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
        [self impactOccurred];
    } else if ( (x < self.frame.size.width / 2) && (self.switchOn == YES) ) {  // on  상태인데 off 상태 영역을 넘어갔다면
        self.switchOn = NO;
        self.moved = YES; // <- 터치가 시작되고 처음 state에서 움직였는지 체크한다.
        [self impactOccurred];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //! 짧게 탭했을 경우(즉, 무빙이 인식되지 않았을 경우, 단순히 on, off 상태만 변화 시킨다.)
    //! 그래도, on, off 상태의 변화는 애니메이션의 연쇠를 부른다.
    //! 이 if 문이 실행된다는 것은 탭으로 인식한다는 것이다. 즉, 현재 위치에서 상대 위치로 무조건 옮긴다.
    //! 즉, 한번이라도 무빙이 인식되면 실행되지 않는다.
    if (self.moved == NO) {
        self.switchOn = !self.switchOn;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self impactOccurred];
    } else if (self.switchOn != self.startSwitchState) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    self.knobView.expand   = NO; // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
    self.moved             = NO; // <- 다시 재설정한다.
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = 30.0;
    CGFloat width  = height * 1.75;
    return CGSizeMake(ceil(width), ceil(height));
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(CGRectZero, self.bounds) == NO &&
        CGRectEqualToRect(_previousFrame, self.bounds) == NO) {
        _previousFrame = self.bounds;
        CommonInit(self);
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame
                     switchOn:(BOOL)switchOn
                configuration:(MGUDNSwitchConfiguration *)configuration {
    self = [super initWithFrame:frame];
    if (self) {
        _switchOn = switchOn;
        _configuration = (configuration != nil) ? configuration : [MGUDNSwitchConfiguration defaultConfiguration];
        _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleLight];
        _previousFrame = frame;
        if (CGRectEqualToRect(_previousFrame, CGRectZero) == NO) {
            CommonInit(self);
        }
    }
    return self;
}

- (instancetype)initWithCenter:(CGPoint)center
                      switchOn:(BOOL)switchOn
                 configuration:(MGUDNSwitchConfiguration *)configuration  {
    CGFloat height = 30.0;
    CGFloat width  = height * 1.75;
    CGRect defaultRectFrame = CGRectMake(center.x - (width  / 2.0),
                                         center.y - (height / 2.0),
                                         width,
                                         height);
    self = [self initWithFrame:defaultRectFrame switchOn:switchOn configuration:configuration];
    return self;
}

static void CommonInit(MGUDNSwitch *self) {
    for (UIView  *view  in [self.subviews reverseObjectEnumerator]) { [view removeFromSuperview]; }
    for (CALayer *layer in [self.layer.sublayers reverseObjectEnumerator]) { [layer removeFromSuperlayer]; }
    
    if (self.switchOn == YES) {
        self.backgroundColor = self.configuration.onTintColor;
    } else {
        self.backgroundColor = self.configuration.offTintColor;
    }
    
    // 보더를 딱 테두리에 맞게 그리고, 굵기를 줬을 때, 테두리 밖을 자르는 효과가 생길 것이다.
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = self.frame.size.height / 2.0;
    [self setupBorderLayers];
    [self setupStarViews];
    [self setupKnob];
    [self setupCloud];
}

- (void)setupBorderLayers {
    _onBorderLayer  = [CAShapeLayer layer];
    _offBorderLayer = [CAShapeLayer layer];
    self.onBorderLayer.contentsScale = [UIScreen mainScreen].scale;
    self.offBorderLayer.contentsScale = [UIScreen mainScreen].scale;
    self.onBorderLayer.path = [self pathForRightStartRoundRect:self.frame].CGPath; // <- 애니메이션을 안주므로 아무거나 넣어도 된다.
    self.onBorderLayer.fillColor   = [UIColor clearColor].CGColor;
    self.onBorderLayer.strokeColor = self.configuration.onBorderColor.CGColor;
    self.onBorderLayer.lineWidth   = self.borderWidth;
    self.offBorderLayer.fillColor   = [UIColor clearColor].CGColor;
    self.offBorderLayer.strokeColor = self.configuration.offBorderColor.CGColor;
    self.offBorderLayer.lineWidth   = self.borderWidth;
    if (self.switchOn == YES) {
        self.offBorderLayer.strokeStart = 1.0;
        self.offBorderLayer.path = [self pathForRightStartRoundRect:self.frame].CGPath;
    } else {
        self.offBorderLayer.path = [self pathForLeftStartRoundRect:self.frame].CGPath;
    }
    
    [self.layer addSublayer:self.onBorderLayer];
    [self.layer addSublayer:self.offBorderLayer];
}

- (void)setupStarViews { // 7개의 별을 나타낼 수 있게, 아주 작은 하얀색 뷰들을 다른 위치와 약간 다른 사이즈로 생성한다.
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat x = h * 0.05; // 높이의 5%
    UIView *s1 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.50, h * 0.16, x,       x)];
    UIView *s2 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.62, h * 0.33, x * 0.6, x * 0.6)];
    UIView *s3 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.70, h * 0.15, x,       x)];
    UIView *s4 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.83, h * 0.39, x * 1.4, x * 1.4)];
    UIView *s5 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.70, h * 0.54, x * 0.8, x * 0.8)];
    UIView *s6 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.52, h * 0.73, x * 1.3, x * 1.3)];
    UIView *s7 = [[UIView alloc] initWithFrame: CGRectMake(w * 0.82, h * 0.66, x * 1.1, x * 1.1)];
    self.stars = @[s1, s2, s3, s4, s5, s6, s7];
    for (UIView *star in self.stars) {
        star.layer.masksToBounds = YES;
        star.layer.cornerRadius  = star.frame.size.height / 2.0;
        star.backgroundColor     = [UIColor whiteColor];
        if (self.switchOn == YES) {
            star.alpha = 0.0;
        }
        [self addSubview:star];
    }
}

- (void)setupKnob {
    CGFloat w           = self.frame.size.height - [self knobViewMargin] * 2;
    CGRect offRectFrame = CGRectMake([self knobViewMargin], [self knobViewMargin], w, w);
    CGRect onRectFrame  = CGRectMake(self.frame.size.width - w - [self knobViewMargin], [self knobViewMargin], w, w);
    if (self.switchOn == YES) {
        self.knobView = [[MGUDNKnobView alloc] initWithFrame:onRectFrame switchOn:YES delegate:self];
    } else {
        self.knobView = [[MGUDNKnobView alloc] initWithFrame:offRectFrame switchOn:NO delegate:self];
    }
    
    [self addSubview:self.knobView];
}

- (void)setupCloud {
    self.cloudImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.0,
                                                      self.frame.size.height * 0.4,
                                                      self.frame.size.width / 3.0,
                                                      self.frame.size.width * 0.23)];
    self.cloudImageView.image = [UIImage imageNamed:@"MGUDNSwitchCloud"
                                           inBundle:[NSBundle mgrIosRes]
                                  withConfiguration:nil];
    if (self.switchOn == NO) {
        self.cloudImageView.transform = CGAffineTransformMakeScale(0, 0); //! 최초가 OFF 상태이면 안보이게 하기 위해서
    }
    [self addSubview:self.cloudImageView];
}


#pragma mark - 세터 & 게터
- (void)setSwitchOn:(BOOL)switchOn {
    if ( _switchOn != switchOn ) {
        _switchOn = switchOn;
        [self moveSwitchToOn:switchOn];
    }
}

- (CGFloat)borderWidth {
    return self.frame.size.height / 7.0;
}


#pragma mark - 컨트롤
- (void)setSwitchOn:(BOOL)switchOn withAnimated:(BOOL)animated {
    if (animated == YES) {
        [self setSwitchOn:switchOn];
    } else if (self.switchOn != switchOn){
        _switchOn = switchOn;
        CommonInit(self);
    }
}

//! - setSwitchOn: 에서만 호출된다.
- (void)moveSwitchToOn:(BOOL)switchOn {
    self.knobView.on = switchOn; // 메서드를 호출할 것이다.
    
    void (^animationsBlock)(void) = ^{
        CGFloat knobRadius = self.knobView.frame.size.width / 2;
        
        if (switchOn == YES) {
            self.knobView.center = CGPointMake(self.frame.size.width - knobRadius - [self knobViewMargin], self.knobView.center.y);
            self.backgroundColor = self.configuration.onTintColor;
        } else {
            self.knobView.center = CGPointMake(knobRadius + [self knobViewMargin], self.knobView.center.y);
            self.backgroundColor = self.configuration.offTintColor;
        }
        
        for (int i = 0; i < self.stars.count; i++) {
            
            if(switchOn == YES) {
                self.stars[i].alpha = 0.0;
            } else {
                self.stars[i].alpha = 1.0;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                self.stars[i].transform = CGAffineTransformMakeScale(1.5, 1.5);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    self.stars[i].transform = CGAffineTransformIdentity;
                });
            });
        }
    };
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.4
                                                                           dampingRatio:1.0
                                                                             animations:animationsBlock];
    [animator startAnimation];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    //! CAAnimation 종료 후, 상태유지를 위해 사용했다. 그러나, CATransaction에서 설정하는 것이 더 효율적일 수 있다.
    scaleAnimation.removedOnCompletion = NO;       // default 는 YES이다.
    scaleAnimation.fillMode            = kCAFillModeForwards; // 애니메이션이 끝난 후 최종상태를 유지하게 해준다.
    
    /// Api:Core Animation/CAAnimationCalculationMode/kCAAnimationPaced 참고
    /// 키프레임 애니메이션에서 calculationMode가 kCAAnimationPaced이면,
    /// keyTimes(CAKeyframeAnimation 프라퍼티) 과 timingFunction(CAAnimation 프라퍼티) 이 무시된다.
    scaleAnimation.calculationMode = kCAAnimationPaced;
    scaleAnimation.duration        = 0.3;
    
    if (switchOn == YES) {
        scaleAnimation.values = @[@(0.0f), @(1.2), @(1.0)];
    } else {
        scaleAnimation.values = @[@(1.0f), @(0.5), @(0.0)];
    }

    CABasicAnimation *strokeStartAnimation   = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.fillMode            = kCAFillModeForwards;
    strokeStartAnimation.duration            = 0.3f;
    
    if (switchOn == YES) {
        strokeStartAnimation.fromValue = @(0.0f);
        strokeStartAnimation.toValue   = @(1.0f);
    } else {
        strokeStartAnimation.fromValue = @(1.0f);
        strokeStartAnimation.toValue   = @(0.0f);
    }
    
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    
    /** 매우 빠르게 애니메이션을 실행시켜서, 컴플리션 블락에서 그 다음 애니메이션을 대비할 수 없는 상황이 발생할 수 있으므로,
     애니메이션 시작 전에 - removeCAAnimationWithSwitchOn: 를 호출하여, 대비할 수 있게 바꿨다.
     [CATransaction setCompletionBlock:^{
     if (switchOn == YES) {
     self.offBorderLayer.path = [self pathForRightStartRoundRect:self.frame].CGPath;
     self.offBorderLayer.strokeStart = 1.0;
     } else {
     self.offBorderLayer.path = [self pathForLeftStartRoundRect:self.frame].CGPath;
     self.offBorderLayer.strokeStart = 0.0;
     }
     }];*/
    
    //!
    [self removeCAAnimationWithSwitchOn:switchOn];
    [self.cloudImageView.layer addAnimation:scaleAnimation forKey:@"ScaleAnimationKey"];
    [self.offBorderLayer addAnimation:strokeStartAnimation forKey:@"StrokeStartAnimationKey"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (CGFloat)knobViewMargin {
    return self.frame.size.height / 10.0;
    //
    // 다양한 곳에서 호출되며, 심지어 서브뷰에서도 호출된다. border와 knobView 사이의 거리
}

/// ============================================================ setupBorderLayers(commonInit 지원 메서드)메서드의 지원 메서드
//! border 애미메이션을 위해서는 start point가 각각 달라야한다.
- (UIBezierPath *)pathForLeftStartRoundRect:(CGRect)rect {
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat radius = rect.size.height / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, radius)];
    [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(width - radius, 0)];
    [path addArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(width - radius, height - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(radius, height)];
    [path addArcWithCenter:CGPointMake(radius, height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    /// 만약, CGPath로 쌩으로 만드는 것을 확인하고 싶다면, ObjSubject - BorderRadiusShadow 프로젝트를 확인하라.
    
    //! 좌측에서 시작하여 시계방향으로 도는 path이다.
    return path;
}

- (UIBezierPath *)pathForRightStartRoundRect:(CGRect)rect {
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat radius = rect.size.height / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(width, radius)];
    [path addArcWithCenter:CGPointMake(width - radius, height - radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(radius, height)];
    [path addArcWithCenter:CGPointMake(radius, height - radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(width - radius, 0)];
    [path addArcWithCenter:CGPointMake(width - radius, radius) radius:radius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    /// 만약, CGPath로 쌩으로 만드는 것을 확인하고 싶다면, ObjSubject - BorderRadiusShadow 프로젝트를 확인하라.
    
    //! 감춰진 상태에서 시계방향으로 보여줄려고한다. start Point로만 조작하려고 한다.(애니메이션에서 startStoke endStorke 둘다 쓰는 것은 번거롭다.)
    //! 우측에서 반시계방향으로 돌아 만들어진 path이다. (왜냐하면 다음줄에서 reverse하므로.)
    return [path bezierPathByReversingPath];
}

//! 원래는 CATransaction의 - setCompletionBlock: 메서드로 다음 애니메이션에 대한 대비를 하려고 했다.
//! 왜냐하면, 탭할 때마다. 다음 탭에서 사용될 path가 교체되어야하기 때문이다. 그러나,
//! 애니메이션이 종료되지 않은 상태에서 마구잡이로 드래그하거나 탭해서 또 애니메이션을 발동하게 될 수 있으므로,
//! - setCompletionBlock: 메서드에서 설정할 수 없는 경우가 발생한다. 따라서, 애니메이션을 시작하기 전에 현재 적용되어야할
//! path에 대한 설정을 하고 들어가기로 했다.
//! 최초의 탭에서는 이미 설정이 되어있으므로, 이 메서드는 그냥 흘러버릴 것이다. 두 번째 부터는 if 문이 실행될 것이다.
- (void)removeCAAnimationWithSwitchOn:(BOOL)switchOn {
    if ([self.offBorderLayer animationForKey:@"StrokeStartAnimationKey"] != nil) {
        [self.offBorderLayer removeAnimationForKey:@"StrokeStartAnimationKey"];
        if (switchOn == NO) {
            self.offBorderLayer.path = [self pathForRightStartRoundRect:self.frame].CGPath;
            self.offBorderLayer.strokeStart = 1.0;
        } else {
            self.offBorderLayer.path = [self pathForLeftStartRoundRect:self.frame].CGPath;
            self.offBorderLayer.strokeStart = 0.0;
        }
    }
}

//! 터치로 인해서만 임팩트가 오게 한다.
- (void)impactOccurred {
    //! 여기에다가 스위치 자체에서 impactFeedbackGenerator 꺼버렸을 때를 대비하게 만들면 될듯.
    [self.impactFeedbackGenerator mgrImpactOccurred];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)aDecoder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame { NSCAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame primaryAction:(nullable UIAction *)primaryAction  { NSCAssert(FALSE, @"- initWithFrame:primaryAction: 사용금지."); return nil; }
@end
