//
//  NSIndexSet+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-08
//  ----------------------------------------------------------------------
//
// https://gist.github.com/mikepj/4459727

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexSet (Extension)

#pragma mark - 교집합, 합집합, 차집합
//! indexSet1과 indexSet2 원소 중 공통으로 갖고 있는 원소만 추려서 배열로 반환한다.
+ (NSIndexSet *)mgrIntersectionIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2; // 교집합

//! indexSet1과 indexSet2 원소를 모두 합쳐 배열로 반환한다.
+ (NSIndexSet *)mgrUnionIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2; // 합집합

//! indexSet1의 원소 중에서 indexSet2에 해당하는 원소를 빼서 배열로 반환한다. 즉, indexSet1 이 고유하게 갖고 있는 원소만 빼준다.
+ (NSIndexSet *)mgrDifferenceIndexSet:(NSIndexSet *)indexSet1 indexSet2:(NSIndexSet *)indexSet2; // 차집합


#pragma mark - 스위프트 스타일의 편의 메서드
//! (3...8) 3부터 8까지 직관적으로 입력할 수 있다. 프레임워크 메서드 [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 6)]
+ (NSIndexSet *)mgrIndexSetFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

//! NSNumber(NSUInteger) 배열로 그 숫자에 해상하는 NSIndexSet 만들어준다.
+ (NSIndexSet *)mgrIndexSetFromArray:(NSArray <NSNumber *>*)numArr; // NSUInteger
@end

NS_ASSUME_NONNULL_END
