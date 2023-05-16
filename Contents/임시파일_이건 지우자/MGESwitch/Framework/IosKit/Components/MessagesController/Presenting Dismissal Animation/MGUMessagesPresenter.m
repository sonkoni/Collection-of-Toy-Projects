//
//  Presenter.m
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/12.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "UIWindow+Extension.h"
#import "MGUMessagesPresenter.h"
#import "MGUMessagesConfig.h"
#import "MGUMessagesTopBottomAnimation.h"
#import "MGUMessagesPhysicsAnimation.h"
#import "MGUMessagesMaskingView.h"
#import "MGUMessagesAnimationContext.h"
#import "MGUMessagesViewController.h"
#import "MGUMessageView.h"
#import "UIViewController+MGUMessages.h"

typedef NS_ENUM(NSUInteger, MGUMessagesPresenterContext) {
    MGUMessagesPresenterContextViewController = 1, // 딤 모드에 따라.
    MGUMessagesPresenterContextView
};

@interface MGUMessagesPresenter ()
@property (nonatomic, weak, nullable) id <MGUMessagesPresenterDelegate>delegate;
@property (nonatomic, assign) BOOL interactivelyHidden; // 디폴트 NO

@property (nonatomic, assign) MGUMessagesPresenterContext context; // 디폴트 MGUMessagesPresenterContextViewController
@property (nonatomic, weak, nullable) UIViewController *contextViewController; // MGUMessagesPresenterContextViewController 일때에만 존재
@property (nonatomic, weak, nullable) UIView *contextView; // 모드에 따라서 다르다.
@end

@implementation MGUMessagesPresenter
@dynamic pauseDuration;
@dynamic delayHide;
@dynamic delayShow;

