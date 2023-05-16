//
//  MGUMessagesPhysicsAnimation.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGUMessagesAnimationContext.h"
@class MGUMessagesPhysicsPanHandler;

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGUMessagesPhysicsAnimationPlacement
 @abstract   ......
 @constant   MGUMessagesPhysicsAnimationPlacementTop     .....
 @constant   MGUMessagesPhysicsAnimationPlacementCenter     .....
 @constant   MGUMessagesPhysicsAnimationPlacementBottom   .....
 */
typedef NS_ENUM(NSUInteger, MGUMessagesPhysicsAnimationPlacement) {
    MGUMessagesPhysicsAnimationPlacementTop = 1,
    MGUMessagesPhysicsAnimationPlacementCenter,
    MGUMessagesPhysicsAnimationPlacementBottom
};


@interface MGUMessagesPhysicsAnimation : NSObject <MGUMessagesAnimator>

@property (nonatomic, assign) MGUMessagesPhysicsAnimationPlacement placement;  // 디폴트 : MGUMessagesPhysicsAnimationPlacementCenter
@property (nonatomic, strong) MGUMessagesPhysicsPanHandler *panHandler;
@property (nonatomic, weak, nullable) UIView *messageView;
@property (nonatomic, weak, nullable) UIView *containerView;
@property (nonatomic, strong, nullable) MGUMessagesAnimationContext *context;

- (instancetype)initWithDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id <MGUMessagesAnimationDelegate>delegate;
@property (nonatomic, assign) NSTimeInterval showDuration; // 디폴트 : 0.5
@property (nonatomic, assign) NSTimeInterval hideDuration; // 디폴트 : 0.15

//- (id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//- (void)setDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//- (NSTimeInterval)showDuration;
//- (NSTimeInterval)hideDuration;

@end

NS_ASSUME_NONNULL_END
