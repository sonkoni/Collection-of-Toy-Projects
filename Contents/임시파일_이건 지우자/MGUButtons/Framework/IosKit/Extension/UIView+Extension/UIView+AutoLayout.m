//
//  UIView+AutoLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (void)mgrPinEdgesToSuperviewEdgesUsingAutoresizingMask {
    NSCAssert(self.superview, @"Superview를 우선 설정하자. 실수를 줄이기 위해서이다.");
    self.frame = self.superview.bounds;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}


#pragma mark - Pure
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewEdges {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor];
    NSLayoutConstraint *c3 = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor];
    NSLayoutConstraint *c4 = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinHorizontalEdgesToSuperviewEdges { // leading, trailing만 super view에 맞춘다.
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor];
    c1.active = YES;
    c2.active = YES;
    return @[c1, c2];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinVerticalEdgesToSuperviewEdges { // top, bottom만 super view에 맞춘다.
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor];
    NSLayoutConstraint *c2 = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    return @[c1, c2];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithSameSize {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor];
    NSLayoutConstraint *c2 = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
    NSLayoutConstraint *c3 = [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor];
    NSLayoutConstraint *c4 = [self.heightAnchor constraintEqualToAnchor:self.superview.heightAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenter {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor];
    NSLayoutConstraint *c2 = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
    c1.active = YES;
    c2.active = YES;
    return @[c1, c2];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithInner {
    NSMutableArray <NSLayoutConstraint *>*result = [self mgrPinCenterToSuperviewCenter].mutableCopy;
    NSLayoutConstraint *c1 = [self.topAnchor constraintGreaterThanOrEqualToAnchor:self.superview.topAnchor];
    NSLayoutConstraint *c2 = [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.superview.leadingAnchor];
    NSLayoutConstraint *c3 = [self.superview.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *c4 = [self.superview.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.trailingAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    [result addObjectsFromArray:@[c1, c2, c3, c4]];
    return result;
}

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithOuter {
    NSMutableArray <NSLayoutConstraint *>*result = [self mgrPinCenterToSuperviewCenter].mutableCopy;
    NSLayoutConstraint *c1 = [self.topAnchor constraintLessThanOrEqualToAnchor:self.superview.topAnchor];
    NSLayoutConstraint *c2 = [self.leadingAnchor constraintLessThanOrEqualToAnchor:self.superview.leadingAnchor];
    NSLayoutConstraint *c3 = [self.superview.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *c4 = [self.superview.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    [result addObjectsFromArray:@[c1, c2, c3, c4]];
    return result;
}

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithFixSize:(CGSize)size {
    NSMutableArray <NSLayoutConstraint *>*result = [self mgrPinCenterToSuperviewCenter].mutableCopy;
    NSLayoutConstraint *c1 = [self.widthAnchor constraintEqualToConstant:size.width];
    NSLayoutConstraint *c2 = [self.heightAnchor constraintEqualToConstant:size.height];
    c1.active = YES;
    c2.active = YES;
    [result addObjectsFromArray:@[c1, c2]];
    return result;
}

- (NSLayoutConstraint *)mgrPinCenterXToSuperviewCenterXWithMultiplier:(CGFloat)multiplier {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:multiplier
                                                               constant:0.0];
    result.active = YES;
    return result;
}

- (NSLayoutConstraint *)mgrPinCenterYToSuperviewCenterYWithMultiplier:(CGFloat)multiplier {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:multiplier
                                                               constant:0.0];
    result.active = YES;
    return result;
    
}

- (NSLayoutConstraint *)mgrPinTrailingToSuperviewTrailingWithMultiplier:(CGFloat)multiplier {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:multiplier
                                                               constant:0.0];
    result.active = YES;
    return result;

}

- (NSLayoutConstraint *)mgrPinBottomToSuperviewBottomWithMultiplier:(CGFloat)multiplier {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *result = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:multiplier
                                                               constant:0.0];
    result.active = YES;
    return result;
}

- (NSArray <NSLayoutConstraint *>*)mgrPinSizeToSuperviewSize {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor];
    NSLayoutConstraint *c2 = [self.heightAnchor constraintEqualToAnchor:self.superview.heightAnchor];
    c1.active = YES;
    c2.active = YES;
    return @[c1, c2];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinFixSize:(CGSize)size {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.widthAnchor constraintEqualToConstant:size.width];
    NSLayoutConstraint *c2 = [self.heightAnchor constraintEqualToConstant:size.height];
    c1.active = YES;
    c2.active = YES;
    return @[c1, c2];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewLayoutMarginsGuide {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.trailingAnchor];
    NSLayoutConstraint *c3 = [self.topAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.topAnchor];
    NSLayoutConstraint *c4 = [self.bottomAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
    
}

- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuide {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.trailingAnchor];
    NSLayoutConstraint *c3 = [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *c4 = [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
    
}

- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewCustomMargins:(UIEdgeInsets)customMargins { // 5,5,5,5 이면 안쪽으로 5만큼 파고든다.
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:customMargins.top];
    NSLayoutConstraint *c2 = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:customMargins.left];
    NSLayoutConstraint *c3 = [self.superview.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:customMargins.right];
    NSLayoutConstraint *c4 = [self.superview.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:customMargins.bottom];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
}