+ (id <MGUMessagesAnimator>)animatorForConfig:(MGUMessagesConfig *)config delegate:(id <MGUMessagesAnimationDelegate>)delegate {
    if (config.presentationStyle == MGUMessagesPresentationStyleTop) {
        return [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleTop delegate:delegate];
    } else if (config.presentationStyle == MGUMessagesPresentationStyleBottom) {
        return [[MGUMessagesTopBottomAnimation alloc] initWithStyle:MGUMessagesTopBottomAnimationStyleBottom delegate:delegate];
    } else if (config.presentationStyle == MGUMessagesPresentationStyleCenter) {
        return [[MGUMessagesPhysicsAnimation alloc] initWithDelegate:delegate];
    } else  { // config.presentationStyle == MGUMessagesPresentationStyleCustom
        if (config.presentationStyle != MGUMessagesPresentationStyleCustom) {
            NSCAssert(FALSE, @"없는 스타일 들어옴.");
        }
        config.animator.delegate = delegate;
        return config.animator;
    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithConfig:(MGUMessagesConfig *)config
                          view:(UIView *)view
                      delegate:(id<MGUMessagesPresenterDelegate>)delegate {
    self = [super init];
    if (self) {
        CommonInit(self);
        _config = config;
        _view = view;
        _delegate = delegate;
        _animator = [MGUMessagesPresenter animatorForConfig:config delegate:delegate];
        UIView <MGUMessagesIdentifiable>*identifiable = (UIView <MGUMessagesIdentifiable>*)view;
        if ([identifiable conformsToProtocol:@protocol(MGUMessagesIdentifiable)]) {
            self.identifier = identifiable.identifier;
        } else {
            self.identifier = [NSString stringWithFormat:@"%p", &view];
        }
        
    }
    return self;
}

static void CommonInit(MGUMessagesPresenter *self) {
    self->_showDate = MGEFloatNull;
    self->_hiding = NO;
    self->_interactivelyHidden = NO;
    self->_maskingView = [MGUMessagesMaskingView new];
    self->_context = MGUMessagesPresenterContextViewController;
    self->_contextViewController = nil;
}


#pragma mark - 세터 & 게터
- (UIView *)contextView {
    if (self.context == MGUMessagesPresenterContextViewController) {
        return _contextViewController.view;
    } else {
        return _contextView;
    }
}

- (UIViewController *)contextViewController {
    if (self.context == MGUMessagesPresenterContextViewController) {
        return _contextViewController;
    } else {
        return nil;
    }
}

- (NSTimeInterval)delayShow {
    if (self.config.duration == MGUMessagesPresentationDurationIndefinite) {
        return self.config.durationIndefiniteDelay;
    }
    return MGEFloatNull;
}

- (NSTimeInterval)delayHide {
    if (self.interactivelyHidden == YES) {
        return 0.0;
    } else if (MGEFloatIsNull(self.showDate) == NO) {
        if (self.config.duration == MGUMessagesPresentationDurationIndefinite && MGEFloatIsNull(self.config.durationIndefiniteMinimum)) {
            CFTimeInterval timeIntervalShown = CACurrentMediaTime() - self.showDate;
            return MAX(0, self.config.durationIndefiniteMinimum - timeIntervalShown);
        }
    }
    return MGEFloatNull;
}

- (NSTimeInterval)pauseDuration {
    if (self.config.duration == MGUMessagesPresentationDurationAutomatic) {
        return 2.0;
    } else if (self.config.duration == MGUMessagesPresentationDurationSeconds) {
        return self.config.durationSeconds;
    } else {
        return MGEFloatNull;
    }
}


#pragma mark - Action
- (BOOL)showCompletion:(void (^)(BOOL completed))completion error:(NSError * _Nullable *)error {
    self.context = [self getPresentationContextError:error];
    [self install];
    
    [self.config.eventListeners enumerateObjectsUsingBlock:^(MGUMessagesEventListener obj, NSUInteger idx, BOOL *stop) {
        obj(MGUMessagesEventWillShow);
    }];

    [self showAnimation:^(BOOL completed) {
        if (completion == nil) {
            NSCAssert(FALSE, @"닐이 들어왔다.");
        }
        completion(completed);
        
        if (completed == YES) {
            if (self.config.dimMode != MGUMessagesDimModeNone) {
                [self showAccessibilityFocus];
            } else {
                [self showAccessibilityAnnouncement];
            }
            
            [self.config.eventListeners enumerateObjectsUsingBlock:^(MGUMessagesEventListener obj, NSUInteger idx, BOOL *stop) {
                obj(MGUMessagesEventDidShow);
            }];
        }
    }];
    
    if (error == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL completed))completion {
    self.hiding = YES;
    [self.config.eventListeners enumerateObjectsUsingBlock:^(MGUMessagesEventListener listener, NSUInteger idx, BOOL * _Nonnull stop) {
        listener(MGUMessagesEventWillHide);
    }];
    
    MGUMessagesAnimationContext *context = [self animationContext];
    
    void (^actionBlock)(void) = ^{
        MGUMessagesViewController *viewController = (MGUMessagesViewController *)(self.contextViewController);
        if ([viewController isKindOfClass:[MGUMessagesViewController class]] == YES) {
            [viewController uninstall];
        }
        
        [self.maskingView removeFromSuperview];
        if (completion == nil) {
            NSCAssert(FALSE, @"블락이 닐이다.");
        }
        completion(YES);
        [self.config.eventListeners enumerateObjectsUsingBlock:^(MGUMessagesEventListener obj, NSUInteger idx, BOOL *stop) {
            obj(MGUMessagesEventDidHide);
        }];
    };

    if (animated == NO) {
        actionBlock();
        return;
    }

    [self.animator hideContext:context completion:^(BOOL completed) {
        actionBlock();
    }];

    void (^undimBlock)(void) = ^{
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ self.maskingView.backgroundColor = [UIColor clearColor]; }
                         completion:^(BOOL finished) {}];
    };
    
    void (^unblurBlock)(void) = ^{
        UIVisualEffectView *view = (UIVisualEffectView *)(self.maskingView.backgroundView);
        if ([view isKindOfClass:[UIVisualEffectView class]] == NO) {
            return;
        }
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ view.effect = nil; }
                         completion:^(BOOL finished) {}];
    };


    if (self.config.dimMode == MGUMessagesDimModeGray || self.config.dimMode == MGUMessagesDimModeColor) {
        undimBlock();
    } else if (self.config.dimMode == MGUMessagesDimModeBlur) {
        unblurBlock();
    }
}


#pragma mark - Helper
- (MGUMessagesAnimationContext *)animationContext {
    return [[MGUMessagesAnimationContext alloc] initWithMessageView:self.view
                                           containerView:self.maskingView
                                       safeZoneConflicts:[self safeZoneConflicts]
                                         interactiveHide:self.config.interactiveHide];
}

