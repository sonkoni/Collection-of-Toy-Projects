//
//  NSMapTable+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-15
//  ----------------------------------------------------------------------
//  MGRSubscripting : 맵테이블에 서브스크립팅을 지원하기 위한 확장
//          - 세터 : tableObject[KEY] = helloWorld;
//          - 게터 : id helloWorld = tableObject[KEY];
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMapTable (Subscripting)
- (id _Nullable)objectForKeyedSubscript:(id)key;                // 원하는 키가 없으면 nil 이 반환된다
- (void)setObject:(id _Nullable)obj forKeyedSubscript:(id)key;  // nil 이 set 되면 해당 키를 지운다.
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-04-15 : 라이브러리 정리됨
 */
