//
//  NSDictionary+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

+ (NSDictionary <id, NSArray *>*)mgrDictionaryWithGroupingValues:(NSArray *)values
                                                   byKeyForValue:(id _Nonnull (^)(id _Nonnull))byKeyForValue {
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id key = byKeyForValue(obj);
        if ([dic.allKeys containsObject:key] == NO) {
            dic[key] = @[obj].mutableCopy;
        } else {
            NSMutableArray *mArr = dic[key];
            [mArr addObject:obj];
        }
    }];
    return dic;
}

@end
