//
//  NSMutableArray+DismissItem.m
//  infrastructure
//
//  Created by 신길호 on 05/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "NSMutableArray+DismissItem.h"

@implementation NSMutableArray (DismissItem)

/// 조건 블락이 YES 를 반환하면 뮤터블 배열에서 그 아이템을 삭제한다.
// 아래와 같이 사용한다. aMuArr 에서 반환 객체가 NSString 이면 제거하는 코드
//    [aMuArr dismissItemByBackwardFor:^BOOL(id  _Nonnull obj) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            return YES;
//        }
//        return NO;
//    }];
//
- (void)dismissItemByBackwardFor:(BOOL (^)(id _Nonnull))conditionBlock {
    for (NSInteger reversedIdx = self.count - 1; reversedIdx >= 0; reversedIdx-- ) {
        id obj = self[reversedIdx];
        if (conditionBlock(obj)) {
            [self removeObject:obj];
        }
    }
}

- (NSArray *)filter:(BOOL (^)(id obj))filterBlock purge:(BOOL (^)(id obj))purgeConditionBlock {
    NSMutableArray *matched = [NSMutableArray array];
    NSMutableIndexSet *removedIdx = [[NSMutableIndexSet alloc] init];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        id obj = self[idx];
        if (filterBlock && purgeConditionBlock) {
            if (purgeConditionBlock(obj)) {
                [removedIdx addIndex:idx];
            } else {
                if (filterBlock(obj)) {
                    [matched addObject:obj];
                }
            }
        }
    }
    if (removedIdx.count > 0) {
        [self removeObjectsAtIndexes:removedIdx];
    }
    return matched;
}

@end
