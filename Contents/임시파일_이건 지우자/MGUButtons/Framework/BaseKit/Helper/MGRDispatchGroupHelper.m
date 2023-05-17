//
//  MGRDispatchGroupHelper.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGRDispatchGroupHelper.h"

#if DEBUG
NSInteger MGRDispatchGroupGetEnterCount(dispatch_group_t dispatchGroup) {
    NSString *description = [dispatchGroup debugDescription];
    NSArray <NSString *>*strArr = [description componentsSeparatedByString:@","];
    __block NSString *countStr = @"";
    [strArr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        if ([str containsString:@"count"] == YES) {
            countStr = str;
            *stop = YES;
        }
    }];
    NSArray<NSString *> *result = [countStr componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *finalStr = [result componentsJoinedByString:@""];
    return [finalStr integerValue];
}

void MGRDispatchGroupSafeLeave(dispatch_group_t dispatchGroup) {
    NSInteger enterCount = MGRDispatchGroupGetEnterCount(dispatchGroup);
    if (enterCount > 0) { // 0 일때, dispatch_group_leave 함수를 사용하면 터진다.
        dispatch_group_leave(dispatchGroup);
    }
}
#endif /* DEBUG */
