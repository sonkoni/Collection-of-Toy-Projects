//
//  NSToolbarItem+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-15
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

#define NSToolbarItem_Mulgrim_UNAVAILABLE                                                   \
+ (instancetype)mgrLeadingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier \
                                         labelTitle:(NSString *)labelTitle                  \
                                  paletteLabelTitle:(NSString *)paletteLabelTitle           \
                                            toolTip:(NSString *)toolTip                     \
                                symbolConfiguration:(NSImageSymbolConfiguration * _Nullable)symbolConfiguration  \
                                             target:(id _Nullable)target                    \
                                             action:(SEL)action NS_UNAVAILABLE;             \
+ (instancetype)mgrTrailingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier                     \
                                          labelTitle:(NSString *)labelTitle                 \
                                   paletteLabelTitle:(NSString *)paletteLabelTitle          \
                                             toolTip:(NSString *)toolTip                    \
                                 symbolConfiguration:(NSImageSymbolConfiguration * _Nullable)symbolConfiguration \
                                              target:(id _Nullable)target                   \
                                              action:(SEL)action NS_UNAVAILABLE;            \
+ (instancetype)mgrTogleItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier          \
                                labelTitle:(NSString *)labelTitle                           \
                       possibleLabelTitles:(NSSet <NSString *>*)possibleLabelTitles         \
                         paletteLabelTitle:(NSString *)paletteLabelTitle                    \
                                   toolTip:(NSString *)toolTip                              \
                                     image:(NSImage *)image                                 \
                                    target:(id _Nullable)target                             \
                                    action:(SEL)action NS_UNAVAILABLE;                      \
+ (instancetype)mgrPopoverItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier        \
                                  labelTitle:(NSString *)labelTitle                         \
                           paletteLabelTitle:(NSString *)paletteLabelTitle                  \
                                     toolTip:(NSString *)toolTip                            \
                                       image:(NSImage *)image                               \
                                      target:(id _Nullable)target                           \
                                      action:(SEL)action NS_UNAVAILABLE;                    \
+ (instancetype)mgrPullDownItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier       \
                                   labelTitle:(NSString *)labelTitle                        \
                            paletteLabelTitle:(NSString *)paletteLabelTitle                 \
                                      toolTip:(NSString *)toolTip                           \
                                        image:(NSImage *)image                              \
                              normalItemArray:(NSArray <NSMenuItem *>*)normalItemArray      \
                            overflowItemArray:(NSArray <NSMenuItem *>*)overflowItemArray NS_UNAVAILABLE;         \
+ (instancetype)mgrCustomItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier         \
                                 labelTitle:(NSString *)labelTitle                          \
                          paletteLabelTitle:(NSString *)paletteLabelTitle                   \
                                    toolTip:(NSString *)toolTip                             \
                                 customView:(__kindof NSView *)customView                   \
                         overflowCustomView:(__kindof NSView * _Nullable)overflowCustomView NS_UNAVAILABLE;      \

NS_ASSUME_NONNULL_BEGIN

@interface NSToolbarItem (Extension)

/*
 #pragma mark - <NSToolbarDelegate>
 - (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag {
    ....
    여기에서 호출될 가능성이 크다.
 
 }
 
 NSImageSymbolConfiguration *config =
 [NSImageSymbolConfiguration configurationWithPointSize:17.0 weight:NSFontWeightRegular scale:NSImageSymbolScaleMedium];
 return [NSToolbarItem mgrLeadingSidebarItemWithIdentifier:itemIdentifier
                                                labelTitle:@"Sidebar"
                                         paletteLabelTitle:@"Sidebar"
                                                   toolTip:@"왼쪽 사이드바"
                                       symbolConfiguration:config
                                                    target:self
                                                    action:@selector(toggleFirstPanel:)];
 */

