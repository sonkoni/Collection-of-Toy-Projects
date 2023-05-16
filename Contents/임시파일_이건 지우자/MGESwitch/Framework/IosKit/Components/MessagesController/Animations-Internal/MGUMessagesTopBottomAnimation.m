//
//  MGUMessagesTopBottomAnimation.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesTopBottomAnimation.h"
#import "MGUMessagesController.h"
#import "MGUMessagesBaseView.h"
#import "MGUMessagesCornerRoundingView.h"

@interface MGUMessagesTopBottomAnimation ()
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGestureRecognizer;  // lazy
@property (nonatomic, assign) CGFloat bounceOffset; // 디폴트 : 5.0
@property (nonatomic, assign) BOOL closing; // 디폴트 : NO
@property (nonatomic, assign) BOOL rubberBanding; // 디폴트 : NO
@property (nonatomic, assign) CGFloat closeSpeed; // 디폴트 : 0.0
@property (nonatomic, assign) CGFloat closePercent; // 디폴트 : 0.0
@property (nonatomic, assign) CGFloat panTranslationY; // 디폴트 : 0.0
@end

@implementation MGUMessagesTopBottomAnimation

#pragma mark - 생성 & 소멸
- (instancetype)initWithStyle:(MGUMessagesTopBottomAnimationStyle)style {
    return [self initWithStyle:style delegate:nil];
}

- (instancetype)initWithStyle:(MGUMessagesTopBottomAnimationStyle)style delegate:(id<MGUMessagesAnimationDelegate>)delegate {
    self = [super init];
    if (self) {
        _style = style;
        _delegate = delegate;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUMessagesTopBottomAnimation *self) {
    self->_showDuration = 0.4;
    self->_hideDuration = 0.2;
    self->_springDamping = 0.8;
    self->_closeSpeedThreshold = 750.0;
    self->_closePercentThreshold = 0.33;
    self->_closeAbsoluteThreshold = 75.0;
    
    self->_bounceOffset = 5.0;
    self->_closing = NO;
    self->_rubberBanding = NO;
    self->_closeSpeed = 0.0;
    self->_closePercent = 0.0;
    self->_panTranslationY = 0.0;
}


#pragma mark - 세터 & 게터
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _panGestureRecognizer;
}


#pragma mark - Action
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.messageView == nil) {
            return;
        }
        
        CGFloat height = self.messageView.bounds.size.height - self.bounceOffset;
        if (height <= 0.0) {
            return;
        }
        CGPoint velocity = [panGestureRecognizer velocityInView:self.messageView];
        CGPoint translation = [panGestureRecognizer translationInView:self.messageView];
        if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
            velocity.y *= -1.0;
            translation.y *= -1.0;
        }
        CGFloat translationAmount = translation.y >= 0 ? translation.y : -pow(ABS(translation.y), 0.7);
        
        if (self.closing == NO) {
            MGUMessagesBaseView *baseView = (MGUMessagesBaseView *)(self.messageView);
            if ([baseView isKindOfClass:[MGUMessagesBaseView class]] == YES && baseView.backgroundView != self.messageView) {
                if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
                    self.rubberBanding = CGRectGetMinY(baseView.backgroundView.frame) > 0;
                } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
                    self.rubberBanding = CGRectGetMaxY(baseView.backgroundView.frame) < CGRectGetHeight(self.messageView.bounds);
                } else {
                    NSCAssert(FALSE, @"잘못들어왔다.");
                }
            }
            
            if (self.rubberBanding == NO && translationAmount < 0.0) {
                return;
            }
            self.closing = YES;
            [self.delegate panStartedAnimator:self];
        } else {
        }
        
        if (self.rubberBanding == NO && translationAmount < 0.0) {
            translationAmount = 0.0;
        }
        
        if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
            self.messageView.transform = CGAffineTransformMakeTranslation(0.0, -translationAmount);
        } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
            self.messageView.transform = CGAffineTransformMakeTranslation(0.0, translationAmount);
        } else {
            NSCAssert(FALSE, @"잘못들어왔다.");
        }

        self.closeSpeed = velocity.y;
        self.closePercent = translation.y / height;
        self.panTranslationY = translation.y;

    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        if (self.closeSpeed > self.closeSpeedThreshold ||
            self.closePercent > self.closePercentThreshold ||
            self.panTranslationY > self.closeAbsoluteThreshold) {
            [self.delegate hideAnimator:self];
        } else {
            self.closing = NO;
            self.rubberBanding = NO;
            self.closeSpeed = 0.0;
            self.closePercent = 0.0;
            self.panTranslationY = 0.0;
            
            [self showAnimationCompletion:^(BOOL completed) {
                [self.delegate panEndedAnimator:self];
            }];
        }
    }
}

