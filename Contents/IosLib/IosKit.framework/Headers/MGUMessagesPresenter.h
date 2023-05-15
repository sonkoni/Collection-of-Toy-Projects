//
//  MGUMessagesPresenter.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <IosKit/MGUMessagesAnimationContext.h>
@class MGUMessagesPresenter;
@class MGUMessagesConfig;
@class MGUMessagesMaskingView;

NS_ASSUME_NONNULL_BEGIN

@protocol MGUMessagesPresenterDelegate <MGUMessagesAnimationDelegate>
@optional
@required
//- (void)hideAnimator:(id <MGUMessagesAnimator>)animator;
//- (void)panStartedAnimator:(id <MGUMessagesAnimator>)animator;
//- (void)panEndedAnimator:(id <MGUMessagesAnimator>)animator;
- (void)hidePresenter:(MGUMessagesPresenter *)presenter;
@end

@interface MGUMessagesPresenter : NSObject

@property (nonatomic, assign, getter=isHiding) BOOL hiding; // 디폴트 NO
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) MGUMessagesConfig *config;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) MGUMessagesMaskingView *maskingView;
@property (nonatomic, strong) id <MGUMessagesAnimator>animator;
@property (nonatomic, assign) CFTimeInterval showDate; // nullable
@property (nonatomic, assign, readonly) NSTimeInterval pauseDuration; // @dynamic nullable 튀어나와서 얼마나 멈춰있는가.
@property (nonatomic, assign, readonly) NSTimeInterval delayHide; // @dynamic nullable
@property (nonatomic, assign, readonly) NSTimeInterval delayShow; // @dynamic nullable

- (BOOL)showCompletion:(void (^)(BOOL completed))completion error:(NSError * _Nullable *)error;
- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL completed))completion;

- (instancetype)initWithConfig:(MGUMessagesConfig *)config
                          view:(UIView *)view
                      delegate:(id<MGUMessagesPresenterDelegate>)delegate;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
