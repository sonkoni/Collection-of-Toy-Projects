//
//  MGUMessagesBaseView.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "MGUMessagesBaseView.h"
#import "MGUMessagesAnimationContext.h"

@interface MGUMessagesBaseView ()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer; // lazy
@property (nonatomic, strong, nullable) NSLayoutConstraint *backgroundHeightConstraint;

@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *>*layoutConstraints;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *>*regularWidthLayoutConstraints;
@end

@implementation MGUMessagesBaseView
@dynamic layoutMarginAdditions;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.backgroundView != self) {
        CGPoint backgroundViewPoint = [self convertPoint:point toView:self.backgroundView];
        return [self.backgroundView pointInside:backgroundViewPoint withEvent:event];
    }
    return [super pointInside:point withEvent:event];
}

- (void)updateConstraints {
    [super updateConstraints];
    NSMutableArray <NSLayoutConstraint *>*on;
    NSMutableArray <NSLayoutConstraint *>*off;
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        on = self.regularWidthLayoutConstraints;
        off = self.layoutConstraints;
    } else {
        on = self.layoutConstraints;
        off = self.regularWidthLayoutConstraints;
    }
    
    [on enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        obj.active = YES;
    }];
    [off enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        obj.active = NO;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateShadowPath];
}

- (void)configureDropShadow {
    self.layer.shadowColor = UIColor.blackColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowRadius = 6.0;
    self.layer.shadowOpacity = 0.4;
    self.layer.masksToBounds = NO;
    [self updateShadowPath];
}

- (void)configureNoDropShadow {
    self.layer.shadowOpacity = 0.0;
}

- (void)updateShadowPath {
    [self.backgroundView layoutIfNeeded];
    CALayer *shadowLayer = (self.backgroundView.layer != nil) ? self.backgroundView.layer : self.layer;
    CGRect shadowRect = [self.layer convertRect:shadowLayer.bounds fromLayer:shadowLayer];
    CGPathRef shadowPath = NULL;
    
    CAShapeLayer *backgroundMaskLayer = shadowLayer.mask;
    if ([backgroundMaskLayer isKindOfClass:[CAShapeLayer class]] == YES && backgroundMaskLayer.path != NULL) {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(CGRectGetMinX(shadowRect), CGRectGetMinY(shadowRect));
        CGPathRef path = CGPathCreateCopyByTransformingPath(backgroundMaskLayer.path, &transform);
        if (path != NULL) {
            shadowPath =  (CGPathRef)CFAutorelease(path);
        }
    } else {
        shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowRect cornerRadius:shadowLayer.cornerRadius].CGPath;
    }
            
    // This is a workaround needed for smooth rotation animations.
    NSArray <NSString *>*animationKeys = [self.layer animationKeys];
    CABasicAnimation *foundAnimation = [animationKeys mgrMap:^id (NSString *animationKey) {
        CABasicAnimation *animation = [self.layer animationForKey:animationKey];
        if ([animation isKindOfClass:[CABasicAnimation class]] && [animation.keyPath isEqualToString:@"bounds.size"]) {
            return animation;
        } else {
            return nil;
        }
    }].firstObject;
    
    if (foundAnimation != nil) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        animation.duration = foundAnimation.duration;
        animation.timingFunction = foundAnimation.timingFunction;
        animation.fromValue = (__bridge id _Nullable)(self.layer.shadowPath);
        animation.toValue = (__bridge id _Nullable)(shadowPath);
        [self.layer addAnimation:animation forKey:@"shadowPath"];
        self.layer.shadowPath = shadowPath;
    } else {
        self.layer.shadowPath = shadowPath;
    }
}

- (void)configureBackgroundViewSideMargin:(CGFloat)sideMargin {
    UIEdgeInsets layoutMargins = self.layoutMargins;
    layoutMargins.left = sideMargin;
    layoutMargins.right = sideMargin;
    self.layoutMargins = layoutMargins;
}

- (void)configureBackgroundViewWidth:(CGFloat)width {
    if (self.backgroundView != nil) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:width];
        [self.backgroundView addConstraint:constraint];
    }
}

#pragma mark - 생성 & 소멸
static void CommonInit(MGUMessagesBaseView *self) {
    self->_respectSafeArea = YES;
    self->_topLayoutMarginAddition = 0.0;
    self->_leftLayoutMarginAddition = 0.0;
    self->_bottomLayoutMarginAddition = 0.0;
    self->_rightLayoutMarginAddition = 0.0;
    self->_collapseLayoutMarginAdditions = YES;
    self->_bounceAnimationOffset = 5.0;
    self->_backgroundHeight = MGEFloatNull;
    
    self.backgroundView = self;
    self.layoutMargins = UIEdgeInsetsZero;
    self->_layoutConstraints = [NSMutableArray array];
    self->_regularWidthLayoutConstraints = [NSMutableArray array];
}

