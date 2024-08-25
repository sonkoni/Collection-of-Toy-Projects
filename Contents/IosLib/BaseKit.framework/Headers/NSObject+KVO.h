//
//  NSObject+KVO.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-17
//  ----------------------------------------------------------------------
//
//  참고소스: https://github.com/cocos543/CCTrendCharts
//  참고소스: NSObject+CCEasyKVO

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @abstract 콜백 Block
 @param targetObject 관찰대상이 되는 객체. 상대경로 제외한
 @param change 변경된 정보
 */
typedef void (^MGRKVOBlock)(id targetObject, NSDictionary<NSKeyValueChangeKey, id> *change);

@interface NSObject (KVO)

// targetObject.keyPath <- 최종 관찰 Path
/**
    [self mgrObserve:self.person
          forKeyPath:@"age"
             options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
               block:^(id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
        NSLog(@"궁금하다. %@", object);  // self.person 객체
        NSLog(@"딕셔너리 -> %@", change);
 
        NSNumber *ageNumber = change[NSKeyValueChangeNewKey];
        NSInteger age = [ageNumber integerValue];
        NSLog(@"New age is: %ld", (long)age);
        if (ageNumber == nil) {
            NSLog(@"NSKeyValueChangeNewKey의 해당밸류 nil이다.");
        } else {
            NSLog(@"NSKeyValueChangeNewKey의 해당밸류 nil이 아니다.");
        }
 
        ageNumber = change[NSKeyValueChangeOldKey];
        age = [ageNumber integerValue];
        NSLog(@"Old age is: %ld", (long)age);
        if (ageNumber == nil) {
            NSLog(@"NSKeyValueChangeOldKey의 해당밸류 nil이다.");
        } else {
            NSLog(@"NSKeyValueChangeOldKey의 해당밸류 nil이 아니다.");
        }
    }];
*/
- (void)mgrObserve:(id)targetObject
        forKeyPath:(NSString *)keyPath
           options:(NSKeyValueObservingOptions)options
             block:(MGRKVOBlock)block;

- (void)mgrRemoveAllKVO;

@end

/// 다음 함수의 위험성으로 인하여 open class 를 만들었음
/// objc_getAssociatedObject(, )
/// objc_setAssociatedObject(, , , )
@interface MGRKVOObserver : NSObject

- (void)addTargetObject:(NSObject *)targetObject
             forKeyPath:(NSString *)relativeKeyPath
                options:(NSKeyValueObservingOptions)options
                  block:(MGRKVOBlock)b;

- (void)removeAllKVO;

#pragma mark - NS_UNAVAILABLE

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
