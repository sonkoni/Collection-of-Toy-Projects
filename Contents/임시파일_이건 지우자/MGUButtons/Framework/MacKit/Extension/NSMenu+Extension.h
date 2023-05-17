//
//  NSMenu+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-26
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMenu (Extension)

- (void)mgrReplaceMenuItemWithMenu:(NSMenu *)menu; // 인수의 메뉴 아이템을 카피하여 인수의 메뉴와 동일하게 만든다. 인수의 메뉴 프라퍼티도 카피한다.

@end

NS_ASSUME_NONNULL_END