- (MGUMessagesSafeZoneConflicts)safeZoneConflicts {
    UIWindow *window = self.maskingView.window;
    if (window == nil) {
        return 0;
    }
    
    UIWindowLevel windowLevel = UIWindowLevelNormal;
    MGUMessagesViewController *vc = (MGUMessagesViewController *)(self.contextViewController);
    if (self.context == MGUMessagesPresenterContextViewController &&
        [vc isKindOfClass:[MGUMessagesViewController class]] == YES) {
        UIWindowLevel level = vc.config.windowLevel;
        if (MGEFloatIsNull(level) == NO) {
            windowLevel = level;
        }
    }
    
    // TODO `underNavigationBar` and `underTabBar` should look up the presentation context's hierarchy
    // TODO for cases where both should be true (probably not an issue for typical height messages, though).
    BOOL underNavigationBar = NO;
    UINavigationController *navigationController = (UINavigationController *)(self.contextViewController);
    if (self.context == MGUMessagesPresenterContextViewController &&
        [navigationController isKindOfClass:[UINavigationController class]] == YES) {
        return [navigationController sm_isVisibleView:navigationController.navigationBar];
    }
    
    BOOL underTabBar = NO;
    UITabBarController *tabBarController = (UITabBarController *)(self.contextViewController);
    if (self.context == MGUMessagesPresenterContextViewController &&
        [tabBarController isKindOfClass:[UITabBarController class]] == YES) {
        return [tabBarController sm_isVisibleView:tabBarController.tabBar];
    }
    
    if (windowLevel != UIWindowLevelNormal) {
        // TODO seeing `maskingView.safeAreaInsets.top` value of 20 on
        // iPhone 8 with status bar window level. This seems like an iOS bug since
        // the message view's window is above the status bar. Applying a special rule
        // to allow the animator to revove this amount from the layout margins if needed.
        // This may need to be reworked if any future device has a legitimate 20pt top safe area,
        // such as with a potentially smaller notch.
        if (self.maskingView.safeAreaInsets.top == 20.0) {
            return MGUMessagesSafeZoneConflictsOverStatusBar;
        } else {
            MGUMessagesSafeZoneConflicts conflicts = 0;
            if (self.maskingView.safeAreaInsets.top > 0) {
                conflicts = conflicts + MGUMessagesSafeZoneConflictsSensorNotch;
            }
            if (self.maskingView.safeAreaInsets.bottom > 0) {
                conflicts = conflicts + MGUMessagesSafeZoneConflictsHomeIndicator;
            }
            return conflicts;
        }
    } else {
        MGUMessagesSafeZoneConflicts conflicts = 0;
        if (underNavigationBar == NO) {
            conflicts = conflicts + MGUMessagesSafeZoneConflictsSensorNotch;
        }
        if (underTabBar == NO) {
            conflicts = conflicts + MGUMessagesSafeZoneConflictsHomeIndicator;
        }
        return conflicts;
    }
}


- (MGUMessagesPresenterContext)getPresentationContextError:(NSError * _Nullable *)error {
    UIViewController *(^newWindowViewController)(void) = ^UIViewController * {
        MGUMessagesViewController *viewController = [MGUMessagesViewController newInstanceConfig:self.config];
        return viewController;
    };
    
    if (self.config.presentationContext == MGUMessagesPresentationContextAutomatic) {
        @try {
            UIViewController *rootViewController = [UIWindow mgrKeyWindow].rootViewController;
            if (rootViewController != nil) {
                UIViewController *viewController = [rootViewController sm_selectPresentationContextTopDown:self.config];
                _context = MGUMessagesPresenterContextViewController;
                _contextViewController = viewController;
                return _context;
            } else {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"rootViewController 없다."
                                                                     forKey:NSLocalizedFailureReasonErrorKey];
                *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadCorruptFileError userInfo:userInfo];
                [*error mgrMakeExceptionAndThrow];
            }
        } @catch(NSException *excpt) {
            [excpt mgrDescription];
        }
        
        
    } else if (self.config.presentationContext == MGUMessagesPresentationContextWindowLevel || self.config.presentationContext == MGUMessagesPresentationContextWindowScene) {
        UIViewController *viewController = newWindowViewController();
        _context = MGUMessagesPresenterContextViewController;
        _contextViewController = viewController;
        return _context;
    } else if (self.config.presentationContext == MGUMessagesPresentationContextViewController) {
        _context = MGUMessagesPresenterContextViewController;
        UIViewController *viewController = [self.config.viewController sm_selectPresentationContextBottomUp:self.config];
        _contextViewController = viewController;
        return _context;
    } else  {
        if (self.config.presentationContext != MGUMessagesPresentationContextView) {
            NSCAssert(FALSE, @"예상치 못한 enum 결과가 들어왔다.");
        }
        _context = MGUMessagesPresenterContextView;
        _contextView = self.config.view;
        return _context;
    }
}

