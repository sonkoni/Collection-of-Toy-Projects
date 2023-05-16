//
//  MGUActionSheet.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUActionSheet.h"
#import "MGUAlertViewButton.h"
#import "MGUActionSheetConfiguration.h"
#import "UIApplication+Extension.h"
#import "UIView+Extension.h"

// https://developer.apple.com/design/human-interface-guidelines/ios/views/popovers/
// https://useyourloaf.com/blog/self-sizing-popovers/ (300-400 points wide)
#define APPLE_ALERT_CONTROLLER_ACTION_SHEET_IPAD_WIDTH (304.0)

@interface MGUAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MGUAlertViewConfiguration *configuration;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewCenterYConstraint;
@property (nonatomic, strong) UIStackView *actionButtonStackView;
@property (nonatomic, strong) NSMutableArray <UIView *>*separatorViews;
- (void)highlightChangesDueToPanGR:(UIPanGestureRecognizer *)gr;
@end


@interface MGUActionSheet ()
@property (nonatomic, strong) MGUActionSheetConfiguration *configuration;
@property (nonatomic, assign, readonly) CGFloat containerViewLayoutMargin; // 일반적인 경우는 8.0 애플이 이렇게 사용한다.
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewTopAnchorConstraint;
@property (nonatomic, strong) NSLayoutConstraint *containerBottomAnchorConstraint; // alertContainerView 또는 bottomContainerView 에 대한 조건.
@end

@implementation MGUActionSheet
@synthesize actionButtons = _actionButtons;
@dynamic thirdContentView;
@dynamic maximumWidth;
@dynamic alertContainerViewCenterYConstraint;
@dynamic alertContainerViewCenterXConstraint;
@dynamic alertContainerViewHeightConstraint;
@dynamic textFields;
@dynamic configuration;
@dynamic containerViewLayoutMargin;

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection]; // 최초에 반드시 호출!
    //! 색깔.
    /*
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        if (self.resultImageView.image != nil) {
            self.resultImageView.image = nil;
            [self performSlowDrawing];
        }
    }*/

    //! 사이즈.
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {
        // 이러면 바뀔때만 들어오게 되고, 최초에 설정이 힘들어진다.
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) { // Pad는 여기서 뭔가를 조작하지 않는다.
        return;
    }
    
    //! iPhone OR iPhod
    self.alertContainerViewWidthConstraint.active = NO;
    self.alertContainerViewWidthConstraint = nil;
    if (self.configuration.isFullAppearance == YES) {
        self.alertContainerViewWidthConstraint = [self.alertContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor];
    } else if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) { // 1. Portait
        self.alertContainerViewWidthConstraint =
        [self.alertContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:(- self.containerViewLayoutMargin * 2.0)];
    } else {
        CGFloat constant = MAX(self.containerViewLayoutMargin * 2.0, self.safeAreaInsets.left + self.safeAreaInsets.right);
        self.alertContainerViewWidthConstraint =
        [self.alertContainerView.widthAnchor constraintEqualToAnchor:self.heightAnchor constant:-constant];
    }
    self.alertContainerViewWidthConstraint.active = YES;
    
    
    self.alertContainerViewTopAnchorConstraint.active = NO;
    self.alertContainerViewTopAnchorConstraint = nil;
    //! 약간 손봐야되지 않을까?
    CGFloat constant = MAX(self.containerViewLayoutMargin, self.safeAreaInsets.top);
    self.alertContainerViewTopAnchorConstraint =
    [self.alertContainerView.topAnchor constraintGreaterThanOrEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:constant];
    self.alertContainerViewTopAnchorConstraint.active = YES;
    
    if (self.configuration.isFullAppearance == NO) {
        self.containerBottomAnchorConstraint.active = NO;
        self.containerBottomAnchorConstraint = nil;
        if (self.bottomContainerView.hidden == NO) { // two piece
            if (self.containerViewLayoutMargin > self.safeAreaInsets.bottom) {
                self.containerBottomAnchorConstraint =
                [self.bottomContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                                      constant:-self.containerViewLayoutMargin];
            } else {
                self.containerBottomAnchorConstraint =
                [self.bottomContainerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor];
            }
        } else { // one piece
            if (self.containerViewLayoutMargin > self.safeAreaInsets.bottom) {
                self.containerBottomAnchorConstraint =
                [self.alertContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor
                                                                     constant:-self.containerViewLayoutMargin];
            } else {
                self.containerBottomAnchorConstraint =
                [self.alertContainerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor];
            }
        }
        self.containerBottomAnchorConstraint.active = YES;
    }
}

