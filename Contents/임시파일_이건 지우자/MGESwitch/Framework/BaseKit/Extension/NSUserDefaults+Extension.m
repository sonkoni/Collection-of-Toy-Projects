//
//  NSUserDefaults+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)

- (void)mgrRemoveAllUserDefaults {
    NSDictionary <NSString *,id>*dict = [self dictionaryRepresentation];
    NSArray <NSString *>*allKeys = dict.allKeys;
    for (NSString *key in allKeys) {
        [self removeObjectForKey:key];
    }
    [self synchronize];
}

- (void)mgrRemoveUserDefaultsForKeys:(NSArray <NSString *>*)keys {
    for (NSString *key in keys) {
        [self removeObjectForKey:key];
    }
    [self synchronize];
}

@end