- (void)install {
    NSLayoutConstraint *(^topLayoutConstraint)(UIView *, UIView *, UIViewController *) =
    ^NSLayoutConstraint* (UIView *view, UIView *containerView, UIViewController * _Nullable viewController){
        UINavigationController *nav = (UINavigationController *)(viewController);
        if (self.config.presentationStyle == MGUMessagesPresentationStyleTop &&
            [nav isKindOfClass:[UINavigationController class]] &&
            [nav sm_isVisibleView:nav.navigationBar]) {
            return [NSLayoutConstraint constraintWithItem:view
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:nav.navigationBar
                                                attribute:NSLayoutAttributeBottom
                                               multiplier:1.0
                                                 constant:0.0];
        }
        
        return [NSLayoutConstraint constraintWithItem:view
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:containerView
                                            attribute:NSLayoutAttributeTop
                                           multiplier:1.0
                                             constant:0.0];
    };
    
    NSLayoutConstraint *(^bottomLayoutConstraint)(UIView *, UIView *, UIViewController *) =
    ^NSLayoutConstraint* (UIView *view, UIView *containerView, UIViewController * _Nullable viewController){
        UITabBarController *tab = (UITabBarController *)(viewController);
        if (self.config.presentationStyle == MGUMessagesPresentationStyleBottom &&
            [tab isKindOfClass:[UITabBarController class]] &&
            [tab sm_isVisibleView:tab.tabBar]) {
            return [NSLayoutConstraint constraintWithItem:view
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:tab.tabBar
                                                attribute:NSLayoutAttributeTop
                                               multiplier:1.0
                                                 constant:0.0];
        }
        
        return [NSLayoutConstraint constraintWithItem:view
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:containerView
                                            attribute:NSLayoutAttributeBottom
                                           multiplier:1.0
                                             constant:0.0];
    };

    void (^installMaskingView)(UIView *) = ^(UIView *containerView){
        self.maskingView.translatesAutoresizingMaskIntoConstraints = NO;
        UINavigationController *nav = (UINavigationController *)(self.contextViewController);
        UITabBarController *tab = (UITabBarController *)(self.contextViewController);
        if (self.context == MGUMessagesPresenterContextViewController &&
            [nav isKindOfClass:[UINavigationController class]] == YES) {
            [containerView insertSubview:self.maskingView belowSubview:nav.navigationBar];
        } else if (self.context == MGUMessagesPresenterContextViewController &&
                   [tab isKindOfClass:[UITabBarController class]] == YES) {
            [containerView insertSubview:self.maskingView belowSubview:tab.tabBar];
        } else {
            [containerView addSubview:self.maskingView];
        }
        
        [self.maskingView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor].active = YES;
        [self.maskingView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor].active = YES;
        
        NSLayoutConstraint *constraint = topLayoutConstraint(self.maskingView, containerView, self.contextViewController);
        constraint.active = YES;
        
        constraint = bottomLayoutConstraint(self.maskingView, containerView, self.contextViewController);
        constraint.active = YES;
        
        MGUMessagesKeyboardTrackingView *keyboardTrackingView = self.config.keyboardTrackingView;
        if (keyboardTrackingView != nil) {
            [self.maskingView installKeyboardTrackingView:keyboardTrackingView];
        }
        
        // Update the container view's layout in order to know the masking view's frame
        [containerView layoutIfNeeded];
    };
    
    __weak __typeof(self) weakSelf = self;
    void (^installInteractive)(void) = ^{
        if (self.config.dimMode == MGUMessagesDimModeNone) { // 모달 형태가 아니다.
            return;
        }

        if (self.config.dimModeInteractive == YES) {
            self.maskingView.tappedHander = ^{
                __strong __typeof(weakSelf) self = weakSelf;
                self.interactivelyHidden = YES;
                [self.delegate hidePresenter:self];
            };
        } else {
            // There's no action to take, but the presence of
            // a tap handler prevents interaction with underlying views.
            self.maskingView.tappedHander = ^{};
        }
    };
    
    void (^installAccessibility)(void) = ^{
        NSMutableArray *elements = @[].mutableCopy;
        UIView <MGUMessagesAccessibleMessage>*accessibleMessage = (UIView <MGUMessagesAccessibleMessage>*)(self.view);
        
        if ([accessibleMessage conformsToProtocol:@protocol(MGUMessagesAccessibleMessage)] == YES) {
            
            NSString *message = accessibleMessage.accessibilityMessage;
            if (message != nil) {
                NSObject *element = accessibleMessage.accessibilityElement;
                if (element == nil) {
                    element = self.view;
                }
                element.isAccessibilityElement = YES;
                if (element.accessibilityLabel == nil) {
                    element.accessibilityLabel = message;
                }
                [elements addObject:element];
            }
                
            NSMutableArray *additional = accessibleMessage.additionalAccessibilityElements;
            if (additional != nil) {
                [elements addObjectsFromArray:additional];
            }
                
        } else {
            [elements addObject:self.view];
        }
        
        if (self.config.dimModeInteractive == YES) {
            UIView *dismissView = [[UIView alloc] initWithFrame:self.maskingView.bounds];
            dismissView.translatesAutoresizingMaskIntoConstraints = YES;
            dismissView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.maskingView addSubview:dismissView];
            [self.maskingView sendSubviewToBack:dismissView];
            dismissView.userInteractionEnabled = NO;
            dismissView.isAccessibilityElement = YES;
            dismissView.accessibilityLabel = self.config.dimModeAccessibilityLabel;
            dismissView.accessibilityTraits = UIAccessibilityTraitButton;
            [elements addObject:dismissView];
        }

        if (self.config.dimMode != MGUMessagesDimModeNone) { // None 이 아니면 모달 형태이다.
            self.maskingView.accessibilityViewIsModal = YES;
        }
        
        self.maskingView.accessibleElements = elements;
        
    };

    UIView *containerView = self.contextView;
    if (containerView == nil) {
        return;
    }
    MGUMessagesViewController *vc = (MGUMessagesViewController *)(self.contextViewController);
    if ([vc isKindOfClass:[MGUMessagesViewController class]] == YES) {
        [vc install];
    }
    
    installMaskingView(containerView);
    installInteractive();
    installAccessibility();
}

