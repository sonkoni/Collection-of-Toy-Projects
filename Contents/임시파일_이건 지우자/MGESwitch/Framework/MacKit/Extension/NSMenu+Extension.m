//
//  NSMenu+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSMenu+Extension.h"

@implementation NSMenu (Extension)

- (void)mgrReplaceMenuItemWithMenu:(NSMenu *)menu {
    NSArray <NSMenuItem *>*itemArray = [[NSArray alloc] initWithArray:menu.itemArray copyItems:YES];
    [self removeAllItems];
    self.itemArray = itemArray;
    self.title = menu.title;
    self.minimumWidth = menu.minimumWidth;
    self.font = menu.font;
    self.userInterfaceLayoutDirection = menu.userInterfaceLayoutDirection;
    self.allowsContextMenuPlugIns = menu.allowsContextMenuPlugIns;
    self.autoenablesItems = menu.autoenablesItems;
    self.showsStateColumn = menu.showsStateColumn;
    self.delegate = menu.delegate;
}

@end
