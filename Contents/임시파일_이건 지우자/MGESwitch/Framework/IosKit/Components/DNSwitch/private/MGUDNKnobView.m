//
//  MGUDNKnobView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUDNKnobView.h"
#import "MGUDNSwitch.h"

@interface MGUDNKnobView ()
@property (nonatomic, weak) MGUDNSwitch *delegate;
@end

@implementation MGUDNKnobView

#pragma mark - 생성 & 소멸
- (instancetype)initWithFrame:(CGRect)frame switchOn:(BOOL)switchOn delegate:(MGUDNSwitch *)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _on       = switchOn;
        _expand   = NO;
        _delegate = delegate;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = self.frame.size.height / 2;
        self.userInteractionEnabled = NO;
        //! circularSubview 설정을한다. 여기서 분화구뷰(circularSubview의 서브뷰)들도 설정된다.
        [self addSubview:[self setupCircularSubview]];
        
        if (switchOn == YES) {
            self.backgroundColor = self.delegate.configuration.onThumbColor;
        } else {
            self.backgroundColor = self.delegate.configuration.offThumbColor;
        }
    }
    
    return self;
}

/** setupCircularSubview 를 생성 및 설정하여 반환한다.
 craters 배열에 해당하는 뷰들도 같이 만든다. crater는 setupCircularSubview의 서브뷰이다. */
- (UIView *)setupCircularSubview {
    
    self.circularSubview = [[UIView alloc] initWithFrame: CGRectMake([self circularSubviewMargin],
                                                                     [self circularSubviewMargin],
                                                                     self.frame.size.width  - [self circularSubviewMargin] * 2,
                                                                     self.frame.size.height - [self circularSubviewMargin] * 2)];
    
    self.circularSubview.layer.masksToBounds = YES;
    self.circularSubview.layer.cornerRadius  = self.circularSubview.frame.size.height / 2;
    
    
    //! 여기서 부터는 self.circularSubview의 서브뷰들의 설정이다.
    for (UIView *crater in [self setupCraters]) {
        [self.circularSubview addSubview:crater];
    }
    
    if (self.on == YES) {
        self.circularSubview.backgroundColor = self.delegate.configuration.onSubThumbColor;
        self.circularSubview.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    } else {
        self.circularSubview.backgroundColor = self.delegate.configuration.offSubThumbColor;
    }
    
    return self.circularSubview;
}


#pragma mark - 세터 & 게터 메서드
- (void)setOn:(BOOL)on {
    _on = on;
    [self moveknobViewToOn:on];
}

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    [self expandKnobView:expand];
}


#pragma mark - 지원 메서드
//! MGUDNKnobView 내부에 들어있는 큰 완전 원형의 뷰와의 거리
- (CGFloat)circularSubviewMargin {
    return self.frame.size.height / 12;
}

/** 달의 분화구를 표현할 수 있는 3 개의 crater를 생성하고 그 배열을 반환한다. */
- (NSArray <UIView *>*)setupCraters {
    
    // shortcuts
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    UIView *topLeft  = [[UIView alloc] initWithFrame: CGRectMake(0,       h * 0.1, w * 0.2,  w * 0.2)];
    UIView *topRight = [[UIView alloc] initWithFrame: CGRectMake(w * 0.5, 0,       w * 0.3,  w * 0.3)];
    UIView *bottom   = [[UIView alloc] initWithFrame: CGRectMake(w * 0.4, h * 0.5, w * 0.25, w * 0.25)];
    
    self.craters = @[topLeft, topRight, bottom];
    
    for (UIView *crater in self.craters) {
        crater.backgroundColor     = self.delegate.configuration.offSubThumbColor;
        crater.layer.masksToBounds = YES;
        crater.layer.cornerRadius  = crater.frame.size.height / 2;
        
        UIColor *offC              = self.delegate.configuration.offThumbColor;
        crater.layer.borderColor   = offC.CGColor;
        crater.layer.borderWidth   = [self circularSubviewMargin];
        
        if (self.on == YES) {
            crater.alpha = 0.0;
        }
    }
    
    return self.craters;
}

