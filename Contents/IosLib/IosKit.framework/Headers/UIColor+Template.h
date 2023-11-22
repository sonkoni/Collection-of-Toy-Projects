//
//  UIColor+Template.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-11-15
//  ----------------------------------------------------------------------
//
// 구형 버전에서 시스템 칼라를 지원하기 위한 카테고리

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Template)

+ (UIColor *)mgrLabelColor;
+ (UIColor *)mgrTertiarySystemFillColor;
+ (UIColor *)mgrTertiaryLabelColor;
+ (UIColor *)mgrQuaternaryLabelColor;

@end

NS_ASSUME_NONNULL_END
