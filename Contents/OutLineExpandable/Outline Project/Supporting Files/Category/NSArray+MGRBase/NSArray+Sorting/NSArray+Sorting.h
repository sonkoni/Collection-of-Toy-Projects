//
//  NSArray+MGRSorting.h
//  arrayTEST
//
//  Created by Kwan Hyun Son on 26/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Sorting)

//! 배열을 거꾸로 배치한다.
- (NSArray *)mgrReverseArray;

//! 배열의 순서를 섞는다. 원소의 갯수 동일
//! - shuffledArray 메서드가 존재하지만, GameplayKit 프레임워크를 XCode에서 받아야하므로, 내가 만들었다.
- (NSArray *)mgrShuffledArray;

//! exchange는 이미 존재하는 메서드이로 옮기는 것만 만들었다. 첫 번째 인수에 해당하는 인덱스의 객체를 두 번째로 옮긴다.
- (NSArray *)mgrMoveItemAtIndex:(NSUInteger)index toIndex:(NSUInteger)newIndex;

//! pullCount 만큼 앞에서 빼서 뒤에 붙인다.
//! 예를 들어, pullCount가 2이면, index 0, 1을 빼서 뒤에 차례로 붙이는 것이다. 물론 앞에서 뺀만큼 앞으로 밀리며, count는 그대로이다.
- (NSMutableArray *)mgrPullArrayWithPullCount:(NSInteger)pullCount;

//! pushCount 만큼 앞에서 밀고 뒤에서 빼와서 앞에 붙인다.
//! 예를 들어, pushCount가 2이면, 뒤쪽의 인덱스를 빼서 앞으로 차례로 붙이는 것이다. 물론 count는 그대로이다.
- (NSMutableArray *)mgrPushArrayWithPushCount:(NSInteger)pushCount;

//! 배열의 배열에서 특정 인덱스를 뽑아서 배열로 반환한다.
//! ex) index를 3으로 지정하면, 원 배열의 각 모든 요소에 차례차례 들어가서 그 요소(배열)의 index 3번만 뽑아서 새로운 배열을 만들어서 반환한다.
- (NSMutableArray *)mgrTwoDimensionalArrayWithIndex:(NSInteger)index; // self가 NSArray <NSArray *>*arr

//! 2차원 배열의 reverse한다.
- (NSMutableArray <NSMutableArray *>*)mgrReverseAnchor; // self가 NSArray <NSArray *>*arr

@end

NS_ASSUME_NONNULL_END
