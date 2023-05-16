//
//  MGALabel+Mulgrim.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-02
//  ----------------------------------------------------------------------
//
#import <MacKit/MGALabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGALabel (Extension)

//! 실제로 서브클래스이다. 백그라운드 칼라, 보더 칼라는 layer를 이용하라.
+ (instancetype)mgrVerticallyCenterLabelWithString:(NSString *)str; // 싱글라인 라벨 Vertically Center
+ (instancetype)mgrVerticallyCenterMultiLineLabelWithString:(NSString *)str; // 멀티라인 라벨 Vertically Center

@end

NS_ASSUME_NONNULL_END
