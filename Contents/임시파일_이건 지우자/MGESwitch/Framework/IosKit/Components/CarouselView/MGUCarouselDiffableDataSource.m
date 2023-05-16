//
//  MGUCarouselDiffableDataSource.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselDiffableDataSource.h"
#import "MGUCarouselView.h"
#import "MGUCarouselView_Internal.h"

@interface MGUCarouselDiffableDataSource ()
@property (nonatomic, strong) MGUCarouselView *carouselView;
@end

@implementation MGUCarouselDiffableDataSource

- (void)setSupplementaryViewProvider:(UICollectionViewDiffableDataSourceSupplementaryViewProvider)supplementaryViewProvider {
    if (supplementaryViewProvider == nil) {
        [super setSupplementaryViewProvider:supplementaryViewProvider];
        return;
    }
    UICollectionViewDiffableDataSourceSupplementaryViewProvider newProvider = ^UICollectionReusableView *(UICollectionView * collectionView, NSString * elementKind, NSIndexPath *indexPath) {
        UICollectionReusableView *reusableView = supplementaryViewProvider(collectionView, elementKind, indexPath);
        
        if (reusableView != nil) {
            reusableView.userInteractionEnabled = NO;
            if ([elementKind isEqualToString:UICollectionElementKindSectionHeader] || [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                if (self.carouselView.volumeType == MGUCarouselVolumeTypeFiniteWrap) {
                    reusableView.hidden = NO;
                } else {
                    reusableView.hidden = YES;
                }
            }
        }
        
        return reusableView;
    };
    
    [super setSupplementaryViewProvider:newProvider];
    
}

- (void)applySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
 animatingDifferences:(BOOL)animatingDifferences
           completion:(void (^)(void))completion {
    self.carouselView.volumeType = self.volumeType;
    MGUCarouselLayout *carouselLayout = (MGUCarouselLayout *)(self.carouselView.collectionView.collectionViewLayout);
    carouselLayout.needsReprepare = YES;
    __weak __typeof(self) weakSelf = self;
    void (^newCompletionBlock)(void) = ^{
        if (completion != nil) {
            completion();
        }
        [weakSelf.carouselView updateCurrentIndex];
    };
    if (animatingDifferences == NO) {
//    [UIView performWithoutAnimation:^{
        [super applySnapshot:snapshot animatingDifferences:animatingDifferences completion:newCompletionBlock];
//     }];
    } else {
        // https://stackoverflow.com/questions/40336463/uicollectionview-custom-flow-layout-delete-cell
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.0
                                                              delay:0.0
                                                            options:UIViewAnimationOptionCurveLinear
                                                         animations:^{
            [super applySnapshot:snapshot animatingDifferences:animatingDifferences completion:newCompletionBlock];
        } completion:^(UIViewAnimatingPosition finalPosition) {}];
    }
}

- (void)applySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot *)snapshot
                          completion:(void (^)(void))completion {
    self.carouselView.volumeType = self.volumeType;
    MGUCarouselLayout *carouselLayout = (MGUCarouselLayout *)(self.carouselView.collectionView.collectionViewLayout);
    carouselLayout.needsReprepare = YES;
    __weak __typeof(self) weakSelf = self;
    void (^newCompletionBlock)(void) = ^{
        if (completion != nil) {
            completion();
        }
        [weakSelf.carouselView updateCurrentIndex];
    };
    
    [super applySnapshotUsingReloadData:snapshot completion:newCompletionBlock];
    
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithCarouselView:(MGUCarouselView *)carouselView
                        cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider {
    if ([carouselView isKindOfClass:[MGUCarouselView class]] == NO) {
        NSCAssert(FALSE, @"MGUCarouselView 클래스를 넣어라.");
    }
    self = [super initWithCollectionView:carouselView.collectionView cellProvider:cellProvider];
    if (self) {
        _carouselView = carouselView;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGUCarouselDiffableDataSource *self) {
    self->_volumeType = MGUCarouselVolumeTypeFinite;
}



#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          cellProvider:(UICollectionViewDiffableDataSourceCellProvider)cellProvider { NSCAssert(FALSE, @"- initWithCollectionView:cellProvider: 사용금지."); return nil; }

@end