//! superView(MGUDNSwitch)의 touch begin 과 end에서만 호출된다. (setExpand:를 통해.)
//! 본 클래스의 - (void)setExpand:(BOOL)expand 에서만 호출된다.
- (void)expandKnobView:(BOOL)expand {
    
    //! width를 height로 잡은 know how에 주목하자. 가로 세로가 동일한 원에서 시작하지만, 터치에 따라서 width 가 변신해야한다.
    //! 즉, height는 그대로이므로 height를 이용하여, width 값을 조정해주면, 추가적인 변수를 만들지 않아도 된다.
    CGFloat newWidth;
    if (expand == YES) { //! <- 시작 시
        newWidth = self.frame.size.height * 1.25;
    } else {                    //! <- 종료 시
        newWidth = self.frame.size.height;
    }
    
    CGFloat newOriginX;
    //! 스위치는 ON일때 손잡이가 오른쪽에 있다.
    if (self.on == YES) { //! 오른쪽 일때 : 시작 또는 종료 시 오른쪽일 경우
        newOriginX = self.superview.frame.size.width - newWidth - [self.delegate knobViewMargin];
    } else { //! 왼쪽 일때 : 시작 또는 종료 시 왼쪽일 경우
        newOriginX = self.frame.origin.x; // <- 수퍼뷰의 무빙에 의해 전혀 문제가 생기지 않는다.
    }
    
    void (^animationsBlock)(void) = ^{
        /// 1. self(MGUDNKnobView)의 크기변화 크기가 변화하지만, 오른쪽(ON)상태에서 크기가 커지면 origin도 변한다.
        self.frame = CGRectMake(newOriginX, self.frame.origin.y, newWidth, self.frame.size.height);
        
        /// 2. circularSubview의 센터이동. 움직이지 않는 것처럼 보이기 위한 변화이다.
        if (self.on == YES){
            self.circularSubview.center = CGPointMake(self.frame.size.width - self.frame.size.height / 2, self.circularSubview.center.y);
        } else {
            self.circularSubview.center = CGPointMake(self.frame.size.height / 2,                         self.circularSubview.center.y);
        }
    };
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.8
                                                                           dampingRatio:1.0
                                                                             animations:animationsBlock];
    [animator startAnimation];
}

//! 본 클래스의 - (void)setOn:(BOOL)on; 에서만 호출된다.
- (void)moveknobViewToOn:(BOOL)on {
    //! on 은 superView의 on 옵저빙 발견 시 그 메서드에서 호출된다.
    //! if 문에서도 self.circularSubview.center는 변하고
    //! else if 문에서도 self.circularSubview.center는 변한다.
    //! if 문에서는 움직임을 보여주기 위해서 변하는 것이고, else if문에서는 움직이지 않는 것처럼
    //! 보이기 위해서 변하는 것이다.
    void (^animationsBlock)(void) = ^{
        if (on == YES) {
            self.backgroundColor                 = self.delegate.configuration.onThumbColor;
            self.circularSubview.backgroundColor = self.delegate.configuration.onSubThumbColor;
            
            for (UIView *crater in self.craters) {
                crater.alpha = 0.0;
            }
            
            self.circularSubview.center = CGPointMake(self.frame.size.width - self.frame.size.height / 2, self.circularSubview.center.y);
            
        } else {
            self.backgroundColor                 = self.delegate.configuration.offThumbColor;
            self.circularSubview.backgroundColor = self.delegate.configuration.offSubThumbColor;
            
            for (UIView *crater in self.craters) {
                crater.alpha = 1.0;
            }
            
            self.circularSubview.center = CGPointMake(self.frame.size.height / 2,                         self.circularSubview.center.y);
        }
    };
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.8
                                                                           dampingRatio:1.0
                                                                             animations:animationsBlock];
    [animator startAnimation];
    
    //! 내부의 완전 동그란 큰 서브뷰의 회전만 담당한다.
    void (^animationsBlock2)(void) = ^{
        self.circularSubview.transform = CGAffineTransformMakeRotation(M_PI * ((self.on == YES) ? 0.5 : 0.0)); };
    
    UIViewPropertyAnimator *animator2 = [[UIViewPropertyAnimator alloc] initWithDuration:0.4
                                                                            dampingRatio:1.0
                                                                              animations:animationsBlock2];
    [animator2 startAnimation];
}
@end
