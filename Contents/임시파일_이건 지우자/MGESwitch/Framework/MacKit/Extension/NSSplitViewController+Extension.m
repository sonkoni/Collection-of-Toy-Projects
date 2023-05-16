//
//  NSSplitViewController+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSSplitViewController+Extension.h"

@implementation NSSplitViewController (Extension)

- (void)mgrDefaultSetupWithAutosaveName:(NSSplitViewAutosaveName)autosaveName
                             identifier:(NSUserInterfaceItemIdentifier)identifier {
    self.view.wantsLayer = YES; // side bar 쪽에 블러를 주려면 필요하다.
    self.view.layer = [CALayer layer];
    self.splitView.wantsLayer = YES;
    self.splitView.layer = [CALayer layer];
    self.splitView.dividerStyle = NSSplitViewDividerStyleThin;
    self.splitView.autosaveName = autosaveName; // splitViewResorationIdentifier
    self.splitView.identifier = identifier; // splitViewResorationIdentifier
    self.splitView.vertical = YES; // 수평으로 뷰 들을 배치하게 해준다.
}

- (NSArray <NSSplitViewItem *>*)mgrXCodeStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                             mainContentController:(__kindof NSViewController *)viewControllerB
                                               inspectorController:(__kindof NSViewController *)viewControllerC {
    if ([viewControllerA isKindOfClass:[NSViewController class]] == NO ||
        [viewControllerB isKindOfClass:[NSViewController class]] == NO ||
        [viewControllerC isKindOfClass:[NSViewController class]] == NO) {
        NSCAssert(FALSE, @"NSViewController 클래스여야한다.");
    }
    NSArray <NSViewController *>*viewControllers = @[viewControllerA, viewControllerB, viewControllerC];
    for (NSViewController *vc in viewControllers) {
        NSView *view = vc.view;
        view.wantsLayer = YES;
        if (view.layer == nil) {
            view.layer = [CALayer layer];
        }
    }
    
    NSSplitViewItem *splitViewItemA = [NSSplitViewItem sidebarWithViewController:viewControllerA];
    splitViewItemA.allowsFullHeightLayout = YES; // 디폴트 YES. side bar 에서만 적용가능.
    splitViewItemA.canCollapse = YES; // side bar 에서는 디폴트 YES
    splitViewItemA.minimumThickness = 243.0;
    splitViewItemA.holdingPriority = NSLayoutPriorityDefaultLow + 9;
    splitViewItemA.collapseBehavior = NSSplitViewItemCollapseBehaviorUseConstraints; // 윈도우 크기를 왠만하면 보존
    splitViewItemA.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone; // window titlebarSeparatorStyle 오토매틱으로 해야함.
    
    NSSplitViewItem *splitViewItemB = [NSSplitViewItem splitViewItemWithViewController:viewControllerB];
    splitViewItemB.minimumThickness = 200.0;
    splitViewItemB.holdingPriority = NSLayoutPriorityDefaultLow - 1;
//    splitViewItemB.collapseBehavior = NSSplitViewItemCollapseBehaviorUseConstraints;
    splitViewItemB.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine; // window titlebarSeparatorStyle 오토매틱으로 해야함.

    NSSplitViewItem *splitViewItemC = [NSSplitViewItem splitViewItemWithViewController:viewControllerC];
    splitViewItemC.canCollapse = YES;
    splitViewItemC.minimumThickness = 260.0;
    splitViewItemC.holdingPriority = NSLayoutPriorityDefaultLow + 10;
    splitViewItemC.collapseBehavior = NSSplitViewItemCollapseBehaviorUseConstraints; // 윈도우 크기를 왠만하면 보존
    splitViewItemC.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
    
    // 문서에 서브 클래스 일 경우에는 - addSplitViewItem:가 아닌 - insertSplitViewItem:atIndex: 를 이용하라고 쓰여있음.
    [self insertSplitViewItem:splitViewItemA atIndex:0];
    [self insertSplitViewItem:splitViewItemB atIndex:1];
    [self insertSplitViewItem:splitViewItemC atIndex:2];
    return @[splitViewItemA, splitViewItemB, splitViewItemC];
}

- (NSArray <NSSplitViewItem *>*)mgrFinderStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                              mainContentController:(__kindof NSViewController *)viewControllerB {
    //        self.minimumThicknessForInlineSidebars = ??; // 일정 크기로 줄어들면 사이드바가 닫히고 열리는 지점.
    if ([viewControllerA isKindOfClass:[NSViewController class]] == NO ||
        [viewControllerB isKindOfClass:[NSViewController class]] == NO) {
        NSCAssert(FALSE, @"NSViewController 클래스여야한다.");
    }
    NSArray <NSViewController *>*viewControllers = @[viewControllerA, viewControllerB];
    for (NSViewController *vc in viewControllers) {
        NSView *view = vc.view;
        view.wantsLayer = YES;
        if (view.layer == nil) {
            view.layer = [CALayer layer];
        }
    }
    NSSplitViewItem *splitViewItemA = [NSSplitViewItem sidebarWithViewController:viewControllerA];
    splitViewItemA.allowsFullHeightLayout = YES; // side bar 에서만 적용가능하면 디폴트 YES
    splitViewItemA.minimumThickness = 140.0;
    splitViewItemA.holdingPriority = 200;
    splitViewItemA.collapseBehavior = NSSplitViewItemCollapseBehaviorPreferResizingSiblingsWithFixedSplitView;
    splitViewItemA.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone; // window titlebarSeparatorStyle 오토매틱으로 해야함.
        
    NSSplitViewItem *splitViewItemB = [NSSplitViewItem splitViewItemWithViewController:viewControllerB];
    splitViewItemB.minimumThickness = 315.0; // window의 최소 높이도 마찬가지.
    splitViewItemB.holdingPriority = 199;
    splitViewItemB.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine; // window titlebarSeparatorStyle 오토매틱으로 해야함.
    
    // 문서에 서브 클래스 일 경우에는 - addSplitViewItem:가 아닌 - insertSplitViewItem:atIndex: 를 이용하라고 쓰여있음.
    [self insertSplitViewItem:splitViewItemA atIndex:0];
    [self insertSplitViewItem:splitViewItemB atIndex:1];
    return @[splitViewItemA, splitViewItemB];
}

