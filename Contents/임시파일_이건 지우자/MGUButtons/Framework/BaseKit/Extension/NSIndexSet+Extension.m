//
//  NSIndexSet+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSIndexSet+Extension.h"

@implementation NSIndexSet (Extension)

#pragma mark - 교집합, 합집합, 차집합
+ (NSIndexSet *)mgrIntersectionIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2 {
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    [indexSet1 enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        if ([indexSet2 containsIndex:index] == YES) {
            [result addIndex:index];
        }
    }];
    return result;
}

+ (NSIndexSet *)mgrUnionIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2 {
    NSMutableIndexSet *result = indexSet2.mutableCopy;
    [indexSet1 enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        if ([indexSet2 containsIndex:index] == NO) {
            [result addIndex:index];
        }
    }];
    return result;
}

+ (NSIndexSet *)mgrDifferenceIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2 {
    NSMutableIndexSet *result = indexSet1.mutableCopy;
    [result enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        if ([indexSet2 containsIndex:index] == YES) {
            [result removeIndex:index];
        }
    }];
    return result;
}


#pragma mark - 스위프트 스타일의 편의 메서드
+ (NSIndexSet *)mgrIndexSetFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex > toIndex) { // 이런 일은 없겠지만
        NSUInteger temp = fromIndex;
        fromIndex = toIndex;
        toIndex = temp;
    }
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(fromIndex, toIndex - fromIndex + 1)];
}

+ (NSIndexSet *)mgrIndexSetFromArray:(NSArray <NSNumber *>*)numArr {
    NSMutableIndexSet *result = [NSMutableIndexSet indexSet];
    NSSet *uniqueSet = [NSSet setWithArray:numArr];
    for (NSNumber *number in uniqueSet) {
        NSUInteger integer = [number unsignedIntegerValue];
        [result addIndex:integer];
    }
    return result;
}

@end
