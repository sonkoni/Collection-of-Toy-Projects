//
//  NSArray+Filtering.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (Filtering)

- (NSArray *)mgrFilteredArrayForKindOfClass:(Class)classObject;
- (BOOL)mgrAllIsKindOfClass:(Class)aClass; // 배열의 모든 element가 인자의 클래스 일때 YES를 반환한다.

- (NSArray <ObjectType>*)mgrSubArrayToIndex:(NSUInteger)index;   // ex : subArrayToIndex:2    // 0, 1, 2
- (NSArray <ObjectType>* _Nullable)mgrSubArrayFromIndex:(NSUInteger)index; // ex : subArrayFromIndex:2  // 2....
- (NSArray <ObjectType>* _Nullable)mgrSubArrayFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex; // ex : 4, 5, ... , 34

//! @[@"A", @"B", @"C", @"D", @"E"]
- (NSArray <ObjectType>*)mgrPrefixWithMaxLength:(NSUInteger)maxLength;   // ex : mgrPrefixWithMaxLength:2    // A, B
- (NSArray <ObjectType>*)mgrSuffixWithMaxLength:(NSUInteger)maxLength;   // ex : mgrSuffixWithMaxLength:2    // D, E

- (nullable ObjectType)mgrPreviousItem:(ObjectType)element;
- (nullable ObjectType)mgrNextItem:(ObjectType)element;
- (nullable ObjectType)mgrRandomElement;


#pragma mark - Aggregation Operators
//! http://wiki.mulgrim.net/page/Project:Mac-ObjC/키-밸류_코딩,_키-밸류_옵저빙#Aggregation_Operators
/* 프라퍼티가 스칼라 및 NSNumber 모두 가능하며, 반환값은 NSNumber객체 이다. 자기자신을 때에는 @"self"를 넣어라.
@avg : 평균
@sum : 합계
@max : 가장 큰 값 - compare 메서드를 구현하고 있어야 한다
@min : 가장 작은 값 - compare 메서드를 구현하고 있어야 한다
@count : collection에 붙어있는 객체 수
 */
- (NSNumber *)mgrAvgForProperty:(NSString *)property;
- (NSNumber *)mgrSumForProperty:(NSString *)property;
- (NSNumber *)mgrMaxForProperty:(NSString *)property;
- (NSNumber *)mgrMinForProperty:(NSString *)property;
// - (NSNumber *)mgrCountForProperty:(NSString *)property; 이건 안쓰는게 더 나을듯.

#pragma mark - Array Operators
//! 배열의 요소가 갖고 있는 프라퍼티에 해당하는 객체를 뽑아서 배열로 만들어 반환한다.
//! http://wiki.mulgrim.net/page/Project:Mac-ObjC/키-밸류_코딩,_키-밸류_옵저빙#Aggregation_Operators
- (NSArray *)mgrDistinctUnionOfObjectsForProperty:(NSString *)property; // 중복 값 제거 ->배열 객체반환
- (NSArray *)mgrUnionOfObjectsForProperty:(NSString *)property;         // 중복 값 포함 -> 배열 객체반환


#pragma mark - Nesting Operators
//! 배열의 배열의 요소가 갖고 있는 프라퍼티에 해당하는 객체를 뽑아서 배열로 만들어 반환한다.
//! http://wiki.mulgrim.net/page/Project:Mac-ObjC/키-밸류_코딩,_키-밸류_옵저빙#Aggregation_Operators
- (NSArray *)mgrDistinctUnionOfArraysForProperty:(NSString *)property; // 중복 값 제거 ->배열 객체반환
- (NSArray *)mgrUnionOfArraysForProperty:(NSString *)property;         // 중복 값 포함 -> 배열 객체반환


#pragma mark - 교집합, 합집합, 차집합
//! array1과 array2 원소 중 공통으로 갖고 있는 원소만 추려서 배열로 반환한다.
+ (NSArray *)mgrIntersectionArray:(NSArray *)array1 array2:(NSArray *)array2; // 교집합

//! array1과 array2 원소를 모두 합쳐 배열로 반환한다. 둘 다 갖고 있는 원소를 중복하고 싶지 않다면 마지막 인수를 YES로 하라.
+ (NSArray *)mgrUnionArray:(NSArray *)array1 array2:(NSArray *)array2 intersectOnce:(BOOL)intersectOnce; // 합집합

//! array1의 원소 중에서 array2에 해당하는 원소를 빼서 배열로 반환한다. 즉, array1 이 고유하게 갖고 있는 원소만 빼준다.
+ (NSArray *)mgrDifferenceArray:(NSArray *)array1 array2:(NSArray *)array2; // 차집합


#pragma mark - 길호가 만든 (NSArray+MGRExtension)에서 추가했다.
// 맵은 블락을 통해 배열 요소 각각을 만지는데 이용된다
- (NSArray *)mgrMap:(id _Nullable (^)(ObjectType obj))mapBlock; // 블락의 결과값이 nil 이면 담지 않는다.
- (NSArray *)mgrMapUsingBlock:(id (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))mapBlock;

/// 필터는 블락의 컨디션 조건에 맞는 것(return YES)만 배출한다
- (NSArray <ObjectType>*)mgrFilter:(BOOL (^)(ObjectType obj))filterBlock;

