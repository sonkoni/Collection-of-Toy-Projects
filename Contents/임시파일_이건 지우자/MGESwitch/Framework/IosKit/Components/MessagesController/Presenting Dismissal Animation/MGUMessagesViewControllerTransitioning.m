//
//  MGUMessagesViewControllerTransitioning.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/28.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesViewControllerTransitioning.h"
#import "MGUMessagesTransitioningPresenter.h"
#import "MGUMessagesTransitioningDismisser.h"
#import "MGUMessagesConfig.h"
#import "MGUMessageView.h"
#import "MGUMessagesCornerRoundingView.h"
#import "MGUMessagesViewController.h"
#import "MGUMessagesTopBottomAnimation.h"
#import "MGUMessagesPresenter.h"
#import "MGUMessagesController.h"

@interface MGUMessagesViewControllerTransitioning ()
@property (nonatomic, strong) MGUMessagesTransitioningDismisser *transitioningDismisser; // lazy
@property (nonatomic, weak) UIViewController *source;
@property (nonatomic, weak) UIViewController *destination;
@end

@implementation MGUMessagesViewControllerTransitioning
//! lazy
- (MGUMessagesTransitioningDismisser *)transitioningDismisser {
    if (_transitioningDismisser == nil) {
        _transitioningDismisser = [[MGUMessagesTransitioningDismisser alloc] init];
        _transitioningDismisser.owner = self;
    }
    return _transitioningDismisser;
}

//! lazy
- (MGUMessagesPresenter *)presenter {
    if (_presenter == nil) {
        _presenter = [[MGUMessagesPresenter alloc] initWithConfig:self.messages.defaultConfig
                                                  view:self.messageView
                                              delegate:self.messages];
    }
    return _presenter;
}


- (instancetype)initWithSource:(UIViewController *)source destination:(UIViewController *)destination {
    self = [super init];
    if (self) {
        _source = source;
        _destination = destination;
        CommonInit(self);
        
    }
    return self;
}

static void CommonInit(MGUMessagesViewControllerTransitioning *self) {
    self->_containment = MGUMessagesContainmentContent;
    self->_overrideModalPresentationStyle = YES;
    self->_messages = [MGUMessagesController new];
    self->_messageView = [MGUMessagesBaseView new];
    self->_containerView = [MGUMessagesCornerRoundingView new];
    
    MGUMessagesConfig *config = self.messages.defaultConfig;
    config.dimMode = MGUMessagesDimModeGray;
    config.dimModeInteractive = YES;
    config.duration = MGUMessagesPresentationDurationForever;
}

- (void)configureLayout:(MGUMessagesTransitioningLayout)layout {
    self.messageView.bounceAnimationOffset = 0.0;
    self.containment = MGUMessagesContainmentContent;
    self.containerView.cornerRadius = 0.0;
    self.containerView.roundsLeadingCorners = NO;
    [self.messageView configureDropShadow];
        
    MGUMessagesConfig *config = self.messages.defaultConfig;
    
    if (layout == MGUMessagesTransitioningLayoutTopMessage) {
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
        self.messageView.collapseLayoutMarginAdditions = NO;
        MGUMessagesTopBottomAnimation *animation = [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleTop];
        animation.springDamping = 1.0;
        config.presentationStyle = MGUMessagesPresentationStyleCustom;
        config.animator = animation;
    } else if (layout == MGUMessagesTransitioningLayoutBottomMessage) {
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
        self.messageView.collapseLayoutMarginAdditions = NO;
        MGUMessagesTopBottomAnimation *animation = [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleBottom];
        animation.springDamping = 1.0;
        config.presentationStyle = MGUMessagesPresentationStyleCustom;
        config.animator = animation;
    } else if (layout == MGUMessagesTransitioningLayoutTopCard) {
        self.containment = MGUMessagesContainmentBackground;
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        self.messageView.collapseLayoutMarginAdditions = YES;
        self.containerView.cornerRadius = 15.0;
        config.presentationStyle = MGUMessagesPresentationStyleTop;
    } else if (layout == MGUMessagesTransitioningLayoutBottomCard) {
        self.containment = MGUMessagesContainmentBackground;
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        self.messageView.collapseLayoutMarginAdditions = YES;
        self.containerView.cornerRadius = 15.0;
        config.presentationStyle = MGUMessagesPresentationStyleBottom;
    } else if (layout == MGUMessagesTransitioningLayoutTopTab) {
        self.containment = MGUMessagesContainmentBackgroundVertical;
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0);
        self.messageView.collapseLayoutMarginAdditions = YES;
        self.containerView.cornerRadius = 15.0;
        self.containerView.roundsLeadingCorners = YES;
        MGUMessagesTopBottomAnimation *animation = [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleTop];
        animation.springDamping = 1.0;
        config.presentationStyle = MGUMessagesPresentationStyleCustom;
        config.animator = animation;
    } else if (layout == MGUMessagesTransitioningLayoutBottomTab) {
        self.containment = MGUMessagesContainmentBackgroundVertical;
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(20.0, 10.0, 20.0, 10.0);
        self.messageView.collapseLayoutMarginAdditions = YES;
        self.containerView.cornerRadius = 15.0;
        self.containerView.roundsLeadingCorners = YES;
        MGUMessagesTopBottomAnimation *animation = [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleBottom];
        animation.springDamping = 1.0;
        config.presentationStyle = MGUMessagesPresentationStyleCustom;
        config.animator = animation;
    } else if (layout == MGUMessagesTransitioningLayoutCentered) {
        self.containment = MGUMessagesContainmentBackground;
        self.messageView.layoutMarginAdditions = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        self.messageView.collapseLayoutMarginAdditions = YES;
        self.containerView.cornerRadius = 15.0;
        config.presentationStyle = MGUMessagesPresentationStyleCenter;
    }
}


