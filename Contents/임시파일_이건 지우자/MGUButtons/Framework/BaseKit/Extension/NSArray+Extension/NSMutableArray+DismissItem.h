//
//  NSMutableArray+DismissItem.h
//  infrastructure
//
//  Created by 신길호 on 05/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (DismissItem)

/// 조건 블락이 YES 를 반환하면 뮤터블 배열에서 삭제한다.
- (void)dismissItemByBackwardFor:(BOOL (^)(id obj))conditionBlock;

/// 퍼지 조건에 맞으면 원본 배열에서 지우고, 필터 조건에 맞는 정상적인 녀석만 반환한다. 정방향 탐색이다.
- (NSArray *)filter:(BOOL (^)(id obj))filterBlock purge:(BOOL (^)(id obj))purgeConditionBlock;

@end

NS_ASSUME_NONNULL_END
