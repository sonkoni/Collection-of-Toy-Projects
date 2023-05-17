//
//  NSMenuItem+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-01
//  ----------------------------------------------------------------------
//
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMenuItem (Extension)

//! 현재 텍스트가 이미 존재할 때만 유효하다. 또한 이후, 새로운 텍스트를 넣으면 효과는 없다.
//! 여러가지 attribute 이 존재한다면 이 메서드를 사용해서는 안된다. 단순히 색만 넣는 효과이다. 이것을 제일 많이 쓸듯.
- (void)mgrSetTitleColor:(NSColor *)color;

@end

NS_ASSUME_NONNULL_END
