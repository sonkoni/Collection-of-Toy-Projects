//
//  NSNumber+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-15
//  ----------------------------------------------------------------------
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MGRNumberType) {
    MGRNumberInt = kCFNumberNSIntegerType,
    MGRNumberFloat = kCFNumberCGFloatType,
    MGRNumberBool = kCFNumberCharType,
};

// ----------------------------------------------------------------------
// 객체형으로 포장된 스칼라 숫자를 어느 형으로 풀어야 할지 검출하기 위한 확장
//  - 객체형 숫자가 돌고 돌아서 혹은 임의로 넣어질 수 있는 함수 등에서 숫자객체를 다시 스칼라로 바꿀 때 활용할 수 있다.
NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Checking)
/// 풀어야 할 스칼라 타입
- (MGRNumberType)mgrType;
@end

// ----------------------------------------------------------------------

@interface NSNumber (General)
- (NSUInteger)mgrCountValue;
- (NSUInteger)mgrIndexValue;
- (NSUInteger)mgrBytesValue;
- (NSInteger)mgrTagValue;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-04-15 : 라이브러리 정리됨
 */
