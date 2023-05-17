//
//  MGUSideBarController.m
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSideBarController.h"
#import "MGUSideBarView.h"
#import "MGUSideBarPresentationController.h"
#import "MGUSideBarPresentationAnimator.h"
#import "MGUSideBarDismissalAnimator.h"

@interface MGUSideBarDumiController ()
@end
@implementation MGUSideBarDumiController
@synthesize preferredStatusBarStyle = _preferredStatusBarStyle; // 재정의 이므로 반드시 넣어줘야한다.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [super setModalPresentationStyle:UIModalPresentationOverCurrentContext];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _preferredStatusBarStyle;
    //
    // 그냥 이놈이 처리하는 게 나을듯.
//    UIViewController *vc = self.presentingViewController.childViewControllerForStatusBarStyle;
//    if (vc == nil) {
//        return [self.presentingViewController preferredStatusBarStyle];
//    } else {
//        return [vc preferredStatusBarStyle];
//    }
}
@end

static const CGFloat standardVelocity = 500.0; // 빠르게 제스처를 날린다의 기준이 되는 속도.

@interface MGUSideBarController () <UIViewControllerTransitioningDelegate , UIGestureRecognizerDelegate>
@property (nonatomic, strong) MGUSideBarView *view;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong, nullable) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, nullable) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, assign) BOOL useInteractionController;
@end

@implementation MGUSideBarController
@synthesize preferredStatusBarStyle = _preferredStatusBarStyle; // 재정의 이므로 반드시 넣어줘야한다.
@dynamic view; // 수퍼 클래스에 존재함을 알리기 위해. 여기서는 self.view의 클래스가 MGUSideBarView 인스턴스로 인식.

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    self.view = [[MGUSideBarView alloc] initWithConfiguration:self.configuration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    // Necessary to avoid retain cycle - http://stackoverflow.com/a/21218703/1227862
//    self.transitioningDelegate = nil;
    [super viewDidDisappear:animated];
}


//- (UIViewController *)childViewControllerForStatusBarStyle { 그냥 이놈이 처리하는게 나을듯
//    return self.viewController;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _preferredStatusBarStyle;
}

//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator

