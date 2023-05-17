//  NSView+Shadow.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-21
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Shadow)

- (void)mgrAddShadow:(NSColor *)shadowColor shadowBlurRadius:(CGFloat)shadowBlurRadius shadowOffset:(NSSize)shadowOffset;
- (void)mgrRemoveShadow;

@end

NS_ASSUME_NONNULL_END
