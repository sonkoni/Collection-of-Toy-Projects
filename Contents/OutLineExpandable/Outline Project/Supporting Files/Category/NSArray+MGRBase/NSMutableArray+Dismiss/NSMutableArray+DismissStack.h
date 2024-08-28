//
//  NSMutableArray+DismissStack.h
//  infrastructure
//
//  Created by 신길호 on 01/10/2019.
//  Copyright © 2019 Mulgrim Co. All rights reserved.
//
//  일부러 메서드 이름을 비슷하게 지었으니, 쓸 때 잘 봐야 함

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (DismissStack)

/// (== 인덱스 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackGreaterThan:(NSUInteger)idx;

/// (== 인덱스 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackGreater:(NSUInteger)idx;

/// 역탐색해서 (== 객체 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackByBackwardAfterThan:(id)object;

/// 순탐색해서 (== 객체 포함 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackAfterThan:(id)object;

/// 역탐색해서 (== 객체 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackByBackwardAfter:(id)object;

/// 순탐색해서 (== 객체 제외 ==) 이후 날림. 제거된 배열 반환. 제거 없으면 빈배열 반환
- (NSArray * _Nullable)dismissStackAfter:(id)object;

@end

NS_ASSUME_NONNULL_END
