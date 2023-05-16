//
//  NSWindow+Appearance.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSWindow+Appearance.h"

@implementation NSWindow (Appearance)
- (void)mgrSplitViewStandardWindowWithTitleVisibility:(NSWindowTitleVisibility)titleVisibility
                           titlebarAppearsTransparent:(BOOL)titlebarAppearsTransparent
                                         toolbarStyle:(NSWindowToolbarStyle)toolbarStyle {
    self.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskFullSizeContentView;
    self.titlebarSeparatorStyle = NSTitlebarSeparatorStyleAutomatic;
    self.titleVisibility = titleVisibility;
    self.titlebarAppearsTransparent = titlebarAppearsTransparent;
    self.toolbarStyle = toolbarStyle;
}

- (void)mgrSplitViewStandardWindowForFinderStyle {
    [self mgrSplitViewStandardWindowWithTitleVisibility:NSWindowTitleVisible
                             titlebarAppearsTransparent:NO
                                           toolbarStyle:NSWindowToolbarStyleUnified];
}

- (void)mgrSplitViewStandardWindowForNotesStyle {
    [self mgrSplitViewStandardWindowWithTitleVisibility:NSWindowTitleHidden
                             titlebarAppearsTransparent:NO
                                           toolbarStyle:NSWindowToolbarStyleUnified];
}

- (void)mgrSplitViewWindowMinimumSizeForFinderStyle {
    self.contentMinSize = CGSizeMake(315, 310);
}
- (void)mgrSplitViewWindowMinimumSizeForXCodeStyle {
    self.contentMinSize = CGSizeMake(960, 360);
}
- (void)mgrSplitViewWindowMinimumSizeForNotesStyle {
    self.contentMinSize = CGSizeMake(500, 350);
}


