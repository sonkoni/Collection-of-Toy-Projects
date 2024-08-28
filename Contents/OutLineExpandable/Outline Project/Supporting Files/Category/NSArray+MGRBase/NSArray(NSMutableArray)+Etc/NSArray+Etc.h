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

@interface NSArray (Etc)

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
+ (NSArray *)mgrRepeating:(id)object count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
