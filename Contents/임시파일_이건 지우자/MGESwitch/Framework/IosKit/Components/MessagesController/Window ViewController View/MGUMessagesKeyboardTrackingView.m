//
//  MGUMessagesKeyboardTrackingView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesKeyboardTrackingView.h"

@interface MGUMessagesKeyboardTrackingView ()
@property (nonatomic, assign) BOOL isAutomaticallyPaused; // 디폴트 NO
@property (nonatomic, strong, nullable) NSLayoutConstraint *heightConstraint;
@end

@implementation MGUMessagesKeyboardTrackingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CommonInit(self);
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesKeyboardTrackingView *self) {
    self->_isPaused = NO;
    self->_isAutomaticallyPaused = NO;
    self->_topMargin = 0.0;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self->_heightConstraint = [self.heightAnchor constraintEqualToConstant:0.0];
    self.heightConstraint.active = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resume:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.backgroundColor = [UIColor clearColor];

}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self showChange:MGUMessagesKeyboardTrackingViewChangeShow notification:notification];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [self showChange:MGUMessagesKeyboardTrackingViewChangeFrame notification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo == nil) {
        return;
    }
    
    if (self.isPaused == NO && self.isAutomaticallyPaused == NO) {
        if (self.heightConstraint.constant != 0.0) {
            [self.delegate keyboardTrackingViewWillChange:MGUMessagesKeyboardTrackingViewChangeHide userInfo:userInfo];
            [self animateKeyboardChange:MGUMessagesKeyboardTrackingViewChangeHide height:0.0 userInfo:userInfo];
        }
    }
}

- (void)pause:(NSNotification *)notification {
    self.isAutomaticallyPaused = YES;
}

- (void)resume:(NSNotification *)notification {
    self.isAutomaticallyPaused = NO;
}

- (void)setIsPaused:(BOOL)isPaused {
    _isPaused = isPaused;
    if (!isPaused) {
        self.isAutomaticallyPaused = NO;
    }
}

#pragma mark - Action
- (void)willChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo {}
- (void)didChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo {}


#pragma mark - Helper
- (void)showChange:(MGUMessagesKeyboardTrackingViewChange)change notification:(NSNotification *)notification {

    NSDictionary *userInfo = notification.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    if ([value isKindOfClass:[NSValue class]] == NO) {
        return;
    }
    
    if (self.isPaused == NO && self.isAutomaticallyPaused == NO) {
        [self willChange:change userInfo:userInfo];
        [self.delegate keyboardTrackingViewWillChange:change userInfo:userInfo];
        CGRect keyboardRect = [value CGRectValue];
        CGRect thisRect = [self convertRect:self.bounds toView:nil];
        CGFloat newHeight = MAX(0.0, CGRectGetMaxY(thisRect) - CGRectGetMinY(keyboardRect)) + self.topMargin;
        
        if (self.heightConstraint.constant != newHeight) {
            [self animateKeyboardChange:change height:newHeight userInfo:userInfo];
        }
    }
}

- (void)animateKeyboardChange:(MGUMessagesKeyboardTrackingViewChange)change
                       height:(CGFloat)height
                     userInfo:(NSDictionary *)userInfo {
    self.heightConstraint.constant = height;
    
    NSNumber *durationNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curveNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    if ([durationNumber isKindOfClass:[NSNumber class]] == YES &&
        [curveNumber isKindOfClass:[NSNumber class]] == YES) {
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self didChange:change userInfo:userInfo];
            [self.delegate keyboardTrackingViewDidChange:change userInfo:userInfo];
        }];
        
        UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
        UIViewAnimationCurve animationCurve = [curveNumber integerValue];
        if (animationCurve == UIViewAnimationCurveEaseInOut) {
            options = UIViewAnimationOptionCurveEaseInOut;
        } else if (animationCurve == UIViewAnimationCurveEaseIn) {
            options = UIViewAnimationOptionCurveEaseIn;
        } else if (animationCurve == UIViewAnimationCurveEaseOut) {
            options = UIViewAnimationOptionCurveEaseOut;
        } else if (animationCurve == UIViewAnimationCurveLinear) {
            options = UIViewAnimationOptionCurveLinear;
        }
        options = options | UIViewAnimationOptionBeginFromCurrentState;
        
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:durationNumber.doubleValue
                                                              delay:0.0
                                                            options:options
                                                         animations:^{ [self.superview layoutIfNeeded]; }
                                                         completion:^(UIViewAnimatingPosition finalPosition) {}];
        [CATransaction commit];
    }
}

@end
