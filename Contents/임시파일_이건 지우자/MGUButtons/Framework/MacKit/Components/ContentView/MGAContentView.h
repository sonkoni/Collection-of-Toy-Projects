//
//  MGAContentView.h
//
//  Created by Kwan Hyun Son on 2022/05/10.
//
// https://stackoverflow.com/questions/55204140/how-do-i-set-custom-tab-order-in-a-cocoa-app
// https://stackoverflow.com/questions/5997997/setting-a-custom-tab-order-in-a-cocoa-application
// https://stackoverflow.com/questions/4261865/tab-order-in-interface-builder
// https://stackoverflow.com/questions/8794520/cocoa-nextkeyview-tab-order
// https://www.stevestreeting.com/2014/02/11/auto-layout-and-tab-ordering/
// https://cocoadev.github.io/KeyViewLoopGuidelines/
// https://developer.apple.com/forums/thread/109158
//
// http://wiki.mulgrim.net/page/Project:IOs-ObjC/first_responder,_next_responder_비교(iOS_MacOS)
// http://wiki.mulgrim.net/page/Api:AppKit/NSWindow/contentView#Discussion

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGAContentView
 @abstract      NSWindow의 contentView로 사용될 뷰이다.
 @discussion    1. nextKeyView를 통해 key view chain을 완성 시켜줄 것이다. 2. 그리고 마우스 클릭을 하면 임의의 뷰(컨트롤) 객체에 있는 포커스링을 제거시켜 줄 것이다.
 @remark        좀 더 구체적인 동적을 규정하고 싶다면 사파리 앱을 보면서 테스트해보자. 프로젝트 NextKeyViewChain 을 참고해서 보자.
 @code
       - (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
           self.window.restorable = NO; // 디폴트가 YES였다.
           [self.window makeFirstResponder:nil];
           self.window.initialFirstResponder = self.button5;
           self.button5.nextKeyView = self.button4;
           self.button4.nextKeyView = self.button3;
           self.button3.nextKeyView = self.button2;
           self.button2.nextKeyView = self.button1;
           self.button1.nextKeyView = self.window.contentView; // 여기서 포커스링이 감춰질 것이다. contentView 는 MGAContentView 객체
           self.window.contentView.nextKeyView = self.button5; // 한번 더 탭하면 최초의 initialFirstResponder로 연결 시켜준다.
       }
@endcode
*/
@interface MGAContentView : NSView

@end

NS_ASSUME_NONNULL_END

/*
//! 툴바가 있을 때에는 그냥 이렇게만 하는게 낫겠다. 최초는 툴바가 먹으라고 하자. 툴바의 영역을 제외하고 루프를 완성하자.
//! 툴바는 루프가 완벽하면 그 루프를 파고든다. 루프가 불완전하여 순환하지 못하면 파고들지 못하지만 그렇게 작성하면 안된다.
//! 즉, nextKeyView 루프가 완벽할 때, window(window.contentView) 다음으로 자기 자신이 자리 잡는다.
self.window.restorable = NO; // 디폴트가 YES였다.
//    [self.window makeFirstResponder:...]; 툴바가 있을 때에는 작성을 안하는게 나을듯.
//    self.window.initialFirstResponder = ...; 툴바가 있을 때에는 작성을 안하는게 나을듯.
self.popUpNib1.nextKeyView = self.button2;
self.button2.nextKeyView = self.button;
self.button.nextKeyView = self.window.contentView;
*/

/* NSToolbar 실패. 아마도 안되는 것 같다.
//! https://stackoverflow.com/questions/51580875/make-nstoolbaritem-become-first-responder
//! 접근 방법이 괜찮은 것 같지만, toolbarItem.view와 toolbarItem.menuFormRepresentation.view 모두 nil이다. xib 에서 커스텀뷰를 끼워서
//! 자동으로 만들어지는 NSToolbarItem 아닌 이상. 따라서 작동하지 않는다.
NSArray <__kindof NSToolbarItem *>*toolbarItems = self.window.toolbar.items;
[toolbarItems enumerateObjectsUsingBlock:^(NSToolbarItem *toolbarItem, NSUInteger idx, BOOL *stop) {
//        NSToolbarItemIdentifier itemIdentifier = toolbarItem.itemIdentifier;
//        NSString *toolbarItemPaletteLabel = toolbarItem.paletteLabel;
    NSString *toolbarItemLabel = toolbarItem.label;
    if ([toolbarItemLabel isEqualToString:@"Day Night"] == YES) { // ETC: @"Search"
        self.window.restorable = NO; // 디폴트가 YES였다.
        [self.window makeFirstResponder:toolbarItem.view]; // toolbarItem.menuFormRepresentation.view
        self.window.initialFirstResponder = toolbarItem.view; // toolbarItem.menuFormRepresentation.view
        *stop = YES;
    }
}];
*/
