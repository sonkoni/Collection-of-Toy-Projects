//
//  MGUSevenKnobView.m
//  MGRSwitch
//
//  Created by Kwan Hyun Son on 28/01/2020.
//  Copyright © 2020 Mulgrim Inc. All rights reserved.
//

#import "MGUSevenKnobView.h"
#import "MGUSevenSwitch.h"

@interface MGUSevenKnobView ()
@property (nonatomic, assign, readonly) MGUSevenSwitchKnobRatio knobRatio; // @dynamic
@end

@implementation MGUSevenKnobView
@dynamic knobRatio;

- (MGUSevenSwitchKnobRatio)knobRatio {
    MGUSevenSwitch *sevenSwitch = (MGUSevenSwitch *)self.superview;
    if ([sevenSwitch isKindOfClass:[MGUSevenSwitch class]] == NO) {
        NSCAssert(FALSE, @"superview는 MGUSevenSwitch 클래스 여야한다.");
    }
    return sevenSwitch.knobRatio;
}

- (void)setExpand:(BOOL)expand {
    _expand = expand;
    [self expandKnobView:expand];
}

- (void)expandKnobView:(BOOL)expand {
    
    //! width를 height로 잡은 know how에 주목하자. 가로 세로가 동일한 원에서 시작하지만, 터치에 따라서 width 가 변신해야한다.
    //! 즉, height는 그대로이므로 height를 이용하여, width 값을 조정해주면, 추가적인 변수를 만들지 않아도 된다.
    CGFloat newWidth = 0.0;
    if (self.knobRatio == MGUSevenSwitchKnobRatioAutomatic) {
        if (expand == YES) { //! <- 시작 시
            newWidth = self.frame.size.height * 1.2;
        } else {                    //! <- 종료 시
            newWidth = self.frame.size.height;
        }
    } else {
        if (expand == YES) { //! <- 시작 시
            newWidth = self.frame.size.height * self.knobRatio * 1.2;
        } else {                    //! <- 종료 시
            newWidth = self.frame.size.height * self.knobRatio;
        }
    }
    
    CGFloat newOriginX;
    //! 스위치는 ON일때 손잡이가 오른쪽에 있다.
    if (self.on == YES) { //! 오른쪽 일때 : 시작 또는 종료 시 오른쪽일 경우
        newOriginX = self.superview.frame.size.width - newWidth - [(MGUSevenSwitch *)self.superview borderWidth];
    } else { //! 왼쪽 일때 : 시작 또는 종료 시 왼쪽일 경우
        newOriginX = self.frame.origin.x; // <- 수퍼뷰의 무빙에 의해 전혀 문제가 생기지 않는다.
    }
    
    void (^animationsBlock)(void) = ^{
        /// 1. self(MGUSevenKnobView)의 크기변화 크기가 변화하지만, 오른쪽(ON)상태에서 크기가 커지면 origin도 변한다.
        self.frame = CGRectMake(newOriginX, self.frame.origin.y, newWidth, self.frame.size.height);
    };
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.8
                                                                           dampingRatio:1.0
                                                                             animations:animationsBlock];
    [animator startAnimation];
    
    /** 안하는게 낫다.
    CABasicAnimation *shadowAnimation  = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowAnimation.removedOnCompletion = NO;
    shadowAnimation.fillMode            = kCAFillModeForwards;
    shadowAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shadowAnimation.duration = 0.8;
    shadowAnimation.fromValue = (__bridge id _Nullable)(self.layer.presentationLayer.shadowPath);
    shadowAnimation.toValue   = (__bridge id _Nullable)[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                                                  cornerRadius:self.layer.cornerRadius].CGPath;
    [self.layer addAnimation:shadowAnimation forKey:@"ShadowAnimationKey"];

    [CATransaction setCompletionBlock:^{}];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    [CATransaction commit];
     */
}

@end
