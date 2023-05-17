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

/// 객체의 어느 동작을 취소할 수 있다
@protocol MGRCancellable
- (void)cancel;
@end

/// 객체에 태그를 넣고 뺄 수 있다
@protocol MGRTagable
- (void)setTag:(NSInteger)tag;
- (NSInteger)tag;
@end

/// 객체의 고유성을 보증한다
NS_SWIFT_UNAVAILABLE("Pr Hashable")
@protocol MGRHashable <NSObject>
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;
@end

/// opaque NSObject
typedef id      mgr_unique_t;

/// 객체에서 유니크한 아이덴티파이어를 반환한다
@protocol MGRIdentifiable <NSObject>
- (mgr_unique_t)identifier;
@end

#endif /* MGRProtocolType_h */
