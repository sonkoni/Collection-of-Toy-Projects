//
//  MGUFlowDiffableDataSource.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUFlowView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NS_ENUM MGUFlowVolumeType
/*!
 @enum       MGUFlowVolumeType
 @abstract   무한, 유한, 유한Wrap 의 종류를 설명한다.
 @constant   MGUFlowVolumeTypeFinite     유한개 Wrap은 없다.
 @constant   MGUFlowVolumeTypeInfinite   무한개
 @constant   MGUFlowVolumeTypeFiniteWrap 유한개 Wrap이 있다.
 */
typedef NS_ENUM(NSInteger, MGUFlowVolumeType) {
    MGUFlowVolumeTypeFinite = 0,
    MGUFlowVolumeTypeInfinite,
    MGUFlowVolumeTypeFiniteWrap
};

@interface MGUFlowDiffableDataSource<__covariant SectionIdentifierType, __covariant ItemIdentifierType> : UICollectionViewDiffableDataSource <SectionIdentifierType, ItemIdentifierType>

@property (nonatomic, assign) MGUFlowVolumeType volumeType;

- (instancetype)initWithFlowView:(MGUFlowView *)flowView
                    cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray <NSString *> *elementOfKinds;
@property (nonatomic, weak) NSDiffableDataSourceSnapshot *tempSnapshot;
// coreData sync를 통해서 다른 기계를 알림을 받아 <NSFetchedResultsControllerDelegate>의
// - controller:didChangeContentWithSnapshot:이 호출될 때, MGUFlowLayout의
// - prepareLayout 메서드 내부에서 self.collectionView.dataSource.snapshot으로 접근해
// snapshot.numberOfSections, snapshot.numberOfItems를 가져올 때 이전 스냅샷을 가져오는 경우가 발생함
// 따라서 - applySnapshot:animatingDifferences:completion:, - applySnapshotUsingReloadData:completion:
// 메서드를 치면 tempSnapshot(weak)를 저장해 갯수 계산을 하는데 정확할 수 있게 했다.


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
