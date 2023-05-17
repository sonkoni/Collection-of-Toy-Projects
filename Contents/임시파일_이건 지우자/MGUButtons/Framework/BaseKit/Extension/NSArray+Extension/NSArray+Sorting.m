//
//  NSArray+Sorting.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSArray+Sorting.h"

@implementation NSArray (Sorting)

- (NSArray *)mgrReverseArray {
    return [self reverseObjectEnumerator].allObjects;
}

- (NSArray *)mgrShuffledArray {
    NSMutableArray *mArr = self.mutableCopy;
    NSInteger count = self.count;
    for (NSInteger i = 0; i < count; ++i) {
       NSInteger nElements = count - i;
       NSInteger n = (arc4random() % nElements) + i;
       [mArr exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return mArr.copy;
}

- (NSArray *)mgrMoveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)newIndex {
    NSInteger count = self.count;
    if (index >= count || newIndex >= count) {
        NSAssert(FALSE, @"배열의 count 이상의 index가 전달되었다.");
    }
    NSMutableArray *mArr = self.mutableCopy;
    id obj = [mArr objectAtIndex:index];
    [mArr removeObjectAtIndex:index];
    [mArr insertObject:obj atIndex:newIndex];
    return mArr.copy;
}

- (NSMutableArray * )mgrPullArrayWithPullCount:(NSInteger)pullCount {
    if (self.count < pullCount) {
        NSCAssert(FALSE, @"인수로 던져진 배열의 인덱스를 초과하여 앞으로 땡겼다.");
    }
    NSArray *frontSubArr = [self subarrayWithRange:NSMakeRange(0, pullCount)];
    NSArray *backSubArr = [self subarrayWithRange:NSMakeRange(pullCount, self.count - pullCount)];
    return [backSubArr arrayByAddingObjectsFromArray:frontSubArr].mutableCopy;
//    NSArray *frontSubArr = [arr subarrayWithRange:NSMakeRange(0, pullCount)];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", frontSubArr];
//    NSArray *backSubArr = [arr filteredArrayUsingPredicate:predicate];
//    return [backSubArr arrayByAddingObjectsFromArray:frontSubArr].mutableCopy;
}

- (NSMutableArray *)mgrPushArrayWithPushCount:(NSInteger)pushCount {
    if (self.count < pushCount) {
        NSCAssert(FALSE, @"인수로 던져진 배열의 인덱스를 초과하여 뒤로 밀었다.");
    }
    NSArray *backSubArr = [self subarrayWithRange:NSMakeRange(self.count - pushCount, pushCount)]; // 뒤에서 빼온다.
    NSArray *frontSubArr = [self subarrayWithRange:NSMakeRange(0, self.count - pushCount)];
    return [backSubArr arrayByAddingObjectsFromArray:frontSubArr].mutableCopy;
//    NSArray *backSubArr = [arr subarrayWithRange:NSMakeRange(arr.count - pushCount, pushCount)]; // 뒤에서 빼온다.
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", backSubArr];
//    NSArray *frontSubArr = [arr filteredArrayUsingPredicate:predicate];
//    return [backSubArr arrayByAddingObjectsFromArray:frontSubArr].mutableCopy;
}


//! self가 NSArray <NSArray *>*arr
- (NSMutableArray *)mgrTwoDimensionalArrayWithIndex:(NSInteger)index {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];

    for (NSInteger i = 0; i < self.count; i++) {
        [result addObject: self[i][index]];
    }
    return result.mutableCopy;
}


- (NSMutableArray <NSMutableArray *>*)mgrReverseAnchor { // self가 NSArray <NSArray *>*arr
    NSArray <NSArray *>*arr = (NSArray <NSArray *>*)self;
    NSInteger count = arr.firstObject.count;
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSMutableArray *temp = [arr mgrTwoDimensionalArrayWithIndex:i];;
        [result addObject:temp];
    }

    return result.mutableCopy;
}

@end

@implementation NSMutableArray (Sorting)

- (NSUInteger)mgrPartitionByBelongsInSecondPartition:(BOOL (^)(id _Nonnull))belongsInSecondPartitionBlock {
    if (self.count == 0) {
        return 0;
    } else if (self.count == 1) {
        return (belongsInSecondPartitionBlock(self.firstObject) == YES) ? 0 : 1;
    }

    // element의 갯수가 2 개 이상인 경우
    NSUInteger leftMark = 0;
    NSUInteger rightMark = self.count - 1;
    do {
        id leftObj = self[leftMark];
        if (belongsInSecondPartitionBlock(leftObj) == NO) {
            leftMark++;
        } else {
            do {
                id rightObj = self[rightMark];
                if (belongsInSecondPartitionBlock(rightObj) == YES) {
                    rightMark--;
                } else { // exchange
                    [self exchangeObjectAtIndex:leftMark withObjectAtIndex:rightMark];
                    rightMark--;
                    break; // 현재 루프만 끝냄.
                }
            } while ( leftMark < rightMark );
        }
    } while ( leftMark < rightMark );
    return leftMark;
}

@end
