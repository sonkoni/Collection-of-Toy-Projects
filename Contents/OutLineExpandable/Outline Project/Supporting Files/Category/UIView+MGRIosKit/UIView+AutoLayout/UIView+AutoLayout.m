#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)


#pragma mark - Pure

- (void)mgrPinEdgesToSuperviewEdges {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
}

- (void)mgrPinHorizontalEdgesToSuperviewEdges { // leading, trailing만 super view에 맞춘다.
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
}

- (void)mgrPinVerticalEdgesToSuperviewEdges { // top, bottom만 super view에 맞춘다.
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor].active = YES;
}

- (void)mgrPinCenterToSuperviewCenter {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = YES;
    [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor].active = YES;
}

- (void)mgrPinCenterToSuperviewCenterWithInner {
    [self mgrPinCenterToSuperviewCenter];
    [self.topAnchor constraintGreaterThanOrEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.superview.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomAnchor].active = YES;
    [self.superview.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)mgrPinCenterToSuperviewCenterWithOuter {
    [self mgrPinCenterToSuperviewCenter];
    [self.topAnchor constraintLessThanOrEqualToAnchor:self.superview.topAnchor].active = YES;
    [self.leadingAnchor constraintLessThanOrEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.superview.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor].active = YES;
    [self.superview.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor].active = YES;
}

- (void)mgrPinCenterToSuperviewCenterWithFixSize:(CGSize)size {
    [self mgrPinCenterToSuperviewCenter];
    [self.widthAnchor constraintEqualToConstant:size.width].active = YES;
    [self.heightAnchor constraintEqualToConstant:size.height].active = YES;
}

- (void)mgrPinSizeToSuperviewSize {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.widthAnchor constraintEqualToAnchor:self.superview.widthAnchor].active = YES;
    [self.heightAnchor constraintEqualToAnchor:self.superview.heightAnchor].active = YES;
}

- (void)mgrPinFixSize:(CGSize)size {
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.widthAnchor constraintEqualToConstant:size.width].active = YES;
    [self.heightAnchor constraintEqualToConstant:size.height].active = YES;
}

- (void)mgrPinEdgesToSuperviewLayoutMarginsGuide {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.bottomAnchor].active = YES;
}

- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuide {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (void)mgrPinEdgesToSuperviewCustomMargins:(UIEdgeInsets)customMargins { // 5,5,5,5 이면 안쪽으로 5만큼 파고든다.
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:customMargins.top].active = YES;
    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:customMargins.left].active = YES;
    [self.superview.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:customMargins.right].active = YES;
    [self.superview.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:customMargins.bottom].active = YES;
}


#pragma mark - Mix

- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndEdges {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndMargins { // 마진(마진은 좌, 우만 존재함)도 제외함
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다.");
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self.leadingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.superview.layoutMarginsGuide.trailingAnchor].active = YES;
    [self.topAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.superview.safeAreaLayoutGuide.bottomAnchor].active = YES;
}


#pragma mark - other
- (UIEdgeInsets)safeAreaInsetsOfSuperview {
    NSAssert(self.superview, @"Superview 는 nil 이어서는 안된다. 붙이고 나서 물어봐라.");
    return self.superview.safeAreaInsets;
}

@end

