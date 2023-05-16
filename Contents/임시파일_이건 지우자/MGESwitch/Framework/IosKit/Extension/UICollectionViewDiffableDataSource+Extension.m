//
//  UICollectionViewDiffableDataSource+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "UICollectionViewDiffableDataSource+Extension.h"

@implementation UICollectionViewDiffableDataSource (Extension)

- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot*)snapshot {
    [self mgrApplySnapshotUsingReloadData:snapshot completion:nil];
}
- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot*)snapshot completion:(void(^)(void))completion {
    [snapshot reloadSectionsWithIdentifiers:snapshot.sectionIdentifiers];
    [self applySnapshot:snapshot animatingDifferences:NO completion:completion];
}

@end
