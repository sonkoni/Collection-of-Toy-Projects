#import "MGUMaterialSwitch.h"
#import <QuartzCore/QuartzCore.h>
#import "MGRMaterialKnobView.h"
#import "UIColor+Extension.h"
#import "UIFeedbackGenerator+Extension.h"

@interface MGUMaterialSwitch()

@property (nonatomic) UIView *trackView;
@property (nonatomic) MGRMaterialKnobView *knobView;
//! 터치가 시작된 후 움직임이 있느냐 없느냐를 판단한다. 움직임이 없다면, 단순 탭으로 인식한다.
//! moved가 없다면(움직이 없다면 = 탭으로 인식하면) 기존 위치에서 반대 방향으로 이동한다.
@property (nonatomic) BOOL moved;

@property (nonatomic) float bounceOffset;
@property (nonatomic) MGUMaterialSwitchSize switchSize;
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedbackGenerator;
@end

@implementation MGUMaterialSwitch

//! 쉽게 초기화 하기. 실제 앱에서는 잘 안쓸 듯.
- (instancetype)init {
  self = [self initWithSize:MGUMaterialSwitchSizeNormal
                      style:MGUMaterialSwitchStyleDefault
                   switchOn:YES];
  return self;
}

//! switch를 터치 하거나 못하게 만든다.
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    CABasicAnimation *knobViewColorAnimation   = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    knobViewColorAnimation.duration            = self.animaitonDuration - 0.1;
    knobViewColorAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    knobViewColorAnimation.fillMode            = kCAFillModeForwards;
    knobViewColorAnimation.removedOnCompletion = NO;
 
    CABasicAnimation *trackViewColorAnimation   = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    trackViewColorAnimation.duration            = self.animaitonDuration - 0.1;
    trackViewColorAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    trackViewColorAnimation.fillMode            = kCAFillModeForwards;
    trackViewColorAnimation.removedOnCompletion = NO;
    
    if (enabled == YES) {
        if (self.switchOn == YES) {
            trackViewColorAnimation.fromValue = (id)self.trackDisabledColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackOnColor.CGColor;
            knobViewColorAnimation.fromValue  = (id)self.knobDisabledColor.CGColor;
            knobViewColorAnimation.toValue    = (id)self.knobOnColor.CGColor;
        }
        else {
            trackViewColorAnimation.fromValue = (id)self.trackDisabledColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackOffColor.CGColor;
            knobViewColorAnimation.fromValue  = (id)self.knobDisabledColor.CGColor;
            knobViewColorAnimation.toValue    = (id)self.knobOffColor.CGColor;
        }
    } else {
        if (self.switchOn == YES) {
            trackViewColorAnimation.fromValue = (id)self.trackOnColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackDisabledColor.CGColor;
            knobViewColorAnimation.fromValue  = (id)self.knobOnColor.CGColor;
            knobViewColorAnimation.toValue    = (id)self.knobDisabledColor.CGColor;
        }
        else {
            trackViewColorAnimation.fromValue = (id)self.trackOffColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackDisabledColor.CGColor;
            knobViewColorAnimation.fromValue  = (id)self.knobOffColor.CGColor;
            knobViewColorAnimation.toValue    = (id)self.knobDisabledColor.CGColor;
        }
    }
    
    [CATransaction setCompletionBlock:^{}];
    [self.knobView.layer  addAnimation:knobViewColorAnimation  forKey:@"KnobViewColorAnimationKey"];
    [self.trackView.layer addAnimation:trackViewColorAnimation forKey:@"TrackViewColorAnimationKey"];
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

