//
//  NSViewController+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-08-31
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSViewController (Extension)

//! window의 contentView 의 view 컨트롤러(root view controller)를 연결한다면
//! 1. winow(controller)를 nib으로 올렸다면 windowDidLoad 메서드에서 self.window.contentViewController = [[TestViewController alloc] initWithNibName:nil bundle:nil]; 를 하면 contentView가 교체된다.
//! 2. winow(controller)를 코드로 올렸다면, window를 만들고 나서 contentViewController에 꽂아주면 된다. ex): PreferencesWindowProject 참고.
- (void)mgrAddChildViewController:(__kindof NSViewController *)childController
                       targetView:(NSView * _Nullable)view;

- (void)mgrAddChildSplitViewController:(__kindof NSSplitViewController *)splitViewController;

- (void)mgrRemoveFromParentViewController; // 자신을 부모에게서 제거할때.

// child view controller(Recurrence), presented view controller(Recurrence)에서 restorationIdentifier에
// 해당하는 view controller 찾는다. child의 child, child의 presented, presented의 child, presented의 presented에
// 해당하는(재귀적으로) 모든 Recurrence 경우의 수를 다 검색하여 찾는다.
- (__kindof NSViewController * _Nullable)mgrRecurrenceFindOfIdentifier:(NSUserInterfaceItemIdentifier)identifier;

//! - (void)loadView 메서드에 결함이 존재한다. 내가 조금 더 업그레이드해서 결함을 없앴다. 필요에 따라 참고하라.
//! - loadView 내부에서 - mgrLoadView를 호출해서 사용하면 된다.
- (void)mgrLoadView;
@end

NS_ASSUME_NONNULL_END
