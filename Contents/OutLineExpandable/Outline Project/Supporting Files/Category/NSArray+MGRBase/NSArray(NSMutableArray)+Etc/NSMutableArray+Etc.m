//
//  NSMutableArray+Etc.m
//  TESTA
//
//  Created by Kwan Hyun Son on 2021/08/25.
//

#import "NSMutableArray+Etc.h"

@implementation NSMutableArray (Etc)

- (void)mgrInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSInteger objectsCount = objects.count;
    NSInteger selfCount = self.count;
    
    if (objectsCount < 1) {
        return;
    }
    
    if (selfCount < 1 || selfCount <= index) {
        [self addObjectsFromArray:objects];
    } else {
        for (NSInteger i = 0; i < objectsCount; i++) {
            id object = objects[i];
            [self insertObject:object atIndex:index + i];
        }
    }
}

@end