- (instancetype)initWithConfiguration:(MGUActionSheetConfiguration *)configuration {
    self = [super initWithConfiguration:configuration];
    if (self) {
        self.alertContainerViewWidthConstraint.active = NO;
        super.alertContainerViewCenterYConstraint.active = NO; // NS_UNAVAILABLE 이므로 super를 호출했다.
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            super.alertContainerViewCenterXConstraint.active = NO; // NS_UNAVAILABLE 이므로 super를 호출했다.
            super.alertContainerViewHeightConstraint.active = NO; // NS_UNAVAILABLE 이므로 super를 호출했다.
            [self.alertContainerView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor].active = YES;
            [self.alertContainerView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor].active = YES;
            [self.alertContainerView.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor].active = YES;
            [self.alertContainerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
            
            CGSize windowSize = [UIApplication mgrKeyWindow].bounds.size;
            CGFloat alertContainerViewWidthConstant = MAX(windowSize.width, windowSize.height) * (1.0/3.0);
            
            // 애플은 Sheet 모드에서 pad는 width 304.0 고정.
            CGFloat appleConstant = APPLE_ALERT_CONTROLLER_ACTION_SHEET_IPAD_WIDTH;
            alertContainerViewWidthConstant = MAX(MIN(400.0, alertContainerViewWidthConstant), appleConstant);
            
            self.alertContainerViewWidthConstraint = [self.alertContainerView.widthAnchor constraintEqualToConstant:alertContainerViewWidthConstant];
            
            // NSLayoutConstraint 이 calculate 되면서, 교착되므로 priority를 조정해줘야한다.
            self.alertContainerViewWidthConstraint.priority = UILayoutPriorityRequired - 1.0;
            self.alertContainerViewWidthConstraint.active = YES;
        }
        
        _bottomContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomContainerView.clipsToBounds = YES;
        
        self.bottomContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomContainerView];
        self.bottomContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bottomContainerView.leadingAnchor constraintEqualToAnchor:self.alertContainerView.leadingAnchor].active = YES;
        [self.bottomContainerView.trailingAnchor constraintEqualToAnchor:self.alertContainerView.trailingAnchor].active = YES;
        [self.bottomContainerView.topAnchor constraintEqualToAnchor:self.alertContainerView.bottomAnchor constant:self.containerViewLayoutMargin].active = YES;
        
        UIVisualEffectView *visualEffectView =
        [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:configuration.blurEffectStyle]];
        visualEffectView.userInteractionEnabled = NO;
        [self.bottomContainerView addSubview:visualEffectView];
        [visualEffectView mgrPinEdgesToSuperviewEdges];
        
        UIView *backgroundColorView = [UIView new];
        backgroundColorView.backgroundColor = configuration.alertViewBackgroundColor;
        [self.bottomContainerView addSubview:backgroundColorView];
        [backgroundColorView mgrPinEdgesToSuperviewEdges];
        
        if (configuration.isFullAppearance == YES) {
            self.alertContainerView.layer.cornerRadius = 0.0f;
            self.bottomContainerView.layer.cornerRadius = 0.0f;
        } else {
            self.alertContainerView.layer.cornerRadius = self.configuration.alertViewCornerRadius;
            self.bottomContainerView.layer.cornerRadius = self.configuration.alertViewCornerRadius;
        }
        
    }
    return self;
}

