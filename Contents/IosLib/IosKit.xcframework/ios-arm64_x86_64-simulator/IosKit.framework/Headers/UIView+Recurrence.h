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
- (NSArray<__kindof UIView *> *)mgrRecurrenceAllSubviewsOfType:(Class)classObject; // Class에 해당하는 자기자신을 포함한 모든 서브뷰들의 배열

// MGUView *result = [self.view mgrRecurrenceSearchFirstSubviewOfType:[MGUView class]];
// 인자에 해당하는 클래스의 Kind에 해당하는 서브뷰를 recurrence 로 검색하여 찾게 되는 첫 번째 서브뷰를 반환한다.
- (__kindof UIView * _Nullable)mgrRecurrenceSearchFirstSubviewOfType:(Class)classObject;

// Class에 해당하는(__kindof) 수퍼뷰를 만날 때까지 위로 찾아서 최초로 찾으면 그 객체(1개)를 반환한다.
- (__kindof UIView * _Nullable)mgrRecurrenceSuperviewsOfType:(Class)classObject;

@end

NS_ASSUME_NONNULL_END
//
// 재귀 메서드를 구현한 카테고리이다.
// retain cycle에서 자유롭다. (검증 되었다.)
