//
//  Item.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-29
//  ----------------------------------------------------------------------
//
// Apple의 원래 프로젝트에서 - isEqual: 자체가 그냥 포인터 비교처럼되어있었다.
// 따라서 copying 프로토콜은 만들지도 않겠다.
//! Diffable을 위해 UUID를 넣었다. Diffable 용 모델 객체이다. 일반적인 모델객체와는 구성이 다르다.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSObject <NSSecureCoding> // NSCopying

@property (nonatomic, strong) NSString *textLabelText;
@property (nonatomic, strong) NSString *detailTextLabelText;

- (instancetype)initWithText:(NSString *)text detailText:(NSString *)detailText;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
