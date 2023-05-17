//
//  MGUPopoverPushController.m
//  MGUPopoverForceResizeProject
//
//  Created by Kwan Hyun Son on 2022/06/23.
//

#import "MGUPopoverPushController.h"
#import "UIView+Extension.h"

// Popover - 팝오버 01 백그라운드 화살표 - UIPopoverBackgroundView objc - 1901 프로젝트를 참고하라.
// 화살표를 없애기 위해 만들었다.
@interface __MGUPopoverBackgroundView : UIPopoverBackgroundView
@property (nonatomic, readwrite) CGFloat arrowOffset; // 자동 synthesize 가 되지 않는다.
@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection; // 자동 synthesize 가 되지 않는다.
@end
@interface __MGUPopoverBackgroundView ()
@end
@implementation __MGUPopoverBackgroundView
@synthesize arrowOffset = _arrowOffset;
@synthesize arrowDirection = _arrowDirection;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
    }
    return self;
}
+ (UIEdgeInsets)contentViewInsets { return UIEdgeInsetsZero; }
+ (CGFloat)arrowHeight { return 0.0; }
+ (CGFloat)arrowBase { return 0.0; }
- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection; // super 호출금지!
    [self setNeedsLayout];
}
- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset; // super 호출금지!
    [self setNeedsLayout];
}

@end

@interface MGUPopoverPushController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UINavigationController *wrappedNavController;
@end

@implementation MGUPopoverPushController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wrappedNavController willMoveToParentViewController:self];
    [self addChildViewController:self.wrappedNavController];
    [self.wrappedNavController didMoveToParentViewController:self];
    [self.view addSubview:self.wrappedNavController.view];
    self.wrappedNavController.view.frame = self.view.bounds;
    self.wrappedNavController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.view setNeedsLayout]; // 참고 코드가 적어놨길래 그냥 넣었다.
//    [self.view layoutIfNeeded]; // 실제 역할을한다.
//    self.preferredContentSize = [self.wrappedNavController.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (self.acceptFirstResponder == YES) {
        NSArray <__kindof UITextField *>*textFields =
        [self.wrappedNavController.topViewController.view mgrRecurrenceAllSubviewsOfType:[UITextField class]];
        for (UITextField *textField in textFields) {
            if (textField.hidden == NO && textField.userInteractionEnabled == YES) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
}

#pragma mark - 생성 & 소멸
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _formSheetWhenHorizontalCompact = NO;
        _wrappedNavController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        self.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popover = self.popoverPresentationController;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popover.delegate = self;
    }
    return self;
}

#pragma mark - Action
- (void)setBarButtonItem:(nullable UIBarButtonItem *)barButtonItem
              sourceView:(nullable UIView *)sourceView
              sourceRect:(CGRect)sourceRect
          arrowDirection:(UIPopoverArrowDirection)arrowDirection
              completion:(void(^_Nullable)(void))completionBlock {
    UIPopoverPresentationController *popover = self.popoverPresentationController;
    popover.permittedArrowDirections = arrowDirection;
    if (barButtonItem != nil) {
        popover.barButtonItem = barButtonItem;
    } else if (sourceView != nil) {
        popover.sourceView = sourceView;
        popover.sourceRect = sourceRect;
    } else {
        NSCAssert(FALSE, @"둘 중에 하나는 건내야한다.");
    }
    
    _completionBlock = completionBlock;
}


- (void)setRemoveArrow:(BOOL)removeArrow {
    _removeArrow = removeArrow;
    UIPopoverPresentationController *popover = self.popoverPresentationController;
    if (removeArrow == YES) {
        popover.popoverBackgroundViewClass = [__MGUPopoverBackgroundView class];
    } else {
        popover.popoverBackgroundViewClass = nil;
    }
}

- (void)changeBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (self.removeArrow == NO) {
        UIVisualEffectView *visualEffectView =
        [UIVisualEffectView appearanceWhenContainedInInstancesOfClasses:@[[UIPopoverBackgroundView class]]];
        visualEffectView.effect = [UIBlurEffect effectWithStyle:blurEffectStyle];
    } else {
        NSCAssert(FALSE, @"화살표가 없을 경우에는 직접 블러이펙트를 설정하라.");
    }
}


#pragma mark - <UIAdaptivePresentationControllerDelegate>
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController { // UIPopoverPresentationController
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"DEBUG && TARGET_OS_SIMULATOR: 외부를 클릭해서 팝오버가 끝났을 때 호출. 팝오버 내부의 dismiss 요청에 의해 죽으면 호출 안됨");
#endif
    if (self.completionBlock != nil) {
        self.completionBlock();
    }
//    __weak __typeof(self.cancelActionForPopover) weakCancelActionFor = self.cancelActionForPopover;
//    if (self.cancelActionForPopover.handler != nil) {
//        self.cancelActionForPopover.handler(weakCancelActionFor);
//    }

    
//    if ((popoverPresentationController == self.assetTypePopover) || (popoverPresentationController == self.imagePickerPopover)) {
//        self.assetTypePopover   = nil;
//        self.imagePickerPopover = nil;
//    }
}


- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController {
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"DEBUG && TARGET_OS_SIMULATOR: 다른 데 클릭해서 팝오버가 사라지기 직전에 호출. 팝오버 내부의 dismiss 요청에 의해 죽으면 호출 안됨");
#endif
    return YES;
}

// 프레젠테이션 컨트롤러와 연계하여 trait changes 에 대응하기 위해 사용

/// 앱의 상태특성(trait)이 변함에 따라 프레젠테이션 컨트롤러 뷰를 대응
//  * 여기에서 설정하면 위에서 .modalPresentationStyle 을 먹이더라도 무시하고 이 설정에 따른다.
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection {
    
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"컨트롤러(UIPresentationController): %@", controller);
    NSLog(@"특성(UITraitCollection): %@", traitCollection);
#endif
    if (_formSheetWhenHorizontalCompact == NO) {
        return UIModalPresentationNone; // width가 콤팩트, 레귤러 상관없이 언제나 popover로 뜨게 하고싶다면 이걸 반환하라.
    } else { // 캘린더 앱이 이런형식이다.
        if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
            return UIModalPresentationPopover;
        } else { // compact
    //         return UIModalPresentationFullScreen; // 팝업컨트롤러의 기본설정
            return UIModalPresentationFormSheet;
        }
    }
}


#pragma mark - <UIPopoverPresentationControllerDelegate>
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"DEBUG && TARGET_OS_SIMULATOR: 팝오버 띄우기 직전에 호출됨");
#endif
}


- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
          willRepositionPopoverToRect:(inout CGRect *)rect
                               inView:(inout UIView * _Nonnull *)view {
#if DEBUG && TARGET_OS_SIMULATOR
    NSLog(@"DEBUG && TARGET_OS_SIMULATOR: 회전 등으로 팝오버의 포지션이 변경됐을 때 호출. 네비버튼으로 팝오버띄우면 이 메서드 호출 안됨.");
#endif
    UIView *sourceView = popoverPresentationController.sourceView;
    *rect = sourceView.bounds;
    // 현재 팝법버튼을 찾아서 rect 좌표 갱신
//    *rect = self.currentPopup.frame;
    
    // 로그
//    CGRect newRect = *rect;
//    NSLog(@"new rect: %lf, %lf, %lf, %lf", newRect.origin.x, newRect.origin.y,
//          newRect.size.width, newRect.size.height);
//    NSLog(@"뷰: %@", *view);
}

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지."); return nil; }
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { NSCAssert(FALSE, @"- initWithNibName:bundle: 사용금지."); return nil; }
@end
