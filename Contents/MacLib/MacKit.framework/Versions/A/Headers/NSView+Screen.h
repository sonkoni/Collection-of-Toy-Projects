//  NSView+Screen.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-23
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Screen)

- (NSRect)mgrFrameFromScreen; // 자신의 뷰가 스크린에서 보았을 때의 frame rect이다.

@end

NS_ASSUME_NONNULL_END
