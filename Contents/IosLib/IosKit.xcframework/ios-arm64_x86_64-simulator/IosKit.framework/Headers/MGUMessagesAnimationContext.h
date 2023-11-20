//
//  MGUMessagesAnimationContext.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MGUMessagesAnimator;
@class MGUMessagesAnimationContext;

NS_ASSUME_NONNULL_BEGIN

@protocol MGUMessagesAnimationDelegate <NSObject>
@optional
@required
- (void)hideAnimator:(id <MGUMessagesAnimator>)animator;
- (void)panStartedAnimator:(id <MGUMessagesAnimator>)animator;
- (void)panEndedAnimator:(id <MGUMessagesAnimator>)animator;
@end

@protocol MGUMessagesAnimator <NSObject>
@optional
@required

- (id<MGUMessagesAnimationDelegate> _Nullable)delegate;
- (void)setDelegate:(id<MGUMessagesAnimationDelegate> _Nullable)delegate;

- (void)showContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping
- (void)hideContext:(MGUMessagesAnimationContext *)context completion:(void (^)(BOOL completed))completion; // escaping

- (NSTimeInterval)showDuration;
- (NSTimeInterval)hideDuration;
@end


#pragma mark - NS_OPTIONS
typedef NS_OPTIONS(NSUInteger, MGUMessagesSafeZoneConflicts) {
//    MGUMessagesSafeZoneConflictsStatusBar = 0,
    MGUMessagesSafeZoneConflictsStatusBar = 1 << 0,
    MGUMessagesSafeZoneConflictsSensorNotch = 1 << 1,
    MGUMessagesSafeZoneConflictsHomeIndicator = 1 << 2,
    MGUMessagesSafeZoneConflictsOverStatusBar = 1 << 3
};

@interface MGUMessagesAnimationContext : NSObject
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) MGUMessagesSafeZoneConflicts safeZoneConflicts;
@property (nonatomic, assign) BOOL interactiveHide;

- (instancetype)initWithMessageView:(UIView *)messageView
                      containerView:(UIView *)containerView
                  safeZoneConflicts:(MGUMessagesSafeZoneConflicts)safeZoneConflicts
                    interactiveHide:(BOOL)interactiveHide;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END


//public typealias AnimationCompletion = (_ completed: Bool) -> Void
//
