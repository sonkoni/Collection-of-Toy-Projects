//
//  JJFloatingActionButton+Animation.m
//  MGUFloatingButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingButton+Animation.h"
#import "MGUFloatingItem.h"
#import "MGUFloatingButtonAnimationConfig.h"
#import "MGUFloatingItemAnimationConfig.h"
#import "MGUFloatingItemsLayout.h"
#import "MGUFloatingItemPreparation.h"

@implementation MGUFloatingButton (Animation)

- (void)openAnimated:(BOOL)animated {
    [self.delegate floatingActionButtonWillOpen:self];      // 델리게이트에 메서드를 보낸다.
    self.buttonState = MGRFloatingActionButtonStateOpening; // 이제 버튼을 열 것이다.
    
    [self.superview bringSubviewToFront:self];
    [self addOverlayViewTo:self.superview];
    [self addItemsTo:self.superview];
    
    dispatch_group_t animationGroup = dispatch_group_create();
    
    [self showOverlayAnimated:animated group:animationGroup];               // overlayView 에 대한 애니메이션
    [self openButtonWithConfiguration:self.buttonAnimationConfiguration     // Button 에 대한 애니메이션
                             animated:animated
                                group:animationGroup];
    [self openItemsAnimated:animated group:animationGroup];                 // Item들에 대한 애니메이션
    
    
    void (^groupCompletion)(void) = ^void() {
        self.buttonState = MGRFloatingActionButtonStateOpen; // 이제 버튼이 열렸다.
        [self.delegate floatingActionButtonDidOpen:self];    // 델리게이트에 메서드를 보낸다.
    };
    if (animated == YES) {
        dispatch_group_notify(animationGroup, dispatch_get_main_queue(), ^{
            groupCompletion();
        });
    } else {
        groupCompletion();
    }
}

- (void)closeAnimated:(BOOL)animated {
    if (self.buttonState != MGRFloatingActionButtonStateOpen && self.buttonState != MGRFloatingActionButtonStateOpening) {
        return;
    }

    self.buttonState = MGRFloatingActionButtonStateClosing; // 이제 버튼을 열 것이다.
    [self.delegate floatingActionButtonWillClose:self];
    self.overlayView.enabled = NO;
    
    dispatch_group_t animationGroup = dispatch_group_create();
    
    [self hideOverlayAnimated:animated group:animationGroup];               // overlayView 에 대한 애니메이션
    [self closeButtonWithConfiguration:self.buttonAnimationConfiguration    // Button 에 대한 애니메이션
                              animated:animated
                                 group:animationGroup];
    [self closeItemsAnimated:animated group:animationGroup];                // Item들에 대한 애니메이션
    
    void (^groupCompletion)(void) = ^void() {
        
        for (MGUFloatingItem *item in self.enabledItems) {
            [item removeFromSuperview];
        }
        
        [self.itemContainerView removeFromSuperview];
        self.buttonState = MGRFloatingActionButtonStateClosed;
        [self.delegate floatingActionButtonDidClose:self];

    };
    
    if (animated == YES){
        dispatch_group_notify(animationGroup, dispatch_get_main_queue(), ^{
            groupCompletion();
        });
    } else {
        groupCompletion();
    }
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드 only private

// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드 - openAnimated:completion:actionBlock 에서만 호출됨.

- (void)addOverlayViewTo:(UIView *)superview {
    self.overlayView.enabled = YES;
    [superview insertSubview:self.overlayView belowSubview:self];
    
    self.overlayView.translatesAutoresizingMaskIntoConstraints = YES;
    self.overlayView.frame = superview.bounds;
    [self.overlayView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
}

- (void)addItemsTo:(UIView *)superview {
    
    [superview insertSubview:self.itemContainerView belowSubview:self];
    self.itemContainerView.backgroundColor = UIColor.clearColor;
    
    for (MGUFloatingItem *item in self.enabledItems) {
        item.alpha = 0.0f;
        item.transform = CGAffineTransformIdentity;
        [self.itemContainerView addSubview:item];
        item.translatesAutoresizingMaskIntoConstraints = NO;
        
        [item.circleView.heightAnchor constraintEqualToAnchor:self.circleView.heightAnchor multiplier:self.itemSizeRatio].active = YES;
        [item.topAnchor constraintGreaterThanOrEqualToAnchor:self.itemContainerView.topAnchor].active = YES;
        [item.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.itemContainerView.leadingAnchor].active = YES;
        [item.trailingAnchor constraintLessThanOrEqualToAnchor:self.itemContainerView.trailingAnchor].active = YES;
        [item.bottomAnchor constraintLessThanOrEqualToAnchor:self.itemContainerView.bottomAnchor].active = YES;
    }
    
    //! 블락의 실행. 여기서 actionItem들과 그 부모인 itemContainerView의 레이아웃이 정해진다.
    //! MGUFloatingItemsLayout 클래스의 인스턴스이다.
    self.itemAnimationConfiguration.itemsLayout.layoutBlock(self.enabledItems, self);
}

- (void)showOverlayAnimated:(BOOL)animated group:(dispatch_group_t)group {
    
    void (^groupedAnimations)(void) = ^void() {
        dispatch_group_enter(group);
        self.overlayView.alpha = 1.0f;
    };
    
    void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
        dispatch_group_leave(group);
    };
    
    if (animated == YES) {
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3
                                                                               dampingRatio:1.0
                                                                                 animations:groupedAnimations];
        [animator addCompletion:groupedCompletion];
        [animator startAnimation];
        
    } else {
        groupedAnimations();
        groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
    }
}

