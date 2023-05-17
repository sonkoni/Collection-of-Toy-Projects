//
//  NSArray+Sorting.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (Sorting)

- (NSArray <ObjectType>*)mgrReverseArray; // 배열을 거꾸로 배치한다.

//! 배열의 순서를 섞는다. 원소의 갯수 동일
//! - shuffledArray 메서드가 존재하지만, GameplayKit 프레임워크를 XCode에서 받아야하므로, 내가 만들었다.
- (NSArray <ObjectType>*)mgrShuffledArray;

//! exchange는 이미 존재하는 메서드이므로 옮기는 것만 만들었다. 첫 번째 인수에 해당하는 인덱스의 객체를 두 번째로 옮긴다.
- (NSArray <ObjectType>*)mgrMoveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)newIndex;

//! pullCount 만큼 앞에서 빼서 뒤에 붙인다.
//! 예를 들어, pullCount가 2이면, index 0, 1을 빼서 뒤에 차례로 붙이는 것이다. 물론 앞에서 뺀만큼 앞으로 밀리며, count는 그대로이다.
- (NSMutableArray <ObjectType>*)mgrPullArrayWithPullCount:(NSInteger)pullCount;

//! pushCount 만큼 앞에서 밀고 뒤에서 빼와서 앞에 붙인다.
//! 예를 들어, pushCount가 2이면, 뒤쪽의 인덱스를 빼서 앞으로 차례로 붙이는 것이다. 물론 count는 그대로이다.
- (NSMutableArray <ObjectType>*)mgrPushArrayWithPushCount:(NSInteger)pushCount;

//! 배열의 배열에서 특정 인덱스를 뽑아서 배열로 반환한다.
//! ex) index를 3으로 지정하면, 원 배열의 각 모든 요소에 차례차례 들어가서 그 요소(배열)의 index 3번만 뽑아서 새로운 배열을 만들어서 반환한다.
- (NSMutableArray *)mgrTwoDimensionalArrayWithIndex:(NSInteger)index; // self가 NSArray <NSArray *>*arr

//! 2차원 배열의 reverse한다.
- (NSMutableArray <NSMutableArray *>*)mgrReverseAnchor; // self가 NSArray <NSArray *>*arr

@end

@interface NSMutableArray<ObjectType> (Sorting)

- (NSUInteger)mgrPartitionByBelongsInSecondPartition:(BOOL (^)(ObjectType obj))belongsInSecondPartitionBlock;
// Swift Array의 partition(by:) 함수 즉, mutating func partition(by belongsInSecondPartition: (Self.Element) throws -> Bool) rethrows -> Self.Index 를 똑같이 구현하였다.
// C 함수의 partition 함수라고 보면된다. Quick Sort에서 이용된다.
// 파트를 앞 파트, 뒷 파트로 나누고 블락을 만족하는 element를 뒷 파트로 보낸다. 그래서 만들어진 배열이 자기 자신이 되며
// 뒷 파트의 첫 번째 인덱스를 반환한다. 효율성은 최상이지만 unstable ordering 이다. 파트의 구분만 하는 선에서 파트 내의 ordering은 고려하지 않는다.
// https://developer.apple.com/documentation/swift/array/partition(by:)-90po8
// https://runestone.academy/ns/books/published/pythonds/SortSearch/TheQuickSort.html
// https://gmlwjd9405.github.io/2018/05/10/algorithm-quick-sort.html
// https://stackoverflow.com/questions/51728469/use-partition-in-swift-to-move-some-predefined-elements-to-the-end-of-the-array
// https://www.anycodings.com/1questions/2318948/in-swift-an-efficient-function-that-separates-an-array-into-2-arrays-based-on-a-predicate

@end

NS_ASSUME_NONNULL_END
