//
//  UIView+Etc.h
//
//  Created by Kwan Hyun Son on 26/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Etc)

/**
 * @brief 앱에서 아랍어를 지원하고, 아랍어로 앱이 구동되었다면 방향을 찾을 수 있다.
 * @discussion 아랍어를 지원하는 앱에서 아랍어와 같은 방향으로 언어가 구성되어있다면 YES이다.
 * @remark NO가 일반적인 상황이다.
 * @code
    if ([self mgrIsRTLLocale] == YES) {
        // 아랍어 같은 방향이다.
    }
 * @endcode
 * @return 아랍어처럼 Right to Left 이면 YES, 일반적인 언어라면, NO. 단, 앱 자체에서 아랍어를 제공해야한다.
*/
- (BOOL)mgrIsRTLLocale;

@end

NS_ASSUME_NONNULL_END
