//
//  NSToolbar+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSToolbar+Extension.h"

@implementation NSToolbar (Extension)

- (void)mgrAddItemWithItemIdentifier:(NSToolbarIdentifier)identifier {
    NSInteger index = self.items.count;
    [self insertItemWithItemIdentifier:identifier atIndex:index];
}

- (void)mgrRemoveItemForIdentifier:(NSToolbarIdentifier)identifier {
    __weak __typeof(self) weakSelf = self;
    [self.items enumerateObjectsUsingBlock:^(NSToolbarItem *item, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:item.itemIdentifier] == YES) {
            [weakSelf removeItemAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (void)mgrRemoveAllItemsForIdentifier:(NSToolbarIdentifier)identifier {
    __weak __typeof(self) weakSelf = self;
    __block NSMutableArray <NSNumber *>*indexes = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(NSToolbarItem *item, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:item.itemIdentifier] == YES) {
            [indexes addObject:@(idx)];
        }
    }];
    
    [indexes enumerateObjectsWithOptions:NSEnumerationReverse
                              usingBlock:^(NSNumber *indexNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger deleteIndex = [indexNumber integerValue];
        [weakSelf removeItemAtIndex:deleteIndex];
    }];
}

- (BOOL)mgrHasCurrentItemIdentifier:(NSToolbarIdentifier)identifier {
    __block BOOL result = NO;
    [self.items enumerateObjectsUsingBlock:^(NSToolbarItem *item, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:item.itemIdentifier] == YES) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
@end
