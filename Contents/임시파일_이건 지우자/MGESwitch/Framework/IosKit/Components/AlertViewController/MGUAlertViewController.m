//
//  MGUAlertViewController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUAlertViewController.h"
#import "MGUAlertView.h"
#import "MGUAlertViewButton.h"
#import "MGUAlertDismissalAnimator.h"
#import "MGUAlertPresentationAnimator.h"
#import "MGUAlertPresentationController.h"
#import "MGUAlertActionConfiguration.h"
#import "UIApplication+Extension.h"

@interface MGUAlertViewController () <UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) MGUAlertView *view;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation MGUAlertViewController
@dynamic maximumWidth;   // 동적 제공
@dynamic contentView;    // 동적 제공
@dynamic secondContentView; // 동적 제공
@dynamic thirdContentView; // 동적 제공
@dynamic messageString;  // 동적 제공
@dynamic titleString;    // 동적 제공
@dynamic view;           // 수퍼 클래스에 존재함을 알리기 위해.

- (void)loadView {
    self.view = [[MGUAlertView alloc] initWithConfiguration:self.configuration];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createActionButtons];
    self.view.textFields = self.textFields;
}

- (void)viewDidDisappear:(BOOL)animated {
    // Necessary to avoid retain cycle - http://stackoverflow.com/a/21218703/1227862
//    self.transitioningDelegate = nil;
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithConfiguration:(nullable MGUAlertViewConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(NSArray<MGUAlertAction *> *)actions {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        MGUAlertViewConfiguration * config = [configuration copy];
        if (config == nil) {
            _configuration = [MGUAlertViewConfiguration new];
        } else {
            _configuration = config;
        }
        
        _actions = actions;
        _textFields = [NSArray array];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;

        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        self.panGestureRecognizer.delegate = self;
        self.panGestureRecognizer.enabled = configuration.swipeDismissalGestureEnabled;
        [self.view addGestureRecognizer:self.panGestureRecognizer]; //! self.view를 처음 호출하는 순간 loadView 메서드가 호출된다.
        [self setTitleString:title];
        [self setMessageString:message];
        [self setupNotificationForTextField]; // 텍스트 필드에 커서가 왔을 때, alert container 를 올릴 수도 있기 때문에.
    }

    return self;
}

- (void)createActionButtons {
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Create buttons for each action
    for (int i = 0; i < [self.actions count]; i++) {
        MGUAlertAction *action = self.actions[i];
        
        MGUAlertViewButton *button = [MGUAlertViewButton buttonWithType:UIButtonTypeCustom];

        button.tag = i; // 버튼을 구별하는 key이다.
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        button.enabled = action.enabled;
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];

        MGUAlertActionConfiguration *buttonConfiguration;
        if (action.configuration != nil) {
            buttonConfiguration = action.configuration;
        } else {
            switch (action.style) {
                case UIAlertActionStyleDefault:
                    buttonConfiguration = self.configuration.buttonConfiguration;
                    break;
                case UIAlertActionStyleCancel:
                    buttonConfiguration = self.configuration.cancelButtonConfiguration;
                    break;
                case UIAlertActionStyleDestructive:
                    buttonConfiguration = self.configuration.destructiveButtonConfiguration;
                    break;
            }
        }
        
        [button setTitleColor:buttonConfiguration.disabledTitleColor forState:UIControlStateDisabled];
        [button setTitleColor:buttonConfiguration.titleColor forState:UIControlStateNormal];
        [button setTitleColor:buttonConfiguration.titleColor forState:UIControlStateHighlighted];
        button.titleLabel.font = buttonConfiguration.titleFont;
        button.alertActionStyle = action.style; // Sheet Mode 대비위해 cancel 버튼을 찾을 수 있어야함.
        button.highlightedButtonBackgroundColor = buttonConfiguration.highlightedButtonBackgroundColor;

        [buttons addObject:button];
        action.actionButton = button;
    }
    
    self.view.actionButtons = buttons;
}

- (void)setupNotificationForTextField {
    //! candySearch에서 영감을 얻었다. keyboard가 올라올 때, alertContainerView의 위치를 올리겠다.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    __weak __typeof(self)weakSelf = self;
    [nc addObserverForName:UIKeyboardWillShowNotification // 키보드가 올라올 때
                    object:nil
                     queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf) self = weakSelf;
        [self handleKeyboardNotification:note];
    }];
    [nc addObserverForName:UIKeyboardDidHideNotification // 완전히 내려가고 나서 정리하는 것이 여기에서는 좋다.
                        object:nil
                     queue:NSOperationQueue.mainQueue
                usingBlock:^(NSNotification * _Nonnull note) {
        __strong __typeof(weakSelf) self = weakSelf;
        [self handleKeyboardNotification:note];
    }];
}

