//  UICollectionViewDiffableDataSource+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-27
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewDiffableDataSource<SectionIdentifierType,ItemIdentifierType> (Extension)

// iOS 15 미만에서 사용하기 위해
- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot;
- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot completion:(void(^ _Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-07-27 : 최초 작성
 */
