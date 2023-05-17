//
//  PopoverController.m
//  TEST
//
//  Created by Kwan Hyun Son on 2022/03/28.
//

#import "MGUSimplePopController.h"

@interface MGUSimplePopController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, weak) UIBarButtonItem *barButtonItem;
@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, copy, nullable) void (^completionBlock)(void);
@end

@implementation MGUSimplePopController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//! - systemLayoutSizeFittingSize: 버그 해결.
// https://stackoverflow.com/questions/29865767/systemlayoutsizefittingsizeuilayoutfittingcompressedsize-doesnt-compress
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.view setNeedsLayout]; // 참고 코드가 적어놨길래 그냥 넣었다.
    [self.view layoutIfNeeded]; // 실제 역할을한다. 가로를 맞춰준다.
    [self.label sizeToFit]; // 가로 맞춰진 상태에서 세로를 맞춰라.
    CGFloat height = self.label.frame.size.height;
    NSLayoutConstraint *constraint = [self.label.heightAnchor constraintEqualToConstant:height];
    constraint.priority = UILayoutPriorityRequired - 1;
    constraint.active = YES;
    self.preferredContentSize = [self.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    if (container != nil) {
//        NSLog(@"container 객체-----> %@", container);
    }
//    if (container as? MessageViewController) != nil {
//      messageHeightConstraint?.constant = container.preferredContentSize.height
//    }
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithMessage:(NSAttributedString *)message
                backgroundColor:(nullable UIColor *)backgroundColor
                  barButtonItem:(nullable UIBarButtonItem *)barButtonItem
                     sourceView:(nullable UIView *)sourceView
                     sourceRect:(CGRect)sourceRect
                 arrowDirection:(UIPopoverArrowDirection)arrowDirection
                     completion:(void(^_Nullable)(void))completionBlock {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _arrowDirection = arrowDirection;
        _completionBlock = completionBlock;
        _label = [UILabel new];
        self.view.backgroundColor = backgroundColor;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.attributedText = message;
        _barButtonItem = barButtonItem;
        _sourceView = sourceView;
        _sourceRect = sourceRect;
        CommonInit(self);
        
    }
    return self;
    
}

static void CommonInit(MGUSimplePopController *self) {
    self.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = self.popoverPresentationController;
    popover.permittedArrowDirections = self.arrowDirection;
    popover.delegate = self;
    
    if ([self.barButtonItem isKindOfClass:[UIBarButtonItem class]] == YES) {
        popover.barButtonItem = self.barButtonItem;
    } else if ([self.sourceView isKindOfClass:[UIView class]] == YES) {
        popover.sourceView = self.sourceView;
        popover.sourceRect = self.sourceRect; // sourceView.bounds
    } else {
        NSCAssert(FALSE, @"sender를 정해야한다.");
    }
    
    //! 글자를 잘 펴줘야한다.
    NSMutableAttributedString *text = self.label.attributedText.mutableCopy;
    NSRange totalRange = NSMakeRange(0, text.length);
    NSParagraphStyle *paraStyle = [text attribute:NSParagraphStyleAttributeName
                                          atIndex:0
                            longestEffectiveRange:NULL
                                          inRange:totalRange];
    NSMutableParagraphStyle *mutableParagraphStyle = paraStyle.mutableCopy;
    mutableParagraphStyle = (mutableParagraphStyle != nil) ? mutableParagraphStyle : [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    mutableParagraphStyle.alignment = NSTextAlignmentNatural;
    [text removeAttribute:NSParagraphStyleAttributeName range:totalRange];
    [text addAttribute:NSParagraphStyleAttributeName value:mutableParagraphStyle range:totalRange];
    self.label.attributedText = text;
    
    [self.view addSubview:self.label];
    self.label.numberOfLines = 0;
    
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
    [self.label setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisHorizontal];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.label.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10.0].active = YES;
    [self.label.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-10.0].active = YES;
    [self.label.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:5.0].active = YES;
    [self.label.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-5.0].active = YES;
    
    //! 다음의 설정을 해주자. 그렇지 않으면, 높이가 낮을 때, radius가 찌그러지면서 overlap 되는 모습으로 보일 수가 있다.
    [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:40.0].active = YES; // 최소 코너라디어스가 존재하여 찌그러질 수 있다.
    NSLayoutConstraint *constraint = [self.view.widthAnchor constraintGreaterThanOrEqualToAnchor:self.view.heightAnchor];
    constraint.priority = UILayoutPriorityDefaultHigh;
    
    [self.view setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.view setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.view setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [self.view setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
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
    return UIModalPresentationNone;
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
