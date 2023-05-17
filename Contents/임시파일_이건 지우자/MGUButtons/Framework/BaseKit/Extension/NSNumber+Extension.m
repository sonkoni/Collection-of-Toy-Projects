//
//  NSNumber+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Checking)
- (MGRNumberType)mgrType {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)self);
    MGRNumberType type = 0;
    switch (numberType) {
        case kCFNumberCharType:
            type = MGRNumberBool;
            break;
        case kCFNumberSInt8Type:
        case kCFNumberSInt16Type:
        case kCFNumberSInt32Type:
        case kCFNumberSInt64Type:
        case kCFNumberShortType:
        case kCFNumberIntType:
        case kCFNumberLongType:
        case kCFNumberLongLongType:
        case kCFNumberCFIndexType:
        case kCFNumberNSIntegerType:
            type = MGRNumberInt;
            break;
        case kCFNumberFloat32Type:
        case kCFNumberFloat64Type:
        case kCFNumberFloatType:
        case kCFNumberDoubleType:
        case kCFNumberCGFloatType:
            type = MGRNumberFloat;
        default:
            NSCAssert(NO, @"Unknown Type");
            break;
    }
    return type;
    /*
    if (numberType == kCFNumberCharType) {
        type = MGRNumberBool;
    } else if (numberType == kCFNumberSInt8Type   || numberType == kCFNumberSInt16Type   ||
               numberType == kCFNumberSInt32Type  || numberType == kCFNumberSInt64Type   ||
               numberType == kCFNumberShortType   || numberType == kCFNumberIntType      ||
               numberType == kCFNumberLongType    || numberType == kCFNumberLongLongType ||
               numberType == kCFNumberCFIndexType || numberType == kCFNumberNSIntegerType) {
        type = MGRNumberInt;
    } else if (numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type ||
               numberType == kCFNumberFloatType   || numberType == kCFNumberDoubleType  ||
               numberType == kCFNumberCGFloatType ) {
        type = MGRNumberFloat;
    }
    return type;
     */
}
@end

// ----------------------------------------------------------------------

@implementation NSNumber (General)
- (NSUInteger)mgrCountValue {
    return [self unsignedIntegerValue];
}
- (NSUInteger)mgrIndexValue {
    return [self unsignedIntegerValue];
}
- (NSUInteger)mgrBytesValue {
    return [self unsignedIntegerValue];
}
- (NSInteger)mgrTagValue {
    return [self integerValue];
}
@end
