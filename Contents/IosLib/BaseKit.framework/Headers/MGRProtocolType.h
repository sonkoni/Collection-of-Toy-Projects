//
//  MGRProtocolType.h
//  Copyright © 2022 mulgrim. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-11-26
//  ----------------------------------------------------------------------
//  클래스 타입의 프로토콜을 정의
//

#ifndef MGRProtocolType_h
#define MGRProtocolType_h
#import <Foundation/Foundation.h>

/// 객체의 동작 취소
@protocol MGRCancellable
- (void)cancel;
@end

/// 객체의 태그 지정/반환
@protocol MGRTagable
- (void)setTag:(NSInteger)tag;
- (NSInteger)tag;
@end

/// 객체 활성화 지정/반환
@protocol MGRActivable
- (void)setIsActive:(BOOL)isActive;
- (BOOL)isActive;
@end

/// 객체 고유성
NS_SWIFT_UNAVAILABLE("Pr Hashable")
@protocol MGRHashable <NSObject>
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;
@end

/// opaque NSObject
typedef id      mgr_unique_t;

/// 객체의 유니크한 아이덴티파이어 반환
@protocol MGRIdentifiable <NSObject>
- (mgr_unique_t)identifier;
@end

#endif /* MGRProtocolType_h */
