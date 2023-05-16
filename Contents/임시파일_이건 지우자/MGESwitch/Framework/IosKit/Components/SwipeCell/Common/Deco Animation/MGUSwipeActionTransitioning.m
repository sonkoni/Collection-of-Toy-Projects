//
//  MGUSwipeActionTransitioning.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeActionTransitioning.h"
#import "MGUSwipeActionButton.h"
#import "MGUFavoriteSwitch.h"

@interface MGUSwipeActionButton ()
//@property (nonatomic, strong) UIImageView *imageView; // lazy
@property (nonatomic, strong) MGUFavoriteSwitch *favoriteSwitch;
@end

@interface MGUSwipeActionTransitioningContext ()
@property (nonatomic, strong, nullable) NSString *actionIdentifier;
@property (nonatomic, strong) MGUSwipeActionButton *button;
@property (nonatomic, assign) CGFloat newPercentVisible;
@property (nonatomic, assign) CGFloat oldPercentVisible;
@property (nonatomic, strong) UIView *wrapperView;
@end

@implementation MGUSwipeActionTransitioningContext

+ (instancetype)transitioningContextWithActionIdentifier:(NSString * _Nullable)actionIdentifier
                                                  button:(MGUSwipeActionButton *)button
                                       newPercentVisible:(CGFloat)newPercentVisible
                                       oldPercentVisible:(CGFloat)oldPercentVisible
                                             wrapperView:(UIView *)wrapperView {
    MGUSwipeActionTransitioningContext *transitioningContext = [[MGUSwipeActionTransitioningContext alloc] initPrivate];
    transitioningContext.actionIdentifier = actionIdentifier;
    transitioningContext.button = button;
    transitioningContext.newPercentVisible = newPercentVisible;
    transitioningContext.oldPercentVisible = oldPercentVisible;
    transitioningContext.wrapperView = wrapperView;
    return transitioningContext;
}
- (instancetype)initPrivate {
    self = [super init];
    if (self) {}
    return self;
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end

@interface MGUSwipeTransitionAnimation ()
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL ready; // 등장하는 애니메이션 준비된 것인지 여부.
@end

@implementation MGUSwipeTransitionAnimation

- (instancetype)initWithTransitionAnimationWithType:(MGUSwipeTransitionAnimationType)transitionAnimationType
                                           duration:(CGFloat)duration
                                       initialScale:(CGFloat)initialScale
                                          threshold:(CGFloat)threshold {
    self = [super init];
    if (self) {
        _transitionAnimationType = transitionAnimationType;
        _duration = duration;
        _initialScale = initialScale;
        _threshold = threshold;
        _ready = YES;
        _isFirst = YES;
    }
    return self;
    
}

+ (instancetype)transitionAnimationWithType:(MGUSwipeTransitionAnimationType)transitionAnimationType {
    CGFloat duration = 0.15;
    CGFloat initialScale = 0.8;
    CGFloat threshold = 0.5;
    if (transitionAnimationType ==     MGUSwipeTransitionAnimationTypeSpring) {
        duration = 0.3;
        // initialScale 사용 안함. threshold 그대로임.
    }
    return [[MGUSwipeTransitionAnimation alloc] initWithTransitionAnimationWithType:transitionAnimationType
                                                                        duration:duration
                                                                    initialScale:initialScale
                                                                       threshold:threshold];
    
}

- (void)didTransitionWithContext:(MGUSwipeActionTransitioningContext *)context {
    if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeNone) {
        return;
    }
    if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeDefault) {
        [self _didTransitionWithContext_Default:context];
    } else if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeSpring ||
               self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeRotate) {
        [self _didTransitionWithContext_SpringRotate:context];
    } else if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeFavorite) {
        [self _didTransitionWithContext_Favorite:context];
    }
}

- (void)_didTransitionWithContext_Default:(MGUSwipeActionTransitioningContext *)context {
    //! 최초.
    if (self.isFirst == YES) {
        self.isFirst = NO;
        if (context.newPercentVisible < self.threshold) { // 최초이자 현재.
            //! 일반적인 경우.
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            context.button.favoriteSwitch.layer.transform = CATransform3DScale(CATransform3DIdentity, self.initialScale, self.initialScale, 0.0);
            [CATransaction commit];
        } else {
            self.ready = NO;
        }
        return;
    }

    CABasicAnimation *transformScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    transformScaleAnimation.fillMode = kCAFillModeForwards;
    transformScaleAnimation.removedOnCompletion = NO;
    transformScaleAnimation.duration = self.duration;
    transformScaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //! context.oldPercentVisible < self.threshold =< context.newPercentVisible
    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold && self.ready == YES) {
        self.ready = NO;
        CGFloat fromValue = self.initialScale;
        if (context.button.favoriteSwitch.layer.presentationLayer != nil) {
            CATransform3D transform = context.button.favoriteSwitch.layer.presentationLayer.transform;
            context.button.favoriteSwitch.layer.transform = transform; // 깜빡 거림을 막을 수 있다.
            fromValue = transform.m11; // <- 현재 스케일에 해당한다.
        }
        transformScaleAnimation.fromValue = @(fromValue);
        transformScaleAnimation.toValue = @(1.0);
        
        void (^completionBlock)(void) = ^(void) {};
        [CATransaction setCompletionBlock:completionBlock];
        [context.button.favoriteSwitch.layer addAnimation:transformScaleAnimation forKey:@"TransformScaleAnimationKey"];
    }
    
    if (context.newPercentVisible < 0.03 && self.ready == NO) {
        self.ready = YES;
        CGFloat fromValue = 1.0;
        if (context.button.favoriteSwitch.layer.presentationLayer != nil) {
            CATransform3D transform = context.button.favoriteSwitch.layer.presentationLayer.transform;
            context.button.favoriteSwitch.layer.transform = transform; // 깜빡 거림을 막을 수 있다.
            fromValue = transform.m11; // <- 현재 스케일에 해당한다.
        }
        transformScaleAnimation.fromValue = @(fromValue);
        transformScaleAnimation.toValue = @(self.initialScale);
        
        void (^completionBlock)(void) = ^(void) {};
        [CATransaction setCompletionBlock:completionBlock];
        [context.button.favoriteSwitch.layer addAnimation:transformScaleAnimation forKey:@"TransformScaleAnimationKey"];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}

