//
//  MGUFlowCollectionView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowCollectionView.h"
#import "MGUFlowView.h"

@implementation MGUFlowCollectionView
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        CommonInit(self);
    }
    return self;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:UIEdgeInsetsZero];
    if (contentInset.top > 0) {
        CGPoint contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + contentInset.top);
        self.contentOffset = contentOffset;
    }
}

- (UIEdgeInsets)contentInset {
    return [super contentInset];
}

- (void)setScrollsToTop:(BOOL)scrollsToTop {
    [super setScrollsToTop:NO];
}

- (BOOL)scrollsToTop {
    return NO;
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self updateCurrentIndex];
    [super deleteItemsAtIndexPaths:indexPaths];
}

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self updateCurrentIndex];
    [super insertItemsAtIndexPaths:indexPaths];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self updateCurrentIndex];
    [super moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}


#pragma mark - 생성 & 소멸
static void CommonInit(MGUFlowCollectionView *self) {
    self.contentInset = UIEdgeInsetsZero;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.prefetchingEnabled = NO; // 셀 및 데이터 prefetching 사용 여부를 나타내는 BOOL 값
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // safe area에 영향을 받지 않는다.
    self.scrollsToTop = NO;  // status bar를 탭했을 때, 스크롤을 가장 위로 올리는지 여부
    self.pagingEnabled = NO;
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    //
    // adjustedContentInset = contentInset + system inset
    // contentInset == UIEdgeInsetsZero, contentInsetAdjustmentBehavior == UIScrollViewContentInsetAdjustmentNever
    // 으로 설정했으므로, adjustedContentInset은 UIEdgeInsetsZero가 된다.
}


#pragma mark - Action
//! MGUFlowView의 프레임이 변함으로 인하여 현재 인덱스를 추출하지 못하는 일이 발생할 수 있다.
- (void)updateCurrentIndex {
    MGUFlowView *flowView = (MGUFlowView *)(self.superview.superview);
    if ([flowView isKindOfClass:[MGUFlowView class]] == YES) {
        [flowView updateCurrentIndex];
    } else {
        NSCAssert(FALSE, @"MGUFlowView를 잘못 골랐다.");
    }
}

@end
