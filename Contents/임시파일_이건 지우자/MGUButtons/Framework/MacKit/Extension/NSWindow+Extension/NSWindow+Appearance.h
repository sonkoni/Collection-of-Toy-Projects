//  NSWindow+Appearance.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-12
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (Appearance)

#pragma mark - SplitView
/**
 * @brief SplitView에서 사용될 Window의 설정 값을 편리하게 설정할 수 있는 메서드이다.
 * @param titleVisibility 타이틀을 보이게 할 것인지 아닐 것인지 결정하는 NSWindowTitleVisibility 매개변수
 * @param titlebarAppearsTransparent 툴바(타이틀바) 투명하게 할 것인지 결정하는 BOOL 매개변수. 투명으로 하는 것이 좋을 듯.
 * @param toolbarStyle 툴바(타이틀바)의 높이를 결정하는 enum 매개변수
 * @discussion ...
 * @remark titlebarSeparatorStyle은 메서드 내부에서 오토매틱으로 했다. splitViewItem에서 재정의하라.
           splitViewItemA.titlebarSeparatorStyle = NSTitlebarSeparatorStyleNone;
           splitViewItemB.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
           splitViewItemC.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
 * @code
        [self.window mgrSplitViewStandardWindowWithTitleVisibility:NSWindowTitleHidden  // 이 부분은 hidden으로 많이 사용할 듯.
                                        titlebarAppearsTransparent:YES // 대부분은 YES로 할 것 같다.
                                                      toolbarStyle:NSWindowToolbarStyleAutomatic]; // 높이는 경우에 따라 다를듯.

 * @endcode
*/
- (void)mgrSplitViewStandardWindowWithTitleVisibility:(NSWindowTitleVisibility)titleVisibility // 타이틀을 보일지 말지 결정한다.
                           titlebarAppearsTransparent:(BOOL)titlebarAppearsTransparent // 툴바 자체를 투명으로 할 것인가.
                                         toolbarStyle:(NSWindowToolbarStyle)toolbarStyle; // 높이와 관련이 있다.

- (void)mgrSplitViewStandardWindowForFinderStyle; // 위 메서드의 convenience 버전이다.
- (void)mgrSplitViewStandardWindowForNotesStyle; // 위 메서드의 convenience 버전이다.

- (void)mgrSplitViewWindowMinimumSizeForFinderStyle;
- (void)mgrSplitViewWindowMinimumSizeForXCodeStyle;
- (void)mgrSplitViewWindowMinimumSizeForNotesStyle;


#pragma mark - NSWindowButton - 리사이즈 버튼관련. 문제가 존재한다. 우선 사용하지 말자.

// window의 NSTitlebarView에 좌측 상단에 존재하는 신호등(ⓧ⊖⊘) 버튼의 활성화 여부를 컨트롤하는 편의 메서드.
// zoom disabled 되었다해도 마우스로 사이즈 변동 가능하므로 반드시 zoom diabled라면 Fixed Size로 고정시키자.
- (void)mgrStandardWindowCloseButtonEnabled:(BOOL)closeEnabled
                      minimizeButtonEnabled:(BOOL)minimizeEnabled
                          zoomButtonEnabled:(BOOL)zoomEnabled;

// window의 NSTitlebarView에 좌측 상단에 존재하는 신호등(ⓧ⊖⊘) 버튼의 감출지 여부를 컨트롤하는 편의 메서드.
// zoom hidden 되었다해도 마우스로 사이즈 변동 가능하므로 반드시 zoom hidden라면 Fixed Size로 고정시키자.
- (void)mgrStandardWindowCloseButtonHidden:(BOOL)closeHidden
                      minimizeButtonHidden:(BOOL)minimizeHidden
                          zoomButtonHidden:(BOOL)zoomHidden;


#pragma mark - Deprecated
- (void)mgrSplitViewStandardWindow __attribute__((deprecated("Replaced by - mgrSplitViewStandardWindowWithTitleVisibility:titlebarAppearsTransparent:toolbarStyle:")));

@end

@interface NSPanel (Appearance)

#pragma mark - Template
// nib에서 제공되는 NSPanel의 Utility Style의 코드로 만들기.
// initialPosition - CGPointZero 이면 139.0 81.0 contentSize - CGSizeZero 이면 276.0 378.0
- (void)mgrUtilityStyleWithInitialPosition:(CGPoint)initialPosition contentSize:(CGSize)contentSize;

// nib에서 제공되는 NSPanel의 HUD style의 코드로 만들기
// initialPosition - CGPointZero 이면 90.0 125.0 contentSize - CGSizeZero 이면 480.0 270.0
- (void)mgrHUDStyleWithInitialPosition:(CGPoint)initialPosition contentSize:(CGSize)contentSize;

@end

@interface NSColorPanel (Appearance)

#pragma mark - Template
//! 애플의 세팅은 NSColorPanel 일반 설정과 조금 다르다.
- (void)mgrAppleSystemPreferencesGeneralHighlightColorPanel;
@end

NS_ASSUME_NONNULL_END

//
// https://forum.juce.com/t/making-a-floating-window-that-doesnt-bring-the-application-to-the-front/36963
// Close Button 모양이 빨간 원 중아에 점이 하나 찍혀있는 경우. EX) Sublime Text
// https://apple.stackexchange.com/questions/66292/whats-the-dot-in-the-centre-of-the-red-window-close-button-for
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/WinPanel/Concepts/UsingPanels.html#//apple_ref/doc/uid/20000224

