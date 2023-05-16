//
//  NSArray+Filtering.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSArray+Filtering.h"
#import "NSArray+Sorting.h"

@implementation NSArray (Filtering)

- (NSArray *)mgrFilteredArrayForKindOfClass:(Class)classObject {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", classObject];
//    아래와 같은 식도 가능하다.
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
//        return [object isKindOfClass:classType];
//    }];
    return [self filteredArrayUsingPredicate:predicate];
}

- (BOOL)mgrAllIsKindOfClass:(Class)aClass { // 모든 element가  인자에 해당하는 클래스이면 YES를 반환한다.
    if (self.count == 0) {
        return NO;
    }
    __block BOOL result = YES;
    [self indexOfObjectPassingTest: ^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:aClass] == NO) {
            *stop = YES;
            result = NO;
            return YES;
        }else {
            return NO;
        }
    }];
    return result;
}

- (NSArray *)mgrSubArrayToIndex:(NSUInteger)index {
    NSInteger count = self.count;
    if ((count - 1) < index) { // index 가 초과했을 때.
#if DEBUG
        NSLog(@"index 초과 self 반환");
#endif
        return self.copy;
    } else {
        return [self subarrayWithRange:NSMakeRange(0, index + 1)];
    }
}

- (NSArray *)mgrSubArrayFromIndex:(NSUInteger)index {
    NSInteger count = self.count;
    if ((count - 1) < index) { // index 가 초과했을 때.
#if DEBUG
        NSLog(@"index 초과 nil 반환");
#endif
        return nil;
    } else {
        return [self subarrayWithRange:NSMakeRange(index, count - index)];
    }
}

- (NSArray *)mgrSubArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex > toIndex) {
        NSAssert(FALSE, @"fromIndex가 toIndex 보다 큰 오류가 발생했다.");
    }
    NSInteger count = self.count;
    if ((count - 1) < fromIndex) { // index 가 초과했을 때.
#if DEBUG
        NSLog(@"index 초과 nil 반환");
#endif
        return nil;
    } else if ((count - 1) < toIndex) { // index 가 초과했을 때.
        return [self mgrSubArrayFromIndex:fromIndex];
    } else {
        NSInteger elementCount = toIndex - fromIndex + 1;
        return [self subarrayWithRange:NSMakeRange(fromIndex, elementCount)];
    }
}

- (NSArray *)mgrPrefixWithMaxLength:(NSUInteger)maxLength {
    if (self.count <= maxLength) {
        return self.copy;
    } else {
        return [self mgrSubArrayToIndex:maxLength - 1];
    }
}

- (NSArray *)mgrSuffixWithMaxLength:(NSUInteger)maxLength {
    if (self.count <= maxLength) {
        return self.copy;
    } else {
        return [self mgrSubArrayFromIndex:self.count - maxLength];
    }
}

- (nullable id)mgrPreviousItem:(id)element {
    NSInteger index = (NSInteger)[self indexOfObject:element];
    if ((index == NSNotFound) || (index == 0)) {
#if DEBUG
        NSLog(@"해당 아이템이 없거나, -1 번 인덱스이다.");
#endif
        return nil;
    }
    return self[index - 1];
}

- (nullable id)mgrNextItem:(id)element {
    NSInteger index = (NSInteger)[self indexOfObject:element];
    if ((index == NSNotFound) || (index == self.count - 1)) {
#if DEBUG
        NSLog(@"해당 아이템이 없거나, 마지막을 초과한 인덱스이다.");
#endif
        return nil;
    }
    return self[index + 1];
}

- (nullable id)mgrRandomElement { //0 ~ x-1 까지 x 개수의 수 중 1개를 랜덤으로 반환한다.
    return [self objectAtIndex:arc4random_uniform((unsigned int)self.count)];
}


#pragma mark - Aggregation Operators
- (NSNumber *)mgrAvgForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@avg.%@", property];
    return [self valueForKeyPath:keyPath];
}

- (NSNumber *)mgrSumForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@sum.%@", property];
    return [self valueForKeyPath:keyPath];
}

