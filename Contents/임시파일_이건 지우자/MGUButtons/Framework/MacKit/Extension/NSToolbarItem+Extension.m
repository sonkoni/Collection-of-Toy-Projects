//
//  NSToolbarItem+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSToolbarItem+Extension.h"

@implementation NSToolbarItem (Extension)

+ (instancetype)mgrLeadingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                         labelTitle:(NSString *)labelTitle
                                  paletteLabelTitle:(NSString *)paletteLabelTitle
                                            toolTip:(NSString *)toolTip
                                symbolConfiguration:(NSImageSymbolConfiguration *)symbolConfiguration
                                             target:(id)target
                                             action:(SEL)action {
    return [NSToolbarItem _mgrSidebarItemWithIdentifier:itemIdentifier
                                             labelTitle:labelTitle
                                      paletteLabelTitle:paletteLabelTitle
                                                toolTip:toolTip
                                    symbolConfiguration:symbolConfiguration
                                                 target:target
                                                 action:action
                                              isLeading:YES];
}

+ (instancetype)mgrTrailingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                          labelTitle:(NSString *)labelTitle // 툴바에 보이는 타이틀
                                   paletteLabelTitle:(NSString *)paletteLabelTitle // 편집모드에서 보이는 타이틀 대부분 라벨타이틀 그대로씀.
                                             toolTip:(NSString *)toolTip // 호버 되었을 시 나오는 문자열.
                                 symbolConfiguration:(NSImageSymbolConfiguration *)symbolConfiguration
                                              target:(id)target
                                              action:(SEL)action {
    return [NSToolbarItem _mgrSidebarItemWithIdentifier:itemIdentifier
                                             labelTitle:labelTitle
                                      paletteLabelTitle:paletteLabelTitle
                                                toolTip:toolTip
                                    symbolConfiguration:symbolConfiguration
                                                 target:target
                                                 action:action
                                              isLeading:NO];
}

+ (instancetype)mgrTogleItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                labelTitle:(NSString *)labelTitle
                       possibleLabelTitles:(NSSet <NSString *>*)possibleLabelTitles
                         paletteLabelTitle:(NSString *)paletteLabelTitle
                                   toolTip:(NSString *)toolTip
                                     image:(NSImage *)image
                                    target:(id)target
                                    action:(SEL)action {
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.label = labelTitle;
    toolbarItem.paletteLabel = paletteLabelTitle;
    toolbarItem.toolTip = toolTip;
    toolbarItem.target = target;
    toolbarItem.action = action;
    toolbarItem.image = image;
    toolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityStandard;
    toolbarItem.bordered = YES; // 이미지만 하나 박았을 때, 마우스 호버되었을 시 활성화 표시가 안될 수 있다.
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
    if (@available(macOS 13, *)) {
        toolbarItem.possibleLabels = possibleLabelTitles;
    }
#endif
    
    // overflow 영역 설정하기 : window가 좁아져서 >> 영역으로 들어갔을 때, 표시하는 방법이다.
    NSMenuItem *menuItem = [NSMenuItem new];
    menuItem.title = labelTitle;
    menuItem.image = image;
    menuItem.target = target;
    menuItem.action = action;
    menuItem.toolTip = toolTip;
    toolbarItem.menuFormRepresentation = menuItem;
    return toolbarItem;
}


+ (instancetype)mgrPopoverItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                  labelTitle:(NSString *)labelTitle
                           paletteLabelTitle:(NSString *)paletteLabelTitle
                                     toolTip:(NSString *)toolTip
                                       image:(NSImage *)image
                                      target:(id _Nullable)target
                                      action:(SEL)action {
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
//    toolbarItem.image = image;
    toolbarItem.label = labelTitle; // 툴바에 보이는 라벨
    toolbarItem.paletteLabel = paletteLabelTitle; // 편집모드에서 보이는 텍스트 보통은 label과 비슷.
    toolbarItem.toolTip = toolTip; // 호버되었을 때. 나오는 메시지
//    toolbarItem.target = target;
//    toolbarItem.action = action;
    toolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityStandard;
    toolbarItem.bordered = YES; // 이미지만 하나 박았을 때, 마우스 호버되었을 시 활성화 표시가 안될 수 있다.
    
    NSSegmentedControl *segmentedControl =
    [NSSegmentedControl segmentedControlWithImages:@[image]
                                      trackingMode:NSSegmentSwitchTrackingMomentary
                                            target:target
                                            action:action];
    segmentedControl.segmentCount = 1;
    segmentedControl.segmentStyle = NSSegmentStyleTexturedRounded;
    segmentedControl.identifier = itemIdentifier;
    NSSegmentedCell *cell = segmentedControl.cell;
    if ([cell isKindOfClass:[NSSegmentedCell class]] == YES) {
        cell.controlSize = NSControlSizeRegular;
        cell.trackingMode = NSSegmentSwitchTrackingMomentary;
    }
    segmentedControl.accessibilitySelected = NO;
    toolbarItem.view = segmentedControl;
    
    // overflow 영역 담당하기.
    NSMenuItem *menuItem = [NSMenuItem new];
    menuItem.target = target;
    menuItem.action = action;
    menuItem.title = labelTitle;
    menuItem.image = image;
    menuItem.toolTip = toolTip;
    toolbarItem.menuFormRepresentation = menuItem;
    return toolbarItem;
}

