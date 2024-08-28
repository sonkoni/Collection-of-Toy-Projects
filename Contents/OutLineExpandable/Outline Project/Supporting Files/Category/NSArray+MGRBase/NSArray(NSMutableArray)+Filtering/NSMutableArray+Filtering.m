//
//  NSMutableArray+MGRFiltering.m
//  SampleBufferPlayer
//
//  Created by Kwan Hyun Son on 2020/06/29.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "NSMutableArray+Filtering.h"

@implementation NSMutableArray (Filtering)

- (id)mgrRemovedObjectAtIndex:(NSUInteger)index {
    NSAssert(index < self.count, @"인덱스 넘친다");
    id object = self[index];
    [self removeObjectAtIndex:index];
    return object;
}

@end