// 사이즈 전용 메서드이다.
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator]; // 특정 시점에서 super를 호출해야한다.
    
    if (_automaticallyDismissWhenSizeChanged == YES) {
        MGUSideBarDumiController *dumiController = (MGUSideBarDumiController *)self.presentingViewController;
        [self dismissViewControllerAnimated:NO completion:^{
            if ([dumiController isKindOfClass:[MGUSideBarDumiController class]] == YES) {
                [dumiController dismissViewControllerAnimated:NO completion:nil];
            }
        }];
        return;
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        if ((self.configuration.transitionStyle & MGUSideBarControllerTransitionStyleDisplace) ||
            (self.configuration.transitionStyle & MGUSideBarControllerTransitionStyleReveal)) {
            CGFloat displaceWidth = 0.0;
            MGUSideBarWidthDeterminant widthDeterminant = self.configuration.widthDeterminant;
            if (widthDeterminant.isRatio == YES) {
                displaceWidth = self.view.frame.size.width * widthDeterminant.ratio;
            } else {
                displaceWidth = widthDeterminant.absoluteWidth;
                if (widthDeterminant.ratio != 0.0) {
                    displaceWidth = MIN(displaceWidth, self.view.frame.size.width * widthDeterminant.ratio);
                }
            }
            
            UIView *fromView = self.presentationController.presentingViewController.view;
            CGRect rect = fromView.frame;
            if (self.configuration.isDirectionLeft == YES) {
                rect.origin.x = displaceWidth;
            } else {
                rect.origin.x = -displaceWidth;
            }
            
            fromView.frame = rect;
            
            if (self.configuration.transitionStyle & MGUSideBarControllerTransitionStyleReveal) { // shadow 프레임수정.
                self.view.maskView.frame =  self.view.containerView.frame;
                CGRect shadowViewLastFrame = self.view.containerView.frame;
                if (self.configuration.isDirectionLeft == YES) {
                    shadowViewLastFrame.origin.x = shadowViewLastFrame.origin.x + self.view.containerView.frame.size.width;
                } else {
                    shadowViewLastFrame.origin.x = shadowViewLastFrame.origin.x - self.view.containerView.frame.size.width;
                }
                self.view.shadowView.frame = shadowViewLastFrame;
            }
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithViewController:(__kindof UIViewController *)viewController
                         configuration:(MGUSideBarConfig *)configuration {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (configuration == nil) {
            configuration = [MGUSideBarConfig new];
        }
        _viewController = viewController;
        _configuration = configuration;
        CommonInit(self);
    }
    return self;
}


static void CommonInit(MGUSideBarController *self) {
    [self.viewController willMoveToParentViewController:self];
    [self addChildViewController:self.viewController];
    [self.viewController didMoveToParentViewController:self];
    [self.view.containerView addSubview:self.viewController.view];
    self.viewController.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.viewController.view.frame = self.view.containerView.bounds;
    self.viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    self->_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
    self->_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    self.panGesture.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:self.panGesture];
    self->_interactionController = [UIPercentDrivenInteractiveTransition new];
    self->_useInteractionController = NO;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.configuration.backgroundTapDismissalGestureEnabled == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    if (view == nil ) {
        return;
    }
    
    CGFloat percent = -[gestureRecognizer translationInView:view].x / (view.bounds.size.width * 1.0);
    if (self.configuration.isDirectionLeft == NO) {
        percent = - percent;
    }
    percent = MIN(1.0, MAX(0.0, percent));
    if (percent == 0.0) {
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view.superview]; // 움직인 위치를 초기화 0, 0 시킨다.
    }

    if (gestureRecognizer.state ==  UIGestureRecognizerStateBegan ) {
        self.useInteractionController = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (gestureRecognizer.state ==  UIGestureRecognizerStateChanged) {
        [self.interactionController updateInteractiveTransition:percent];
    } else if (gestureRecognizer.state ==  UIGestureRecognizerStateEnded) {
        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
        if (standardVelocity > ABS(velocity.x)) { // 느린 속도라면, 가까운 곳으로 붙어라.
            if (percent > 0.5) {
//                self.interactionController.completionSpeed = percent;
                [self.interactionController finishInteractiveTransition];
            } else {
//                self.interactionController.completionSpeed = 1.0 - percent;
                [self.interactionController cancelInteractiveTransition];
            }
        } else { // 빠른 속도.
            if ((velocity.x < 0 && self.configuration.isDirectionLeft == YES) ||
                (velocity.x > 0 && self.configuration.isDirectionLeft == NO)) {
//                self.interactionController.completionSpeed = 1.0 * 2.0;
                [self.interactionController finishInteractiveTransition];
            } else {
//                self.interactionController.completionSpeed = 1.0 * 2.0;
                [self.interactionController cancelInteractiveTransition];
            }
        }
        self.useInteractionController = NO;
    } else if (gestureRecognizer.state ==  UIGestureRecognizerStateCancelled) {
//        self.interactionController.completionSpeed = (1.0 - percent);
        [self.interactionController cancelInteractiveTransition];
        self.useInteractionController = NO;
    }
}


#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGesture) {
        CGPoint point = [touch locationInView:self.view.containerView];
        CGRect rect =  self.view.containerView.bounds;
        if (CGRectContainsPoint(rect, point) == YES) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

#pragma mark - <UIViewControllerTransitioningDelegate> - Mac에서는 <NSViewControllerPresentationAnimator> 에 해당할듯.
//! 등장할때 호출 1.
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    return [[MGUSideBarPresentationController alloc] initWithPresentedViewController:presented
                                                            presentingViewController:presenting
                                                                       sideBarConfig:self.configuration];
}

//! 등장할때 호출 2.
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return [[MGUSideBarPresentationAnimator alloc] initWithSideBarConfig:self.configuration];
}

//! 사라질때 호출
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[MGUSideBarDismissalAnimator alloc] initWithSideBarConfig:self.configuration];
}

// present 일때에는 interaction controller를 사용하지 않겠다는 뜻. 즉, percent driven 하지 않겠다는 뜻.
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

// dimiss 시에 interaction controller를 때에 따라 사용하겠다는 뜻.
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.useInteractionController == NO) {
        return nil;
    } else {
        return self.interactionController;
    }
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil { NSCAssert(FALSE, @"- initWithNibName:bundle: 사용금지."); return nil; }
@end
