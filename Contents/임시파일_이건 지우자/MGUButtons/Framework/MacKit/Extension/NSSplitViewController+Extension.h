//
//  NSSplitViewController+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-17
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSplitViewController (Extension)

// static NSSplitViewAutosaveName const splitViewResorationIdentifier = @"com.mulgrim.currnetProjsect.MainSplitViewController.AutosaveName";
// 같은 걸 넣어줄 것 같다.
// 자신의 view와 자신의 splitView의 가장 많이 쓰이는 기본적인 설정이다.
- (void)mgrDefaultSetupWithAutosaveName:(NSSplitViewAutosaveName)autosaveName
                             identifier:(NSUserInterfaceItemIdentifier)identifier;

//! Discardable XCodeStyle 3단 Column, 양쪽 사이드 canCollapse.
- (NSArray <NSSplitViewItem *>*)mgrXCodeStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                             mainContentController:(__kindof NSViewController *)viewControllerB
                                               inspectorController:(__kindof NSViewController *)viewControllerC;

//! Discardable FinderStyle 2단 Column, 왼쪽 사이드 canCollapse.
- (NSArray <NSSplitViewItem *>*)mgrFinderStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                              mainContentController:(__kindof NSViewController *)viewControllerB;

//! Discardable NotesStyle 3단 Column, 왼쪽 사이드 canCollapse.
- (NSArray <NSSplitViewItem *>*)mgrNotesStyleWithSidebarController:(__kindof NSViewController *)viewControllerA
                                                    listController:(__kindof NSViewController *)viewControllerB
                                             mainContentController:(__kindof NSViewController *)viewControllerC;


#pragma mark - Actions
- (void)mgrToggleFirstPanel:(BOOL)animated; // holdingPriority 값이 적절해야지 애니메이션 도중 삑싸리가 나지 않는다.
- (void)mgrToggleLastPanel:(BOOL)animated; // holdingPriority 값이 적절해야지 애니메이션 도중 삑싸리가 나지 않는다.

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-09-17 : 라이브러리 정리됨
*/
