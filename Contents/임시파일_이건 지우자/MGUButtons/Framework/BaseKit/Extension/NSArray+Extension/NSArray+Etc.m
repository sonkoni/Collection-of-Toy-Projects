//
//  NSArray+Etc.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
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

- (BOOL)mgrIsGenericsClass:(Class)classObject {
    if (self.count < 1) {
        return YES;
    }
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:classObject] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

@end

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