- (NSNumber *)mgrMaxForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@max.%@", property];
    return [self valueForKeyPath:keyPath];
}

- (NSNumber *)mgrMinForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@min.%@", property];
    return [self valueForKeyPath:keyPath];
}

// - (NSNumber *)mgrCountForProperty:(NSString *)property {}

#pragma mark - Array Operators
- (NSArray *)mgrDistinctUnionOfObjectsForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", property];
    return [self valueForKeyPath:keyPath]; // 중복 값 제거 -> 배열 객체반환
}

- (NSArray *)mgrUnionOfObjectsForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@unionOfObjects.%@", property];
    return [self valueForKeyPath:keyPath]; // 중복 값 제거 -> 배열 객체반환
}


#pragma mark - Nesting Operators
- (NSArray *)mgrDistinctUnionOfArraysForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@distinctUnionOfArrays.%@", property];
    return [self valueForKeyPath:keyPath]; // 중복 값 제거 -> 배열 객체반환
}

- (NSArray *)mgrUnionOfArraysForProperty:(NSString *)property {
    NSString *keyPath = [NSString stringWithFormat:@"@unionOfArrays.%@", property];
    return [self valueForKeyPath:keyPath]; // 중복 값 제거 -> 배열 객체반환
}


#pragma mark - 교집합, 합집합, 차집합
+ (NSArray *)mgrIntersectionArray:(NSArray *)array1 array2:(NSArray *)array2 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", array1];
    return [array2 filteredArrayUsingPredicate:predicate];
}

+ (NSArray *)mgrUnionArray:(NSArray *)array1 array2:(NSArray *)array2 intersectOnce:(BOOL)intersectOnce {
    
    // Adding all objects
    if (intersectOnce == NO) { // 즉, 중복 되어있다면 같은 원소가 두 개가 있을 수 있다.
        return [array1 arrayByAddingObjectsFromArray:array2];
    }
 
    // 즉, 중복 되어있다면 한 원소만 포함되게 한다.
    // Calculating the relative complement was shown above ...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", array1];
    NSArray *relativeComplement = [array2 filteredArrayUsingPredicate:predicate];
    return [array1 arrayByAddingObjectsFromArray:relativeComplement];

}

+ (NSArray *)mgrDifferenceArray:(NSArray *)array1 array2:(NSArray *)array2 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT SELF IN %@", array2];
    return [array1 filteredArrayUsingPredicate:predicate];
}


#pragma mark - 길호가 만든 (NSArray+MGRExtension)에서 추가했다.
- (NSArray *)mgrMap:(id (^)(id _Nonnull))mapBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id obj in self) {
        id result = mapBlock(obj);
        if (result != nil) {
            [mutableArray addObject:result];
        }
    }
    return [mutableArray copy];
    //
    // 1차원 배열 전용
}

- (NSArray *)mgrMapUsingBlock:(id _Nonnull (NS_NOESCAPE ^)(id _Nonnull, NSUInteger, BOOL *))mapBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    NSInteger count = self.count;
    BOOL stop = NO;
    for (NSInteger i = 0;  i < count; i++) {
        id obj = self[i];
        id result = mapBlock(obj, i, &stop);
        if (result != nil) {
            [mutableArray addObject:result];
        }
        if (stop == YES) {
            break;
        }
    }
    return [mutableArray copy];
}

- (NSArray *)mgrFilter:(BOOL (^)(id _Nonnull))filterBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id obj in self) {
        if (filterBlock(obj) == YES) {
            [mutableArray addObject:obj];
        }
    }
    return [mutableArray copy];
}