- (void)handleKeyboardNotification:(nullable NSNotification *)notification {
    NSNumber *duration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    NSNumber *animationCurveNumber = notification.userInfo[UIKeyboardAnimationCurveUserInfoKey];
    if (animationCurveNumber != nil) {
        UIViewAnimationCurve animationCurve = [animationCurveNumber integerValue];
        if (animationCurve == UIViewAnimationCurveEaseInOut) {
            options = UIViewAnimationOptionCurveEaseInOut;
        } else if (animationCurve == UIViewAnimationCurveEaseIn) {
            options = UIViewAnimationOptionCurveEaseIn;
        } else if (animationCurve == UIViewAnimationCurveEaseOut) {
            options = UIViewAnimationOptionCurveEaseOut;
        } else if (animationCurve == UIViewAnimationCurveLinear) {
            options = UIViewAnimationOptionCurveLinear;
        }
    }
    
    if ([notification.name isEqualToString:UIKeyboardDidHideNotification] == YES) { // 키보드 내릴 때, 호출된다.
        self.view.alertContainerViewCenterYConstraint.constant = 0.0f;
        MGUAlertPresentationController *presentationController = (MGUAlertPresentationController *)self.presentationController;
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration.doubleValue
                                                              delay:0.0
                                                            options:options
                                                         animations:^{
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                presentationController.backgroundDimmingView.alpha = 0.6;
            } else {
                presentationController.backgroundDimmingView.alpha = 0.4;
            }
            [self.view layoutIfNeeded];
        } completion:nil];
        return;
    }

    NSValue *keyboardFrame = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    if (notification.userInfo == nil || keyboardFrame == nil) {
        return;
    }
    
    CGFloat half = self.view.frame.size.height / 2.0;
    CGFloat keyboardHeight = keyboardFrame.CGRectValue.size.height;
    
    CGFloat interHeight = half - keyboardHeight - (self.view.alertContainerView.frame.size.height / 2.0);
    if (interHeight > 50.0) { // alertContainerView와 keyboard의 간격이 50.0이 안되면 조정하는 것이다.
        return;
    }
    self.view.alertContainerViewCenterYConstraint.constant = -(50.0 - interHeight); // -100.0f;
    MGUAlertPresentationController *presentationController = (MGUAlertPresentationController *)self.presentationController;
    
    CGFloat windowHeight = [UIApplication mgrKeyWindow].bounds.size.height;
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration.doubleValue
                                                          delay:0.0
                                                        options:options
                                                     animations:^{
        CGFloat dimAlpha;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            dimAlpha = 0.6;
        } else {
            dimAlpha = 0.4;
        }
        
        presentationController.backgroundDimmingView.alpha =
        dimAlpha - (ABS(self.view.alertContainerViewCenterYConstraint.constant) / windowHeight);
        [self.view layoutIfNeeded];
    } completion:nil];
}


#pragma mark - 세터 & 게터
- (void)setTitleString:(NSString *)titleString {
    self.view.titleLabel.text = titleString;
}

- (void)setMessageString:(NSString *)messageString {
    self.view.messageTextView.text = messageString;
}

- (CGFloat)maximumWidth {
    return self.view.maximumWidth;
}

- (void)setMaximumWidth:(CGFloat)maximumWidth {
    self.view.maximumWidth = maximumWidth;
}

- (UIView *)contentView {
    return self.view.contentView;
}

- (UIView *)secondContentView {
    return self.view.secondContentView;
}

- (UIView *)thirdContentView {
    return self.view.thirdContentView;
}

- (void)setContentView:(UIView *)contentView {
    self.view.contentView = contentView;
}

- (void)setSecondContentView:(UIView *)secondContentView {
    self.view.secondContentView = secondContentView;
}

- (void)setThirdContentView:(UIView *)thirdContentView {
    self.view.thirdContentView = thirdContentView;
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;

    if (configurationHandler != nil) {
        configurationHandler(textField);
    }

    _textFields = [self.textFields arrayByAddingObject:textField];
}


