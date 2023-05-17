//
//  NSArray+Etc.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (Etc)

/**
 * @brief 주어진 객체를 count 만큼 반복해서 넣은 다음에 만들어진 배열을 반한다.
 * @param object 반복해서 집어넣을 객체
 * @param count 반복할 횟수
 * @discussion 반복할 객체는 copy하지는 않았다.
 * @remark 나중에 수정할려면하자.
 * @code
    NSArray *arr = [NSArray mgrRepeating:@"koni" count:5];
    NSLog(@"arr 알려줘 : %@", arr);
    2020-09-24 13:34:05.301566+0900 ArrayTEST[88537:25736300] arr 알려줘 : (
        koni,
        koni,
        koni,
        koni,
        koni
    )
 * @endcode
 * @return 주어진 객체를 count 만큼 반복해서 넣은 다음에 만들어진 배열
*/
+ (NSArray <ObjectType>*)mgrRepeating:(ObjectType)object count:(NSInteger)count;

/**
 * @brief 주어진 인수에 해당하는 클래스 객체의 인스턴스만으로 구성된 배열인지를 판단한다.
 * @param classObject element가 classObject의 인스턴스가 맞는지 판단할 것이다.
 * @discussion 빈 배열이거나 모든 element가 classObject 인스턴스이면 YES를 반환한다. 그렇지 않으면 NO 반환.
 * @remark ...
 * @code
    NSArray *arr1 = @[@"asdf", @"VVVVV", @"aa"];
    NSArray *arr2 = @[@(NO), @"VVVVV", @"aa"];
    NSArray *arr3 = @[@(1), @(1.3), @(1.0), @(YES)];
    
    NSLog(@"1---> %d", [arr1 mgrIsGenericsClass:[NSString class]]);
    NSLog(@"1---> %d", [arr1 mgrIsGenericsClass:[NSNumber class]]);
    
    NSLog(@"2---> %d", [arr2 mgrIsGenericsClass:[NSString class]]);
    NSLog(@"2---> %d", [arr2 mgrIsGenericsClass:[NSNumber class]]);
    
    NSLog(@"3---> %d", [arr3 mgrIsGenericsClass:[NSString class]]);
    NSLog(@"3---> %d", [arr3 mgrIsGenericsClass:[NSNumber class]]);
 
    2021-09-24 10:09:59.853659+0900 TEST[62440:4173879] 1---> 1
    2021-09-24 10:09:59.853679+0900 TEST[62440:4173879] 1---> 0
    2021-09-24 10:09:59.853692+0900 TEST[62440:4173879] 2---> 0
    2021-09-24 10:09:59.853703+0900 TEST[62440:4173879] 2---> 0
    2021-09-24 10:09:59.853712+0900 TEST[62440:4173879] 3---> 0
    2021-09-24 10:09:59.853722+0900 TEST[62440:4173879] 3---> 1
 * @endcode
 * @return 주어진 객체를 count 만큼 반복해서 넣은 다음에 만들어진 배열
*/
- (BOOL)mgrIsGenericsClass:(Class)classObject;

@end

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