/// ============================================================ 터치 액션 파트
//! 터치가 시작되면, 계속 누르고 있던, 바로 때던 이 메서드가 쳐지고,
//! flag를 설정한다. self의 drag 프라퍼티를 YES로 설정하고 knobView의 expanded 프라퍼티를 YES로 설정한다.
//! knobView의 expanded 프라퍼티는 key - value - observing에 의하여 옵저빙 메서드를 발동 시킨다.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.rippleEnabled == YES) {
        self.knobView.touched = YES; // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.moved = YES; // <- 터치가 시작되고 조금이라도 움직였는지 여부를 체크한다.
    
    CGFloat x = [(UITouch *)touches.allObjects.lastObject locationInView:self].x;
    
    if ( (x > self.frame.size.width / 2) && (self.switchOn == NO) ) {          // off 상태인데 on  상태 영역을 넘어갔다면
        self.switchOn = YES;
        [self impactOccurred];
    } else if ( (x < self.frame.size.width / 2) && (self.switchOn == YES) ) {  // on  상태인데 off 상태 영역을 넘어갔다면
        self.switchOn = NO;
        [self impactOccurred];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //! 짧게 탭했을 경우(즉, 무빙이 인식되지 않았을 경우, 단순히 on, off 상태만 변화 시킨다.)
    //! 그래도, on, off 상태의 변화는 애니메이션의 연쇠를 부른다.
    //! 이 if 문이 실행된다는 것은 탭으로 인식한다는 것이다. 즉, 현재 위치에서 상대 위치로 무조건 옮긴다.
    //! 즉, 한번이라도 무빙이 인식되면 실행되지 않는다.
    if (self.moved == NO) {
        self.switchOn = !self.switchOn; // <- 여기서 바운스까지 처리한다.
        [self impactOccurred];
    } else if (self.bounceEnabled == YES) {
        [self bounceAnimation];
    }
    
    if (self.rippleEnabled == YES) {
        self.knobView.touched = NO; // <- setExpand: 메서드에 의해 expandKnobView: 가 호출된다.
    }
    
    self.moved = NO; // <- 다시 재설정한다.
    
    //! 실제로 멈췄을 때 master의 변화를 원할 수 있다.
    [self sendActionsForControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 생성 소멸 메서드
//! 지정초기화 메서드
- (instancetype)initWithSize:(MGUMaterialSwitchSize)size
                       style:(MGUMaterialSwitchStyle)style
                    switchOn:(BOOL)switchOn {
    
    /// 여기서 설정해줘야한다. 중요!!
    _switchSize = size;
    _switchOn   = switchOn;
    [self setSwitchColorToStyle:style];
    self.rippleEnabled = YES;
    self.bounceEnabled = YES;
    
    self = [super initWithFrame:[self mainFrame]];
    if (self) {
        _impactFeedbackGenerator = [UIImpactFeedbackGenerator mgrImpactFeedbackGeneratorWithStyle:UIImpactFeedbackStyleLight];
        [self commonInit];
    }
    return self;
}

- (void)setSwitchColorToStyle:(MGUMaterialSwitchStyle)style {
    // Determine switch style from preset colour set
    // Light and Dark color styles come from Google's design guidelines
    // https://www.google.com/design/spec/components/selection-controls.html
    switch (style) {
        case MGUMaterialSwitchStyleLight:
//            [UIColor mgrMaterialObservatory]
            self.knobOnColor        = [UIColor mgrMaterialObservatory];
            self.knobOffColor       = [UIColor mgrMaterialWhite];
            self.trackOnColor       = [UIColor mgrMaterialTradewind];
            self.trackOffColor      = [UIColor mgrMaterialGray];
            self.knobDisabledColor  = [UIColor mgrMaterialBombay2];
            self.trackDisabledColor = [UIColor mgrMaterialIron];
            self.rippleFillColor    = [UIColor grayColor];
            break;
        case MGUMaterialSwitchStyleDark:
            self.knobOnColor        = [UIColor mgrMaterialMonteCarlo];
            self.knobOffColor       = [UIColor mgrMaterialBombay2];
            self.trackOnColor       = [UIColor mgrMaterialTaxBreak];
            self.trackOffColor      = [UIColor mgrMaterialChicago];
            self.knobDisabledColor  = [UIColor mgrMaterialMineShaft];
            self.trackDisabledColor = [UIColor mgrMaterialShark];
            self.rippleFillColor    = [UIColor grayColor];
            break;
            
        default:
            self.knobOnColor        = [UIColor mgrMaterialUltramarineBlue];
            self.knobOffColor       = [UIColor mgrMaterialHintOfRed];
            self.trackOnColor       = [UIColor mgrMaterialJordyBlue];
            self.trackOffColor      = [UIColor mgrMaterialSilver];
            self.knobDisabledColor  = [UIColor mgrMaterialBombay];
            self.trackDisabledColor = [UIColor mgrMaterialIron];
            self.rippleFillColor    = [UIColor blueColor];
            break;
    }
}

- (void)commonInit {
    self.bounceOffset      = 3.0f;
    self.animaitonDuration = 0.2f;
    [self addSubview:[self setupTrackView]];
    [self addSubview:[self setupKnob]];               // <- 추가 지원 메서드
}

//! commonInit 메서드에서만 호출된다.
/** UIView를 설정하고 반환한다. 긴 바에 해당하는 뷰이다. */
- (UIView *)setupTrackView {
    self.trackView = [[UIView alloc] initWithFrame:[self trackFrame]];
    self.trackView.layer.cornerRadius = self.trackView.frame.size.height / 2.0;
    self.trackView.userInteractionEnabled  = NO;
    
    /// 이렇게 넣어주는 것이 맞다. 최초에 만들어지고 난 후, 리셋을 할 수 도 있다.
    if (self.isEnabled == NO) {
        self.trackView.layer.backgroundColor = [self trackDisabledColor].CGColor;
    } else {
        if (self.switchOn == YES) {
            self.trackView.layer.backgroundColor = [self trackOnColor].CGColor;
        } else {
            self.trackView.layer.backgroundColor = [self trackOffColor].CGColor;
        }
    }
    return self.trackView;
}

//! commonInit 메서드에서만 호출된다.
/** MGRMaterialKnobView를 설정하고 반환한다. 손잡이에 해당하는 둥근 뷰이다. */
- (MGRMaterialKnobView *)setupKnob {
    self.knobView = [[MGRMaterialKnobView alloc] initWithFrame:[self knobFrameForSwitchOn:self.switchOn]
                                                      switchOn:self.switchOn];
    return self.knobView;
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 세터 게터 메서드

- (void)setSwitchOn:(BOOL)switchOn {
    
    if ( _switchOn != switchOn ) {
        _switchOn = switchOn;
        [self moveSwitchToOn:switchOn];
    }
}

- (void)setAnimaitonDuration:(CGFloat)animaitonDuration {
    if ( _animaitonDuration != animaitonDuration ) {
        _animaitonDuration              = animaitonDuration;
        self.knobView.animaitonDuration = animaitonDuration;
    }
}

- (void)setRippleFillColor:(UIColor *)rippleFillColor {
    if (_rippleFillColor != rippleFillColor) {
        _rippleFillColor = rippleFillColor;
        
        self.knobView.rippleLayer.fillColor = rippleFillColor.CGColor; // 앱 실행 중에 색을 자유롭게 바꿀 수 있게 한다.
    }
}

- (void)setKnobOnColor:(UIColor *)thumbOnTintColor {
    if (_knobOnColor != thumbOnTintColor) {
        _knobOnColor = thumbOnTintColor;
        
        if (self.switchOn == YES && self.isEnabled == YES) { // 앱 실행 중에 색을 자유롭게 바꿀 수 있게 한다.
            self.knobView.layer.backgroundColor = thumbOnTintColor.CGColor;
        }
    }
}

- (void)setKnobOffColor:(UIColor *)thumbOffTintColor {
    if (_knobOffColor != thumbOffTintColor) {
        _knobOffColor = thumbOffTintColor;
        
        if (self.switchOn == NO && self.isEnabled == YES) { // 앱 실행 중에 색을 자유롭게 바꿀 수 있게 한다.
            self.knobView.layer.backgroundColor = thumbOffTintColor.CGColor;
        }
    }
}

- (void)setTrackOnColor:(UIColor *)trackOnTintColor {
    if (_trackOnColor != trackOnTintColor) {
        _trackOnColor = trackOnTintColor;
        
        if (self.switchOn == YES && self.isEnabled == YES) { // 앱 실행 중에 색을 자유롭게 바꿀 수 있게 한다.
            self.trackView.layer.backgroundColor = trackOnTintColor.CGColor;
        }
    }
}

- (void)setTrackOffColor:(UIColor *)trackOffTintColor {
    if (_trackOffColor != trackOffTintColor) {
        _trackOffColor = trackOffTintColor;
        
        if (self.switchOn == NO && self.isEnabled == YES) { // 앱 실행 중에 색을 자유롭게 바꿀 수 있게 한다.
            self.trackView.layer.backgroundColor = trackOffTintColor.CGColor;
        }
    }
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 컨트롤 메서드

- (void)setSwitchOn:(BOOL)switchOn WithAnimated:(BOOL)animated {
    if (animated == YES) {
        [self setSwitchOn:switchOn];
        
    } else if (self.switchOn != switchOn){
        _switchOn = switchOn;
        //! 삭제된 항목이 옆 index에 영향을 미치므로 이렇게 해야한다. 그런데, subviews는 왜 괜찮은지 모르겠다.
        //! reverseObjectEnumerator를 쓰면 -> the next index won't be affected when you remove an object.
        for (UIView  *view  in [self.subviews reverseObjectEnumerator])        { [view removeFromSuperview]; }
        [self commonInit];
    }
}

/// ============================================================ - setSwitchOn: 에서만 호출된다.
- (void)moveSwitchToOn:(BOOL)switchOn {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    self.knobView.on = switchOn; // 메서드를 호출할 것이다.
    
    if (self.isEnabled == YES) {
        CABasicAnimation *trackViewColorAnimation   = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        trackViewColorAnimation.duration            = self.animaitonDuration;
        trackViewColorAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        trackViewColorAnimation.fillMode            = kCAFillModeForwards;
        trackViewColorAnimation.removedOnCompletion = NO;
        
        if (switchOn == YES) {
            trackViewColorAnimation.fromValue = (id)self.trackOffColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackOnColor.CGColor;
        } else {
            trackViewColorAnimation.fromValue = (id)self.trackOnColor.CGColor;
            trackViewColorAnimation.toValue   = (id)self.trackOffColor.CGColor;
        }
        
        [CATransaction setCompletionBlock:^{}];
        [self.trackView.layer addAnimation:trackViewColorAnimation forKey:@"TrackViewColorAnimationKey"];
    }

    CAKeyframeAnimation *knobViewPositionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGRect offFrame           = [self knobFrameForSwitchOn:NO];
    CGRect onFrame            = [self knobFrameForSwitchOn:YES];
    CGPoint offPosition       = CGPointMake(CGRectGetMidX(offFrame), CGRectGetMidY(offFrame));
    CGPoint onPosition        = CGPointMake(CGRectGetMidX(onFrame), CGRectGetMidY(onFrame));
    CGPoint offBouncePosition = CGPointMake(offPosition.x - self.bounceOffset, offPosition.y);
    CGPoint onBouncePosition  = CGPointMake(onPosition.x  + self.bounceOffset, onPosition.y);
    
    NSArray *onValues, *offValues, *keyTimes;
    if (self.bounceEnabled  == YES && self.moved == NO) {
        onValues =  @[[NSValue valueWithCGPoint:offPosition],
                      [NSValue valueWithCGPoint:onBouncePosition],
                      [NSValue valueWithCGPoint:onPosition]];
        
        offValues = @[[NSValue valueWithCGPoint:onPosition],
                      [NSValue valueWithCGPoint:offBouncePosition],
                      [NSValue valueWithCGPoint:offPosition]];
        
        keyTimes = @[@(0.0), @(0.5), @(1.0)];
    } else {
        onValues  = @[[NSValue valueWithCGPoint:offPosition], [NSValue valueWithCGPoint:onPosition]];
        offValues = @[[NSValue valueWithCGPoint:onPosition],  [NSValue valueWithCGPoint:offPosition]];
        keyTimes  = @[@(0.0), @(0.75)];
    }
    
    if (self.switchOn == YES) {
        knobViewPositionAnimation.values = onValues;
    } else {
        knobViewPositionAnimation.values = offValues;
    }
    
    knobViewPositionAnimation.calculationMode = kCAAnimationLinear;
    knobViewPositionAnimation.keyTimes        = keyTimes;
    
    knobViewPositionAnimation.removedOnCompletion = NO;
    knobViewPositionAnimation.fillMode            = kCAFillModeForwards;
    knobViewPositionAnimation.duration            = self.animaitonDuration;
    knobViewPositionAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [CATransaction setCompletionBlock:^{}];
    [self.knobView.layer addAnimation:knobViewPositionAnimation forKey:@"KnobViewPositionAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)bounceAnimation {
    CAKeyframeAnimation * bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    if (self.switchOn == YES) {
        bounceAnimation.values   = @[@(0.0), @(self.bounceOffset), @(0.0)];
    } else {
        bounceAnimation.values   = @[@(0.0), @(-self.bounceOffset), @(0.0)];
    }
    
    bounceAnimation.keyTimes            = @[@0.0, @0.5, @1.0];
    bounceAnimation.duration            = self.animaitonDuration;
    bounceAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bounceAnimation.fillMode            = kCAFillModeForwards;
    bounceAnimation.removedOnCompletion = NO;
    
    [CATransaction setCompletionBlock:^{}];
    [self.knobView.layer addAnimation:bounceAnimation forKey:@"BounceAnimationKey"];
    
    [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드

- (CGRect)mainFrame {
    switch (self.switchSize) {
        case MGUMaterialSwitchSizeBig:
            return CGRectMake(0, 0, 50, 40);
        case MGUMaterialSwitchSizeNormal:
            return CGRectMake(0, 0, 40, 30);
        case MGUMaterialSwitchSizeSmall:
            return CGRectMake(0, 0, 30, 25);
        default:
            NSAssert(false, @"잘못된 입력!!");
    }
}

- (CGRect)trackFrame {
    CGRect mainFrame = [self mainFrame];
    CGFloat originX, originY, sizeWidth, sizeHeight;
    sizeWidth = mainFrame.size.width;
    originX   = 0.0;
    
    // Determine trackFrame size
    switch (self.switchSize) {
        case MGUMaterialSwitchSizeBig:
            sizeHeight = 23.0;
            originY    = (mainFrame.size.height - 23.0) / 2.0;
            break;
        case MGUMaterialSwitchSizeNormal:
            sizeHeight = 17.0;
            originY    = (mainFrame.size.height - 17.0) / 2.0;
            break;
        case MGUMaterialSwitchSizeSmall:
            sizeHeight = 13.0;
            originY    = (mainFrame.size.height - 13.0) / 2.0;
            break;
        default:
            NSAssert(false, @"잘못된 입력!!");
            break;
    }
    
    return CGRectMake(originX, originY, sizeWidth, sizeHeight);
}

//! 메인 뷰의 사이즈와 현재 state(ON 또는 OFF)가 정해졌을 때의 frame에 대한 정보이다.
//! 즉, 현재 thumb frame을 뱉어주는 것이아니라, 현재 상태가 이러이러하게 해야됬을 때의 frame이라고 보면된다.
//! 즉, self.currentState를 설정한 뒤, 호출하는 것이 맞다. 그렇다면, self.currentState에 대한
//! thumb frame을 반환해준다.
- (CGRect)knobFrameForSwitchOn:(BOOL)switchOn {
    
    CGRect mainFrame = [self mainFrame];
    CGFloat originX, originY, sizeWidth, sizeHeight;
    
    // Determine trackFrame size
    switch (self.switchSize) {
        case MGUMaterialSwitchSizeBig:
            sizeHeight = 31.0;
            sizeWidth  = 31.0;
            originY    = (mainFrame.size.height - 31.0) / 2.0;
            
            break;
        case MGUMaterialSwitchSizeNormal:
            sizeHeight = 24.0;
            sizeWidth  = 24.0;
            originY    = (mainFrame.size.height - 24.0) / 2.0;
            break;
        case MGUMaterialSwitchSizeSmall:
            sizeHeight = 18.0;
            sizeWidth  = 18.0;
            originY    = (mainFrame.size.height - 18.0) / 2.0;
            break;
        default:
            NSAssert(false, @"잘못된 입력!!");
            break;
    }
    
    if (switchOn == NO) {
        originX = 0.0f;
    } else {
        originX = mainFrame.size.width - sizeWidth;
    }
    
    return CGRectMake(originX, originY, sizeWidth, sizeHeight);
}

//! 터치로 인해서만 임팩트가 오게 한다.
- (void)impactOccurred {
    //! 여기에다가 스위치 자체에서 impactFeedbackGenerator 꺼버렸을 때를 대비하게 만들면 될듯.
    [self.impactFeedbackGenerator mgrImpactOccurred];
}

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame { NSAssert(FALSE, @"- initWithFrame: 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }

@end