#pragma mark - NSWindowButton - 리사이즈 버튼관련. 문제가 존재한다. 우선 사용하지 말자.
- (void)mgrStandardWindowCloseButtonEnabled:(BOOL)closeEnabled
                      minimizeButtonEnabled:(BOOL)minimizeEnabled
                          zoomButtonEnabled:(BOOL)zoomEnabled {
    NSButton *closeButton = [self standardWindowButton:NSWindowCloseButton];
    NSButton *minimizeButton = [self standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
    if (closeButton.isEnabled != closeEnabled) { closeButton.enabled = closeEnabled; }
    if (minimizeButton.isEnabled != minimizeEnabled) { minimizeButton.enabled = minimizeEnabled; }
    if (zoomButton.isEnabled != zoomEnabled) { zoomButton.enabled = zoomEnabled; }
}

- (void)mgrStandardWindowCloseButtonHidden:(BOOL)closeHidden
                      minimizeButtonHidden:(BOOL)minimizeHidden
                          zoomButtonHidden:(BOOL)zoomHidden {
    NSButton *closeButton = [self standardWindowButton:NSWindowCloseButton];
    NSButton *minimizeButton = [self standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
    if (closeButton.isHidden != closeHidden) { closeButton.hidden = closeHidden; }
    if (minimizeButton.isHidden != minimizeHidden) { minimizeButton.hidden = minimizeHidden; }
    if (zoomButton.isHidden != zoomHidden) { zoomButton.hidden = zoomHidden; }
}

#pragma mark - Deprecated
- (void)mgrSplitViewStandardWindow {
    self.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskFullSizeContentView;
    self.titlebarSeparatorStyle = NSTitlebarSeparatorStyleAutomatic;
    //
//    splitViewItemA.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone; // window titlebarSeparatorStyle 오토매틱으로 해야함.
//    splitViewItemB.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine; // window titlebarSeparatorStyle 오토매틱으로 해야함.
//    splitViewItemC.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine; // window titlebarSeparatorStyle 오토매틱으로 해야함.
}

@end

@implementation  NSPanel (Appearance)

#pragma mark - Style Sample
// initialPosition - CGPointZero 이면 139.0 81.0 contentSize - CGSizeZero 이면 276.0 378.0
- (void)mgrUtilityStyleWithInitialPosition:(CGPoint)initialPosition contentSize:(CGSize)contentSize {
    self.styleMask = NSWindowStyleMaskTitled |
                     NSWindowStyleMaskClosable |
                     NSWindowStyleMaskMiniaturizable |
                     NSWindowStyleMaskResizable |
                     NSWindowStyleMaskUtilityWindow;  // 타이틀 바를 얇게, 신호등을 작게 만듬.
    self.hidesOnDeactivate = YES; // 닙으로 했을 때, 디폴트 값이 NO이다.
    // NO이면 Deactivate 가 되어도 사라지지 않는다. Deactivate란 앱이 아닌 다른 곳(다른 앱이나 바탕화면 등등.)을 찍었을 때. 청색이 사라지는 것.
    self.floatingPanel = YES; // 메인 윈도우보다 항상 앞에 선다.
    
    initialPosition = (CGPointEqualToPoint(initialPosition, CGPointZero) == YES)? CGPointMake(139.0, 81.0) : initialPosition;
    contentSize = (CGSizeEqualToSize(contentSize, CGSizeZero) == YES)? CGSizeMake(276.0, 378.0) : contentSize;
    [self setContentSize:contentSize];
    [self setFrameOrigin:initialPosition];
    //
    // - setFrame:display:animate: 메서드도 있다.
}

// initialPosition - CGPointZero 이면 90.0 125.0 contentSize - CGSizeZero 이면 480.0 270.0
- (void)mgrHUDStyleWithInitialPosition:(CGPoint)initialPosition contentSize:(CGSize)contentSize {
    self.styleMask = NSWindowStyleMaskTitled |
                     NSWindowStyleMaskClosable |
                     NSWindowStyleMaskMiniaturizable |
                     NSWindowStyleMaskResizable |
                     NSWindowStyleMaskUtilityWindow | // 타이틀 바를 얇게, 신호등을 작게 만듬.
                     NSWindowStyleMaskHUDWindow; // NSWindowStyleMaskHUDWindow은 NSWindowStyleMaskUtilityWindow를 필요로한다.
    self.hidesOnDeactivate = NO; // HUD 닙으로 했을 때, 디폴트 값이 NO이다.
    // NO이면 Deactivate 가 되어도 사라지지 않는다. Deactivate란 앱이 아닌 다른 곳(다른 앱이나 바탕화면 등등.)을 찍었을 때. 청색이 사라지는 것.
    self.floatingPanel = YES; // 메인 윈도우보다 항상 앞에 선다.
    
    initialPosition = (CGPointEqualToPoint(initialPosition, CGPointZero) == YES)? CGPointMake(90.0, 125.0) : initialPosition;
    contentSize = (CGSizeEqualToSize(contentSize, CGSizeZero) == YES)? CGSizeMake(480.0, 270.0) : contentSize;
    [self setContentSize:contentSize];
    [self setFrameOrigin:initialPosition];
}

@end

@implementation  NSColorPanel (Appearance)

- (void)mgrAppleSystemPreferencesGeneralHighlightColorPanel {
    self.styleMask = NSWindowStyleMaskTitled |
                     NSWindowStyleMaskClosable |
//!                  NSWindowStyleMaskHUDWindow | // 이거 하나 더해도 괜찮다.
                     NSWindowStyleMaskUtilityWindow; // 타이틀 바를 얇게, 신호등을 작게 만듬.
    self.showsAlpha = NO; // 기본값도 NO이다.
    self.hidesOnDeactivate = NO; // 기본값은 YES이지만 애플은 이렇다.
    self.floatingPanel = NO; // 기본값은 YES이지만 애플은 이렇다.
    self.continuous = NO; // 기본값은 YES이지만 애플은 이렇다. popup 버튼에 들어가는 것은 이미지인데 색으로 이미지를 그려야하기 때문에 퍼포먼스 이슈를 피하기 위함.
    [self setContentSize:CGSizeMake(228.0, 307.0)];
    self.title = @"Colors (General (System Preferences))";
}

@end

/**
 일반 NSWindow(nib) 기본값 : 00000000 00001111 : NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable

 일반 NSPanel(nib) Utility Panel 스타일 기본값 : 00000000 00011111 : NSWindow 값 | NSWindowStyleMaskUtilityWindow
 일반 NSPanel(nib) HUD Panel 스타일 기본값 : 00100000 00011111 : Utility Panel 값 | NSWindowStyleMaskHUDWindow
 일반 NSColorPanel(코드) 기본값 : 00000000 00011011 : NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskUtilityWindow
*/
