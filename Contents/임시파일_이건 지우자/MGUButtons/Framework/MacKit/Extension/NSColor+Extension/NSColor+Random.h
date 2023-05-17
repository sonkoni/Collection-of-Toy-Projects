//
//  NSColor+Random.h
//
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (Random)
+ (NSColor *)mgrRandomColorWithAlpha:(CGFloat)alpha;

+ (NSColor *)mgrRandomColorBetweenColor:(NSColor *)color1 andColor:(NSColor *)color2;
+ (NSColor *)mgrRandomHSBColorBetweenColor:(NSColor *)color1 andColor:(NSColor *)color2;

//! 1, 2, 3 단계로 focus를 주어서 random을 만들어낸다. 1단계이면 color1에 가깝게 더 많이 뽑아준다.
//! 3 단계이면 color2에 가깝게 더 많이 뽑아준다. 2 단계이면 중간 값에 가깝게 더 많이 뽑아준다.
+ (NSColor *)mgrRandomColorBetweenColor:(NSColor *)color1 andColor:(NSColor *)color2 foucus:(NSInteger)foucus;
@end

NS_ASSUME_NONNULL_END