+ (instancetype)mgrLeadingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                         labelTitle:(NSString *)labelTitle // 툴바에 보이는 타이틀
                                  paletteLabelTitle:(NSString *)paletteLabelTitle // 편집모드에서 보이는 타이틀 대부분 라벨타이틀 그대로씀.
                                            toolTip:(NSString *)toolTip // 호버 되었을 시 나오는 문자열.
                                symbolConfiguration:(NSImageSymbolConfiguration * _Nullable)symbolConfiguration
                                             target:(id _Nullable)target // nil 일 때는 first responder
                                             action:(SEL)action; // NSSelectorFromString(...) first responder에 보낼때.
+ (instancetype)mgrTrailingSidebarItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                          labelTitle:(NSString *)labelTitle // 툴바에 보이는 타이틀
                                   paletteLabelTitle:(NSString *)paletteLabelTitle // 편집모드에서 보이는 타이틀 대부분 라벨타이틀 그대로씀.
                                             toolTip:(NSString *)toolTip // 호버 되었을 시 나오는 문자열.
                                 symbolConfiguration:(NSImageSymbolConfiguration * _Nullable)symbolConfiguration
                                              target:(id _Nullable)target
                                              action:(SEL)action;

//! 토글시에 툴바에 표시되는 텍스트가 보이는 스타일이라면 토글되면서 글자 길이가 변하면서 아이템의 크기가 변동될 수 있다. 이를 잘 잡아준다.
/*
 - (IBAction)toggleTitlebarAccessory:(id)sender {
     self.titlebarAccessoryViewIsHidden = !self.titlebarAccessoryViewIsHidden;
     self.titlebarAccessoryViewController.animator.hidden = self.titlebarAccessoryViewIsHidden;
     if  (self.titlebarAccessoryViewIsHidden == YES) {
         self.togleItem.label = @"Show";
         self.togleItem.toolTip = @"Shows additional accessories";
         self.togleItem.image = [NSImage imageWithSystemSymbolName:@"menubar.arrow.up.rectangle" accessibilityDescription:@""];
     } else {
         self.togleItem.label = @"Hide";
         self.togleItem.toolTip = @"Hides additional accessories";
         self.togleItem.image = [NSImage imageWithSystemSymbolName:@"menubar.arrow.down.rectangle" accessibilityDescription:@""];
     }
 }
 */
+ (instancetype)mgrTogleItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                labelTitle:(NSString *)labelTitle // 툴바에 보이는 타이틀
                       possibleLabelTitles:(NSSet <NSString *>*)possibleLabelTitles //! 자리 확보를 위해.
                         paletteLabelTitle:(NSString *)paletteLabelTitle // 편집모드에서 보이는 타이틀 대부분 라벨타이틀 그대로씀.
                                   toolTip:(NSString *)toolTip // 호버 되었을 시 나오는 문자열.
                                     image:(NSImage *)image
                                    target:(id _Nullable)target
                                    action:(SEL)action;


/**
 * @brief 1. overflow가 아닐 경우, sender는 NSSegmentedControl 객체이고 이 프레임으로 팝오버를 띄우는 위치를 찾는다. 2. overflow일 경우, sender는 NSMenuItem이고 팝오버의 위치는 다른 곳에서 띄워야한다.
 * @discussion ....
 * @remark ...
 
 * @code
 
        NSImage *image = [NSImage imageWithSystemSymbolName:@"tag" accessibilityDescription:@"tag"];
        return [NSToolbarItem mgrPopoverItemWithIdentifier:itemIdentifier
                                                labelTitle:@"Add Tags"
                                         paletteLabelTitle:@"Add Tags"
                                                   toolTip:@"태그를 더한다."
                                                     image:image
                                                     target:self
                                                     action:@selector(showTagPopover:)];
 
        - (void)showTagPopover:(id)sender {
            if ([sender isKindOfClass:[NSSegmentedControl class]] == YES) {
                NSSegmentedControl *segmentedControl = sender;
                NSLog(@"segmentedControl %@ : 이 객체에서 Popover를 띄워라.", sender);
            } else if ([sender isKindOfClass:[NSMenuItem class]] == YES) {
                NSLog(@"overflow 되었으므로 적절한 위치에서 Popover를 띄워라.");
            }
        }
 * @endcode
 * @return NSToolbarItem 인스턴스 객체
*/
+ (instancetype)mgrPopoverItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                  labelTitle:(NSString *)labelTitle
                           paletteLabelTitle:(NSString *)paletteLabelTitle
                                     toolTip:(NSString *)toolTip
                                       image:(NSImage *)image
                                      target:(id _Nullable)target
                                      action:(SEL)action;