#pragma mark - 컨트롤
//! 스와이프를 처리하기 위한 팬 제스처 컨트롤 메서드.
- (void)panGestureRecognized:(UIPanGestureRecognizer *)gr {
    CGFloat translationY = [gr translationInView:self.view].y;
    //self.view.alertContainerViewCenterYConstraint.constant = translationY;
    self.view.alertContainerViewCenterYConstraint.constant += translationY;
    [gr setTranslation:CGPointZero inView:self.view];
    MGUAlertPresentationController *presentationController = (MGUAlertPresentationController *)self.presentationController;
    CGFloat windowHeight = [UIApplication mgrKeyWindow].bounds.size.height;
    //presentationController.backgroundDimmingView.alpha = 0.7f - (ABS(translationY) / windowHeight);
    
    CGFloat dimAlpha;
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        dimAlpha = 0.6;
    } else {
        dimAlpha = 0.4;
    }
    presentationController.backgroundDimmingView.alpha =
    dimAlpha - (ABS(self.view.alertContainerViewCenterYConstraint.constant) / windowHeight);
    
    if (gr.state == UIGestureRecognizerStateEnded) {
        CGFloat verticalGestureVelocity = [gr velocityInView:self.view].y;
        
        if (ABS(verticalGestureVelocity) > 500.0f) { // pan이 끝나는 시점의 가속도가 500.0 보다 빠르면 날려버린다.
            CGFloat backgroundViewYPosition;
            
            if (verticalGestureVelocity > 500.0f) {
                backgroundViewYPosition = CGRectGetHeight(self.view.frame);
            } else {
                backgroundViewYPosition = -CGRectGetHeight(self.view.frame);
            }
            
            self.view.alertContainerViewCenterYConstraint.constant = backgroundViewYPosition; // - layoutIfNeeded 로 인하여 스프링 애니메이션이 먹는다.
            
            CGVector initalVelocity = CGVectorMake(0.0f, 0.2f);
            UISpringTimingParameters *springTimingParameters =
            [[UISpringTimingParameters alloc] initWithDampingRatio:0.8f initialVelocity:initalVelocity];
            UIViewPropertyAnimator *animator =
            [[UIViewPropertyAnimator alloc] initWithDuration:500.0f / ABS(verticalGestureVelocity)
                                            timingParameters:springTimingParameters];
            
            void (^animationBlock)(void) = ^void() {
                presentationController.backgroundDimmingView.alpha = 0.0;
                [self.view layoutIfNeeded];
            };
            
            void (^completionBlock)(UIViewAnimatingPosition) = ^(UIViewAnimatingPosition finalPosition) {
                [self dismissViewControllerAnimated:YES completion:^{
                    self.view.alertContainerViewCenterYConstraint.constant = 0.0f;
                }];
            };
            
            [animator addAnimations:animationBlock];
            [animator addCompletion:completionBlock];
            [animator startAnimation];
        } else {
            [self.view endEditing:YES]; // 텍스트필드가 존재하여 키보드가 떠있을 경우, 내려버린다.
            self.view.alertContainerViewCenterYConstraint.constant = 0.0f; // - layoutIfNeeded 로 인하여 스프링 애니메이션이 먹는다.
            CGVector initalVelocity = CGVectorMake(0.0f, 0.4f);
            UISpringTimingParameters *springTimingParameters = [[UISpringTimingParameters alloc] initWithDampingRatio:0.8f
                                                                                                      initialVelocity:initalVelocity];
            UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5f
                                                                               timingParameters:springTimingParameters];
            
            void (^animationBlock)(void) = ^void() {
                if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    presentationController.backgroundDimmingView.alpha = 0.6;
                } else {
                    presentationController.backgroundDimmingView.alpha = 0.4;
                }
                [self.view layoutIfNeeded];
            };
            
            [animator addAnimations:animationBlock];
            [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {}];
            [animator startAnimation];
        }
    }
}

- (void)actionButtonPressed:(UIButton *)button {
    MGUAlertAction *action = self.actions[button.tag];

    if (action.handler != nil) {
        action.handler(action);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - <UIViewControllerTransitioningDelegate>
//! Mac에서는 <NSViewControllerPresentationAnimator> 에 해당할듯.

//! 등장할때 호출 1.
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    
    MGUAlertPresentationController *presentationController = [[MGUAlertPresentationController alloc] initWithPresentedViewController:presented
                                                                                                  presentingViewController:presenting];
    
    presentationController.backgroundTapDismissalGestureEnabled = self.configuration.backgroundTapDismissalGestureEnabled;
    presentationController.transitionStyle = self.configuration.transitionStyle;
    return presentationController;
}

//! 등장할때 호출 2.
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    MGUAlertPresentationAnimator *presentationAnimationController = [[MGUAlertPresentationAnimator alloc] init];
    presentationAnimationController.transitionStyle = self.configuration.transitionStyle;
    return presentationAnimationController;
}

//! 사라질때 호출
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    MGUAlertDismissalAnimator *dismissalAnimationController = [[MGUAlertDismissalAnimator alloc] init];
    dismissalAnimationController.transitionStyle = self.configuration.transitionStyle;
    return dismissalAnimationController;
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] == YES) { // 버튼에서 팬 제스처를 인식하지 못하므로 사용자가 아래를 터치 한 후 손가락을 멀리 움직일 수 있다.
        return NO;
    }
    
    return YES;
}

@end
