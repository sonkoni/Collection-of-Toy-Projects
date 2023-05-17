//  NSWindow+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-05
//  ----------------------------------------------------------------------
//
// https://github.com/uliwitness/UKFileWatcher/tree/111d81a72a6c1d4ea49af543d191dbf82ef70ca9
// https://github.com/uliwitness/FileExplorer/tree/3da7f290afa11c87a49e9bb91c1ed58e9439f335

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (Etc)

/* window controller의 이 단계에서 설정해 주면된다.
- (void)windowDidLoad {
    [super windowDidLoad];
 
    TestViewController *vc = [TestViewController new]; // vc가 nib 이 전혀 없다면(어디에도) loadView 재정의 필요
    [self.window mgrSetRootViewController:vc];
}
 */
- (void)mgrSetRootViewController:(__kindof NSViewController *)viewController;

//! Document Based 앱은 사용하지 마라. 자동으로 아이콘 이미지가 들어가므로 그렇게 하는 것이 낫다.
//! Document 앱에서 등장하는 타이틀 왼편의 아이콘(버튼)(파일 경로를 보여주는(커맨드+클릭 또는 컨트롤+클릭))을 Document 앱이 아닌 곳에서도 표현할 수 있게 한다.
//! 아이콘을 눌렀을 때, 파일경로(여기서는 앱이 저장된 경로. 제일 아래가 루트. 만약 존재하지 않는 경로이면 현재 앱경로 내부의 데이터 폴더에서 임의의 계보로 보여준다.)가
//! 팝업메뉴로 나오게 하는 것을 막고 싶다면 NSWindowDelegate 메서드
//! - window:shouldPopUpDocumentPathMenu:에서 NO를 반환하면 된다.
//! 타이틀이 나올때, 아이콘(버튼)도 같이 나오게 해준다. icon 변수가 nil 이면 앱 아이콘을 표시한다. nil 이 아니면 Delegate 메서드 메서드를 작성하는 것을 고려해보자.
//!
- (void)mgrSetTitle:(NSString *)title subtitle:(NSString *)subtitle iconImage:(NSImage * _Nullable)iconImage;

//! 미니어처 모드로 들어가서 독으로 보일때의 이미지와 그 위를 마우스 오버했을 때 나오는 팝업 타이틀을 설정하게 한다.
- (void)mgrSetMiniwindowTitle:(NSString *)miniwindowTitle miniwindowImage:(NSImage * _Nullable)miniwindowImage;


// open(fade In) OR close(fade Out)
- (void)mgrFadeDuration:(CGFloat)duration
                 fadeIn:(BOOL)fadeIn
      completionHandler:(void(^_Nullable)(void))completionHandler;

//! DEBUG - constraints 를 보여주고 감춘다.
- (void)mgrShowAllConstraints;
- (void)mgrHideAllConstraints;
@end

NS_ASSUME_NONNULL_END
