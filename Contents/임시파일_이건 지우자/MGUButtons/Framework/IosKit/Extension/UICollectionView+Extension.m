//
//  UICollectionView+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UICollectionView+Extension.h"

@implementation UICollectionView (Extension)

- (NSArray <NSIndexPath *>* _Nullable)mgrOrderedIndexPathsForVisibleItems {
    NSArray <NSIndexPath *>*indexPathsForVisibleItems = [self indexPathsForVisibleItems];
    if (indexPathsForVisibleItems == nil || indexPathsForVisibleItems.count < 1) {
        return nil;
    }
    return [indexPathsForVisibleItems sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray <NSIndexPath *>* _Nullable)mgrOrderedIndexPathsForFullVisibleItems {
    NSMutableArray <NSIndexPath *>*returnCells = [NSMutableArray array];
    for (UICollectionViewCell *cell in self.visibleCells) {
        CGRect cellRect = [self convertRect:cell.frame toView:self.superview];
        if (CGRectContainsRect(self.frame, cellRect) == YES) {
            [returnCells addObject:[self indexPathForCell:cell]];
        }
    }
    if (returnCells == nil || returnCells.count < 1) {
        return nil;
    }
    return [returnCells sortedArrayUsingSelector:@selector(compare:)];
}

@end
