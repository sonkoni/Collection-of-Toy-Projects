//
//  NSToolbar+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSToolbar+Extension.h"

@implementation NSToolbar (Extension)

- (void)mgrAddItemWithItemIdentifier:(NSToolbarItemIdentifier)identifier {
    NSInteger index = self.items.count;
    [self insertItemWithItemIdentifier:identifier atIndex:index];
}

- (void)mgrRemoveItemForIdentifier:(NSToolbarItemIdentifier)identifier {
    __weak __typeof(self) weakSelf = self;
    [self.items enumerateObjectsUsingBlock:^(NSToolbarItem *item, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:item.itemIdentifier] == YES) {
            [weakSelf removeItemAtIndex:idx];
            *stop = YES;
        }
    }];
}

- (void)mgrRemoveAllItemsForIdentifier:(NSToolbarItemIdentifier)identifier {
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

- (BOOL)mgrHasCurrentItemIdentifier:(NSToolbarItemIdentifier)identifier {
    __block BOOL result = NO;
    [self.items enumerateObjectsUsingBlock:^(NSToolbarItem *item, NSUInteger idx, BOOL *stop) {
        if ([identifier isEqualToString:item.itemIdentifier] == YES) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)mgrRemoveItemsForIdentifierRange:(NSRange)range {
    if (self.items.count < 1 || range.length < 1 || range.location > (self.items.count - 1)) {
        return; // 뺄 수 있는 영역이 없다.
    }
    
    NSInteger firstRemoveIndex = range.location;
    NSInteger lastRemoveIndex = range.location + (range.length - 1);
    lastRemoveIndex = MIN(lastRemoveIndex, self.items.count - 1);
    
    for (NSInteger i = lastRemoveIndex; i >= firstRemoveIndex; i--) {
        [self removeItemAtIndex:i];
    }
}

- (void)mgrInsertItemsWithItemIdentifiers:(NSArray <NSToolbarItemIdentifier>*)identifiers atIndex:(NSInteger)index {
    if (identifiers == nil) {
        return;
    }
    index = MIN(index, self.items.count);
    for (NSInteger i = 0; i < identifiers.count; i++) {
        NSToolbarItemIdentifier toolbarItemIdentifier = identifiers[i];
        NSUInteger targetIndex = index + i;
        [self insertItemWithItemIdentifier:toolbarItemIdentifier atIndex:targetIndex];
    }
}
@end
