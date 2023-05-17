//
//  MGUVisualEffectView.m
//  DropFactor
//
//  Created by Kwan Hyun Son on 31/12/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "MGUVisualEffectView.h"

@interface MGUVisualEffectView ()
@property (nonatomic, strong) UIViewPropertyAnimator *animator;
@end

@implementation MGUVisualEffectView
#if DEBUG && TARGET_OS_SIMULATOR
@dynamic debugIntensity;
#endif

- (instancetype)initWithEffect:(UIVisualEffect *)effect intensity:(CGFloat)intensity{
    self = [super initWithEffect:nil];
    if (self) {
        _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.1 curve:UIViewAnimationCurveLinear animations:^{
            self.effect = effect;
        }];
        // 실전용
        // 콜렉션뷰 등등에서 화면에서 나갔다 들어오거나, 백그라운드를 갔다가 오면 풀려버리는 증상(컴플리션 해버림.)이 존재하여 아래 처럼 조치했다.
        // 그런데, 그러면 Intensity 수정은 못한다.
        // https://stackoverflow.com/questions/43201565/swift-uiviewpropertyanimator-automatically-plays-when-leaving-app
        [_animator startAnimation];
        [_animator pauseAnimation];
        _animator.fractionComplete = intensity;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.animator pauseAnimation];
            [self.animator stopAnimation:YES];
            [self.animator finishAnimationAtPosition:UIViewAnimatingPositionCurrent];
        });
    }
    return self;
}


#if DEBUG && TARGET_OS_SIMULATOR
- (instancetype)initWithEffect:(UIVisualEffect *)effect debugIntensity:(CGFloat)debugIntensity {
    self = [super initWithEffect:nil];
    if (self) {
        _animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.1 curve:UIViewAnimationCurveLinear animations:^{
            self.effect = effect;
        }];
        [self.animator startAnimation];
        [self.animator pauseAnimation];
        self.animator.fractionComplete = MIN(MAX(0.0, debugIntensity), 1.0);
    }
    return self;
}

- (void)setDebugIntensity:(CGFloat)debugIntensity {
    NSLog(@"DEBUG && TARGET_OS_SIMULATOR : 실제 앱에서는 생성 후에 조절해서는 안된다.");
    CGFloat i = MIN(MAX(0.0, debugIntensity), 1.0);
    self.animator.fractionComplete = i;
}
#endif

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