- (void)installContentView:(UIView *)contentView insets:(UIEdgeInsets)insets {
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addSubview:contentView];
    [contentView.topAnchor constraintEqualToAnchor:self.backgroundView.topAnchor constant:insets.top].active = YES;
    [contentView.bottomAnchor constraintEqualToAnchor:self.backgroundView.bottomAnchor constant:-insets.bottom].active = YES;
    [contentView.leftAnchor constraintEqualToAnchor:self.backgroundView.leftAnchor constant:insets.left].active = YES;
    [contentView.rightAnchor constraintEqualToAnchor:self.backgroundView.rightAnchor constant:-insets.right].active = YES;
    NSLayoutConstraint *constraint = [contentView.heightAnchor constraintEqualToConstant:350.0];
    constraint.priority = 200.0;
    constraint.active = YES;
}

- (void)installBackgroundView:(UIView *)backgroundView insets:(UIEdgeInsets)insets {
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    if (backgroundView != self) {
        [backgroundView removeFromSuperview];
    }
     
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    NSLayoutConstraint *constraint = [backgroundView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    constraint.priority = 950.0;
    constraint.active = YES;
        
    constraint = [backgroundView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:insets.top];
    constraint.priority = 900.0;
    constraint.active = YES;
    
    constraint = [backgroundView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:-insets.bottom];
    constraint.priority = 900.0;
    constraint.active = YES;
    
    constraint = [backgroundView.heightAnchor constraintEqualToConstant:350.0];
    constraint.priority = 200.0;
    constraint.active = YES;
    
    constraint = [backgroundView.leftAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leftAnchor constant:insets.left];
    constraint.priority = 900.0;
    [self.layoutConstraints addObject:constraint];
    constraint = [backgroundView.rightAnchor constraintEqualToAnchor:self.layoutMarginsGuide.rightAnchor constant:-insets.right];
    constraint.priority = 900.0;
    [self.layoutConstraints addObject:constraint];
    
    constraint = [backgroundView.leftAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leftAnchor constant:insets.left];
    constraint.priority = 900.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.rightAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.rightAnchor constant:-insets.right];
    constraint.priority = 900.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.widthAnchor constraintLessThanOrEqualToConstant:500.0];
    constraint.priority = 950.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.widthAnchor constraintEqualToConstant:500.0];
    constraint.priority = 200.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    
    [self installTapRecognizer];
}

- (void)installBackgroundVerticalView:(UIView *)backgroundView insets:(UIEdgeInsets)insets {
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    if (backgroundView != self) {
        [backgroundView removeFromSuperview];
    }
    
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    NSLayoutConstraint *constraint = [backgroundView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    constraint.priority = 950.0;
    constraint.active = YES;
        
    constraint = [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor constant:insets.top];
    constraint.priority = UILayoutPriorityRequired;
    constraint.active = YES;
    
    constraint = [backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-insets.bottom];
    constraint.priority = UILayoutPriorityRequired;
    constraint.active = YES;
    
    constraint = [backgroundView.heightAnchor constraintEqualToConstant:350.0];
    constraint.priority = 200.0;
    constraint.active = YES;
    
    constraint = [backgroundView.leftAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leftAnchor constant:insets.left];
    constraint.priority = 900.0;
    [self.layoutConstraints addObject:constraint];
    constraint = [backgroundView.rightAnchor constraintEqualToAnchor:self.layoutMarginsGuide.rightAnchor constant:-insets.right];
    constraint.priority = 900.0;
    [self.layoutConstraints addObject:constraint];
    
    
    constraint = [backgroundView.leftAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leftAnchor constant:insets.left];
    constraint.priority = 900.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.rightAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.rightAnchor constant:-insets.right];
    constraint.priority = 900.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.widthAnchor constraintLessThanOrEqualToConstant:500.0];
    constraint.priority = 950.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    constraint = [backgroundView.widthAnchor constraintEqualToConstant:500.0];
    constraint.priority = 200.0;
    [self.regularWidthLayoutConstraints addObject:constraint];
    
    [self installTapRecognizer];
}


#pragma mark - 세터 & 게터
- (void)setBackgroundView:(UIView *)backgroundView {
    UIView *oldvalue = _backgroundView;
    _backgroundView = backgroundView;
    
    if (oldvalue == backgroundView) {
        [oldvalue removeGestureRecognizer:self.tapRecognizer];
    }
    [self installTapRecognizer];
    [self updateBackgroundHeightConstraint];
}

- (UITapGestureRecognizer *)tapRecognizer {
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    }
    return _tapRecognizer;
}

- (void)setTapHandler:(void (^)(MGUMessagesBaseView * _Nonnull))tapHandler {
    _tapHandler = tapHandler;
    [self installTapRecognizer];
}

- (void)setBackgroundHeight:(CGFloat)backgroundHeight {
    _backgroundHeight = backgroundHeight;
    [self updateBackgroundHeightConstraint];
}

- (UIEdgeInsets)layoutMarginAdditions {
    return UIEdgeInsetsMake(self.topLayoutMarginAddition,
                            self.leftLayoutMarginAddition,
                            self.bottomLayoutMarginAddition,
                            self.rightLayoutMarginAddition);
}

- (void)setLayoutMarginAdditions:(UIEdgeInsets)layoutMarginAdditions {
    self.topLayoutMarginAddition = layoutMarginAdditions.top;
    self.leftLayoutMarginAddition = layoutMarginAdditions.left;
    self.bottomLayoutMarginAddition = layoutMarginAdditions.bottom;
    self.rightLayoutMarginAddition = layoutMarginAdditions.right;
}


