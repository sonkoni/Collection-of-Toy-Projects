//
//  NSArray+MGRSorting.m
//  arrayTEST
//
//  Created by Kwan Hyun Son on 26/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSArray+Etc.h"

@implementation NSArray (Etc)

+ (NSArray *)mgrRepeating:(id)object count:(NSInteger)count {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        [mArr addObject:object];
    }
    
    return mArr.copy;
}

@end
