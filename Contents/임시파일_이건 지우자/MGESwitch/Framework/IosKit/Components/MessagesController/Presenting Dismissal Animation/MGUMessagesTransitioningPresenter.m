//
//  MGUMessagesTransitioningPresenter.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/28.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import GraphicsKit;
#import "MGUMessagesTransitioningPresenter.h"
#import "MGUMessagesViewControllerTransitioning.h"
#import "MGUMessagesConfig.h"
#import "MGUMessageView.h"
#import "MGUMessagesCornerRoundingView.h"
#import "MGUMessagesPresenter.h"
#import "MGUMessagesController.h"


@interface MGUMessagesTransitioningPresenter ()
@property (nonatomic, copy, nullable, readwrite) void (^completeTransition)(BOOL);
@end


@implementation MGUMessagesTransitioningPresenter

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (self.owner == nil || toView == nil) {
        [transitionContext completeTransition:NO];
        return;
    }
    
    self.completeTransition = ^(BOOL completed) { if(completed)
        [transitionContext completeTransition:completed];
    };

//    segue.containerView.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
//    segue.containerView.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
//    segue.containerView.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
//    segue.containerView.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
    
    
    UIView *transitionContainer = [transitionContext containerView];
    toView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.owner.containerView addSubview:toView];
    [self.owner.containerView.topAnchor constraintEqualToAnchor:toView.topAnchor].active = YES;
    [self.owner.containerView.bottomAnchor constraintEqualToAnchor:toView.bottomAnchor].active = YES;
    [self.owner.containerView.leadingAnchor constraintEqualToAnchor:toView.leadingAnchor].active = YES;
    [self.owner.containerView.trailingAnchor constraintEqualToAnchor:toView.trailingAnchor].active = YES;
    
    // Install the `toView` into the message view.
    if (self.owner.containment == MGUMessagesContainmentContent) {
        [self.owner.messageView installContentView:self.owner.containerView insets:UIEdgeInsetsZero];
    } else if (self.owner.containment == MGUMessagesContainmentBackground) {
        [self.owner.messageView installBackgroundView:self.owner.containerView insets:UIEdgeInsetsZero];
    } else if (self.owner.containment == MGUMessagesContainmentBackgroundVertical) {
        [self.owner.messageView installBackgroundVerticalView:self.owner.containerView insets:UIEdgeInsetsZero];
    }
        
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC != nil) {
        CGFloat preferredHeight = toVC.preferredContentSize.height;
        if (preferredHeight > 0.0) {
            NSLayoutConstraint *constraint = [self.owner.containerView.heightAnchor constraintEqualToConstant:preferredHeight];
            constraint.priority = 951.0;
            constraint.active = YES;
            NSLog(@"preferredHeight %@ %f", toVC, preferredHeight);
        }
        
        CGFloat preferredWidth = toVC.preferredContentSize.width;
        if (preferredWidth > 0.0) {
            NSLayoutConstraint *constraint = [self.owner.containerView.widthAnchor constraintEqualToConstant:preferredWidth];
            constraint.priority = 951.0;
            constraint.active = YES;
        }
    }
    
    self.owner.presenter.config.presentationContext = MGUMessagesPresentationContextView;
    self.owner.presenter.config.view = transitionContainer;
    
    [self.owner.messages showPresenter:self.owner.presenter];
    
    //!---
    
        // Install the `toView` into the message view.
//        switch segue.containment {
//        case .content:
//            segue.messageView.installContentView(segue.containerView)
//        case .background:
//            segue.messageView.installBackgroundView(segue.containerView)
//        case .backgroundVertical:
//            segue.messageView.installBackgroundVerticalView(segue.containerView)
//        }
//        let toVC = transitionContext.viewController(forKey: .to)
//        if let preferredHeight = toVC?.preferredContentSize.height,
//            preferredHeight > 0 {
//            segue.containerView.heightAnchor.constraint(equalToConstant: preferredHeight).with(priority: UILayoutPriority(rawValue: 951)).isActive = true
//        }
//        if let preferredWidth = toVC?.preferredContentSize.width,
//            preferredWidth > 0 {
//            segue.containerView.widthAnchor.constraint(equalToConstant: preferredWidth).with(priority: UILayoutPriority(rawValue: 951)).isActive = true
//        }
//        segue.presenter.config.presentationContext = .view(transitionContainer)
//        segue.messenger.show(presenter: segue.presenter)
//
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval showDuration = self.owner.presenter.animator.showDuration;
    if (MGEFloatIsNull(showDuration) == NO) {
        return showDuration;
    } else {
        return 0.5;
    }
}

@end
