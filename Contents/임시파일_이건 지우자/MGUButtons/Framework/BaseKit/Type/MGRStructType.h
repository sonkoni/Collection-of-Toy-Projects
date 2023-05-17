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
