//  NSView+Shadow.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-21
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Shadow)

/*
   macOS에서는 view의 백업 layer에 shadow 설정하는 것 만으로는 원하는 결과를 얻을 수 없다.
   layer에 shadow 설정을 하려면 해당 뷰를 우선 super view에 붙인 상태에서 설정해야하고,
   다크모드 전환이 발생할 경우 shadow설정이 풀려버리는 결과가 발생한다.
   따라서, NSShadow를 이용하여 shadow 설정을 해야한다. 물론 view에 layer가 이미 존재해야하는 선행조건이 필요하다.
*/
- (void)mgrAddShadow:(NSColor *)shadowColor shadowBlurRadius:(CGFloat)shadowBlurRadius shadowOffset:(NSSize)shadowOffset;
- (void)mgrRemoveShadow;

@end

NS_ASSUME_NONNULL_END
