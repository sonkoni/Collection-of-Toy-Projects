//
//  MGUAlertView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertView.h"
#import "MGUAlertTextView.h"
#import "MGUAlertAction.h"
#import "MGUAlertViewButton.h"
#import "MGUAlertViewController.h"
#import "UIColor+Extension.h"
#import "UIApplication+Extension.h"
#import "UIView+Extension.h"

#define APPLE_ALERT_CONTROLLER_ALERT_WIDTH (270.0)


@interface MGUAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MGUAlertViewConfiguration *configuration;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewWidthConstraint;
@property (nonatomic, strong) UIView *contentViewContainerView;
@property (nonatomic, strong) UIView *secondContentViewContainerView;
@property (nonatomic, strong) UIView *thirdContentViewContainerView;
@property (nonatomic, strong) UIView *textFieldContainerView;
@property (nonatomic, strong) UIView *actionButtonContainerView;
@property (nonatomic, strong) UIStackView *actionButtonStackView;
@property (nonatomic, strong) UIImpactFeedbackGenerator *feedbackGenerator;
@property (nonatomic, strong) NSMutableArray <UIView *>*separatorViews;
@end

@implementation MGUAlertView

// presentation controller가 dismissal를 처리할 수 있도록 backgroundView 외부의 터치를 통과한다.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event { //! UIView에 존재함.
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES; // 터치를 responder chain 위로 올려버리지 않겠다. 나 또는 내 서브뷰에서 받겠다.
        }
    }
    return NO; // 터치를 흘려서 responder chain 위로 올려버린다.
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithConfiguration:(MGUAlertViewConfiguration *)configuration {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.maximumWidth = 300.0; // 애플은 Alert 모드에서 기계와 관계없이 width 270.0 NYAlertViewController는 480.0 이었음.
        _configuration = configuration;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _alertContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.alertContainerView.clipsToBounds = YES;
    self.alertContainerView.layer.cornerRadius = self.configuration.alertViewCornerRadius;
    self.alertContainerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.alertContainerView];
    self.alertContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIVisualEffectView *visualEffectView =
    [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.configuration.blurEffectStyle]];
    visualEffectView.userInteractionEnabled = NO;
    [self.alertContainerView addSubview:visualEffectView];
    [visualEffectView mgrPinEdgesToSuperviewEdges];
    
    UIView *backgroundColorView = [UIView new];
    backgroundColorView.userInteractionEnabled = NO;
    backgroundColorView.backgroundColor = self.configuration.alertViewBackgroundColor;
    [self.alertContainerView addSubview:backgroundColorView];
    [backgroundColorView mgrPinEdgesToSuperviewEdges];
    
    _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.alertContainerView addSubview:self.contentViewContainerView];
    self.contentViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _secondContentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.alertContainerView addSubview:self.secondContentViewContainerView];
    self.secondContentViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _thirdContentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.alertContainerView addSubview:self.thirdContentViewContainerView];
    self.thirdContentViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = self.configuration.titleFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = self.configuration.titleTextColor;
    self.titleLabel.text = NSLocalizedString(@"Title Label", nil);
    [self.alertContainerView addSubview:self.titleLabel];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _messageTextView = [[MGUAlertTextView alloc] initWithFrame:CGRectZero];
    self.messageTextView.backgroundColor = [UIColor clearColor];
    self.messageTextView.editable = NO;
    self.messageTextView.textAlignment = NSTextAlignmentCenter;
    self.messageTextView.textColor = self.configuration.messageTextColor;
    self.messageTextView.font = self.configuration.messageFont;
    self.messageTextView.text = NSLocalizedString(@"Message Text View", nil);
    [self.alertContainerView addSubview:self.messageTextView];
    [self.messageTextView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
    [self.messageTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    self.messageTextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _textFieldContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.alertContainerView addSubview:self.textFieldContainerView];
    self.textFieldContainerView .translatesAutoresizingMaskIntoConstraints = NO;
    
    _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.alertContainerView addSubview:self.actionButtonContainerView];
    self.actionButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    _actionButtonStackView = [[UIStackView alloc] init];
    [self.actionButtonContainerView addSubview:self.actionButtonStackView];
    [self.actionButtonStackView mgrPinEdgesToSuperviewEdges];
    _separatorViews = [NSMutableArray array];
    if (self.configuration.showsSeparators == YES) {
        UIView *separatorView = [[UIView alloc] init];
        [self.separatorViews addObject:separatorView];
        separatorView.backgroundColor = self.configuration.separatorColor;
        [self.alertContainerView addSubview:separatorView];
        separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
        [separatorView.leadingAnchor constraintEqualToAnchor:self.alertContainerView.leadingAnchor].active = YES;
        [separatorView.trailingAnchor constraintEqualToAnchor:self.alertContainerView.trailingAnchor].active = YES;
        [separatorView.bottomAnchor constraintEqualToAnchor:self.actionButtonStackView.topAnchor].active = YES;
    }

    CGSize windowSize = [UIApplication mgrKeyWindow].bounds.size;
    CGFloat alertContainerViewWidthConstant = MIN(windowSize.width, windowSize.height) * 0.8f;
    
    // 애플은 Alert 모드에서 기계(pad 및 phone)와 관계없이 width 270.0
    CGFloat appleConstant = APPLE_ALERT_CONTROLLER_ALERT_WIDTH;
    alertContainerViewWidthConstant = MAX(MIN(self.maximumWidth, alertContainerViewWidthConstant), appleConstant);
    
    _alertContainerViewCenterXConstraint = [self.alertContainerView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    self.alertContainerViewCenterXConstraint.active = YES; // iPad에서 Sheet Mode 일경우 없애야함.
    _alertContainerViewCenterYConstraint = [self.alertContainerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    self.alertContainerViewCenterYConstraint.active = YES; // swipe로 날리기 위해
    _alertContainerViewHeightConstraint = [self.alertContainerView.heightAnchor constraintLessThanOrEqualToAnchor:self.heightAnchor multiplier:0.9];
    self.alertContainerViewHeightConstraint.active = YES; // iPad에서 Sheet Mode 일경우 없애야함.
    _alertContainerViewWidthConstraint = [self.alertContainerView.widthAnchor constraintEqualToConstant:alertContainerViewWidthConstant];
    self.alertContainerViewWidthConstraint.active = YES;
    
    [self.contentViewContainerView mgrPinHorizontalEdgesToSuperviewEdges]; // leading, trailing만 super에 맞춘다.
    [self.secondContentViewContainerView mgrPinHorizontalEdgesToSuperviewEdges]; // leading, trailing만 super에 맞춘다.
    [self.thirdContentViewContainerView mgrPinHorizontalEdgesToSuperviewEdges]; // leading, trailing만 super에 맞춘다.
    
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.alertContainerView.leadingAnchor constant:8.0].active = YES;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.alertContainerView.trailingAnchor constant:-8.0].active = YES;
    
    [self.messageTextView.leadingAnchor constraintEqualToAnchor:self.alertContainerView.leadingAnchor constant:8.0].active = YES;
    [self.messageTextView.trailingAnchor constraintEqualToAnchor:self.alertContainerView.trailingAnchor constant:-8.0].active = YES;

    [self.textFieldContainerView mgrPinHorizontalEdgesToSuperviewEdges]; // leading, trailing만 super에 맞춘다.
    [self.actionButtonContainerView mgrPinHorizontalEdgesToSuperviewEdges]; // leading, trailing만 super에 맞춘다.
    
    NSLayoutConstraint *layoutConstraint = [self.contentViewContainerView.heightAnchor constraintEqualToConstant:0.0];
    layoutConstraint.priority = UILayoutPriorityDefaultLow; // 250 - 무언가를 담고 있는 컨테이너 뷰의 heightAnchor는 0.0 & 250
    layoutConstraint.active = YES;
    
    layoutConstraint = [self.secondContentViewContainerView.heightAnchor constraintEqualToConstant:0.0];
    layoutConstraint.priority = UILayoutPriorityDefaultLow; // 250 - 무언가를 담고 있는 컨테이너 뷰의 heightAnchor는 0.0 & 250
    layoutConstraint.active = YES;
    
    layoutConstraint = [self.thirdContentViewContainerView.heightAnchor constraintEqualToConstant:0.0];
    layoutConstraint.priority = UILayoutPriorityDefaultLow; // 250 - 무언가를 담고 있는 컨테이너 뷰의 heightAnchor는 0.0 & 250
    layoutConstraint.active = YES;
    
    layoutConstraint = [self.textFieldContainerView.heightAnchor constraintEqualToConstant:0.0];
    layoutConstraint.priority = UILayoutPriorityDefaultLow; // 250 - 무언가를 담고 있는 컨테이너 뷰의 heightAnchor는 0.0 & 250
    layoutConstraint.active = YES;
    
    [self.alertContainerView.topAnchor constraintEqualToAnchor:self.contentViewContainerView.topAnchor].active = YES;
    [self.contentViewContainerView.bottomAnchor constraintEqualToAnchor:self.titleLabel.topAnchor constant:-8.0].active = YES;
    [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.messageTextView.topAnchor constant:-2.0].active = YES;
    [self.messageTextView.bottomAnchor constraintEqualToAnchor:self.secondContentViewContainerView.topAnchor].active = YES;
    [self.secondContentViewContainerView.bottomAnchor constraintEqualToAnchor:self.textFieldContainerView.topAnchor].active = YES;
    [self.textFieldContainerView.bottomAnchor constraintEqualToAnchor:self.thirdContentViewContainerView.topAnchor].active = YES;
    [self.thirdContentViewContainerView.bottomAnchor constraintEqualToAnchor:self.actionButtonContainerView.topAnchor constant:-8.0].active = YES;
    [self.actionButtonContainerView.bottomAnchor constraintEqualToAnchor:self.alertContainerView.bottomAnchor].active = YES;
    
    if (self.configuration.onlyOneContentView == YES) {
        [self.secondContentViewContainerView removeFromSuperview];
        [self.thirdContentViewContainerView removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.messageTextView removeFromSuperview];
        [self.textFieldContainerView removeFromSuperview];
        [self.actionButtonContainerView.topAnchor constraintEqualToAnchor:self.contentViewContainerView.bottomAnchor].active = YES;
    }
    
    _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [self.feedbackGenerator prepare];
}

