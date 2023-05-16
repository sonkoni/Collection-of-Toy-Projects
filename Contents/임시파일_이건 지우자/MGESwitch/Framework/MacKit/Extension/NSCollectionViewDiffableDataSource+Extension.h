//
//  NSCollectionViewDiffableDataSource+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCollectionViewDiffableDataSource<SectionIdentifierType,ItemIdentifierType> (Extension)

/** 애플이 실수로 공개를 안했다.
*  - (void)applySnapshot:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot
*   animatingDifferences:(BOOL)animatingDifferences
*             completion:(void(^ _Nullable)(void))completion;
*/
 - (void)mgrApplySnapshot:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot
  animatingDifferences:(BOOL)animatingDifferences
            completion:(void(^ _Nullable)(void))completion;

// macOS에는 iOS에 해당하는 메서드가 없다.
// 특이하게 - applySnapshot:animatingDifferences: 의 두 번째 인자에 NO를 넣으면 reloadData 하는 성질을 가지고 있다.
// iOS는 전혀 그렇지 않다. 일관성을 맞추기 위해 이렇게 만들자. identifier가 동일 할때도 다시 그리는 메서드이다.
- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot;
- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot<SectionIdentifierType,ItemIdentifierType>*)snapshot completion:(void(^ _Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-07-27 : 최초 작성
 */