/// 플랫맵 : 1차원 배열에서 닐을 제거한다. 하지만 N차원 배열은 제거 안하고 걍 펴서 붙인다. 결과값이 그대로 담긴다.
- (NSArray *)mgrFlatMap:(id (^)(id obj))flatBlock;   // 블락 리턴값이 nil 이면 안된다. -> 스위프트는 옵셔널로 담긴다

/// 콤팩트맵 : 1차원 배열에서 닐을 제거한다. 하지만 N차원 배열은 제거 안하고 게다가 펴지도 않는다. 구조를 유지한다. 다만 결과값은 닐이 아니다.
- (NSArray *)mgrCompactMap:(id _Nullable (^)(id obj))flatBlock; // 블락 리턴값이 nil 이면 완성배열에 담기지 않는다.

/// 리듀스는 모든 요소를 결합하여, 블락 반환형으로 지정된 하나의 객체를 반환한다(combine to single output)
//  처음 블락의 object 변수에 initial 을 던지며, target 변수에는 배열요소를 계속 던진다.
//  블락 반환형이 지속적으로 loop 를 돌며 블락 첫 인자인 object 로 던지는 방식으로 연산값을 누적시킨다.
- (id)mgrReduce:(id)initial block:(id (^)(id object, id target))reduceBlock;


#pragma mark - Partition
// 연속되는 _Nonnull에 뒷쪽의 의미는 인수로 nil을 넣어서는 안된다는 뜻이다.
- (void)mgrPartitionByBelongsInSecondPartition:(BOOL (^)(ObjectType obj))belongsInSecondPartitionBlock
                                      matching:(NSArray * _Nonnull *_Nonnull)matching
                                   notMatching:(NSArray * _Nonnull *_Nonnull)notMatching;

#pragma mark 이런 컨셉의 편의함수
/// 닥치고 배열 속의 배열을 플랫배열로 만든다. 아무 처리도 안하고 걍 편다
- (NSArray *)mgrFlatten;

/// 배열 속 배열을 돌며 블락을 때린 (( 결과 ))를 플랫배열에 담는다. 블락에서 옵셔널, NSNull, nil 이 반환되면 그건 플랫배열에 안 담는다.
- (NSArray *)mgrFlatCompactMap:(id _Nullable (^)(id obj))flatBlock;

/// 닥치고 배열 속 배열을 돌며 블락을 때린 (( 결과 ))를 플랫배열에 담는다. mgrFlatCompactMap 과 비슷하나 nil 제거 안한다.
- (NSArray *)mgrFlattenMap:(id (^)(id obj))flatBlock;

/// 닥치고 배열 속의 배열을 돌며 블락리턴이 YES 인 (( 객체요소 ))를 플랫배열에 담는다.
- (NSArray *)mgrFlattenFilter:(BOOL (^)(id obj))filterBlock;

/// 필터블락의 조건에 맞는 첫 번째 객체를 반환하고 종료
- (ObjectType _Nullable)mgrFilterFirst:(BOOL (^)(ObjectType obj))filterBlock;

/// 필터블락의 조건에 맞는 첫 번째 인덱스를 반환하고 종료. 못찾았으면 NSNotFound 반환
- (NSUInteger)mgrFilterFirstIdx:(BOOL (^)(ObjectType obj))filterBlock;

/// Number 로 구성된 배열객체를 IndexPath 로 만들어준다
- (NSIndexPath *)mgrToIndexPath;
@end

@interface NSMutableArray<ObjectType> (Filtering)

- (ObjectType)mgrRemovedObjectAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END


/*
//! 배열의 배열일때.
NSArray <NSArray <MyObject *>*>*arr = @[...];
NSArray <MyObject *>*resultArr = [arr valueForKeyPath:@"@distinctUnionOfArrays.self"];
NSArray <MyObject *>*resultArr = [arr valueForKeyPath:@"@unionOfArrays.self"];
*/

/*
//! 배열의 세트일때.
NSArray <NSSet <MyObject *>*>*arr = @[...];
NSArray <MyObject *>*resultArr = [arr valueForKeyPath:@"@distinctUnionOfSets.self"]; <- 추천.
NSArray <MyObject *>*resultArr = [arr valueForKeyPath:@"@distinctUnionOfArrays.self"]; <- 이것도 됨
NSArray <MyObject *>*resultArr = [arr valueForKeyPath:@"@unionOfArrays.self"]; <- 이것도 됨
*/

/*
//! 세트의 배열일때.
NSSet <NSArray <MyObject *>*>*arr = [[NSSet alloc] initWithObjects:<#(nonnull id), ...#>, nil];
NSSet <MyObject *>*resultSet = [arr valueForKeyPath:@"@distinctUnionOfArrays.self"];
*/

/*
//! 세트의 세트일때.
NSSet <NSSet <MyObject *>*>*set = [[NSSet alloc] initWithObjects:<#(nonnull id), ...#>, nil];
NSSet <MyObject *>*resultSet = [set valueForKeyPath:@"@distinctUnionOfSets.self"]; <- 추천.
NSSet <MyObject *>*resultSet = [set valueForKeyPath:@"@distinctUnionOfArrays.self"]; <- 이것도 됨
*/
