//
//  MGRWarnUnusedResultMacro.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-03-07
//  ----------------------------------------------------------------------
//  스위프트처럼 반환값을 할당하지 않으면 경고를 띄워준다.
//  스위프트에서는 반환값을 사용하지 않고 싶을 때,(c는 기본이다.)  @discardableResult 을 사용한다.
//      메서드
//          - (NSString *)kekeke MGR_WARN_UNUSED_RESULT;
//      함수
//          NSString *mymymy(void) MGR_WARN_UNUSED_RESULT;
//
//  반환값을 할당하고 반환값 자체를 사용하지 않으려면(쓸대 없는 짓이긴 하지만) 다음과 같이 하면된다.
//  __unused NSString *str = [self.person kekeke];
//

#ifndef MGRWarnUnusedResultMacro_h
#define MGRWarnUnusedResultMacro_h
#import <Foundation/Foundation.h>

#define MGR_WARN_UNUSED_RESULT __attribute__((warn_unused_result))

#endif /* MGRWarnUnusedResultMacro_h */
//
// MGRAnnotationsMacro.h로 바꿀지 고민 중.