- (void)setActionButtons:(NSArray <MGUAlertViewButton *>*)actionButtons { // 컨트롤러의 - viewWillAppear:에서 호출된다.
    for (UIView *view  in self.actionButtonStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    __block MGUAlertViewButton *canCelButton = nil;
    [actionButtons enumerateObjectsUsingBlock:^(MGUAlertViewButton *button, NSUInteger idx, BOOL *stop) {
        if (button.alertActionStyle == UIAlertActionStyleCancel) {
            canCelButton = button;
            *stop = YES;
        }
    }];
    
    NSMutableArray *temp = actionButtons.mutableCopy;
    if (canCelButton != nil) {
        [temp removeObject:canCelButton];
        [temp addObject:canCelButton];
    }
    _actionButtons = actionButtons = temp.copy; // cancel 버튼이 존재할 경우, 제일 마지막으로 옮겨서 건내준다.
    //[super setActionButtons:actionButtons];
    
    NSMutableArray <MGUAlertViewButton *>*mainContainerButtons = actionButtons.mutableCopy;
    BOOL isTwoPiece = NO;
    if (canCelButton != nil && ((MGUActionSheetConfiguration *)self.configuration).isFullAppearance == NO) {
        isTwoPiece = YES;
        [mainContainerButtons removeObject:canCelButton];
    }
    
    if (isTwoPiece == YES) {
        //! safe area가 기계마다 차이가 존재한다.
        [self.bottomContainerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor
                                                                        constant:-self.containerViewLayoutMargin].active = YES;
        [self.bottomContainerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
        //[self.bottomContainerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
    } else {
        self.bottomContainerView.hidden = YES;
        if (self.configuration.isFullAppearance == YES) { // iPad는 항상 Full이다. iPad의 설정은 초기화 단계에서 했다.
            if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) { // 따라서 phone에서만 조정하면된다.
                [self.alertContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            }
        } else {
            //! safe area가 기계마다 차이가 존재한다.
            //! 원래 constant:-self.containerViewLayoutMargin 였는데, 수정했다.
            [self.alertContainerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor
                                                                           constant:-self.containerViewLayoutMargin].active = YES;
            [self.alertContainerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
            //[self.alertContainerView.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor].active = YES;
        }
    }

    if ((actionButtons.count == 2) && (self.configuration.alwaysArrangesActionButtonsVertically == NO)) { // 2 개 일 경우. 수평으로 배치할 것인가
        self.actionButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        self.actionButtonStackView.axis = UILayoutConstraintAxisVertical; // 원래 vertical
    }
        
    [mainContainerButtons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.configuration.showsSeparators && idx > 0) {
            // Add separator view
            UIView *separatorView = [[UIView alloc] init];
            [self.separatorViews addObject:separatorView];
            separatorView.backgroundColor = self.configuration.separatorColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;

            CGFloat scale = [UIScreen mainScreen].scale;
            if (self.actionButtonStackView.axis == UILayoutConstraintAxisVertical) {
                [separatorView.heightAnchor constraintEqualToConstant:1.0f / scale].active = YES;
            } else {
                [separatorView.widthAnchor constraintEqualToConstant:1.0f / scale].active = YES;
            }

            [self.actionButtonStackView addArrangedSubview:separatorView];
        }

        [button setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisVertical];
        [button setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisVertical];
        
        [button setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                forAxis:UILayoutConstraintAxisHorizontal];
        [button setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                  forAxis:UILayoutConstraintAxisHorizontal];
        
        [button setExclusiveTouch:YES];
        [self.actionButtonStackView addArrangedSubview:button];

        if (idx > 0) {
            UIButton *previousButton = actionButtons[idx - 1];
            [button.widthAnchor constraintEqualToAnchor:previousButton.widthAnchor].active = YES;
            [button.heightAnchor constraintEqualToAnchor:previousButton.heightAnchor].active = YES;
        } else { // idx == 0, Sheet Mode일때에는 56이다.
            [button.heightAnchor constraintEqualToConstant:56.0f].active = YES;
        }
        
        if (self.configuration.isFullAppearance == YES) {
            if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) { // 따라서 phone에서만 조정하면된다.
                self.actionButtonStackView.layoutMargins =
                UIEdgeInsetsMake(0.0, 0.0, self.safeAreaInsets.bottom + 10.0, 0.0);
                self.actionButtonStackView.layoutMarginsRelativeArrangement = YES;
            }
        }
    }];
    
    if (mainContainerButtons == nil) {
        for (UIView *separatorView in self.separatorViews) {
            separatorView.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (isTwoPiece == YES) {
        [canCelButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                forAxis:UILayoutConstraintAxisVertical];
        [canCelButton setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisVertical];
        
        [canCelButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                forAxis:UILayoutConstraintAxisHorizontal];
        [canCelButton setContentHuggingPriority:UILayoutPriorityFittingSizeLevel
                                  forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.bottomContainerView addSubview:canCelButton];
        [canCelButton mgrPinEdgesToSuperviewEdges];
        [actionButtons.firstObject.heightAnchor constraintEqualToAnchor:canCelButton.heightAnchor].active = YES;
    }
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(highlightChangesDueToPanGR:)];
    panGR.delegate = self;
    [self addGestureRecognizer:panGR];
    //
    // 버튼이 2 개만 존재할 경우, 수평으로 배치할 수도 있고 그렇지 않을 수 도 있다. 3 개 이상인 경우 무조건 수직 배치이다.
}


#pragma mark - 게터 @dynamic
- (CGFloat)containerViewLayoutMargin {
    if (self.configuration.isFullAppearance == NO) {
        return 8.0f;
    } else {
        return 0.0f;
    }
}


#pragma mark - FIXME: 테스트
- (void)safeAreaInsetsDidChange {
//    [self updateConstraintsIfNeeded];
//    [self setNeedsUpdateConstraints];
    [super safeAreaInsetsDidChange];
//    [self updateConstraintsIfNeeded];
//    [self setNeedsUpdateConstraints];
//    [self layoutIfNeeded];
//    [self updateConstraintsIfNeeded];
    UIEdgeInsets insets = self.safeAreaInsets;
    NSLog(@"어쩌라고?? %f %f %f %f", insets.top, insets.left, insets.bottom, insets.right);
}
@end
