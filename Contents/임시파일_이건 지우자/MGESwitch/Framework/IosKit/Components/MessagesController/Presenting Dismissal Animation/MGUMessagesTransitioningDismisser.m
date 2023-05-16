//
//  MGUMessagesTransitioningDismisser.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/28.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUMessagesTransitioningDismisser.h"
#import "MGUMessagesViewControllerTransitioning.h"
#import "MGUMessagesConfig.h"
#import "MGUMessageView.h"
#import "MGUMessagesController.h"

@interface MGUMessagesTransitioningDismisser ()
@property (nonatomic, copy, nullable, readwrite) void (^completeTransition)(BOOL);
@end

@implementation MGUMessagesTransitioningDismisser

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    MGUMessagesController *messages = self.owner.messages;
    if (messages == nil) {
        [transitionContext completeTransition:NO];
        return;
    }
    
    self.completeTransition = ^(BOOL completed) { if(completed)
        [transitionContext completeTransition:completed];
    };
    
    [messages hideAnimated:YES];    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval hideDuration = self.owner.presenter.animator.hideDuration;
    if (MGEFloatIsNull(hideDuration) == NO) {
        return hideDuration;
    } else {
        return 0.5;
    }
}

@end
