//
//  NSArray+DragDrop.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSArray+DragDrop.h"
#import "NSArray+Etc.h"

@implementation NSMutableArray (DragDrop)

- (void)mgrDragFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex < 0 || fromIndex >= self.count) {
        return;
    }
    if (toIndex < 0 || toIndex > self.count) {
        return;
    }
    if (fromIndex == toIndex) {
        return;
    }
    NSUInteger targetIndex = (fromIndex < toIndex) ? toIndex - 1 : toIndex;
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:targetIndex];
}

- (void)mgrDragFromIndexes:(NSIndexSet *)fromIndexes toIndex:(NSUInteger)toIndex {
    NSArray *movingData = [self objectsAtIndexes:fromIndexes];
    __block NSUInteger count = 0;
    [fromIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < toIndex) {
            count = count + 1;
        }
    }];
    NSUInteger targetIndex = toIndex - count;
    [self removeObjectsAtIndexes:fromIndexes];
    [self mgrInsertObjects:movingData atIndex:targetIndex];
}

@end