#pragma mark - 세터 & 게터

- (void)setMaximumWidth:(CGFloat)maximumWidth {
    _maximumWidth = maximumWidth;
    self.alertContainerViewWidthConstraint.constant = maximumWidth;
}

- (void)setContentView:(UIView *)contentView {
    [self.contentView removeFromSuperview];
    _contentView = contentView;
    
    if (contentView != nil) {
        self.contentViewContainerView.layoutMargins = self.configuration.contentViewInset;
        [self.contentViewContainerView addSubview:self.contentView];
        [self.contentView mgrPinEdgesToSuperviewLayoutMarginsGuide];
    }
}

- (void)setSecondContentView:(UIView *)secondContentView {
    [self.secondContentView removeFromSuperview];
    _secondContentView = secondContentView;
    
    if (secondContentView != nil) {
        self.secondContentViewContainerView.layoutMargins = self.configuration.contentViewInset;
        [self.secondContentViewContainerView addSubview:self.secondContentView];
        [self.secondContentView mgrPinEdgesToSuperviewLayoutMarginsGuide];
    }
}

- (void)setThirdContentView:(UIView *)thirdContentView {
    [self.thirdContentView removeFromSuperview];
    _thirdContentView = thirdContentView;
    
    if (thirdContentView != nil) {
        self.thirdContentViewContainerView.layoutMargins = self.configuration.contentViewInset;
        [self.thirdContentViewContainerView addSubview:self.thirdContentView];
        [self.thirdContentView mgrPinEdgesToSuperviewLayoutMarginsGuide];
    }
}