+ (instancetype)mgrPullDownItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                   labelTitle:(NSString *)labelTitle
                            paletteLabelTitle:(NSString *)paletteLabelTitle
                                      toolTip:(NSString *)toolTip
                                        image:(NSImage *)image
                              normalItemArray:(NSArray <NSMenuItem *>*)normalItemArray
                            overflowItemArray:(NSArray <NSMenuItem *>*)overflowItemArray {
    [normalItemArray.firstObject.menu removeAllItems];   //! 반드시 필요하다. x 로 윈도우를 가리고 다시 나타나면 다시 만드므로 충돌한다.
    [overflowItemArray.firstObject.menu removeAllItems]; //! 반드시 필요하다. x 로 윈도우를 가리고 다시 나타나면 다시 만드므로 충돌한다.
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.image = image;
    toolbarItem.label = labelTitle;
    toolbarItem.paletteLabel = paletteLabelTitle;
    toolbarItem.toolTip = toolTip;
    toolbarItem.target = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    toolbarItem.action = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    toolbarItem.bordered = NO;
    toolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityStandard;
    
    NSPopUpButton *popUpButton = [[NSPopUpButton alloc] initWithFrame:CGRectZero pullsDown:YES]; // 아래방향 화살표
    popUpButton.bezelStyle = NSBezelStyleTexturedRounded;
    popUpButton.target = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    popUpButton.action = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    NSMenuItem *faceItem = [NSMenuItem new]; // 외부에 보여지는 이미지를 표현하는 고정아이템 역할
    faceItem.image = image;
    faceItem.title = @"";
    faceItem.tag = -1004;  // 0 <= 숫자는 태그로 사용될 수 있으므로 걸리지 않을 태그를 설정해주자.
    faceItem.hidden = YES; // 컨텐츠로 사용되지 않으므로.
    [popUpButton.menu addItem:faceItem];
    [normalItemArray enumerateObjectsUsingBlock:^(NSMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
        [popUpButton.menu addItem:menuItem];
    }];
    toolbarItem.view = popUpButton;
    /** NSSegmentedControl 만들 수 있다. 효과는 동일하다.
    NSSegmentedControl *segmentControl =
    [NSSegmentedControl segmentedControlWithImages:@[image] trackingMode:NSSegmentSwitchTrackingSelectOne target:nil action:nil];
    NSMenu *containerMenu = [[NSMenu alloc] initWithTitle:@""];
    containerMenu.itemArray = normalItemArray;
    [segmentControl setMenu:containerMenu forSegment:0];
    [segmentControl setShowsMenuIndicator:YES forSegment:0];
    toolbarItem.view = segmentControl;
     */
    
    // overflow 영역
    NSMenuItem *overflowItem = [NSMenuItem new];
    overflowItem.title = labelTitle; // 다른 텍스트를 넣을 수 있지만, 그냥 사용하는 것이 더 좋을 듯. 일관성.
    overflowItem.image = image; // 다른 이미지를 넣을 수 있지만, 그냥 사용하는 것이 더 좋을 듯. 일관성.
    overflowItem.target = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    overflowItem.action = nil; // NSMenuItem 배열에 설정해야한다. 외부에서 하는 것이 낫다.
    overflowItem.toolTip = toolTip; // 다른 toolTip을 넣을 수 있지만, 그냥 사용하는 것이 더 좋을 듯. 일관성.
    overflowItem.submenu = [[NSMenu alloc] initWithTitle:@""]; // 판대기
    overflowItem.submenu.itemArray = overflowItemArray;
    toolbarItem.menuFormRepresentation = overflowItem; // overflow 되었을 시 아이템을 설정한다.
    return toolbarItem;
    //
    // normalItemArray, overflowItemArray이 기존에 menu에 붙어있었는데 다른 menu에 붙이면 앱이 터진다. x 로 윈도우를 가렸다가
    // 다시 보이게하면, 다시 툴바아이템을 만들면서 앱이 터지는 일이 발생하므로 반드시 이렇게 부모 menu 에서 제거해줘야한다.
}