- (void)openButtonWithConfiguration:(MGUFloatingButtonAnimationConfig *)configuration
                           animated:(BOOL)animated
                              group:(dispatch_group_t)group {
    
    NSTimeInterval duration = self.buttonAnimationConfiguration.duration;
    CGFloat dampingRatio = self.buttonAnimationConfiguration.dampingRatio;
    
    switch (configuration.style) {
        case MGRButtonAnimationStyleRotation: {
            void (^groupedAnimations)(void) = ^void() {
                dispatch_group_enter(group);
                self.circleView.transform = CGAffineTransformMakeRotation(configuration.angle);
                //self.circleView.layer.transform = CGAffineTransformRotate(CGAffineTransformIdentity, configuration.angle);
//                self.circleView.layer.transform = CATransform3DRotate(CATransform3DIdentity, configuration.angle, 0.0, 0.0, 1.0);
            };
            
            void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
                dispatch_group_leave(group);
            };
            
            if (animated == YES) {
                UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                                       dampingRatio:dampingRatio
                                                                                         animations:groupedAnimations];
                [animator addCompletion:groupedCompletion];
                [animator startAnimation];
            } else {
                groupedAnimations();
                groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
            }
            break;
        }
        case MGRButtonAnimationStyleTransition: {
            void (^groupedAnimations)(void) = ^void() {
                dispatch_group_enter(group);
                self.imageView.image = configuration.image; // self.buttonImage로 설정해서는 안된다.
            };
            
            void (^groupedCompletion)(BOOL) = ^void(BOOL finished) {
                dispatch_group_leave(group);
            };
            
            if (animated == YES) {
                [UIView transitionWithView:self.imageView
                                  duration:duration
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:groupedAnimations
                                completion:groupedCompletion];
            } else {
                groupedAnimations();
                groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
            }
            break;
        }
        default:
            break;
    }
}

- (void)openItemsAnimated:(BOOL)animated group:(dispatch_group_t)group {
    NSTimeInterval delay    = 0.0;
    NSTimeInterval duration = self.itemAnimationConfiguration.duration;
    CGFloat    dampingRatio = self.itemAnimationConfiguration.dampingRatio;
    
    for (NSInteger index = 0; index < self.enabledItems.count; index ++) {
        
        MGUFloatingItem *item = self.enabledItems[index];
        self.itemAnimationConfiguration.closedStatePreparation.prepareBlock(item, index, self.enabledItems.count, self);
        
        void (^groupedAnimations)(void) = ^void() {
            dispatch_group_enter(group);
            item.transform = CGAffineTransformIdentity;
            item.alpha = 1.0f;
        };
        
        void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
            dispatch_group_leave(group);
        };
        
        if (animated == YES) {
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                                   dampingRatio:dampingRatio
                                                                                     animations:groupedAnimations];
            [animator addCompletion:groupedCompletion];
            [animator startAnimationAfterDelay:delay];
            
        } else {
            groupedAnimations();
            groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
        }
    
        delay = delay + self.itemAnimationConfiguration.interItemDelay;
    }
}


// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - 지원 메서드 - closeAnimated:completion:actionBlock 에서만 호출됨.
- (void)hideOverlayAnimated:(BOOL)animated group:(dispatch_group_t)group {
    
    void (^groupedAnimations)(void) = ^void() {
        dispatch_group_enter(group);
        self.overlayView.alpha = 0.0f;
    };
    
    void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
        [self.overlayView removeFromSuperview];
        dispatch_group_leave(group);
    };
    
    if (animated == YES) {
        UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3
                                                                               dampingRatio:1.0
                                                                                 animations:groupedAnimations];
        [animator addCompletion:groupedCompletion];
        [animator startAnimation];
        
    } else {
        groupedAnimations();
        groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
    }
}

- (void)closeButtonWithConfiguration:(MGUFloatingButtonAnimationConfig *)configuration
                            animated:(BOOL)animated
                               group:(dispatch_group_t)group {
    
    NSTimeInterval duration = self.buttonAnimationConfiguration.duration;
    CGFloat dampingRatio = self.buttonAnimationConfiguration.dampingRatio;
    
    switch (configuration.style) {
        case MGRButtonAnimationStyleRotation: {
            void (^groupedAnimations)(void) = ^void() {
                dispatch_group_enter(group);
                self.circleView.transform = CGAffineTransformMakeRotation(0);
            };
            
            void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
                dispatch_group_leave(group);
            };
            
            if (animated == YES) {
                UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                                       dampingRatio:dampingRatio
                                                                                         animations:groupedAnimations];
                [animator addCompletion:groupedCompletion];
                [animator startAnimation];
            } else {
                groupedAnimations();
                groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
            }
            break;
        }
        case MGRButtonAnimationStyleTransition: {
            void (^groupedAnimations)(void) = ^void() {
                dispatch_group_enter(group);
                self.imageView.image = self.buttonImage;
            };
            
            void (^groupedCompletion)(BOOL) = ^void(BOOL finished) {
                dispatch_group_leave(group);
            };
            
            if (animated == YES) {
                [UIView transitionWithView:self.imageView
                                  duration:duration
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:groupedAnimations
                                completion:groupedCompletion];
            } else {
                groupedAnimations();
                groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
            }
            break;
        }
        default:
            break;
    }
}

- (void)closeItemsAnimated:(BOOL)animated group:(dispatch_group_t)group {

    NSInteger numberOfItems = self.enabledItems.count;
    NSInteger index         = numberOfItems - 1;
    NSTimeInterval delay    = 0.0;
    NSTimeInterval duration = self.itemAnimationConfiguration.duration;
    CGFloat    dampingRatio = self.itemAnimationConfiguration.dampingRatio;
    
    //! 삭제된 항목이 옆 index에 영향을 미치므로 이렇게 해야한다. 그런데, subviews는 왜 괜찮은지 모르겠다.
    //! reverseObjectEnumerator를 쓰면 -> the next index won't be affected when you remove an object.
    for (MGUFloatingItem *item  in [self.enabledItems reverseObjectEnumerator]) {
        void (^groupedAnimations)(void) = ^void() {
            dispatch_group_enter(group);
            self.itemAnimationConfiguration.closedStatePreparation.prepareBlock(item, index, numberOfItems, self);
        };
        
        void (^groupedCompletion)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
            dispatch_group_leave(group);
        };
        
        if (animated == YES) {
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                                   dampingRatio:dampingRatio
                                                                                     animations:groupedAnimations];
            [animator addCompletion:groupedCompletion];
            [animator startAnimationAfterDelay:delay];
            
        } else {
            groupedAnimations();
            groupedCompletion(UIViewAnimatingPositionStart); // 사실 인자로 뭘 넣으나 상관없다.
        }
    
        delay = delay + self.itemAnimationConfiguration.interItemDelay;
        index = index - 1;
    }
    
}

@end
