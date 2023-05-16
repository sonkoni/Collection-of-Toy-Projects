//
//  NSColor+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-03
//  ----------------------------------------------------------------------
//
//
// https://github.com/xamarin/Xamarin.Forms/issues/9962

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (Etc)

//! systemGreenColor 과 같은 NSColorTypeCatalog은 - getRed:green:blue:alpha: 메서드를 사용하면 앱이 터진다.
//! 어떤 경우에든 안전하게 사용할 수 있게 메서드를 만들었다.
- (void)mgrGetRed:(nullable CGFloat *)red
            green:(nullable CGFloat *)green
             blue:(nullable CGFloat *)blue
            alpha:(nullable CGFloat *)alpha;

@end

NS_ASSUME_NONNULL_END
