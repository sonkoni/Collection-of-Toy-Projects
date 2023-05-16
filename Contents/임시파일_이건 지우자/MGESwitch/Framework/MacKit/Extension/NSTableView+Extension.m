//
//  NSTableView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSTableView+Extension.h"
#import <BaseKit/BaseKit.h>

@implementation NSTableView (Extension)

- (NSEdgeInsets)mgrContentInset {
    NSScrollView *scrollView = self.enclosingScrollView;
    if (scrollView == nil) {
        NSCAssert(FALSE, @"enclosingScrollView 가 nil 이다.");
    }
    
    return scrollView.contentView.contentInsets;
}

- (void)setMgrContentInset:(NSEdgeInsets)contentInset {
    NSScrollView *scrollView = self.enclosingScrollView;
    if (scrollView == nil) {
        NSCAssert(FALSE, @"enclosingScrollView 가 nil 이다.");
    }
#if DEBUG
    printf("DEBUG : automaticallyAdjustsContentInsets = NO 설정한다. \n");
#endif
    scrollView.contentView.automaticallyAdjustsContentInsets = NO;
    scrollView.contentView.contentInsets = contentInset;
}

- (nullable __kindof NSTableCellView *)mgrCellForRow:(NSInteger)row column:(NSInteger)column {
    return [self viewAtColumn:column row:row makeIfNecessary:NO];
}


#pragma mark - Select & Deselect
- (void)mgrSelectRow:(NSInteger)row animated:(BOOL)animated {
    if ([self isRowSelected:row] == YES) {
        return;
    }
    [self mgrSelectRowAtIndexes:[NSIndexSet indexSetWithIndex:row] animated:animated];
}
- (void)mgrSelectRowAtIndexes:(NSIndexSet *)indexSet animated:(BOOL)animated {
    if (self.allowsMultipleSelection == NO) {
        if (animated == YES) {
            [self.animator selectRowIndexes:indexSet byExtendingSelection:NO];
        } else {
            [self selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    } else {
        NSIndexSet *selectedRowIndexes = self.selectedRowIndexes;
        NSIndexSet *unionIndexSet = [NSIndexSet mgrUnionIndexSet:selectedRowIndexes indexSet2:indexSet];
        if (selectedRowIndexes.count == unionIndexSet.count) {
            return; // 더할 것이 없다면 나가라.
        }
        if (animated == YES) {
            [self.animator selectRowIndexes:unionIndexSet byExtendingSelection:NO];
        } else {
            [self selectRowIndexes:unionIndexSet byExtendingSelection:NO];
        }
    }
}
- (void)mgrSelectAllRowAnimated:(BOOL)animated {
    if (animated == YES) {
        [self.animator selectRowIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfRows-1)]
                   byExtendingSelection:NO];
    } else {
        [self selectAll:nil];
    }
}

// Deselect 메서드 자체가 애니메이션이 안된다. - selectRowIndexes:byExtendingSelection: 이용해야함.
- (void)mgrDeselectRowAtIndexes:(NSIndexSet *)indexSet animated:(BOOL)animated {
    if (self.selectedRow == -1) { return; } // 선택된게 없으면 나가라.
    NSIndexSet *selectedRowIndexes = self.selectedRowIndexes;
    NSIndexSet *intersection = [NSIndexSet mgrDifferenceIndexSet:selectedRowIndexes indexSet2:indexSet];
    if (selectedRowIndexes.count == intersection.count) {
        return; // 제외할 것이 없다면 나가라.
    }
    if (animated == YES) {
        [self.animator selectRowIndexes:intersection byExtendingSelection:NO];
    } else {
        [self selectRowIndexes:intersection byExtendingSelection:NO];
    }
}
- (void)mgrDeselectRow:(NSInteger)row animated:(BOOL)animated {
    if ([self isRowSelected:row] == NO) {
        return;
    }
    if (animated == NO) {
        [self deselectRow:row];
    } else {
        [self mgrDeselectRowAtIndexes:[NSIndexSet indexSetWithIndex:row] animated:YES];
    }
}
- (void)mgrDeselectAllRowAnimated:(BOOL)animated {
    if (self.selectedRow == -1) { return; } // 선택된게 없으면 나가라.
    if (animated == YES) {
        [self.animator selectRowIndexes:[NSIndexSet indexSet] byExtendingSelection:NO];
    } else {
        [self deselectAll:nil];
    }
}

@end