#pragma mark - <MGUMessagesMarginAdjustable>
- (UIEdgeInsets)defaultMarginAdjustmentWithContext:(MGUMessagesAnimationContext *)context {
    UIEdgeInsets layoutMargins = [self layoutMarginAdditions];
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if ([self respectSafeArea] == YES) {
        self.insetsLayoutMarginsFromSafeArea = NO;
        safeAreaInsets = self.safeAreaInsets;
    }
        
    if (context.safeZoneConflicts & MGUMessagesSafeZoneConflictsOverStatusBar) {
        safeAreaInsets.top = 0.0;
    }
    
    if ([self collapseLayoutMarginAdditions] == YES) {
        return UIEdgeInsetsMake(MAX(layoutMargins.top, safeAreaInsets.top),
                                MAX(layoutMargins.left, safeAreaInsets.left),
                                MAX(layoutMargins.bottom, safeAreaInsets.bottom),
                                MAX(layoutMargins.right, safeAreaInsets.right));
    } else {
        return UIEdgeInsetsMake(layoutMargins.top + safeAreaInsets.top,
                                layoutMargins.left + safeAreaInsets.left,
                                layoutMargins.bottom + safeAreaInsets.bottom,
                                layoutMargins.right + safeAreaInsets.right);
    }
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    if (self.tapHandler != nil) {
        __weak __typeof(self) weakSelf = self;
        self.tapHandler(weakSelf);
    }
}


#pragma mark - Helper
- (void)installTapRecognizer {
    if (self.backgroundView == nil) {
        return;
    }
    
    [self removeGestureRecognizer:self.tapRecognizer];
    [self.backgroundView removeGestureRecognizer:self.tapRecognizer];
    
    if (self.tapHandler != nil) {
        [self.backgroundView addGestureRecognizer:self.tapRecognizer];
    }
}

- (void)updateBackgroundHeightConstraint {
    if (self.backgroundHeightConstraint != nil) {
        UIView *view = self.backgroundHeightConstraint.firstItem;
        [view removeConstraint:self.backgroundHeightConstraint];
        self.backgroundHeightConstraint = nil;
    }
    
    //! FIXME: 여기가 문제다 고쳐라.
    if (MGEFloatIsNull(self.backgroundHeight) == NO && self.backgroundView != nil) {
        NSLog(@"backgroundHeight ===> %f", self.backgroundHeight);
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:self.backgroundHeight];
        [self.backgroundView addConstraint:constraint];
        self.backgroundHeightConstraint = constraint;
    }
}


@end

UIImage * _Nullable makeImageWithStyleAndTheme(MGUMessagesIconStyle style, MGUMessagesTheme theme) {
    
    UIImage*(^imageWithIconName)(MGUMessagesIconName) = ^UIImage* (MGUMessagesIconName name){
        NSBundle *bundle = [NSBundle mgrIosRes];
        if (bundle == nil) { NSCAssert(FALSE, @"[NSBundle mgrIosRes] 번들이 없다."); }
        UIImage *image = [UIImage imageNamed:name inBundle:bundle withConfiguration:nil];
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    };

    if (theme == MGUMessagesThemeInfo) {
        if (style == MGUMessagesIconStyleDefault) {
            return imageWithIconName(MGUMessagesIconNameInfo);
        } else if (style == MGUMessagesIconStyleLight) {
            return imageWithIconName(MGUMessagesIconNameInfoLight);
        } else if (style == MGUMessagesIconStyleSubtle) {
            return imageWithIconName(MGUMessagesIconNameInfoSubtle);
        }
    } else if (theme == MGUMessagesThemeSuccess) {
        if (style == MGUMessagesIconStyleDefault) {
            return imageWithIconName(MGUMessagesIconNameSuccess);
        } else if (style == MGUMessagesIconStyleLight) {
            return imageWithIconName(MGUMessagesIconNameSuccessLight);
        } else if (style == MGUMessagesIconStyleSubtle) {
            return imageWithIconName(MGUMessagesIconNameSuccessSubtle);
        }
    } else if (theme == MGUMessagesThemeWarning) {
        if (style == MGUMessagesIconStyleDefault) {
            return imageWithIconName(MGUMessagesIconNameWarning);
        } else if (style == MGUMessagesIconStyleLight) {
            return imageWithIconName(MGUMessagesIconNameWarningLight);
        } else if (style == MGUMessagesIconStyleSubtle) {
            return imageWithIconName(MGUMessagesIconNameWarningSubtle);
        }
    } else if (theme == MGUMessagesThemeError) {
        if (style == MGUMessagesIconStyleDefault) {
            return imageWithIconName(MGUMessagesIconNameError);
        } else if (style == MGUMessagesIconStyleLight) {
            return imageWithIconName(MGUMessagesIconNameErrorLight);
        } else if (style == MGUMessagesIconStyleSubtle) {
            return imageWithIconName(MGUMessagesIconNameErrorSubtle);
        }
    }
    
    return nil;
}