#pragma mark - Mix
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndEdges {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor];
    NSLayoutConstraint *c3 = [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *c4 = [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
}

- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndMargins { // 마진(마진은 좌, 우만 존재함)도 제외함
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *c1 = [self.leadingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.leadingAnchor];
    NSLayoutConstraint *c2 = [self.trailingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.trailingAnchor];
    NSLayoutConstraint *c3 = [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor];
    NSLayoutConstraint *c4 = [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor];
    c1.active = YES;
    c2.active = YES;
    c3.active = YES;
    c4.active = YES;
    return @[c1, c2, c3, c4];
}


#pragma mark - other
- (UIEdgeInsets)safeAreaInsetsOfSuperview {
    NSCAssert(self.superview, @"Superview 는 nil 이어서는 안된다. 붙이고 나서 물어봐라.");
    return self.superview.safeAreaInsets;
}


#pragma mark - Remove
- (void)mgrRemoveAllConstraints:(BOOL)translatesAutoresizingMaskIntoConstraints {
    UIView *mySuperView = self.superview;
    while (mySuperView != nil) {
        for (NSLayoutConstraint *constraint in mySuperView.constraints) {
            UIView *first = constraint.firstItem;
            UIView *second = constraint.secondItem;
            if ([first isKindOfClass:[UIView class]] && first == self) {
                [mySuperView removeConstraint:constraint];
            }
            if ([second isKindOfClass:[UIView class]] && second == self) {
                [mySuperView removeConstraint:constraint];
            }
        }

        mySuperView = mySuperView.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
}

- (void)mgrRemoveAllConstraintsRelatedToMe:(BOOL)translatesAutoresizingMaskIntoConstraints {
    UIView *mySuperView = self;
    while (mySuperView != nil) {
        for (NSLayoutConstraint *constraint in mySuperView.constraints) {
            UIView *first = constraint.firstItem;
            UIView *second = constraint.secondItem;
            if ([first isKindOfClass:[UIView class]] && first == self) {
                [mySuperView removeConstraint:constraint];
            }
            if ([second isKindOfClass:[UIView class]] && second == self) {
                [mySuperView removeConstraint:constraint];
            }
        }

        mySuperView = mySuperView.superview;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
}

- (void)mgrRemoveAllConstraintsAncestorsHoldOnToMe:(BOOL)translatesAutoresizingMaskIntoConstraints {
    UIView *mySuperView = self.superview;
    while (mySuperView != nil) {
        for (NSLayoutConstraint *constraint in mySuperView.constraints) {
            UIView *first = constraint.firstItem;
            UIView *second = constraint.secondItem;
            if ([first isKindOfClass:[UIView class]] && first == self) {
                [mySuperView removeConstraint:constraint];
            }
            if ([second isKindOfClass:[UIView class]] && second == self) {
                [mySuperView removeConstraint:constraint];
            }
        }
        mySuperView = mySuperView.superview;
    }
    
    self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
}

#pragma mark - Active / Inactive
- (void)mgrSelfConstraints:(BOOL)isActive {
    if (isActive == YES) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    } else {
        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
    
    UIView *mySuperView = self;
    while (mySuperView != nil) {
        for (NSLayoutConstraint *constraint in mySuperView.constraints) {
            UIView *first = constraint.firstItem;
            UIView *second = constraint.secondItem;
            if ([first isKindOfClass:[UIView class]] && first == self) {
                constraint.active = isActive;
            }
            if ([second isKindOfClass:[UIView class]] && second == self) {
                constraint.active = isActive;
            }
        }
        mySuperView = mySuperView.superview;
    }
}
@end

