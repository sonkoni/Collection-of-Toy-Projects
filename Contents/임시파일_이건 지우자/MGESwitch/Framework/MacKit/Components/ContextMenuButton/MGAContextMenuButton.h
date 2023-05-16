//
//  MGAContextMenuButton+Mulgrim.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-26
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/60909487/objective-c-nspopmenubutton-nsmenu-color
// https://stackoverflow.com/questions/13222205/how-to-change-the-background-color-of-an-nspopupbutton
// https://stackoverflow.com/questions/51175125/nspopupbutton-nspopupbuttoncell-deprecated
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
/*
 * NSToolBar에서 볼 수 있는 컨텍스트 메뉴 스타일의 버튼을 일반 뷰에서 작동할 수 있도록 만들었다.
 ** 기본 색은 투명이다. 마우스 호버일 때의 색, 메뉴가 튀어나왔을 때의 색이 다르다. 메뉴가 튀어나올때 색이 좀 더 진하다.
 ** 색을 넣지 않으면 애플이 사용하는 값과 유사하게 설정한다.
 ** 이미지만 넣어서 사용할 것으로 예상하고 만들었다. 추후의 업데이트는 필요에 따라 기능을 추가하겠다.

 * 만든 이유:
     * 설정을 잘하면, NSPopupButton으로도 비슷하게 보일 수 있다. 그런데 문제는 호버의 색 영역 및 하이라이트 색 영역이 버튼의 높이와 맞지 않게 너무 좁다. 예쁘지 않아서 만들었다.
 */
@interface MGAContextMenuButton : NSPopUpButton
@property (nonatomic, strong, nullable) NSColor *highlightedColor; // 메뉴가 열렸을 때 배경색
@property (nonatomic, strong, nullable) NSColor *hoverColor; // 메뉴가 열리지 않고 마우스 오버 되었을 때의 배경색
@property (nonatomic, strong, nullable) NSImage *faceImage; // @dynamic

- (void)resetItemArray:(NSArray <NSMenuItem *>*)itemArray; // 중간에 메뉴를 교체해서 보여주고 싶을 때 사용한다.

// Target - Action 은 itemArray가 하는 것. 이미지만 넣는 것으로 예상하고 만들었다.
- (instancetype)initWithFrame:(NSRect)frameRect
                    faceImage:(NSImage *)faceImage
                    itemArray:(NSArray <NSMenuItem *>*)itemArray
                   hoverColor:(NSColor * _Nullable)hoverColor
             highlightedColor:(NSColor * _Nullable)highlightedColor
        refusesFirstResponder:(BOOL)refusesFirstResponder // 탭으로 퍼스트 리스폰더가 되는 것을 막을 수 있다.
                      toolTip:(NSString *)toolTip NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)frameRect NS_UNAVAILABLE;
- (instancetype)initWithFrame:(NSRect)buttonFrame pullsDown:(BOOL)flag NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

/** 사용 예제.
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window.backgroundColor = [NSColor whiteColor];
    
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
    _itemArray = @[menuItem1, menuItem2, menuItem3, menuItem4, menuItem5, menuItem6, menuItem7, menuItem8, menuItem9, menuItem10, menuItem11];
    [self.itemArray enumerateObjectsUsingBlock:^(NSMenuItem *obj, NSUInteger idx, BOOL *stop) {
        obj.identifier = obj.title;
        obj.tag = idx;
        obj.target = self;
    }];
    menuItem1.state = NSControlStateValueOn;

    NSColor *hoverColor = [NSColor colorWithWhite:0.0 alpha:0.051];
    NSColor *highlightedColor = [NSColor colorWithWhite:0.0 alpha:0.1];
    NSImage *image = [NSImage imageWithSystemSymbolName:@"square.grid.3x1.below.line.grid.1x2" accessibilityDescription:@""];
    MGAContextMenuButton *popUpButton =
    [[MGAContextMenuButton alloc] initWithFrame:CGRectZero
                                      faceImage:image
                                      itemArray:self.itemArray
                                     hoverColor:hoverColor
                               highlightedColor:highlightedColor
                          refusesFirstResponder:YES  // 퍼스트 리스폰더가 되면 원치 않는 결과가 올 수 있다.
                                        toolTip:@"툴팁이양"];
    [self.window.contentView addSubview:popUpButton];
    popUpButton.translatesAutoresizingMaskIntoConstraints = NO;
    [popUpButton.leadingAnchor constraintEqualToAnchor:self.window.contentView.leadingAnchor constant:20.0].active = YES;
    [popUpButton.bottomAnchor constraintEqualToAnchor:self.window.contentView.bottomAnchor constant:-20.0].active = YES;
    [popUpButton.widthAnchor constraintEqualToConstant:46.0].active = YES;
    [popUpButton.heightAnchor constraintEqualToConstant:21.0].active = YES;
}

#pragma mark - Actions
- (void)groupItemClicked:(NSMenuItem *)menuItem {
    NSInteger tag = menuItem.tag;
    for (NSInteger i = 0; i < self.itemArray.count; i++) {
        NSMenuItem *item = self.itemArray[i];
        if (item.tag == tag) {
            item.state = NSControlStateValueOn;
        } else {
            item.state = NSControlStateValueOff;
        }
    }
}
*/
