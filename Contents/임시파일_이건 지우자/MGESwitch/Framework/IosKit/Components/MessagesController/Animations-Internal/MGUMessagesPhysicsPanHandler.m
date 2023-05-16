//
//  MGUMessagesPhysicsPanHandler.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUMessagesPhysicsPanHandler.h"
#import "MGUMessagesBaseView.h"
#import "MGUMessagesAnimationContext.h"


@interface MGUMessagesPhysicsPanHandler ()
@property (nonatomic, strong, readwrite, nullable) MGUMessagesPhysicsPanHandlerState *state; // 내부에서는 세팅가능함.
@property (nonatomic, assign, readwrite) BOOL isOffScreen; // 디폴트 NO. 내부에서는 세팅가능함.
@property (nonatomic, assign) CGPoint restingCenter; // 널러블.
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGestureRecognizer;  // lazy
@end

@implementation MGUMessagesPhysicsPanHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        CommonInit(self);
    }
    return self;
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesPhysicsPanHandler *self) {
    self->_hideDelay = 0.2;
    self->_isOffScreen = NO;
    self->_restingCenter = MGEPointNull;
}


#pragma mark - 세터 & 게터
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _panGestureRecognizer;
}


#pragma mark - Action
- (void)configureContext:(MGUMessagesAnimationContext *)context animator:(id <MGUMessagesAnimator>)animator {
    MGUMessagesBaseView *oldView = (MGUMessagesBaseView *)(self.messageView);
    if (oldView != nil) {
        if ( [oldView isKindOfClass:[MGUMessagesBaseView class]] == YES && oldView.backgroundView != nil) {
            [oldView.backgroundView removeGestureRecognizer:self.panGestureRecognizer];
        } else {
            [oldView removeGestureRecognizer:self.panGestureRecognizer];
        }
    }
    
    self.messageView = context.messageView;
    
    MGUMessagesBaseView *view = (MGUMessagesBaseView *)(self.messageView);
    if ([view isKindOfClass:[MGUMessagesBaseView class]] == YES && view.backgroundView != nil) {
        view = (id)(view.backgroundView);
    }

    [view addGestureRecognizer:self.panGestureRecognizer];
    self.containerView = context.containerView;
    self.animator = animator;
}

- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.messageView == nil ||
        self.containerView == nil ||
        self.animator == nil) {
        return;
    }
    
    CGPoint anchorPoint = [panGestureRecognizer locationInView:self.containerView];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator.delegate panStartedAnimator:self.animator];
        
        MGUMessagesPhysicsPanHandlerState *state = [[MGUMessagesPhysicsPanHandlerState alloc] initWithMessageView:self.messageView containerView:self.containerView];
        self.state = state;
        CGPoint center = self.messageView.center;
        self.restingCenter = center;
        UIOffset offset = UIOffsetMake(anchorPoint.x - center.x, anchorPoint.y - center.y);
        UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.messageView
                                                                             offsetFromCenter:offset
                                                                             attachedToAnchor:anchorPoint];
        
        state.attachmentBehavior = attachmentBehavior;
        
        __weak __typeof(self) weakSelf = self;
        
        state.itemBehavior.action = ^{
            if (weakSelf == nil ||
                weakSelf.isOffScreen == YES ||
                weakSelf.messageView == nil ||
                weakSelf.containerView == nil ||
                weakSelf.animator == nil) {
                return;
            }
            
            UIView *view = weakSelf.messageView;
            if ([view isKindOfClass:[MGUMessagesBaseView class]] == YES) {
                UIView *temp = ((MGUMessagesBaseView *)(weakSelf.messageView)).backgroundView;
                if (temp != nil) {
                    view = temp;
                }
            }
            
            CGRect frame = [weakSelf.containerView convertRect:view.bounds fromView:view];
            if (CGRectIntersectsRect(weakSelf.containerView.bounds, frame) == NO) {
                weakSelf.isOffScreen = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(weakSelf.hideDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.animator.delegate hideAnimator:weakSelf.animator];
                });
            }
        };
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (self.state != nil) {
            [self.state updateAttachmentAnchorPoint:anchorPoint];
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.state != nil) {
            
            [self.state updateAttachmentAnchorPoint:anchorPoint];
            CGPoint velocity = [panGestureRecognizer velocityInView:self.containerView];
            CGFloat angularVelocity = self.state.angularVelocity;
            CGFloat speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
            // The multiplier on angular velocity was determined by hand-tuning
            CGFloat energy = sqrt(pow(speed, 2) + pow(angularVelocity * 75, 2));
            if (energy > 200.0 && speed > 600.0) {
                // Limit the speed and angular velocity to reasonable values
                CGFloat speedScale = speed > 0.0 ? MIN(1.0, 1800.0 / speed) : 1.0;
                CGPoint escapeVelocity = CGPointMake(velocity.x * speedScale, velocity.y * speedScale);
                CGFloat angularSpeedScale = MIN(1.0, 10.0 / ABS(angularVelocity));
                CGFloat escapeAngularVelocity = angularVelocity * angularSpeedScale;
                [self.state.itemBehavior addLinearVelocity:escapeVelocity forItem:self.messageView];
                [self.state.itemBehavior addAngularVelocity:escapeAngularVelocity forItem:self.messageView];
                self.state.attachmentBehavior = nil;
            } else {
                [self.state stop];
                self.state = nil;
                [self.animator.delegate panEndedAnimator:self.animator];
                
                [UIView animateWithDuration:0.5
                                      delay:0.0
                     usingSpringWithDamping:0.65
                      initialSpringVelocity:0.0
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                    
                    if (MGEPointIsNull(self.restingCenter) == NO) {
                        self.messageView.center = self.restingCenter;
                    } else {
                        self.messageView.center = CGPointMake(self.containerView.bounds.size.width / 2.0,
                                                              self.containerView.bounds.size.height / 2.0);
                    }
                    
                    self.messageView.transform = CGAffineTransformIdentity;
                }
                                 completion:NULL];
                
                
            }
            
        }
    }
}

