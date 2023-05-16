//
//  MaskingView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/18.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesMaskingView.h"
#import "MGUMessagesKeyboardTrackingView.h"
#import "MGUMessagesBaseView.h"

@interface MGUMessagesMaskingView ()
@property (nonatomic, strong, nullable) MGUMessagesKeyboardTrackingView *keyboardTrackingView;
@end

@implementation MGUMessagesMaskingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (self.keyboardTrackingView == nil || view == self.keyboardTrackingView || view == self.backgroundView) {
        return;
    }
    
    CGFloat offset;
    
    UIView <MGUMessagesMarginAdjustable>*adjustable = (UIView <MGUMessagesMarginAdjustable>*)view;
    if ([adjustable conformsToProtocol:@protocol(MGUMessagesMarginAdjustable)]) {
        offset = -adjustable.bounceAnimationOffset;
    } else {
        offset = 0.0;
    }
    
    NSLayoutConstraint *constraint = [self.keyboardTrackingView.topAnchor constraintGreaterThanOrEqualToAnchor:view.bottomAnchor constant:offset];
    constraint.priority  = UILayoutPriorityDefaultLow;
    constraint.active = YES;
}

- (NSInteger)accessibilityElementCount {
    return self.accessibleElements.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return self.accessibleElements[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    if ([element isKindOfClass:[NSObject class]] == NO) {
        return 0;
    }
    
    NSInteger result = [self.accessibilityElements indexOfObject:element];
    if (result == NSNotFound) {
        return 0;
    } else {
        return result;
    }
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesMaskingView *self) {
    self.clipsToBounds = YES;
    self->_accessibleElements = @[].mutableCopy;
}


#pragma mark - 세터 & 게터
- (void)setBackgroundView:(UIView *)backgroundView {
    UIView *oldValue = _backgroundView;
    _backgroundView = backgroundView;
    
    [oldValue removeFromSuperview];
    if (backgroundView != nil) {
        backgroundView.userInteractionEnabled = NO;
        backgroundView.frame = self.bounds;
        backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
    }
}

- (void)installKeyboardTrackingView:(MGUMessagesKeyboardTrackingView *)keyboardTrackingView {
    self.keyboardTrackingView = keyboardTrackingView;
    keyboardTrackingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:keyboardTrackingView];
    [keyboardTrackingView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [keyboardTrackingView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [keyboardTrackingView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
}

@end
