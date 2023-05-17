//
//  UIControl+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-14
//  ----------------------------------------------------------------------
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Extension)

//! 둘은 같이 쌍으로 쓰일 수 있다. UIControlEventTouchUpInside 가 가장 많이 쓰이므로 이렇게 만들었다.
- (UIAction *)mgrAddActionForControlEventTouchUpInside:(void(^)(void))actionBlock API_AVAILABLE(ios(14.0));
- (void)mgrRemoveActionForControlEventTouchUpInside:(UIAction *)action API_AVAILABLE(ios(14.0));
@end

NS_ASSUME_NONNULL_END