@end


//!----------------------------------------------------------------------------------------------------------------
@implementation MGUMessagesPhysicsPanHandlerState
@dynamic angularVelocity;

- (CGFloat)angularVelocity {
    if (self.snapshots.lastObject == nil) {
        return 0.0;
    }
    
    for (MGUMessagesMotionSnapshot *previous in self.snapshots.reverseObjectEnumerator) {
        // Ignore snapshots where the angle or time hasn't changed to avoid degenerate cases.
        if (previous.angle != self.snapshots.lastObject.angle &&
            previous.time != self.snapshots.lastObject.time) {
            return (self.snapshots.lastObject.angle - previous.angle) / (CGFloat)(self.snapshots.lastObject.time - previous.time);
        }
    }

    return 0.0;
}

- (instancetype)initWithMessageView:(UIView *)messageView containerView:(UIView *)containerView {
    self = [super init];
    if (self) {
        _snapshots = [NSMutableArray array];
        self.messageView = messageView;
        self.containerView = containerView;
        UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[messageView]];
        itemBehavior.allowsRotation = YES;
        [dynamicAnimator addBehavior:itemBehavior];
        
        self.itemBehavior = itemBehavior;
        self.dynamicAnimator = dynamicAnimator;
        
    }
    return self;
}

- (void)updateAttachmentAnchorPoint:(CGPoint)anchorPoint {
    [self addSnapshot];
    if (self.attachmentBehavior != nil) {
        self.attachmentBehavior.anchorPoint = anchorPoint;
    }
}

- (void)setAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior {
    UIAttachmentBehavior *oldValue = _attachmentBehavior;
    _attachmentBehavior = attachmentBehavior;
    
    if (oldValue != nil) {
        [self.dynamicAnimator removeBehavior:oldValue];
    }
    
    if (attachmentBehavior != nil) {
        [self.dynamicAnimator addBehavior:attachmentBehavior];
        [self addSnapshot];
    }
}

- (void)addSnapshot {
    CGFloat angle = 0.0;
    if (self.messageView != nil) {
        angle = atan2(self.messageView.transform.b, self.messageView.transform.a);
    } else if (self.snapshots.lastObject != nil) {
        angle = self.snapshots.lastObject.angle;
    }
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    [self.snapshots addObject:[[MGUMessagesMotionSnapshot alloc] initWithAngle:angle time:time]];
    
}

- (void)stop {
    if (self.messageView == nil) {
        [self.dynamicAnimator removeAllBehaviors];
        return;
    }
    
    CGPoint center = self.messageView.center;
    CGAffineTransform transform = self.messageView.transform;
    [self.dynamicAnimator removeAllBehaviors];
    self.messageView.center = center;
    self.messageView.transform = transform;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end


//!----------------------------------------------------------------------------------------------------------------
@implementation MGUMessagesMotionSnapshot
- (instancetype)init {
    return [self initWithAngle:0.0 time:0.0];
}
- (instancetype)initWithAngle:(CGFloat)angle time:(CFAbsoluteTime)time {
    self = [super init];
    if (self) {
        _angle = angle;
        _time = time;
    }
    return self;
}
@end