- (NSArray <NSSplitViewItem *>*)mgrNotesStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                                    listController:(__kindof NSViewController *)viewControllerB
                                             mainContentController:(__kindof NSViewController *)viewControllerC {
    if ([viewControllerA isKindOfClass:[NSViewController class]] == NO ||
        [viewControllerB isKindOfClass:[NSViewController class]] == NO ||
        [viewControllerC isKindOfClass:[NSViewController class]] == NO) {
        NSCAssert(FALSE, @"NSViewController 클래스여야한다.");
    }
    NSArray <NSViewController *>*viewControllers = @[viewControllerA, viewControllerB, viewControllerC];
    for (NSViewController *vc in viewControllers) {
        NSView *view = vc.view;
        view.wantsLayer = YES;
        if (view.layer == nil) {
            view.layer = [CALayer layer];
        }
    }
    
    NSSplitViewItem *splitViewItemA = [NSSplitViewItem sidebarWithViewController:viewControllerA];
    splitViewItemA.allowsFullHeightLayout = YES; // 디폴트 YES. side bar 에서만 적용가능.
    splitViewItemA.canCollapse = YES; // side bar 에서는 디폴트 YES
    splitViewItemA.minimumThickness = 140.0;
    splitViewItemA.maximumThickness = 300.0;
    splitViewItemA.holdingPriority = NSLayoutPriorityDefaultLow + 10;
    splitViewItemA.collapseBehavior = NSSplitViewItemCollapseBehaviorPreferResizingSiblingsWithFixedSplitView;
    splitViewItemA.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone; // window titlebarSeparatorStyle 오토매틱으로 해야함.
    
    NSSplitViewItem *splitViewItemB = [NSSplitViewItem contentListWithViewController:viewControllerB];
    splitViewItemB.canCollapse = NO;
    splitViewItemB.minimumThickness = 200.0;
    splitViewItemB.maximumThickness = 500.0;
    splitViewItemB.holdingPriority = NSLayoutPriorityDefaultLow + 9;
//    splitViewItemB.collapseBehavior = NSSplitViewItemCollapseBehaviorUseConstraints;
    splitViewItemB.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine; // window titlebarSeparatorStyle 오토매틱으로 해야함.

    NSSplitViewItem *splitViewItemC = [NSSplitViewItem splitViewItemWithViewController:viewControllerC];
    splitViewItemC.canCollapse = NO;
    splitViewItemC.minimumThickness = 300.0;
    splitViewItemC.holdingPriority = NSLayoutPriorityDefaultLow - 1;
//    splitViewItemC.collapseBehavior = NSSplitViewItemCollapseBehaviorUseConstraints; // 윈도우 크기를 왠만하면 보존
    splitViewItemC.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
    
    // 문서에 서브 클래스 일 경우에는 - addSplitViewItem:가 아닌 - insertSplitViewItem:atIndex: 를 이용하라고 쓰여있음.
    [self insertSplitViewItem:splitViewItemA atIndex:0];
    [self insertSplitViewItem:splitViewItemB atIndex:1];
    [self insertSplitViewItem:splitViewItemC atIndex:2];
    return @[splitViewItemA, splitViewItemB, splitViewItemC];
}


#pragma mark - Actions
- (void)mgrToggleFirstPanel:(BOOL)animated {
    NSSplitViewItem *firstSplitViewItem = self.splitViewItems.firstObject;
    if (firstSplitViewItem != nil) {
        if (animated == YES) { firstSplitViewItem = firstSplitViewItem.animator; }
        if (firstSplitViewItem.isCollapsed == YES) {
            firstSplitViewItem.collapsed = NO;
        } else {
            firstSplitViewItem.collapsed = YES;
        }
    }
}

- (void)mgrToggleLastPanel:(BOOL)animated {
    NSSplitViewItem *lastSplitViewItem = self.splitViewItems.lastObject;
    if (lastSplitViewItem != nil) {
        if (animated == YES) { lastSplitViewItem = lastSplitViewItem.animator; }
        if (lastSplitViewItem.isCollapsed == YES) {
            lastSplitViewItem.collapsed = NO;
        } else {
            lastSplitViewItem.collapsed = YES;
        }
    }
}

@end
