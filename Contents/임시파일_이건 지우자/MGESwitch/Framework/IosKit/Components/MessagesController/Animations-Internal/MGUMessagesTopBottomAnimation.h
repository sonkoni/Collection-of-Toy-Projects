//
//  MGUMessagesTopBottomAnimation.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGUMessagesAnimationContext.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @enum       MGUMessagesTopBottomAnimationStyle
 @abstract   ......
 @constant   MGUMessagesTopBottomAnimationStyleTop     .....
 @constant   MGUMessagesTopBottomAnimationStyleBottom   .....
 */
typedef NS_ENUM(NSUInteger, MGUMessagesTopBottomAnimationStyle) {
    MGUMessagesTopBottomAnimationStyleTop = 1,
    MGUMessagesTopBottomAnimationStyleBottom
};

@interface MGUMessagesTopBottomAnimation : NSObject <MGUMessagesAnimator>

@property (nonatomic, assign) MGUMessagesTopBottomAnimationStyle style;
@property (nonatomic, assign) CGFloat springDamping; // 디폴트 : 0.8
@property (nonatomic, assign) CGFloat closeSpeedThreshold; // 디폴트 : 750.0
@property (nonatomic, assign) CGFloat closePercentThreshold; // 디폴트 : 0.33
@property (nonatomic, assign) CGFloat closeAbsoluteThreshold; // 디폴트 : 75.0

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, weak, nullable) UIView *messageView;
@property (nonatomic, weak, nullable) UIView *containerView;
@property (nonatomic, strong, nullable) MGUMessagesAnimationContext *context;

- (instancetype)initWithStyle:(MGUMessagesTopBottomAnimationStyle)style;
- (instancetype)initWithStyle:(MGUMessagesTopBottomAnimationStyle)style delegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id <MGUMessagesAnimationDelegate>delegate;
@property (nonatomic, assign) NSTimeInterval showDuration; // 디폴트 : 0.4
@property (nonatomic, assign) NSTimeInterval hideDuration; // 디폴트 : 0.2

//- (id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//- (void)setDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate;
//- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
//- (NSTimeInterval)showDuration;
//- (NSTimeInterval)hideDuration;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
