//
//  NSMapTable+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSMapTable+Extension.h"

@implementation NSMapTable (Subscripting)
- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key {
    if (obj) {
        [self setObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}
@end
