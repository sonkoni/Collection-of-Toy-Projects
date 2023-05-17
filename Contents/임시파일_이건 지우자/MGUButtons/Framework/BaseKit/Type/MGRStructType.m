//
//  MGRStructType.m
//  Copyright © 2022 mulgrim. All rights reserved.
//

#import "MGRStructType.h"

// MGRIpx ----------------------------------------------------------------------
bool MGRIpxEqualToIpx(MGRIpx ipx1, MGRIpx ipx2) {
    return ((ipx1.ix == ipx2.ix) && (ipx1.iy == ipx2.iy));
}
bool MGRIpxIsEmpty(MGRIpx ipx) {
    return (!ipx.ix && !ipx.iy);
}
bool MGRIpxIsNull(MGRIpx ipx) {
    return ((ipx.ix == NSIntegerMax) && (ipx.iy == NSIntegerMax));
}
@implementation NSValue (MGRIpx)
+ (instancetype)valueWithMGRIpx:(MGRIpx)cStruct {
    return [NSValue value:&cStruct withObjCType:@encode(MGRIpx)];
}
- (MGRIpx)MGRIpxValue {
    NSCAssert(strcmp([self objCType], @encode(MGRIpx)) == 0, @"Type Error");
    MGRIpx decodedStruct;
    [self getValue:&decodedStruct size:sizeof(MGRIpx)];
    return decodedStruct;
}
@end


// MGRUpx ----------------------------------------------------------------------
bool MGRUpxEqualToUpx(MGRUpx upx1, MGRUpx upx2) {
    return ((upx1.ux == upx2.ux) && (upx1.uy == upx2.uy));
}
bool MGRUpxIsEmpty(MGRUpx upx) {
    return (!upx.ux && !upx.uy);
}
bool MGRUpxIsNull(MGRUpx upx) {
    return ((upx.ux == NSUIntegerMax) && (upx.uy == NSUIntegerMax));
}
@implementation NSValue (MGRUpx)
+ (instancetype)valueWithMGRUpx:(MGRUpx)cStruct {
    return [NSValue value:&cStruct withObjCType:@encode(MGRUpx)];
}
- (MGRUpx)MGRUpxValue {
    NSCAssert(strcmp([self objCType], @encode(MGRUpx)) == 0, @"Type Error");
    MGRUpx decodedStruct;
    [self getValue:&decodedStruct size:sizeof(MGRUpx)];
    return decodedStruct;
}
@end