#pragma mark - Private
+ (instancetype)_mgrSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                   labelTitle:(NSString *)labelTitle
                            paletteLabelTitle:(NSString *)paletteLabelTitle
                                      toolTip:(NSString *)toolTip
                          symbolConfiguration:(NSImageSymbolConfiguration *)symbolConfiguration
                                       target:(id)target
                                       action:(SEL)action
                                    isLeading:(BOOL)isLeading {
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.label = labelTitle;
    toolbarItem.paletteLabel = paletteLabelTitle;
    toolbarItem.toolTip = toolTip;
    toolbarItem.target = target;
    toolbarItem.action = action;
    
    NSString *systemSymbolName = (isLeading == YES) ? @"sidebar.leading" : @"sidebar.trailing";
    NSImage *image = [NSImage imageWithSystemSymbolName:systemSymbolName accessibilityDescription:@""];
    if (symbolConfiguration != nil) {
        image = [image imageWithSymbolConfiguration:symbolConfiguration];
    }
    toolbarItem.image = image;
    toolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityUser; // 윈도우가 좁아졌을 때, 가장 늦게 가려지게
    toolbarItem.bordered = YES; // 이미지만 하나 박았을 때, 마우스 호버되었을 시 활성화 표시가 안될 수 있다.
    
    // overflow 영역 설정하기 : window가 좁아져서 >> 영역으로 들어갔을 때, 표시하는 방법이다.
    NSMenuItem *menuItem = [NSMenuItem new];
    menuItem.title = labelTitle;
    menuItem.image = image;
    menuItem.target = target;
    menuItem.action = action;
    menuItem.toolTip = toolTip;
    toolbarItem.menuFormRepresentation = menuItem;
    return toolbarItem;
}
@end


@implementation NSToolbarItemGroup (Extension)
+ (NSToolbarItemGroup *)mgrFinderNavigationalItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                                     labelTitle:(NSString *)labelTitle
                                              paletteLabelTitle:(NSString *)paletteLabelTitle
                                                        toolTip:(NSString *)toolTip
                                                         target:(id)target
                                                         action:(SEL)action {
    NSToolbarItem *item1 = [[NSToolbarItem alloc] initWithItemIdentifier:@"backwardItem"];
    NSToolbarItem *item2 = [[NSToolbarItem alloc] initWithItemIdentifier:@"forwardItem"];
    NSImageSymbolConfiguration *config = [NSImageSymbolConfiguration configurationWithPointSize:17.0
                                                                                         weight:NSFontWeightLight
                                                                                          scale:NSImageSymbolScaleSmall];
    NSImage *image1 = [NSImage imageWithSystemSymbolName:@"chevron.backward" accessibilityDescription:nil];
    NSImage *image2 = [NSImage imageWithSystemSymbolName:@"chevron.forward" accessibilityDescription:nil];
    item1.image = [image1 imageWithSymbolConfiguration:config];
    item2.image = [image2 imageWithSymbolConfiguration:config];
    item1.tag = 0;
    item2.tag = 1;
    item1.bordered = YES;
    item2.bordered = YES;
    item1.label = @"backward";
    item2.label = @"forward";
    item1.target = target;
    item1.action = action;
    item2.target = target;
    item2.action = action;
    NSToolbarItemGroup *groupToolbarItem = [[NSToolbarItemGroup alloc] initWithItemIdentifier:itemIdentifier];
    groupToolbarItem.subitems = @[item1, item2];
    groupToolbarItem.controlRepresentation = NSToolbarItemGroupControlRepresentationExpanded;
    groupToolbarItem.label = labelTitle; // ex: @"Back/Forward"
    groupToolbarItem.paletteLabel = paletteLabelTitle;  // ex: @"Navigate Controls"
    groupToolbarItem.toolTip = toolTip; // @"go backwards or go forward to the next track";
    groupToolbarItem.navigational = YES; // 이렇게 해야 타이틀 왼쪽에 배치할 수 있다.
    groupToolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityStandard;
    // groupToolbarItem.selectedIndex = 0;
    return groupToolbarItem;
}
@end


@implementation NSMenuToolbarItem (Extension)

+ (instancetype)mgrPullDownItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                   labelTitle:(NSString *)labelTitle
                            paletteLabelTitle:(NSString *)paletteLabelTitle
                                      toolTip:(NSString *)toolTip
                                        image:(NSImage *)image
                                         menu:(NSMenu *)menu {
    NSMenuToolbarItem *menuToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    menuToolbarItem.showsIndicator = YES;
    menuToolbarItem.menu = menu;
    menuToolbarItem.label = labelTitle;
    menuToolbarItem.paletteLabel = paletteLabelTitle;
    menuToolbarItem.toolTip = toolTip;
    menuToolbarItem.bordered = YES;
    menuToolbarItem.image = image;
    menuToolbarItem.visibilityPriority = NSToolbarItemVisibilityPriorityStandard;
    
//    menuToolbarItem.menuFormRepresentation = ... overflow 메뉴는 자동이며, 대체 및 삭제가 불가능하다.
    return menuToolbarItem;
}


@end