//! NSWindowStyleMaskTitled         // The window displays a title bar.
//! NSWindowStyleMaskClosable       // The window displays a close button.
//! NSWindowStyleMaskMiniaturizable // The window displays a minimize button.
//! NSWindowStyleMaskResizable      // The window can be resized by the user.
   
//  NSPanel 및 서브 클래스(NSColorPanel 등등)만 이용가능.
//! NSWindowStyleMaskUtilityWindow  // The window is a panel or a subclass of NSPanel. 이용하면 신호등이 쪼끄마게 나옴.
//! NSWindowStyleMaskDocModalWindow // The window is a document-modal panel (or a subclass of NSPanel).
//! NSWindowStyleMaskNonactivatingPanel // Panel does not activate the owning app. (앱을 활성화하지 않는다.)
//! NSWindowStyleMaskHUDWindow      // The window is a HUD(heads up display) panel. 시컴하고 블러들어감.
    
    
//! NSWindowStyleMaskBorderless = 0. // window는 일반적인 주변 요소가 표시되지 않는다. 단순 표시 또는 캐싱 목적으로만 유용. 이 마스크를 사용하는 window는 canBecomeKeyWindow 또는 canBecomeMainWindow의 값이 YES가 아닌 한 키 window 또는 메인 window가 될 수 없다. xib 상에서 Attributes inspector에서 Show Title Bar를 선택 해제하여 이 마스크를 설정할 수 있다.
    
//! NSWindowStyleMaskFullSizeContentView // title bar 가 컨텐츠를 살짝 가린다. 별로 추천안하고 싶다. titlebar가 존재할때만 적용된다. 이 마스크를 사용하면 레이어 백업이 선택된다. contentLayoutRect 또는 auto-layout contentLayoutGuide를 이용하여 titlebar/toolbar 영역 아래에 view를 레이아웃한다.
    
//! NSWindowStyleMaskFullScreen // window가 full screen으로 나타날 수 있다. fullscreen window는 title bar를 draw 하지 않으며 toolbar에 대해 특별한 처리가 있을 수 있다. (이 마스크는 toggleFullScreen:이 호출될 때 자동으로 토글된다.)
    
//! NSWindowStyleMaskUnifiedTitleAndToolbar // toolbar를 포함하는 모든 window는 통합(unified) 스타일을 사용하기 때문에 이 상수는 아무런 effect가 없다.

/**
 NSWindowStyleMaskBorderless =                   0,  0000 0000 0000 0000 // 아무것도 없는 상태. 선택이라고 하기에는 애매하다. 코너라디어스 제거됨. 쉐도우 제거됨. 타이틀바 제거됨.
 NSWindowStyleMaskTitled =                  1 << 0,  0000 0000 0000 0001 // 거의 Required라고 보면된다. 이게 있어야 다른것도 표현가능하다.
 NSWindowStyleMaskClosable =                1 << 1,  0000 0000 0000 0010
 NSWindowStyleMaskMiniaturizable =          1 << 2,  0000 0000 0000 0100
 NSWindowStyleMaskResizable =               1 << 3,  0000 0000 0000 1000
 NSWindowStyleMaskUtilityWindow =           1 << 4,  0000 0000 0001 0000 <- Panel 전용. 타이틀바 얇아짐. 신호등도 작아짐.
                                            1 << 5,
 NSWindowStyleMaskDocModalWindow =          1 << 6,  0000 0000 0100 0000 <- Panel 전용.
 NSWindowStyleMaskNonactivatingPanel =      1 << 7,  0000 0000 1000 0000 <- Panel 전용.
                                            1 << 8,
                                            1 << 9,
                                           1 << 10,
                                           1 << 11,
                                           1 << 12,
 NSWindowStyleMaskHUDWindow =              1 << 13,  0010 0000 0000 0000 <- Panel 전용. 검은색 블러 스킨. minimize, Resizable 버튼 히든됨. NSWindowStyleMaskUtilityWindow 반드시 필요.
 NSWindowStyleMaskFullScreen =             1 << 14,  0100 0000 0000 0000 // 별다른 효과가 없이 자동 토글되는 것으로. 추정.
 NSWindowStyleMaskFullSizeContentView =    1 << 15,  1000 0000 0000 0000 // 타이틀바가 컨텐츠를 가림. 좀 꺼려진다.

 //---- 사용금지항목 ----//
 NSWindowStyleMaskTexturedBackground =      1 << 8,  0000 0001 0000 0000 // API_DEPRECATED
 NSWindowStyleMaskUnifiedTitleAndToolbar = 1 << 12,  0001 0000 0000 0000 // 아무런 효과가 없다. - 공식문서에 기재됨.
*/

/**
 일반 NSWindow(nib) 기본값 : 00000000 00001111 : NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable

 일반 NSPanel(nib) Utility Panel 스타일 기본값 : 00000000 00011111 : NSWindow 값 | NSWindowStyleMaskUtilityWindow
 일반 NSPanel(nib) HUD Panel 스타일 기본값 : 00100000 00011111 : Utility Panel 값 | NSWindowStyleMaskHUDWindow
 일반 NSColorPanel(코드) 기본값 : 00000000 00011011 : NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskUtilityWindow
*/
/**
 == 디펜던시 ==
 * NSWindowStyleMaskTitled : 거의 Required라고 보면된다. 이게 있어야 다른것도 표현가능하다.
 * NSWindowStyleMaskHUDWindow : 이 마스크는 NSWindowStyleMaskUtilityWindow를 반드시 같이 사용해야한다. 애플 로그(NSPanel requires NSWindowStyleMaskUtilityWindow for a HUD window)
  */
