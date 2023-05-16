//
//  MGUSideBarView.m
//  SlideSideBarMenuProject
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSideBarView.h"
#import "MGUSideBarConfig.h"

@interface MGUSideBarView ()
@property (nonatomic, weak) MGUSideBarConfig *config;
@end

@implementation MGUSideBarView

- (instancetype)initWithConfiguration:(MGUSideBarConfig *)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _config = configuration;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUSideBarView *self) {
    self->_containerView = [UIView new];
    [self addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    if (self.config.transitionStyle & MGUSideBarControllerTransitionStyleReveal) {
        self.maskView = [UIView new];
        self.maskView.backgroundColor = [UIColor redColor];
    }
    
    if (self.config.transitionStyle & MGUSideBarControllerTransitionStyleLeading) {
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    } else if (self.config.transitionStyle & MGUSideBarControllerTransitionStyleTrailing) {
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    } else if (self.config.transitionStyle & MGUSideBarControllerTransitionStyleLeft) {
        [self.containerView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    } else if (self.config.transitionStyle & MGUSideBarControllerTransitionStyleRight) {
        [self.containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    }
    
    [self.containerView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor].active = YES;
    
    if (self.config.widthDeterminant.isRatio == YES) {
        [self.containerView.widthAnchor constraintEqualToAnchor:self.widthAnchor
                                                     multiplier:self.config.widthDeterminant.ratio].active = YES;
    } else { // absoluteWidth
        NSLayoutConstraint *constraint = [self.containerView.widthAnchor constraintEqualToConstant:self.config.widthDeterminant.absoluteWidth];
        constraint.priority = UILayoutPriorityDefaultHigh;
        constraint.active = YES;
        if (self.config.widthDeterminant.ratio != 0.0) {
            [self.containerView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor
                                                                   multiplier:self.config.widthDeterminant.ratio].active = YES;
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 세터 & 게터
- (UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _shadowView.layer.shadowOpacity = 0.5;
        _shadowView.layer.shadowOffset = CGSizeZero;
        _shadowView.layer.shadowRadius = 5.0;
        [self addSubview:_shadowView];
    }
    return _shadowView;
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithFrame:(CGRect)frame  { NSCAssert(FALSE, @"- initWithFrame 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
@end
