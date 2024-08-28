//
//  UIView+Recurrence.h
//
//  Created by Kwan Hyun Son on 28/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Recurrence)

- (NSArray<__kindof UIView *> *)mgrRecurrenceAllSubviews; // 자기자신을 포함한 모든 서브뷰
- (NSArray<__kindof UIView *> *)mgrRecurrenceAllSubviewsOfType:(Class)type; // Class에 해당하는 자기자신을 포함한 모든 서브뷰들의 배열

@end

NS_ASSUME_NONNULL_END
//
// 재귀 메서드를 구현한 카테고리이다.
// retain cycle에서 자유롭다. (검증 되었다.)