/**
 * @brief Pull Down 메뉴형식으로 표현한다.
 * @discussion NSMenuToolbarItem 으로도 거의 같은 기능을 할 수 있다. Project:Solution/NSToolbarItem 에 설명했다.
 * @warning TARGET - ACTION 은 NSMenuItem 배열에 설정해야한다.
 * @remark ...
 * @code
 - (void)viewDidLoad {
     [super viewDidLoad];
     ...
     
     SEL selector = @selector(groupItemClicked:);
     NSMenuItem *menuItem1 = [[NSMenuItem alloc] initWithTitle:@"None" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem2 = [NSMenuItem separatorItem];
     NSMenuItem *menuItem3 = [[NSMenuItem alloc] initWithTitle:@"Name" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem4 = [[NSMenuItem alloc] initWithTitle:@"Kind" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem5 = [[NSMenuItem alloc] initWithTitle:@"Application" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem6 = [[NSMenuItem alloc] initWithTitle:@"Date Last Opened" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem7 = [[NSMenuItem alloc] initWithTitle:@"Date Added" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem8 = [[NSMenuItem alloc] initWithTitle:@"Date Modified" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem9 = [[NSMenuItem alloc] initWithTitle:@"Date Created" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem10 = [[NSMenuItem alloc] initWithTitle:@"Size" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem11 = [[NSMenuItem alloc] initWithTitle:@"Tags" action:selector keyEquivalent:@""];
     NSArray <NSMenuItem *>*itemArray = @[menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6, menuItem7, menuItem8, menuItem9, menuItem10, menuItem11];
     _itemArray1 = itemArray;
     [itemArray enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
         obj.identifier = obj.title;
         obj.tag = idx;
         obj.target = self;
     }];
     menuItem1.state = NSControlStateValueOn;
     _itemArray2 = [[NSArray alloc] initWithArray:itemArray copyItems:YES]; // 딥카피를 해야한다. 동시에 잡힐 수 없다.
 }
 
 - (void)groupItemClicked:(NSMenuItem *)menuItem {
     NSInteger tag = menuItem.tag;
     for (NSInteger i = 0; i < self.itemArray1.count; i++) {
         NSMenuItem *item = self.itemArray1[i];
         NSMenuItem *_item = self.itemArray2[i];
         if (item.tag == tag) {
             item.state = NSControlStateValueOn;
             _item.state = NSControlStateValueOn;
         } else {
             item.state = NSControlStateValueOff;
             _item.state = NSControlStateValueOff;
         }
     }
 }
 
 #pragma mark - <NSToolbarItemValidation>
 - (BOOL)validateToolbarItem:(NSToolbarItem *)item { ... }
 #pragma mark - <NSMenuItemValidation>
 - (BOOL)validateMenuItem:(NSMenuItem *)menuItem { ... }

 #pragma mark - <NSToolbarDelegate>
 - (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag {
  ...
     if ([itemIdentifier isEqualToString:MGPToolbarGroupItemIdentifier] == YES) {
         NSImage *image = [NSImage imageWithSystemSymbolName:@"square.grid.3x1.below.line.grid.1x2" accessibilityDescription:@""];
         return [NSToolbarItem mgrPullDownItemWithIdentifier:itemIdentifier
                                                  labelTitle:@"Group"
                                           paletteLabelTitle:@"파렛트 라벨"
                                                     toolTip:@"이것은 툴팁이다."
                                                       image:image
                                             normalItemArray:self.itemArray1
                                           overflowItemArray:self.itemArray2];
     }
   ...
 }
 
 * @endcode
 * @return NSToolbarItem 인스턴스 객체
*/
+ (instancetype)mgrPullDownItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                   labelTitle:(NSString *)labelTitle
                            paletteLabelTitle:(NSString *)paletteLabelTitle
                                      toolTip:(NSString *)toolTip
                                        image:(NSImage *)image
                              normalItemArray:(NSArray <NSMenuItem *>*)normalItemArray
                            overflowItemArray:(NSArray <NSMenuItem *>*)overflowItemArray;