- (void)showAccessibilityAnnouncement {
    UIView <MGUMessagesAccessibleMessage>*accessibleMessage = (UIView <MGUMessagesAccessibleMessage>*)(self.view);
    if ([accessibleMessage conformsToProtocol:@protocol(MGUMessagesAccessibleMessage)] == NO || accessibleMessage.accessibilityMessage == nil) {
        return;
    }
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, accessibleMessage.accessibilityMessage);
}

- (void)showAccessibilityFocus {
    UIView <MGUMessagesAccessibleMessage>*accessibleMessage = (UIView <MGUMessagesAccessibleMessage>*)(self.view);
    if ([accessibleMessage conformsToProtocol:@protocol(MGUMessagesAccessibleMessage)] == NO) {
        return;
    }
    id focus1 = accessibleMessage.accessibilityElement;
    if (focus1 == nil) {
        if (accessibleMessage.additionalAccessibilityElements.firstObject == nil) {
            return;
        } else {
            focus1 = accessibleMessage.additionalAccessibilityElements.firstObject;
        }
    }
    
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, focus1);
}

- (void)showAnimation:(void (^)(BOOL completed))completion{
     void (^dim)(UIColor *) = ^(UIColor *color) {
        self.maskingView.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.maskingView.backgroundColor = color;
        }];
    };
    
    void (^blur)(UIBlurEffectStyle, CGFloat) = ^(UIBlurEffectStyle style, CGFloat alpha) {
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:nil];
        blurView.alpha = alpha;
        self.maskingView.backgroundView = blurView;
        [UIView animateWithDuration:0.3 animations:^{
            blurView.effect = [UIBlurEffect effectWithStyle:style];
        }];
    };

    MGUMessagesAnimationContext *context = [self animationContext];
    
    [self.animator showContext:context
                    completion:^(BOOL completed) {
        if (completion == nil) {
            NSCAssert(FALSE, @"닐 블락이다.");
        }
        completion(completed);
    }];
    
    if (self.config.dimMode == MGUMessagesDimModeGray) {
        dim([UIColor colorWithWhite:0.0 alpha:0.3]);
    } else if (self.config.dimMode == MGUMessagesDimModeColor) {
        dim(self.config.dimColor);
    } else if (self.config.dimMode == MGUMessagesDimModeBlur) {
        blur(self.config.dimBlurEffectStyle, self.config.dimBlurAlpha);
    }
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }

@end
