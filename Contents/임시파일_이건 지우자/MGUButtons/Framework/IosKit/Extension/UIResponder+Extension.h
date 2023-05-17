//
//  UIResponder+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-12-11
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (FirstResponder)

/**
* 현재 first responder 를 찾아서 반환해준다.
* @return 현재 first responder
* @discussion 현재 first responder를 모를때, 찾아주는 메서드이다.
* @code
 id currentFirstResponder = [UIResponder mgrCurrentFirstResponder];
 @endcode
*/
+ (id _Nullable)mgrCurrentFirstResponder;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-12-11 : 라이브러리 정리됨
 */