- (NSArray *)mgrFlatMap:(id  _Nonnull (^)(id _Nonnull))flatBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        if ([unit isKindOfClass:[NSArray class]]) {
            [mutableArray addObjectsFromArray:[(NSArray *)unit mgrFlattenMap:flatBlock]];
        } else { // 1차원일 때
            if ([unit isKindOfClass:[NSNull class]]) {
                continue;
            }
            id element = flatBlock(unit);
            if (element != nil) {
                [mutableArray addObject:element];
            }
        }
    }
    return [mutableArray copy];
    // 스위프트 플랫맵 특징을 정리해보면 다음과 같다.
    // (1) n차원 배열을 1차원으로 쫙 편다.
    // (2) 1차원 배열일 때에만 nil 제거한다. 그 이상의 배열은 걍 쫙 펴서 담는다.
    //  ---->> 옵셔널 바인딩을 수행하지 않는다.
    // 위 함수는 이 특성 그래도 만들었다. 근데, 씨바 어디서는 폐기됐다고 하고 어디서는 쓴다고 하고 헷갈리다. 이건 나중에 살펴보자.
}

- (NSArray *)mgrCompactMap:(id  _Nullable (^)(id _Nonnull))flatBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        id target = unit;
        if ([target isKindOfClass:[NSNull class]] || !target) {
            continue;
        } else {
            id result = flatBlock(target);
            if (result && ![result isKindOfClass:[NSNull class]]) {
                [mutableArray addObject:result]; // 결과가 있는 것만 담는다.
            }
        }
    }
    return [mutableArray copy];
    // 스위프트 콤팩트맵 특징을 정리해보면 다음과 같다.
    // (1) 옵셔널 바인딩한다
    // (2) 1차원 배열일 때에만 nil 제거한다. 그 이상은 제거하지 않는다.
    //  ---->> n차원 배열 펴는 기능을 수행하지 않는다. 트리를 그대로 유지한다.
    // 위 함수는 이 특성 그래도 만들었다.
}


- (id)mgrReduce:(id)initial block:(id  _Nonnull (^)(id _Nonnull, id _Nonnull))reduceBlock {
    __block id obj = initial; // 블락에서 고칠 수 있는 변수
    for (id unit in self) {
        obj = reduceBlock(obj, unit); // 결과값을 다시 블락에 집어넣어 연산을 누적한다.
    }
    return obj; // 최종 블락 반환형으로 빠지는 객체의 타입으로 반환된다
//
// 이건 사용 방법이 좀 헷갈릴 수 이어서 예시를 남겨둔다.
//
//    //배열 안의 객체 중 NSNumber 이면 더해서 결과가 담긴 새 객체 생성
//    NSArray *someArr = @[@"hello", @"world", @(20), @(30), @"크크"];
//    NSNumber *num = @(100);
//    NSNumber *result = [someArr reduce:num block:^id _Nonnull(id  _Nonnull object, id  _Nonnull target) {
//        if ([target isKindOfClass:[NSNumber class]]) {
//            return @([(NSNumber *)object integerValue] + [(NSNumber *)target integerValue]);
//        } else {
//            return object;
//        }
//    }];
//    NSLog(@"%@, %@", num, result);  // 100, 150
//
// 주의할 것은 이니셜 타입으로 결과가 반환되는 것이 아니라 블락 반환형이 최종 함수 반환형이라는 점이다.
// 다음은 NSNumber 를 이니셜타입으로 주고 NSString 으로 반환받는 예시이다.
//
//    // 배열 안의 객체 중 NSNumber 이면 더해서 결과가 담긴 새 객체 생성
//    NSArray *someArr = @[@"hello", @"world", @(20), @(30), @"크크"];
//    NSNumber *num = @(100);
//    NSString *result = [someArr reduce:num block:^id _Nonnull(id  _Nonnull object, id  _Nonnull target) {
//        if ([target isKindOfClass:[NSNumber class]]) {
//            return [NSString stringWithFormat:@"%@ AND %@", object, target];
//        } else {
//            return object;
//        }
//    }];
//    NSLog(@"%@", result);  // 100 AND 20 AND 30
//
}