- (void)installContext:(MGUMessagesAnimationContext *)context {
    UIView *view = context.messageView;
    UIView *container = context.containerView;
    self.messageView = view;
    self.containerView = container;
    self.context = context;
    
    UIView <MGUMessagesMarginAdjustable>*adjustable = (UIView <MGUMessagesMarginAdjustable>*)view;
    if ([adjustable conformsToProtocol:@protocol(MGUMessagesMarginAdjustable)]) {
        self.bounceOffset = adjustable.bounceAnimationOffset;
    }
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:view];
    [view.leadingAnchor constraintEqualToAnchor:container.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:container.trailingAnchor].active = YES;
        
    if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
        NSLayoutConstraint *constraint = [view.topAnchor constraintEqualToAnchor:container.topAnchor constant:-self.bounceOffset];
        constraint.priority = 200;
        constraint.active = YES;
    } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
        NSLayoutConstraint *constraint = [view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:self.bounceOffset];
        constraint.priority = 200;
        constraint.active = YES;
    }
    
    // Important to layout now in order to get the right safe area insets
    [container layoutIfNeeded];
    [self adjustMargins:nil];
    [container layoutIfNeeded];
    CGFloat animationDistance = view.frame.size.height;
    
    if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
        view.transform = CGAffineTransformMakeTranslation(0.0, -animationDistance);
    } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
        view.transform = CGAffineTransformMakeTranslation(0.0, animationDistance);
    }
    
    if (context.interactiveHide == YES) {
        MGUMessagesBaseView *baseView = (MGUMessagesBaseView *)view;
        if ([baseView isKindOfClass:[MGUMessagesBaseView class]] == YES) {
            [baseView.backgroundView addGestureRecognizer:self.panGestureRecognizer];
        } else {
            [view addGestureRecognizer:self.panGestureRecognizer];
        }
    }
    
    MGUMessagesBaseView *baseView = (MGUMessagesBaseView *)view;
    MGUMessagesCornerRoundingView *cornerRoundingView = (MGUMessagesCornerRoundingView *)(baseView.backgroundView);
    if ([baseView isKindOfClass:[MGUMessagesBaseView class]] == YES &&
        [cornerRoundingView isKindOfClass:[MGUMessagesCornerRoundingView class]] == YES &&
        cornerRoundingView.roundsLeadingCorners == YES) {
        
        if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
            cornerRoundingView.roundedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
            cornerRoundingView.roundedCorners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
    }
}

// 내가 보낼 수도 있다.
- (void)adjustMargins:(NSNotification * _Nullable)notification {
    UIView <MGUMessagesMarginAdjustable>*adjustable = (UIView <MGUMessagesMarginAdjustable>*)(self.messageView);
    if ([adjustable conformsToProtocol:@protocol(MGUMessagesMarginAdjustable)] == NO || self.context == nil) {
        return;
    }
    
    adjustable.preservesSuperviewLayoutMargins = NO;
    adjustable.insetsLayoutMarginsFromSafeArea = NO;
    
    UIEdgeInsets layoutMargins = [adjustable defaultMarginAdjustmentWithContext:self.context];
    
    if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
        layoutMargins.top += self.bounceOffset;
    } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {
        layoutMargins.bottom += self.bounceOffset;
    }
    
    adjustable.layoutMargins = layoutMargins;
}

- (void)showAnimationCompletion:(void (^)(BOOL completed))completion { // escaping
    if (self.messageView == nil) {
        if (completion == nil) {
            NSCAssert(FALSE, @"completion 이어서는 안된다.");
        } else {
            completion(NO);
        }
        return;
    }
        
    CGFloat animationDistance = ABS(self.messageView.transform.tx);
        
    CGFloat initialSpringVelocity = animationDistance == 0.0 ? 0.0 : MIN(0.0, self.closeSpeed / animationDistance);
    
    [UIView animateWithDuration:self.showDuration
                          delay:0.0
         usingSpringWithDamping:self.springDamping
          initialSpringVelocity:initialSpringVelocity
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ self.messageView.transform = CGAffineTransformIdentity; }
                     completion:^(BOOL finished) {
        completion(finished || [UIApplication sharedApplication].applicationState != UIApplicationStateActive);
    }];
}


#pragma mark - <MGUMessagesAnimator>
- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustMargins:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self installContext:context];
    [self showAnimationCompletion:completion];
}

- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIView *view = context.messageView;
    self.context = context;
    
    [UIView animateWithDuration:self.hideDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:^{
        if (self.style == MGUMessagesTopBottomAnimationStyleTop) {
            view.transform = CGAffineTransformMakeTranslation(0.0, -view.frame.size.height);
        } else if (self.style == MGUMessagesTopBottomAnimationStyleBottom) {

            view.transform = CGAffineTransformMakeTranslation(0.0, CGRectGetMaxY(view.frame) + view.frame.size.height);
        }
    }
                     completion:^(BOOL finished) {
        completion(finished || [UIApplication sharedApplication].applicationState != UIApplicationStateActive);
    }];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
