//
//  UIColor+MGRRandom.h
//  TweenKit
//
//  Created by Kwan Hyun Son on 08/04/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

// #import <AppKit/AppKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Random)

+ (UIColor *)mgrRandomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2;

//! 1, 2, 3 단계로 focus를 주어서 random을 만들어낸다. 1단계이면 color1에 가깝게 더 많이 뽑아준다.
//! 3 단계이면 color2에 가깝게 더 많이 뽑아준다. 2 단계이면 중간 값에 가깝게 더 많이 뽑아준다.
+ (UIColor *)mgrRandomColorBetweenColor:(UIColor *)color1 andColor:(UIColor *)color2 foucus:(NSInteger)foucus;
@end

NS_ASSUME_NONNULL_END
