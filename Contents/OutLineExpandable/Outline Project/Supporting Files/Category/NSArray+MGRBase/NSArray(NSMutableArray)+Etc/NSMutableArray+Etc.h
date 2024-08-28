//
//  NSMutableArray+Etc.h
//  TESTA
//
//  Created by Kwan Hyun Son on 2021/08/25.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray<ObjectType> (Etc)

/**
 * @brief 주어진 배열을 주어진 인덱스에 끼워넣는다. 2개 이상일 경우 그만큼 밀려난다.
 * @param objects 반복해서 집어넣을 객체
 * @param index 끼워 넣을 인덱스
 * @discussion - insertObjects:atIndexes: 메서드의 두 번째 인자가 index set이라서 편리하게 처리하기 위해 만들었다.
 * @remark 나중에 수정할려면하자.
 * @code
    NSMutableArray *arr = @[@"a", @"b", @"c", @"d"].mutableCopy;
    NSArray *arr2 = @[@"YYYYYY", @"VVV"];
    [arr mgrInsertObjects:arr2 atIndex:2];
    NSLog(@"%@", arr);
    2021-08-25 12:01:57.277185+0900 TESTA[21596:1349877] (
        a,
        b,
        YYYYYY,
        VVV,
        c,
        d
    )
 * @endcode
*/
- (void)mgrInsertObjects:(NSArray <ObjectType>*)objects atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
