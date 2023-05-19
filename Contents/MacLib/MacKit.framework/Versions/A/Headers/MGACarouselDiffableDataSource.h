//
//  MGACarouselDiffableDataSource.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>
@class MGACarouselView;

NS_ASSUME_NONNULL_BEGIN
#pragma mark - NS_ENUM MGUCarouselVolumeType
/*!
 @enum       MGACarouselVolumeType
 @abstract   무한, 유한, 유한Wrap 의 종류를 설명한다.
 @constant   MGACarouselVolumeTypeFinite     유한개 Wrap은 없다.
 @constant   MGACarouselVolumeTypeInfinite   무한개 : 최소 3 이상의 홀수의 섹션 && 전체 컨텐츠의 길이가 collection view 의 6배가 정도가 되도록 설계하자.
 @constant   MGACarouselVolumeTypeFiniteWrap 유한개 Wrap이 있다.
 */
typedef NS_ENUM(NSInteger, MGACarouselVolumeType) {
    MGACarouselVolumeTypeFinite = 0,
    MGACarouselVolumeTypeInfinite,
    MGACarouselVolumeTypeFiniteWrap
};

@interface MGACarouselDiffableDataSource<__covariant SectionIdentifierType, __covariant ItemIdentifierType> : NSCollectionViewDiffableDataSource <SectionIdentifierType, ItemIdentifierType>

@property (nonatomic, assign) MGACarouselVolumeType volumeType;

- (instancetype)initWithCarouselView:(MGACarouselView *)flowView
                        itemProvider:(NSCollectionViewDiffableDataSourceItemProvider)itemProvider NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) NSArray <NSString *>*elementOfKinds;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView
                          itemProvider:(NSCollectionViewDiffableDataSourceItemProvider)itemProvider NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

