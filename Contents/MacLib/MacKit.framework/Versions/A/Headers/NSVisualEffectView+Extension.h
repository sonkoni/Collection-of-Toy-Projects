//
//  NSVisualEffectView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-18
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSVisualEffectView (Extension)

// 윈도우 위에 붙는 타이틀바(툴바)의 느낌을 내는 뷰. window의 styleMask 비트마스크 프라퍼티는 NSWindowStyleMaskFullSizeContentView를 포함해야한다.
+ (NSVisualEffectView *)mgrTitlebarVisualEffectView:(NSTitlebarSeparatorStyle)separatorStyle;

// 윈도우 뒷면이 살짝 보일 것이다.
+ (NSVisualEffectView *)mgrSidebarVisualEffectView;
@end

NS_ASSUME_NONNULL_END
