//
//  MGAToolbarItemStyleViewController.m
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/05/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGAToolbarItemStyleViewController.h"
#import "MGAPreferencePane.h"
#import "MGAPreferencesStyleInterface.h"

@implementation MGAToolbarItemStyleViewController

- (instancetype)initWithPreferencePanes:(NSArray <NSViewController <MGAPreferencePane>*>*)preferencePanes
                                toolbar:(NSToolbar *)toolbar
                     centerToolbarItems:(BOOL)centerToolbarItems {
    self = [super init];
    if (self) {
        self.preferencePanes = preferencePanes.mutableCopy;
        self.toolbar = toolbar;
        self.centerToolbarItems = centerToolbarItems;
    }
    return self;
}


#pragma mark - <MGAPreferencesStyleController>
- (NSArray <NSToolbarItemIdentifier>*)toolbarItemIdentifiers {
    NSMutableArray <NSToolbarItemIdentifier>*toolbarItemIdentifiers = [NSMutableArray array];
    
    if (self.centerToolbarItems == YES) {
        [toolbarItemIdentifiers addObject:NSToolbarFlexibleSpaceItemIdentifier];
    }

    for (NSViewController <MGAPreferencePane>*preferencePane in self.preferencePanes) {
        [toolbarItemIdentifiers addObject:preferencePane.preferencePaneIdentifier];
    }

    if (self.centerToolbarItems == YES) {
        [toolbarItemIdentifiers addObject:NSToolbarFlexibleSpaceItemIdentifier];
    }

    return toolbarItemIdentifiers.copy;
}

- (NSToolbarItem *)toolbarItemPreferenceIdentifier:(NSToolbarItemIdentifier)preferenceIdentifier {
    __block NSViewController <MGAPreferencePane>*preference;
    [self.preferencePanes enumerateObjectsUsingBlock:^(NSViewController <MGAPreferencePane>*vc, NSUInteger idx, BOOL *stop) {
        if ([vc.preferencePaneIdentifier isEqualToString:preferenceIdentifier] == YES) {
            preference = vc;
            *stop = YES;
        }
    }];
    if (preference == nil) {
        NSCAssert(FALSE, @"preferenceIdentifier 해당하는 NSViewController가 없다.");
    }
    
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:preferenceIdentifier];
    toolbarItem.label = preference.preferencePaneTitle;
    toolbarItem.image = preference.toolbarItemIcon;
    toolbarItem.target = self;
    toolbarItem.action = @selector(toolbarItemSelected:);
    return toolbarItem;
}

- (void)selectTabIndex:(NSInteger)index {
    self.toolbar.selectedItemIdentifier = self.preferencePanes[index].preferencePaneIdentifier;
}

- (BOOL)isKeepingWindowCentered {
    return self.centerToolbarItems;
}


#pragma mark - Action
- (void)toolbarItemSelected:(NSToolbarItem *)toolbarItem {
    [self.delegate activateTabPreferenceIdentifier:toolbarItem.itemIdentifier animated:YES];
}

@end
