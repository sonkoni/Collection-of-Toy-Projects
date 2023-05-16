//
//  NSCollectionViewDiffableDataSource+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSCollectionViewDiffableDataSource+Extension.h"

@implementation NSCollectionViewDiffableDataSource (Extension)

- (void)mgrApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
    animatingDifferences:(BOOL)animatingDifferences
              completion:(void(^)(void))completion {
    SEL aSelector = @selector(applySnapshot:animatingDifferences:completion:);
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aSelector;
    [invocation setArgument:&snapshot atIndex:2];
    [invocation setArgument:&animatingDifferences atIndex:3];
    [invocation setArgument:&completion atIndex:4];
    [invocation invoke];
}

- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot*)snapshot {
    [self mgrApplySnapshotUsingReloadData:snapshot completion:nil];
    //
    // iOS에서는 이렇게 하지만, mac은 animated NO이면 reload 이다.
    // [snapshot reloadSectionsWithIdentifiers:snapshot.sectionIdentifiers];
    // [self applySnapshot:snapshot animatingDifferences:NO];
}

- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot*)snapshot completion:(void(^)(void))completion {
    [self mgrApplySnapshot:snapshot animatingDifferences:NO completion:completion];
}

@end