//! alertView controller가 viewWillAppear: 메서드에서 호출된다.
- (void)setTextFields:(NSArray <UITextField *>*)textFields {
    for (UITextField *textField in self.textFields) {
        [textField removeFromSuperview];
    }
    
    _textFields = textFields;
    
    for (int i = 0; i < [textFields count]; i++) {
        UITextField *textField = textFields[i];
        [self.textFieldContainerView addSubview:textField];
        
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        [textField.leadingAnchor constraintEqualToAnchor:self.textFieldContainerView.leadingAnchor constant:8.0].active = YES;
        [textField.trailingAnchor constraintEqualToAnchor:self.textFieldContainerView.trailingAnchor constant:-8.0].active = YES;
        
        if (i == 0) { // 첫 번째 텍스트 필드
            [textField.topAnchor constraintEqualToAnchor:self.textFieldContainerView.layoutMarginsGuide.topAnchor].active = YES;
        } else { // 두 번째 이상의 텍스트 필드
            UITextField *previousTextField = textFields[i - 1];
            [previousTextField.bottomAnchor constraintEqualToAnchor:textField.topAnchor constant:-8.0].active = YES;
        }
        
        if (i == ([textFields count] - 1)) { // 마지막 텍스트 필드
            [textField.bottomAnchor constraintEqualToAnchor:self.textFieldContainerView.layoutMarginsGuide.bottomAnchor].active = YES;
        }
    }
}

