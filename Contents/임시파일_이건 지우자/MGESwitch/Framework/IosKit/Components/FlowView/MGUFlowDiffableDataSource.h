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


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
