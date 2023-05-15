//
//  MGUMessagesViewControllerTransitioning.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/28.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesBaseView;
@class MGUMessagesController;
@class MGUMessagesPresenter;
@class MGUMessagesCornerRoundingView;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUMessagesTransitioningLayout) {
    MGUMessagesTransitioningLayoutTopMessage = 1, // 0은 피하는 것이 좋다.
    MGUMessagesTransitioningLayoutBottomMessage,
    MGUMessagesTransitioningLayoutTopCard,
    MGUMessagesTransitioningLayoutTopTab,
    MGUMessagesTransitioningLayoutBottomCard,
    MGUMessagesTransitioningLayoutBottomTab,
    MGUMessagesTransitioningLayoutCentered
};

typedef NS_ENUM(NSUInteger, MGUMessagesContainment) {
    MGUMessagesContainmentContent = 1, // 0은 피하는 것이 좋다.
    MGUMessagesContainmentBackground,
    MGUMessagesContainmentBackgroundVertical
};

@interface MGUMessagesViewControllerTransitioning : NSObject <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) MGUMessagesController *messages;
@property (nonatomic, strong) MGUMessagesBaseView *messageView;
@property (nonatomic, strong) MGUMessagesCornerRoundingView *containerView;
@property (nonatomic, strong) MGUMessagesPresenter *presenter; // lazy

@property (nonatomic, assign) MGUMessagesContainment containment; // 디폴트 MGUMessagesContainmentContent
@property (nonatomic, assign) BOOL overrideModalPresentationStyle; // 디폴트 YES

- (void)configureLayout:(MGUMessagesTransitioningLayout)layout;

- (void)perform;


- (instancetype)initWithSource:(UIViewController *)source destination:(UIViewController *)destination;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END