#pragma mark - Custom View
+ (instancetype)mgrCustomItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                 labelTitle:(NSString *)labelTitle
                          paletteLabelTitle:(NSString *)paletteLabelTitle
                                    toolTip:(NSString *)toolTip
                                 customView:(__kindof NSView *)customView
                         overflowCustomView:(__kindof NSView * _Nullable)overflowCustomView;
@end


@interface NSToolbarItemGroup (Extension)

/**
 * @brief 내비게이션 아이템. 타이틀 왼쪽에 위치할 수 있다. 내비게이션 아이템은 그룹아이템이 꼭 아니어도 된다.
 * @discussion 파인더 앱의 타이틀 왼쪽에 존재하는 Back/Forward 버튼
 * @remark groupToolbarItem.subitems 으로 서브 NSToolbarItem을 잡을 수 있고, 태그 번호는 0(back), 1(forward)가 설정되어있다.
 
 * @code
 - (void)navigateItemClicked:(NSToolbarItem *)toolbarItem {
     // Back 버튼은 태그가 0, Forward 버튼은 태그가 1
     NSLog(@"x===> 태그 %ld",(long)toolbarItem.tag);
 }

 #pragma mark - <NSToolbarDelegate>
 - (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag {
     ....
     if ([itemIdentifier isEqualToString:MGPToolbarNavigationalItemIdentifier] == YES) {
         toolbarItem = [NSToolbarItemGroup mgrFinderNavigationalItemWithIdentifier:itemIdentifier
                                                                        labelTitle:@"Back/Forward"
                                                                 paletteLabelTitle:@"Navigate Controls"
                                                                           toolTip:@"go backwards or go forward to the next track"
                                                                            target:self
                                                                            action:@selector(navigateItemClicked:)];
     }
     ....
 }

 #pragma mark - <NSToolbarItemValidation> - target에 메시지를 보낸다.
 - (BOOL)validateToolbarItem:(NSToolbarItem *)item {
     if ([item.itemIdentifier isEqualToString:@"backwardItem"] == YES) {
         // ...... 뒤로 갈 아이템이 없으면 NO 반환 : NO 이면 비활성화 상태가 된다.
     } else if ([item.itemIdentifier isEqualToString:@"forwardItem"] == YES) {
         // ...... 앞으로 갈 아이템이 없으면 NO 반환 : NO 이면 비활성화 상태가 된다.
     }
     return YES;
 }
 * @endcode
 * @return NSToolbarItemGroup 인스턴스 객체
*/
+ (NSToolbarItemGroup *)mgrFinderNavigationalItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                                     labelTitle:(NSString *)labelTitle
                                              paletteLabelTitle:(NSString *)paletteLabelTitle
                                                        toolTip:(NSString *)toolTip
                                                         target:(id _Nullable)target
                                                         action:(SEL)action;
NSToolbarItem_Mulgrim_UNAVAILABLE  // NSToolbarItem (Extension) 카테고리를 사용하지 못하게 방어한다.
@end


@interface NSMenuToolbarItem (Extension)

