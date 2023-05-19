//
//  MGRStructType.h
//  Copyright © 2022 mulgrim. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-07
//  ----------------------------------------------------------------------
//

#ifndef MGRStructType_h
#define MGRStructType_h
#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------
// BOXABLE 지원 : CF_BOXABLE 대신 MGR_BOXABLE 을 써도 된다.
// .h 파일에서 다음과 같이 선언해준다.
//    struct MGPHello {
//        NSInteger one;
//        NSInteger two;
//    };
//    typedef struct CF_BOXABLE MGPHello MGPHello;
//    MGR_BOXABLE_VALUE(MGPHello)
// 혹은 다음과 같이 선언하면서 바로 별칭 추가해도 된다.
//    typedef struct CG_BOXABLE MGPHello {
//        NSInteger one;
//        NSInteger two;
//    } MGPHello;
//    MGR_BOXABLE_VALUE(MGPHello)
// .m 파일에서 다음과 같이 선언해준다.
//    MGR_BOXABLE_VALUE_IMP(MGPHello)
//

#if defined(__has_attribute) && __has_attribute(objc_boxable)
#define MGR_BOXABLE __attribute__((objc_boxable))
#else
#define MGR_BOXABLE
#endif

// 박서블 밸류지원 선언
#define MGR_BOXABLE_VALUE(TYPE)                     \
@interface NSValue (TYPE)                           \
+ (instancetype)valueWith##TYPE:(TYPE)cStruct;      \
- (TYPE)TYPE##Value;                                \
@end
// 박서블 밸류지원 구현
#define MGR_BOXABLE_VALUE_IMP(TYPE)                 \
@implementation NSValue (TYPE)                      \
+ (instancetype)valueWith##TYPE:(TYPE)cStruct {     \
    return [NSValue value:&cStruct withObjCType:@encode(TYPE)]; \
}                                                           \
- (TYPE)TYPE##Value {                                       \
    NSCAssert(strcmp([self objCType], @encode(TYPE)) == 0, @"Type Error");  \
    TYPE decodedStruct;                                     \
    [self getValue:&decodedStruct size:sizeof(TYPE)];       \
    return decodedStruct;                                   \
}                                                           \
@end


// ----------------------------------------------------------------------
/// 정수형 (NSInteger ix, NSInteger iy) 구조체. 박스지원.
/// @discussion MGRIpxZero : (0, 0) 반환
/// @discussion MGRIpxNull : (NSIntegerMax, NSIntegerMax) 반환
/// @discussion MGRIpxMake(ix, iy) : 만들기
/// @discussion MGRIpxEqualToIpx(ipx1, ipx2) : 동일한지 여부
/// @discussion MGRIpxIsEmpty(ipx) : (0, 0)인지 여부
/// @discussion MGRIpxIsNull(ipx) : (NSIntegerMax, NSIntegerMax)인지 여부
struct MGRIpx {
    NSInteger ix;
    NSInteger iy;
};
typedef struct __attribute__((objc_boxable)) MGRIpx MGRIpx;
static MGRIpx const MGRIpxZero = {0,};
static MGRIpx const MGRIpxNull = {NSIntegerMax, NSIntegerMax};
static inline MGRIpx MGRIpxMake(NSInteger ix, NSInteger iy) {MGRIpx ipx = {ix, iy}; return ipx;}
bool MGRIpxEqualToIpx(MGRIpx ipx1, MGRIpx ipx2);
bool MGRIpxIsEmpty(MGRIpx ipx);
bool MGRIpxIsNull(MGRIpx ipx);
@interface NSValue (MGRIpx)
+ (instancetype)valueWithMGRIpx:(MGRIpx)cStruct;
- (MGRIpx)MGRIpxValue;
@end


// ----------------------------------------------------------------------
/// 자연수형 (NSUInteger ux, NSUInteger uy) 구조체. 박스지원.
/// @discussion MGRUpxZero : (0, 0) 반환
/// @discussion MGRUpxNull : (NSUIntegerMax, NSUIntegerMax) 반환
/// @discussion MGRUpxMake(ux, uy) : 만들기
/// @discussion MGRUpxEqualToUpx(upx1, upx2) : 동일한지 여부
/// @discussion MGRUpxIsEmpty(upx) : (0, 0)인지 여부
/// @discussion MGRUpxIsNull(upx) : (NSUIntegerMax, NSUIntegerMax)인지 여부
struct MGRUpx {
    NSUInteger ux;
    NSUInteger uy;
};
typedef struct __attribute__((objc_boxable)) MGRUpx MGRUpx;
static MGRUpx const MGRUpxZero = {0,};
static MGRUpx const MGRUpxNull = {NSUIntegerMax, NSUIntegerMax};
static inline MGRUpx MGRUpxMake(NSUInteger ux, NSUInteger uy) {MGRUpx upx = {ux, uy}; return upx;}
bool MGRUpxEqualToUpx(MGRUpx upx1, MGRUpx upx2);
bool MGRUpxIsEmpty(MGRUpx upx);
bool MGRUpxIsNull(MGRUpx upx);
@interface NSValue (MGRUpx)
+ (instancetype)valueWithMGRUpx:(MGRUpx)cStruct;
- (MGRUpx)MGRUpxValue;
@end

#endif /* MGRStructType_h */
