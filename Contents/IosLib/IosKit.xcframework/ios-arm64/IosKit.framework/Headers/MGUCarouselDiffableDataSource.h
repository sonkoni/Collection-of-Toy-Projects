//
//  MGUCarouselDiffableDataSource.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUCarouselView;

NS_ASSUME_NONNULL_BEGIN
#pragma mark - NS_ENUM MGUCarouselVolumeType
/*!
 @enum       MGUCarouselVolumeType
 @abstract   무한, 유한, 유한Wrap 의 종류를 설명한다.
 @constant   MGUCarouselVolumeTypeFinite     유한개 Wrap은 없다.
 @constant   MGUCarouselVolumeTypeInfinite   무한개 : 최소 3 이상의 홀수의 섹션 && 전체 컨텐츠의 길이가 collection view 의 6배가 정도가 되도록 설계하자.
 @constant   MGUCarouselVolumeTypeFiniteWrap 유한개 Wrap이 있다.
 */
typedef NS_ENUM(NSInteger, MGUCarouselVolumeType) {
    MGUCarouselVolumeTypeFinite = 0,
    MGUCarouselVolumeTypeInfinite,
    MGUCarouselVolumeTypeFiniteWrap
};

@interface MGUCarouselDiffableDataSource<__covariant SectionIdentifierType, __covariant ItemIdentifierType> : UICollectionViewDiffableDataSource <SectionIdentifierType, ItemIdentifierType>

@property (nonatomic, assign) MGUCarouselVolumeType volumeType;

- (instancetype)initWithCarouselView:(MGUCarouselView *)flowView
                        cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray <NSString *> *elementOfKinds;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