- (void)_didTransitionWithContext_SpringRotate:(MGUSwipeActionTransitioningContext *)context {
    //! 최초.
    if (self.isFirst == YES) {
        self.isFirst = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        context.button.favoriteSwitch.layer.transform = CATransform3DIdentity;
        [CATransaction commit];
        if (context.newPercentVisible >= self.threshold) {
            self.ready = NO;
        }
        if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeRotate) {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1 / 35.0; // 일반적으로 500.0을 많이 사용한다. 35.0 에 해당하는 수가 작아질 수록 효과는 과장된다.
            context.button.favoriteSwitch.layer.superlayer.sublayerTransform = transform;
        }
        return;
    }
    //! context.oldPercentVisible < self.threshold =< context.newPercentVisible
    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold && self.ready == YES) {
        self.ready = NO;
        CAKeyframeAnimation *transformScaleAnimationX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        CAKeyframeAnimation *transformScaleAnimationY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        CAKeyframeAnimation *transformRotationAnimationY = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.y"];

        [self setupAnimation:transformScaleAnimationX];
        [self setupAnimation:transformScaleAnimationY];
        [self setupAnimation:transformRotationAnimationY];
        
        transformScaleAnimationX.values = @[@(1.0), @(1.2), @(0.9), @(1.0)];
        transformScaleAnimationX.keyTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
        
        //! 이쪽에 조금 더 힘을 실어주자.
        transformScaleAnimationY.values = @[@(1.0), @(0.5), @(1.25), @(1.0)];
        transformScaleAnimationY.keyTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
        
        transformRotationAnimationY.values = @[@(0.0), @(M_PI_4), @(-M_PI_4 / 3.0), @(0.0)];
        transformRotationAnimationY.keyTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
        
        void (^completionBlock)(void) = ^(void) {};
        [CATransaction setCompletionBlock:completionBlock];
        
        if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeSpring) {
            [context.button.favoriteSwitch.layer addAnimation:transformScaleAnimationX forKey:@"TransformScaleAnimationXKey"];
            [context.button.favoriteSwitch.layer addAnimation:transformScaleAnimationY forKey:@"TransformScaleAnimationYKey"];
        } else if (self.transitionAnimationType ==     MGUSwipeTransitionAnimationTypeRotate) {
            [context.button.favoriteSwitch.layer addAnimation:transformRotationAnimationY forKey:@"TransformRotationAnimationYKey"];
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
    }
    
    if (context.newPercentVisible < 0.03 && self.ready == NO) {
        self.ready = YES;
    }
}

- (void)_didTransitionWithContext_Favorite:(MGUSwipeActionTransitioningContext *)context {
    if (self.isFirst == YES) {
        self.isFirst = NO;
        if (context.newPercentVisible >= self.threshold) {
            [context.button.favoriteSwitch setSelected:YES animated:NO notify:NO];
            self.ready = NO;
        } else {
            [context.button.favoriteSwitch setSelected:NO animated:NO notify:NO];
        }
        return;
    }

    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold && self.ready == YES) {
        self.ready = NO;
        [context.button.favoriteSwitch setSelected:YES animated:YES notify:NO];
    }
    
    if (context.newPercentVisible < 0.03 && self.ready == NO) {
        self.ready = YES;
        [context.button.favoriteSwitch setSelected:NO animated:NO notify:NO];
    }
}


#pragma mark - Helper
- (void)setupAnimation:(CAPropertyAnimation *)animation {
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = self.duration;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 우선권.
    if ([animation isKindOfClass:[CAKeyframeAnimation class]]) {
        CAKeyframeAnimation *keyframeAnimation = (CAKeyframeAnimation *)animation;
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        //! value가 4개 => 간격이 3개
        keyframeAnimation.timingFunctions = @[timingFunction, timingFunction, timingFunction];
    }
    
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end

/** 예전 코드.
- (void)didTransitionWithContext:(MGUSwipeActionTransitioningContext *)context {
    if (context.oldPercentVisible == 0.0) {
        context.button.imageView.transform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);
    }

    void (^animationBlock)(void);

    //! context.oldPercentVisible < self.threshold =< context.newPercentVisible
    if (context.oldPercentVisible < self.threshold && context.newPercentVisible >= self.threshold) {
        animationBlock = ^{
            context.button.imageView.transform = CGAffineTransformIdentity;
        };
    //! context.newPercentVisible < self.threshold =< context.oldPercentVisible
    } else if (context.oldPercentVisible >= self.threshold && context.newPercentVisible < self.threshold) {
        animationBlock = ^{
            context.button.imageView.transform = CGAffineTransformMakeScale(self.initialScale, self.initialScale);
        };
    }

    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:self.duration
                                                          delay:0.0
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                     animations:animationBlock
                                                     completion:nil];
}
*/