#pragma mark - Partition
- (void)mgrPartitionByBelongsInSecondPartition:(BOOL (^)(id _Nonnull))belongsInSecondPartitionBlock
                                      matching:(NSArray * _Nonnull __autoreleasing *)matching
                                   notMatching:(NSArray * _Nonnull __autoreleasing *)notMatching {
    NSMutableArray *mArr = self.mutableCopy;
    NSInteger partitionIndex = [mArr mgrPartitionByBelongsInSecondPartition:belongsInSecondPartitionBlock];
    if (partitionIndex == 0) {
        *matching = mArr.copy;
        *notMatching = @[];
    } else if (mArr.count <= partitionIndex) {
        *matching = @[];
        *notMatching = mArr.copy;
    }
    *notMatching = [mArr mgrSubArrayToIndex:(partitionIndex - 1)];
    *matching = [mArr mgrSubArrayFromIndex:partitionIndex];
}


#pragma mark 편의 및 지원
// 닥치고 배열 속의 배열을 플랫배열로 만든다. 아무 처리도 안하고 걍 편다
- (NSArray *)mgrFlatten {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        if ([unit isKindOfClass:[NSArray class]]) { // n차원
            [mutableArray addObjectsFromArray:[(NSArray *)unit mgrFlatten]]; // 내부 배열을 재귀로 푼다.
        } else { // 1차원
            [mutableArray addObject:unit]; // 객체 그 자체를 담아
        }
    }
    return [mutableArray copy];
}

/// 배열 속 배열을 돌며 블락을 때린 (( 결과 ))를 플랫배열에 담는다. 블락에서 옵셔널, NSNull, nil 이 반환되면 제거한다.
- (NSArray *)mgrFlatCompactMap:(id  _Nullable (^)(id _Nonnull))flatBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        id target = unit;
        if ([target isKindOfClass:[NSNull class]] || !target) {
            continue;
        } else if ([target isKindOfClass:[NSArray class]]) {
            [mutableArray addObjectsFromArray:[(NSArray *)target mgrFlatCompactMap:^id _Nullable(id  _Nonnull obj) {
                return flatBlock(obj); // 재귀로 내부 배열을 더 때려박는다.
            }]];
        } else {
            id result = flatBlock(target);
            if (result && ![result isKindOfClass:[NSNull class]]) {
                [mutableArray addObject:result]; // 결과가 있는 것만 담는다.
            }
        }
    }
    return [mutableArray copy];
//
// 예시 : 다음과 같은 복잡한 배열이 있다고 할 때
// 이 배열 속에서, 5보다 큰 숫자객체가 있다면 10 을 곱한 값을 결과배열에 담아줘
//    NSArray *complexArr = @[@1,
//                             @"hihi",
//                             @[@3, [NSNull null], @[@3, @4]],
//                             @"hehe",
//                             [NSNull null],
//                             @[@6, @[@7, @8, @9]]
//                            ];
//    NSArray *objArr1 = [complexArr mgrFlatCompactMap:^id _Nullable(id  _Nonnull obj) {
//        if ([obj isKindOfClass:[NSNumber class]] && ([(NSNumber *)obj integerValue] > 5)) {
//            return @([(NSNumber *)obj integerValue] * 10);
//        }
//        return nil;
//    }];
// NSLog(@"---> result : %@", objArr1); // 60, 70, 80, 90 이 담긴다.
}

/// 닥치고 배열 속 배열을 돌며 블락을 때린 (( 결과 ))를 플랫배열에 담는다. mgrFlatCompactMap 과 비슷하나 nil 제거 안한다.
- (NSArray *)mgrFlattenMap:(id  _Nonnull (^)(id _Nonnull))flatBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        if ([unit isKindOfClass:[NSArray class]]) { // n차원
            [mutableArray addObjectsFromArray:[(NSArray *)unit mgrFlattenMap:flatBlock]];  // 내부 배열을 재귀로 푼다.
        } else { // 1차원
            [mutableArray addObject:flatBlock(unit)]; // 결과를 담아
        }
    }
    return [mutableArray copy];
