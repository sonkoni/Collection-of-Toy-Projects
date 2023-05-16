//
//  MGUMessagesPhysicsAnimation.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesPhysicsAnimation.h"
#import "MGUMessagesPhysicsPanHandler.h"
#import "MGUMessagesBaseView.h"

@interface MGUMessagesPhysicsAnimation ()
@end

@implementation MGUMessagesPhysicsAnimation

- (instancetype)init {
    return [self initWithDelegate:nil];
}

#pragma mark - 생성 & 소멸
- (instancetype)initWithDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUMessagesPhysicsAnimation *self) {
    self->_placement = MGUMessagesPhysicsAnimationPlacementCenter;
    self->_showDuration = 0.5;
    self->_hideDuration = 0.15;
    self->_panHandler = [MGUMessagesPhysicsPanHandler new];
}


#pragma mark - Action
- (void)installContext:(MGUMessagesAnimationContext *)context {
    UIView *view = context.messageView;
    UIView *container = context.containerView;
    self.messageView = view;
    self.containerView = container;
    self.context = context;
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:view];
    
    if (self.placement == MGUMessagesPhysicsAnimationPlacementCenter) {
        NSLayoutConstraint *constraint = [view.centerYAnchor constraintEqualToAnchor:container.centerYAnchor];
        constraint.priority = 200;
        constraint.active = YES;
    } else if (self.placement == MGUMessagesPhysicsAnimationPlacementTop) {
        NSLayoutConstraint *constraint = [view.topAnchor constraintEqualToAnchor:container.topAnchor];
        constraint.priority = 200;
        constraint.active = YES;
    } else if (self.placement == MGUMessagesPhysicsAnimationPlacementBottom) {
        NSLayoutConstraint *constraint = [view.bottomAnchor constraintEqualToAnchor:container.bottomAnchor];
        constraint.priority = 200;
        constraint.active = YES;
    }
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:container
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0].active = YES;
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:container
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    // Important to layout now in order to get the right safe area insets
    [container layoutIfNeeded];
    [self adjustMargins:nil];
    [container layoutIfNeeded];
    [self installInteractiveContext:context];
}

// 내가 보낼 수도 있다.
- (void)adjustMargins:(NSNotification * _Nullable)notification {
    UIView <MGUMessagesMarginAdjustable>*adjustable = (UIView <MGUMessagesMarginAdjustable>*)(self.messageView);
    if ([adjustable conformsToProtocol:@protocol(MGUMessagesMarginAdjustable)] == NO || self.context == nil) {
        return;
    }
    
    adjustable.preservesSuperviewLayoutMargins = NO;
    adjustable.insetsLayoutMarginsFromSafeArea = NO;
    
    adjustable.layoutMargins = [adjustable defaultMarginAdjustmentWithContext:self.context];
}

- (void)installInteractiveContext:(MGUMessagesAnimationContext *)context {
    if (context.interactiveHide == YES) {
        [self.panHandler configureContext:context animator:self];
    }
}

- (void)showAnimationContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion {
    UIView *view = context.messageView;
    view.alpha = 0.25;
    view.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completion != nil) {
            completion(YES);
        } else {
            NSCAssert(FALSE, @"블락이 닐이다.");
        }
    }];
    
    [UIView animateWithDuration:self.showDuration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ view.transform = CGAffineTransformIdentity; }
                     completion:nil];
    
    [UIView animateWithDuration:0.3 * self.showDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ view.alpha = 1.0; }
                     completion:nil];
    [CATransaction commit];
}


#pragma mark - <MGUMessagesAnimator>
- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustMargins:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self installContext:context];
    [self showAnimationContext:context completion:completion];
}

- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.panHandler.isOffScreen == YES) {
        context.messageView.alpha = 0.0;
        [self.panHandler.state stop];
    }
    
    UIView *view = context.messageView;
    self.context = context;
    
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        view.alpha = 1.0;
        view.transform = CGAffineTransformIdentity;
        if (completion != nil) {
            completion(YES);
        } else {
            NSCAssert(FALSE, @"블락이 nil 이다.");
        }
    }];
    
    
    [UIView animateWithDuration:self.hideDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ view.transform = CGAffineTransformMakeScale(0.8, 0.8); }
                     completion:nil];
    
    [UIView animateWithDuration:self.hideDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{ view.alpha = 0.0; }
                     completion:nil];
    [CATransaction commit];
}


@end


//- (id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//- (void)setDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//
//- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//
//- (NSTimeInterval)showDuration;
//- (NSTimeInterval)hideDuration;
