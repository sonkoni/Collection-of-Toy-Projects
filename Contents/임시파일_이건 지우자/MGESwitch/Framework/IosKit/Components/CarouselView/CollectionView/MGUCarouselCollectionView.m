//
//  MGUCarouselCollectionView.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselCollectionView.h"

@implementation MGUCarouselCollectionView
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


#pragma mark - 생성 & 소멸
static void CommonInit(MGUCarouselCollectionView *self) {
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
    
    //! 아래의 프라퍼티를 NO로 설정하면, cell 위에 UIControl 객체가 존재할 때, 불규칙적으로 의도치 않은 스크롤이 되는 것을 막을 수 있다.
    //    self.delaysContentTouches = NO;

}


@end
