//
//  MGUMessagesPhysicsPanHandler.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesAnimationContext;
@class MGUMessagesPhysicsPanHandlerState;
@class MGUMessagesMotionSnapshot;
@protocol MGUMessagesAnimator;

NS_ASSUME_NONNULL_BEGIN

@interface MGUMessagesPhysicsPanHandler : NSObject

@property (nonatomic, assign) NSTimeInterval hideDelay; // 디폴트 : 0.2

@property (nonatomic, weak, nullable) id <MGUMessagesAnimator>animator;
@property (nonatomic, weak, nullable) UIView *messageView;
@property (nonatomic, weak, nullable) UIView *containerView;
@property (nonatomic, strong, readonly, nullable) MGUMessagesPhysicsPanHandlerState *state; // 내부에서는 세팅가능함.
@property (nonatomic, assign, readonly) BOOL isOffScreen; // 디폴트 NO. 내부에서는 세팅가능함.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

- (void)configureContext:(MGUMessagesAnimationContext *)context animator:(id <MGUMessagesAnimator>)animator;
@end


//! MGUMessagesPhysicsPanHandler 에서만 사용됨.
@interface MGUMessagesPhysicsPanHandlerState : NSObject

@property (nonatomic, weak, nullable) UIView *messageView;
@property (nonatomic, weak, nullable) UIView *containerView;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong, nullable) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) NSMutableArray <MGUMessagesMotionSnapshot *>*snapshots;

@property (nonatomic, assign, readonly) CGFloat angularVelocity; // @dynamic

- (instancetype)initWithMessageView:(UIView * _Nullable)messageView
                      containerView:(UIView *)containerView NS_DESIGNATED_INITIALIZER;

- (void)updateAttachmentAnchorPoint:(CGPoint)anchorPoint;
- (void)stop;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end


@interface MGUMessagesMotionSnapshot : NSObject
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CFAbsoluteTime time;

- (instancetype)initWithAngle:(CGFloat)angle time:(CFAbsoluteTime)time NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