#pragma mark - Action
- (void)perform {
    MGUMessagesViewController *windowViewController = (MGUMessagesViewController *)(self.source);
    if ([windowViewController isKindOfClass:[MGUMessagesViewController class]] == YES) {
        [windowViewController install];
    }
    if (self.overrideModalPresentationStyle == YES) {
        self.destination.modalPresentationStyle = UIModalPresentationCustom;
    }
    self.destination.transitioningDelegate = self;
    [self.source presentViewController:self.destination animated:YES completion:nil];
}



#pragma mark - <UIViewControllerTransitioningDelegate>
//! 등장할때 호출 1.
//- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
//                                                      presentingViewController:(UIViewController *)presenting
//                                                          sourceViewController:(UIViewController *)source {
//
//    MGRPresentationController *presentationController = [[MGRPresentationController alloc] initWithPresentedViewController:presented
//                                                                                                  presentingViewController:presenting];
//
//    presentationController.backgroundTapDismissalGestureEnabled = self.configuration.backgroundTapDismissalGestureEnabled;
//    presentationController.transitionStyle = self.configuration.transitionStyle;
//    return presentationController;
//}

//! 등장할때 호출 2.
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    MGUMessagesTransitioningPresenter *transitioningPresenter = [[MGUMessagesTransitioningPresenter alloc] init];
    transitioningPresenter.owner = self;
    
    
    __weak __typeof(self) weakSelf = self;
    MGUMessagesEventListener listener = ^(MGUMessagesEvent event) {
        if (event == MGUMessagesEventDidShow) {
            if (transitioningPresenter.completeTransition != nil) {
                transitioningPresenter.completeTransition(YES);
            }
        } else if (event == MGUMessagesEventDidHide) {
            if (weakSelf.transitioningDismisser.completeTransition != nil) {
                weakSelf.transitioningDismisser.completeTransition(YES);
            } else {
                // Case where message is internally hidden by MGUMessages, such as with a
                // dismiss gesture, rather than by view controller dismissal.
                [source dismissViewControllerAnimated:NO completion:nil];
            }
            
            MGUMessagesViewController *windowViewController = (MGUMessagesViewController *)source;
            if ([windowViewController isKindOfClass:[MGUMessagesViewController class]] == YES) {
                [windowViewController uninstall];
            }
//            self.selfRetainer = nil
        }
    };
    

    MGUMessagesController *messages = self.messages;
    NSMutableArray <MGUMessagesEventListener>*eventListeners = messages.defaultConfig.eventListeners;
    [eventListeners addObject:listener];
    
    return transitioningPresenter;
}

//! 사라질때 호출
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitioningDismisser;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