- (void)setActionButtons:(NSArray <MGUAlertViewButton *>*)actionButtons { // 컨트롤러의 - viewWillAppear:에서 호출된다.
    for (UIView *view  in self.actionButtonStackView.arrangedSubviews) {
        [view removeFromSuperview];
    }
    
    _actionButtons = actionButtons; // 버튼 객체(배열)들을 건내준다.

    if ((actionButtons.count == 2) && (self.configuration.alwaysArrangesActionButtonsVertically == NO)) { // 2 개 일 경우. 수평으로 배치할 것인가
        self.actionButtonStackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        self.actionButtonStackView.axis = UILayoutConstraintAxisVertical; // 원래 vertical
    }

    [actionButtons enumerateObjectsUsingBlock:^(UIButton *  _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.configuration.showsSeparators && idx > 0) {
            // Add separator view
            UIView *separatorView = [[UIView alloc] init];
            [self.separatorViews addObject:separatorView];
            separatorView.backgroundColor = self.configuration.separatorColor;
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;

            if (self.actionButtonStackView.axis == UILayoutConstraintAxisVertical) {
                [separatorView.heightAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            } else {
                [separatorView.widthAnchor constraintEqualToConstant:1.0f / [UIScreen mainScreen].scale].active = YES;
            }

            [self.actionButtonStackView addArrangedSubview:separatorView];
        }

        [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [button setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [button setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        
        [button setExclusiveTouch:YES];
        [self.actionButtonStackView addArrangedSubview:button];

        if (idx > 0) {
            UIButton *previousButton = actionButtons[idx - 1];
            [button.widthAnchor constraintEqualToAnchor:previousButton.widthAnchor].active = YES;
            [button.heightAnchor constraintEqualToAnchor:previousButton.heightAnchor].active = YES;
        }
    }];
    
    if (actionButtons == nil) {
        for (UIView *separatorView in self.separatorViews) {
            separatorView.backgroundColor = [UIColor clearColor];
        }
    }
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(highlightChangesDueToPanGR:)];
    panGR.delegate = self;
    [self addGestureRecognizer:panGR];
    //
    // 버튼이 2 개만 존재할 경우, 수평으로 배치할 수도 있고 그렇지 않을 수 도 있다. 3 개 이상인 경우 무조건 수직 배치이다.
}


#pragma mark - 컨트롤
//! 버튼을 누른채 움직이면 현재 터치된 상태의 버튼이 하이라이팅 되게 만든다.
- (void)highlightChangesDueToPanGR:(UIPanGestureRecognizer *)gr {
    //! CGPoint point = [gr locationInView:self.actionButtonStackView];
    CGPoint point = [gr locationInView:self]; // Sheet Mode에서도 작동되게 하기 위해
    
    if (gr.state == UIGestureRecognizerStateChanged || gr.state == UIGestureRecognizerStateEnded) {
        for (MGUAlertViewButton *button in self.actionButtons.objectEnumerator) {
            
            CGRect relativeRect = [button convertRect:button.bounds toView:self];
            BOOL points = CGRectContainsPoint(relativeRect, point) && !button.isHidden; // Sheet Mode에서도 작동되게 하기 위해
            //! BOOL points = CGRectContainsPoint(button.frame, point) && !button.isHidden;
            
            if (gr.state == UIGestureRecognizerStateChanged) {
                BOOL feedbackGeneratorOperate = NO;
                if (button.highlighted == NO && points == YES) {
                    feedbackGeneratorOperate = YES;
                }
                
                [button setHighlighted:points];
                
                //! 위의 메서드에서 인수에 YES를 대입해도 button 자체가 disable 상태라면 highlighted는 여전히 NO일 수 있다.
                if (feedbackGeneratorOperate == YES && button.highlighted == YES) { //
                    [self.feedbackGenerator impactOccurred];
                    [self.feedbackGenerator prepare];
                }
            } else {
                [button setHighlighted:NO];
            }
            
            if (gr.state == UIGestureRecognizerStateEnded && points && button.enabled) {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[MGUAlertViewButton class]] == YES) { // 버튼에서 팬 제스처를 인식하지 못하므로 사용자가 아래를 터치 한 후 손가락을 멀리 움직일 수 있다.
        return YES;
    }
    return NO;
}

@end
