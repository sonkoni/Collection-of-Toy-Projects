//
//  NSMutableArray+DismissStack.m
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//

#import "NSMutableArray+DismissStack.h"

@implementation NSMutableArray (DismissStack)

/// (== 인덱스 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackGreaterThan:(NSUInteger)idx {
    if (idx > self.count -1) {
        return nil;
    }
    NSUInteger afterLength = self.count - idx;
    NSRange removeRange = NSMakeRange(idx, afterLength);
    NSArray *removed = [self subarrayWithRange:removeRange];
    [self removeObjectsInRange:removeRange];
    return removed;
}

/// (== 인덱스 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackGreater:(NSUInteger)idx {
    if (idx > self.count -1 || self.count == 0) {
        return nil;
    }
    NSUInteger afterLength = self.count - idx - 1;
    NSRange removeRange = NSMakeRange(idx + 1, afterLength);
    NSArray *removed = [self subarrayWithRange:removeRange];
    [self removeObjectsInRange:removeRange];
    return removed;
}

/// 역탐색해서 (== 객체 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackByBackwardAfterThan:(id)object {
    NSUInteger idx = NSNotFound;
    for (NSInteger reversedIdx = self.count - 1; reversedIdx >= 0; reversedIdx--) {
        id exObj = self[reversedIdx];
        if (exObj == object) {
            idx = reversedIdx;
            break;
        }
    }
    if (idx == NSNotFound) {
        return nil;
    }
    NSUInteger afterLength = self.count - idx;
    NSRange removeRange = NSMakeRange(idx, afterLength);
    NSArray *removed = [self subarrayWithRange:removeRange];
    [self removeObjectsInRange:removeRange];
    return removed;
}

/// 순탐색해서 (== 객체 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackAfterThan:(id)object {
    NSUInteger idx = [self indexOfObject:object];
    if (idx == NSNotFound) {
        return nil;
    }
    NSUInteger afterLength = self.count - idx;
    NSRange removeRange = NSMakeRange(idx, afterLength);
    NSArray *removed = [self subarrayWithRange:removeRange];
    [self removeObjectsInRange:removeRange];
    return removed;
}

/// 역탐색해서 (== 객체 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackByBackwardAfter:(id)object {
    NSMutableArray *tempMuArr = [@[] mutableCopy];
    for (NSInteger reversedIdx = self.count - 1; reversedIdx >= 0; reversedIdx--) {
        id exObj = self[reversedIdx];
        if (exObj == object) {
            break;
        }
        [tempMuArr addObject:exObj];
        [self removeObjectAtIndex:reversedIdx];
    }
    if (!tempMuArr.count) {
        return nil;
    }
    NSMutableArray *removed = [@[] mutableCopy];
    for (NSInteger reversedIdx = tempMuArr.count - 1; reversedIdx >= 0; reversedIdx--) {
        [removed addObject:tempMuArr[reversedIdx]];
    }
    return removed;
}

/// 순탐색해서 (== 객체 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray *)dismissStackAfter:(id)object {
    NSUInteger idx = [self indexOfObject:object];
    if (idx == NSNotFound) {
        return nil;
    }
    NSUInteger afterLength = self.count - idx - 1;
    NSRange removeRange = NSMakeRange(idx + 1, afterLength);
    NSArray *removed = [self subarrayWithRange:removeRange];
    [self removeObjectsInRange:removeRange];
    return removed;
}
@end