/**
 * @brief Pull Down 메뉴형식으로 표현한다.
 * @discussion NSToolbarItem 으로도 거의 같은 기능을 할 수 있다. Project:Solution/NSToolbarItem 에 설명했다.
 * @warning TARGET - ACTION 은  action은 menu의 NSMenuItem에서 한다.
 * @remark ...
 * @code
 - (void)viewDidLoad {
     [super viewDidLoad];
     ...
     
     _actionsMenu = [[NSMenu alloc] initWithTitle:@""];
     SEL selector = @selector(groupItemClicked:);
     NSMenuItem *menuItem1 = [[NSMenuItem alloc] initWithTitle:@"None" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem2 = [NSMenuItem separatorItem];
     NSMenuItem *menuItem3 = [[NSMenuItem alloc] initWithTitle:@"Name" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem4 = [[NSMenuItem alloc] initWithTitle:@"Kind" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem5 = [[NSMenuItem alloc] initWithTitle:@"Application" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem6 = [[NSMenuItem alloc] initWithTitle:@"Date Last Opened" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem7 = [[NSMenuItem alloc] initWithTitle:@"Date Added" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem8 = [[NSMenuItem alloc] initWithTitle:@"Date Modified" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem9 = [[NSMenuItem alloc] initWithTitle:@"Date Created" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem10 = [[NSMenuItem alloc] initWithTitle:@"Size" action:selector keyEquivalent:@""];
     NSMenuItem *menuItem11 = [[NSMenuItem alloc] initWithTitle:@"Tags" action:selector keyEquivalent:@""];
     NSArray <NSMenuItem *>*itemArray = @[menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6, menuItem7, menuItem8,     menuItem9, menuItem10, menuItem11];
     self.actionsMenu.itemArray = itemArray;
     [itemArray enumerateObjectsUsingBlock:^(NSMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
         menuItem.target = self;
         menuItem.identifier = menuItem.title;
         menuItem.tag = idx;
     }];
     menuItem1.state = NSControlStateValueOn;
 }
 
 - (void)groupItemClicked:(NSMenuItem *)menuItem {
     NSInteger tag = menuItem.tag;
     [self.actionsMenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *item, NSUInteger idx, BOOL *stop) {
         if (tag == item.tag) {
             item.state = NSControlStateValueOn;
         } else {
             item.state = NSControlStateValueOff;
         }
     }];
 }
 
 #pragma mark - <NSToolbarItemValidation>
 - (BOOL)validateToolbarItem:(NSToolbarItem *)item { ... }
 #pragma mark - <NSMenuItemValidation>
 - (BOOL)validateMenuItem:(NSMenuItem *)menuItem { ... }

 #pragma mark - <NSToolbarDelegate>
 - (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
      itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
  willBeInsertedIntoToolbar:(BOOL)flag {
  ...
     if ([itemIdentifier isEqualToString:MGPToolbarGroupItemIdentifier] == YES) {
         NSImage *image = [NSImage imageWithSystemSymbolName:@"square.grid.3x1.below.line.grid.1x2" accessibilityDescription:@""];
         return [NSMenuToolbarItem mgrPullDownItemWithIdentifier:itemIdentifier
                                                      labelTitle:@"Group"
                                               paletteLabelTitle:@"Group Actions"
                                                         toolTip:@"Displays available Group actions"
                                                           image:image
                                                            menu:self.actionsMenu];
     }
   ...
 }
 
 * @endcode
 * @return NSMenuToolbarItem 인스턴스 객체
*/
+ (instancetype)mgrPullDownItemWithIdentifier:(NSToolbarItemIdentifier)itemIdentifier
                                   labelTitle:(NSString *)labelTitle
                            paletteLabelTitle:(NSString *)paletteLabelTitle
                                      toolTip:(NSString *)toolTip
                                        image:(NSImage *)image
                                         menu:(NSMenu *)menu;
NSToolbarItem_Mulgrim_UNAVAILABLE  // NSToolbarItem (Extension) 카테고리를 사용하지 못하게 방어한다.
@end

NS_ASSUME_NONNULL_END


#undef NSToolbarItem_Mulgrim_UNAVAILABLE
