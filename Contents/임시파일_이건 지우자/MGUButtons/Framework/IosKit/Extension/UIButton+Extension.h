//
//  UIButton+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Shrink)

//! 카테고리를 가장한 서브 클래스를 반환한다. 기능이 shrink밖에 없다. 0.1 보다 작은 값이 오면 디폴트로 0.85로 설정한다.
+ (UIButton *)mgrShinkButton:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
