//
//  MGACarouselDiffableDataSource.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGACarouselDiffableDataSource.h"
#import "MGACarouselView.h"
#import "MGACarouselView_Internal.h"
#import "NSCollectionViewDiffableDataSource+Extension.h"

@interface MGACarouselDiffableDataSource ()
@property (nonatomic, strong) MGACarouselView *carouselView;
@end

@implementation MGACarouselDiffableDataSource

- (void)setSupplementaryViewProvider:(NSCollectionViewDiffableDataSourceSupplementaryViewProvider)supplementaryViewProvider {
    
    if (supplementaryViewProvider == nil) {
        [super setSupplementaryViewProvider:supplementaryViewProvider];
        return;
    }
    
    NSCollectionViewDiffableDataSourceSupplementaryViewProvider newProvider = ^NSView *(NSCollectionView * collectionView, NSString * elementKind, NSIndexPath *indexPath) {
        
        NSView *reusableView = supplementaryViewProvider(collectionView, elementKind, indexPath);
        
        if (reusableView != nil) {
            //! reusableView.userInteractionEnabled = NO;
            if ([elementKind isEqualToString:NSCollectionElementKindSectionHeader] || [elementKind isEqualToString:NSCollectionElementKindSectionFooter]) {
                if (self.carouselView.volumeType == MGACarouselVolumeTypeFiniteWrap) {
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
 animatingDifferences:(BOOL)animatingDifferences {
    [self mgrApplySnapshot:snapshot animatingDifferences:animatingDifferences completion:nil];
}

- (void)mgrApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
    animatingDifferences:(BOOL)animatingDifferences
              completion:(void (^)(void))completion {
    self.carouselView.volumeType = self.volumeType;
    MGACarouselLayout *carouselLayout =
        (MGACarouselLayout *)(self.carouselView.collectionView.collectionViewLayout);
    carouselLayout.needsReprepare = YES;
    __weak __typeof(self) weakSelf = self;
    void (^newCompletionBlock)(void) = ^{
        if (completion != nil) {
            completion();
        }
        [weakSelf.carouselView updateCurrentIndex];
    };
    if (animatingDifferences == NO) {
        [super mgrApplySnapshot:snapshot animatingDifferences:NO completion:newCompletionBlock];
    } else {
        // https://stackoverflow.com/questions/40336463/uicollectionview-custom-flow-layout-delete-cell
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            // context.duration = 0.2; // 0.0으로 해서는 안된다. 아예 안써도 된다.
            context.allowsImplicitAnimation = YES;
            [super mgrApplySnapshot:snapshot animatingDifferences:YES completion:newCompletionBlock];
        } completionHandler:^{}];
    }
}


- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot *)snapshot {
    [self mgrApplySnapshotUsingReloadData:snapshot completion:nil];
}

- (void)mgrApplySnapshotUsingReloadData:(NSDiffableDataSourceSnapshot *)snapshot
                            completion:(void (^)(void))completion {
    self.carouselView.volumeType = self.volumeType;
    MGACarouselLayout *carouselLayout = (MGACarouselLayout *)(self.carouselView.collectionView.collectionViewLayout);
    carouselLayout.needsReprepare = YES;
    __weak __typeof(self) weakSelf = self;
    void (^newCompletionBlock)(void) = ^{
        if (completion != nil) {
            completion();
        }
        [weakSelf.carouselView updateCurrentIndex];
    };
    [super mgrApplySnapshotUsingReloadData:snapshot completion:newCompletionBlock];
}


#pragma mark - 생성 & 소멸
- (instancetype)initWithCarouselView:(MGACarouselView *)carouselView
                        itemProvider:(NSCollectionViewDiffableDataSourceItemProvider)itemProvider {
    if ([carouselView isKindOfClass:[MGACarouselView class]] == NO) {
        NSCAssert(FALSE, @"MGACarouselView 클래스를 넣어라.");
    }
    self = [super initWithCollectionView:carouselView.collectionView itemProvider:itemProvider];
    if (self) {
        _carouselView = carouselView;
        CommonInit(self);
    }
    return self;
}

static void CommonInit(MGACarouselDiffableDataSource *self) {
    self->_volumeType = MGACarouselVolumeTypeFinite;
}



#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
- (instancetype)initWithCollectionView:(NSCollectionView *)collectionView
                          itemProvider:(NSCollectionViewDiffableDataSourceItemProvider)itemProvider { NSCAssert(FALSE, @"- initWithCollectionView:cellProvider: 사용금지."); return nil; }

@end