//
// mgrFlatCompactMap 예시와 비교해보면 이 함수 결과는
//    NSArray *objArr2 = [complexArr mgrFlattenMap:^id _Nonnull(id  _Nonnull obj) {
//        if ([obj isKindOfClass:[NSNumber class]] && [(NSNumber *)obj compare:@(5)]) {
//            return @([(NSNumber *)obj integerValue] * 10);
//        }
//        return [NSNull null];
//    }];
//    NSLog(@"---> result : %@", objArr2);
//
// 결과 :
//    "<null>", "<null>", "<null>", "<null>", "<null>", "<null>", "<null>", "<null>", 60, 70, 80, 90
}

/// 닥치고 배열 속의 배열을 돌며 블락리턴이 YES 인 (( 객체요소 )) 를 플랫배열에 담는다.
- (NSArray *)mgrFlattenFilter:(BOOL (^)(id _Nonnull))filterBlock {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id unit in self) {
        if ([unit isKindOfClass:[NSArray class]]) { // n차원
            [mutableArray addObjectsFromArray:[(NSArray *)unit mgrFlattenFilter:filterBlock]];
        } else { // 1차원
            if (filterBlock(unit) == YES) {
                [mutableArray addObject:unit]; // 객체 그 자체를 담아 -> 이건 mgrFilter 랑 동일
            }
        }
    }
    return [mutableArray copy];
// 예시 : 다음과 같은 복잡한 배열이 있다고 할 때
// 이 배열 속에서, 5보다 큰 숫자객체가 있다면 결과배열에 담아줘
//
//    NSArray *complexArr = @[@1,
//                            @"hihi",
//                            @[@3, [NSNull null], @[@3, @4]],
//                            @"hehe",
//                            [NSNull null],
//                            @[@6, @[@7, @8, @9]]
//                            ];
//
//    NSArray *objArr = [complexArr mgrFlattenFilter:^BOOL(id  _Nonnull obj) {
//        if ([obj isKindOfClass:[NSNumber class]] && ([(NSNumber *)obj integerValue] > 5)) {
//            return YES;
//        }
//        return NO;
//    }];
//
//    리턴값이 BOOL 이기 때문에 다음과 같이 구성해도 된다.
//    NSArray *objArr = [complexArr mgrFlattenFilter:^BOOL(id  _Nonnull obj) {
//        return ([obj isKindOfClass:[NSNumber class]] && ([(NSNumber *)obj integerValue] > 5));
//    }];
//
//    어쨌든 결과는 다음과 같다
//    NSLog(@"---> result : %@", objArr); // 6, 7, 8, 9 가 담긴다
}

- (id _Nullable)mgrFilterFirst:(BOOL (^)(id _Nonnull))filterBlock {
    id resultObject;
    for (id obj in self) {
        if (filterBlock(obj) == YES) {
            resultObject = obj;
            break;
        }
    }
    return resultObject;
}

- (NSUInteger)mgrFilterFirstIdx:(BOOL (^)(id _Nonnull))filterBlock {
    NSUInteger idx = NSNotFound;
    NSUInteger index = 0;
    for (id obj in self) {
        if (filterBlock(obj) == YES) {
            idx = index;
            break;
        }
        index++;
    }
    return idx;
}

// ----------------------------------------------------------------------
// 배열을 통해 노드를 만드는 데 지원
- (NSIndexPath *)mgrToIndexPath {
    NSUInteger length = self.count;
    NSUInteger cArray[length];
    NSUInteger idx = 0;
    for (id obj in self) {
        NSAssert([obj isKindOfClass:[NSNumber class]], @"Array Must Consist Only Number !!");
        NSInteger num = [(NSNumber *)obj integerValue];
        NSAssert(num >= 0, @"Must Non-Negative number !!");
        cArray[idx++] = num;  // idx 를 함수로 던진 뒤 증가
    }
    return [NSIndexPath indexPathWithIndexes:cArray length:length];
}

@end

@implementation NSMutableArray (Filtering)

- (id)mgrRemovedObjectAtIndex:(NSUInteger)index {
    NSAssert(index < self.count, @"인덱스 넘친다");
    id object = self[index];
    [self removeObjectAtIndex:index];
    return object;
}

@end

//yourArray = [yourArray objectsAtIndexes:[yourArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    return [self testFunc:obj];
//}]];
