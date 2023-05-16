//
//  MGUActionSheetController.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUActionSheetController.h"
#import "MGUActionSheet.h"

@interface MGUActionSheetController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) MGUActionSheet *view;
@property (nonatomic, strong) MGUAlertAction *cancelActionForPopover;
@end

@implementation MGUActionSheetController
@dynamic thirdContentView;
@dynamic configuration;
@dynamic thirdContentViewController;
@dynamic maximumWidth;
@dynamic textFields;
@dynamic view;           // 수퍼 클래스에 존재함을 알리기 위해.

- (void)loadView {
    self.view = [[MGUActionSheet alloc] initWithConfiguration:self.configuration];
}


//! - systemLayoutSizeFittingSize: 버그 해결.
// https://stackoverflow.com/questions/29865767/systemlayoutsizefittingsizeuilayoutfittingcompressedsize-doesnt-compress
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //! 딱맞게 만든다.
        MGUActionSheet *actionSheet = (MGUActionSheet *)self.view;
        //! 이걸 때려줘야 - systemLayoutSizeFittingSize:가 제대로 작동한다.
        [actionSheet.alertContainerView setNeedsLayout]; // 참고 코드가 적어놨길래 그냥 넣었다.
        [actionSheet.alertContainerView layoutIfNeeded]; // 실제 역할을한다.
        self.preferredContentSize = [actionSheet.alertContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        /** 예전 억지로 했던 방식. - 방법이 더럽다.
        CGSize size = [actionSheet.alertContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.preferredContentSize = size;
         //! 갱신을 강제로 때리기 위해서 두번씩 적용해줘야한다. textView에서 갱신이 제대로 파고들지 못한다. 한번 더 때려라.
        size = [actionSheet.alertContainerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.preferredContentSize = size;
         */
        self.view.backgroundColor = self.configuration.alertViewBackgroundColor;        
    }
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
- (instancetype)initWithConfiguration:(nullable MGUActionSheetConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(NSArray<MGUAlertAction *> *)actions {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        NSCAssert(FALSE, @"Pad에서는 - initWithConfiguration:title:message:actions:barButtonItem:sourceView:sourceRect: 를 이용해라.");
    }
    self = [super initWithConfiguration:configuration title:title message:message actions:actions];
    if (self) {
        //! super에 존재하는 observer를 제거하자.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    return self;
}

- (instancetype)initWithConfiguration:(nullable MGUActionSheetConfiguration *)configuration
                                title:(nullable NSString *)title
                              message:(nullable NSString *)message
                              actions:(nullable NSArray<MGUAlertAction *> *)actions
                        barButtonItem:(nullable UIBarButtonItem *)barButtonItem
                           sourceView:(nullable UIView *)sourceView
                           sourceRect:(CGRect)sourceRect {
    if([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad) {
        NSCAssert(FALSE, @"Pad가 아니라면 - initWithConfiguration:title:message:actions:를 이용해라.");
    } else {
        configuration.isFullAppearance = YES;
        NSMutableArray<MGUAlertAction *> *tempActions = actions.mutableCopy;
        if (tempActions != nil) {
            for (MGUAlertAction *action in tempActions.reverseObjectEnumerator) {
                if (action.style == UIAlertActionStyleCancel) {
                    _cancelActionForPopover = action;
                    [tempActions removeObject:action];
                }
            }
            actions = tempActions;
        }
    }
    
    self = [super initWithConfiguration:configuration title:title message:message actions:actions];
    if (self) {
        //! super에 존재하는 observer를 제거하자.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popover = self.popoverPresentationController;
        if ([barButtonItem isKindOfClass:[UIBarButtonItem class]] == YES) {
            popover.barButtonItem = barButtonItem;
        } else if ([sourceView isKindOfClass:[UIView class]] == YES) {
            popover.sourceView = sourceView;
            popover.sourceRect = sourceRect; // sourceView.bounds
        } else {
            NSCAssert(FALSE, @"sender를 정해야한다.");
        }
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popover.delegate = self;
    }
    return self;
}



#pragma mark - <UIAdaptivePresentationControllerDelegate>
//! Deprecated
//- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {}
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController { // UIPopoverPresentationController
    NSLog(@"외부를 클릭해서 팝오버가 끝났을 때 호출. 팝오버 내부의 dismiss 요청에 의해 죽으면 호출 안됨");
    __weak __typeof(self.cancelActionForPopover) weakCancelActionFor = self.cancelActionForPopover;
    if (self.cancelActionForPopover.handler != nil) {
        self.cancelActionForPopover.handler(weakCancelActionFor);
    }
    
//    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
//    if (indexPath != nil) {
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; // 원래 뷰로 돌아 올때, 셀렉션을 해제시킨다. 이게 더 멋지다.
//    }
    
//    if ((popoverPresentationController == self.assetTypePopover) || (popoverPresentationController == self.imagePickerPopover)) {
//        self.assetTypePopover   = nil;
//        self.imagePickerPopover = nil;
//    }
}


- (BOOL)presentationControllerShouldDismiss:(UIPresentationController *)presentationController {
    NSLog(@"다른 데 클릭해서 팝오버가 사라지기 직전에 호출. 팝오버 내부의 dismiss 요청에 의해 죽으면 호출 안됨");
    return YES;
}

// 프레젠테이션 컨트롤러와 연계하여 trait changes 에 대응하기 위해 사용

/// 앱의 상태특성(trait)이 변함에 따라 프레젠테이션 컨트롤러 뷰를 대응
//  * 여기에서 설정하면 위에서 .modalPresentationStyle 을 먹이더라도 무시하고 이 설정에 따른다.
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
                                                               traitCollection:(UITraitCollection *)traitCollection {
    
    NSLog(@"컨트롤러: %@", controller);
    NSLog(@"특성: %@", traitCollection);
    
    if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        return UIModalPresentationPopover;
    } else { // compact
        // return UIModalPresentationFullScreen; // 팝업컨트롤러의 기본설정
        return UIModalPresentationFormSheet;
    }
}


#pragma mark - <UIPopoverPresentationControllerDelegate>
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"팝오버 띄우기 직전에 호출됨");
}


- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
          willRepositionPopoverToRect:(inout CGRect *)rect
                               inView:(inout UIView * _Nonnull *)view {
    NSLog(@"회전 등으로 팝오버의 포지션이 변경됐을 때 호출. 네비버튼으로 팝오버띄우면 이 메서드 호출 안됨.");
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

@end
