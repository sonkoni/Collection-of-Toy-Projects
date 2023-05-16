//
//  MGAPreferencesWindowController.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAPreferencesWindowController.h"
#import "MGAPreferencesTabViewController.h"
#import "MGAUserInteractionPausableWindow.h"

// static NSWindowFrameAutosaveName const preferences = @"com.mulgrim.Preferences.FrameAutosaveName"; <- 지우는 게 낫다.

@interface MGAPreferencesWindowController ()
@property (nonatomic, strong) MGAPreferencesTabViewController *tabViewController;
@end

@implementation MGAPreferencesWindowController
@dynamic animated;

//! - initWithWindow: 에 nil을 넣어서 초기화해도 닙이름을 잘 찾아갈 수 있게 해준다. 닙파일을 안쓸꺼면 작성하지 말자. 에러 로그 뜸.
//- (NSNibName)windowNibName {
//    return NSStringFromClass([MGAPreferencesWindowController class]);
//}

- (void)dealloc { // super 호출금지.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

// given action에 응답하면 active pane을 반환한다.
- (id)supplementalTargetForAction:(SEL)action sender:(id)sender {
    id target = [super supplementalTargetForAction:action sender:sender];
    if (target != nil) {
        return target;
    }
    NSViewController *activeViewController = self.tabViewController.activeViewController;
    if (activeViewController == nil) {
        return nil;
    }

    NSResponder *target2 = [NSApp targetForAction:action to:activeViewController from:sender];
    if ([target2 isKindOfClass:[NSResponder class]] == YES && [target2 respondsToSelector:action] == YES) {
        return target2;
    }
    
    NSResponder *target3 = [activeViewController supplementalTargetForAction:action sender:sender];
    if ([target3 isKindOfClass:[NSResponder class]] == YES && [target3 respondsToSelector:action] == YES) {
        return target3;
    }

    return nil;
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                                  style:(MGAPreferencesStyle)style
                               animated:(BOOL)animated
              hidesToolbarForSingleItem:(BOOL)hidesToolbarForSingleItem {
    
    if (preferencePanes == nil || preferencePanes.count == 0) {
        NSCAssert(FALSE, @"최소 하나의 view controller는 설정해야한다.");
    }
    
    NSWindowStyleMask windowStyleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable;
    NSWindow *window =
    [[MGAUserInteractionPausableWindow alloc] initWithContentRect:preferencePanes[0].view.bounds
                                                        styleMask:windowStyleMask
                                                          backing:NSBackingStoreBuffered
                                                            defer:YES];
    self.hidesToolbarForSingleItem = hidesToolbarForSingleItem;
    self = [super initWithWindow:window];
    if (self) {
        _tabViewController = [MGAPreferencesTabViewController new];
        window.contentViewController = self.tabViewController;
        if (style == MGAPreferencesStyleToolbarItems) {
            window.titleVisibility = NSWindowTitleVisible;
        } else if (style == MGAPreferencesStyleSegmentedControl) {
            window.titleVisibility = (preferencePanes.count <= 1) ? NSWindowTitleVisible : NSWindowTitleHidden;
        } else {
            NSCAssert(FALSE, @"뭔가 잘못 들어왔다.");
        }
        
        if (@available(macOS 11.0, *)) {
            if (style == MGAPreferencesStyleToolbarItems) {
                window.toolbarStyle = NSWindowToolbarStylePreference; //! ScreenShot 확인바람
//                NSWindowToolbarStyleAutomatic,  // 알아서
//                NSWindowToolbarStylePreference  // 툴바 아이템이 가운데로 오게 해준다.
//                NSWindowToolbarStyleExpanded,   // 왼쪽 아래로 (툴바 자체가 세로로 길어짐)
//                NSWindowToolbarStyleUnified,    // 오른쪽으로
//                NSWindowToolbarStyleUnifiedCompact // 오른쪽으로 작게
            }
        }
        
        self.tabViewController.animated = animated;
        [self.tabViewController configurePreferencePanes:preferencePanes
                                                   style:style];
        [self updateToolbarVisibility];
    }

    return self;
}


#pragma mark - 세터 & 게터
- (void)setAnimated:(BOOL)animated {
    self.tabViewController.animated = animated;
}

- (BOOL)isAnimated {
    return self.tabViewController.isAnimated;
}

- (void)setHidesToolbarForSingleItem:(BOOL)hidesToolbarForSingleItem {
    _hidesToolbarForSingleItem = hidesToolbarForSingleItem;
    [self updateToolbarVisibility];
}


#pragma mark - Action
- (void)updateToolbarVisibility {
    self.window.toolbar.visible = (self.hidesToolbarForSingleItem == NO) || (self.tabViewController.preferencePanesCount > 1);
}

- (void)showPreferencePane:(NSToolbarItemIdentifier)preferenceIdentifier {
    if (self.window.isVisible == YES) {
        [self showWindow:self];
        return;
    }
    if (preferenceIdentifier != nil) {
        [self.tabViewController activateTabPreferenceIdentifier:preferenceIdentifier animated:NO];
    } else {
        [self.tabViewController restoreInitialTab];
    }
    
    [self showWindow:self];
    [self.window center]; // 중앙보다 살짝 위.
    //
//    [self restoreWindowPosition]; 필요 없을 듯. 윗줄의 [self.window center]; 로 대신한다.
    //! http://wiki.mulgrim.net/page/Api:AppKit/NSApplication/-_activateIgnoringOtherApps:#Discussion
//    [NSApp activateIgnoringOtherApps:YES];//<- 굳이 필요없을 듯.
}


#pragma mark - Helper
/** 딱히 필요 없을 듯.
- (void)restoreWindowPosition {
    if (self.window == nil || self.window.screen == nil) {
        return;
    }
    
    NSScreen *screenContainingWindow = self.window.screen;
    CGFloat originX = CGRectGetMidX(screenContainingWindow.visibleFrame) - self.window.frame.size.width / 2.0;
    CGFloat originY = CGRectGetMidY(screenContainingWindow.visibleFrame) - self.window.frame.size.height / 2.0;
    [self.window setFrameOrigin:CGPointMake(originX, originY)];

//    [self.window setFrameUsingName:preferences];  <- 지우는 게 낫다.
//    [self.window setFrameAutosaveName:preferences];  <- 지우는 게 낫다.
}
 */

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)coder { NSCAssert(FALSE, @"- initWithCoder: 사용금지. - initWithPreferencePanes:style:animated:hidesToolbarForSingleItem: 이걸 사용하라."); return nil; }
- (instancetype)initWithWindow:(NSWindow *)window { NSCAssert(FALSE, @"- initWithWindow: 사용금지. - initWithPreferencePanes:style:animated:hidesToolbarForSingleItem: 이걸 사용하라."); return nil; }
@end
