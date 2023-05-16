//
//  MGACarouselLayout.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//
// 시스템의 심각한 버그가 존재한다.
// - targetContentOffsetForProposedContentOffset:withScrollingVelocity: 가 호출되지 않는다.
// iOS에서는 UIScrollView의 pagingEnabled 를 NO로 하면되는데, AppKit에서는 해당하는 프라퍼티가 존재하지 않는다.
// 유사한 프라퍼티 pageScroll, verticalPageScroll ,horizontalPageScroll 에 별 짓을 해도 통하지 않는다.
// 6년동안 고치지 않았다. 애플 개색끼들. 내가 쌩으로 만들어야겠다.
// https://developer.apple.com/forums/thread/37212

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselLayout : NSCollectionViewLayout

//! 바로 아래의 프라퍼티 3개는 숨겨도 될듯하다. 아직은 잘모르겠다.
@property (nonatomic, assign) CGSize contentSize; // 디폴트 CGSizeZero
@property (nonatomic, assign) CGFloat leadingSpacing; // 디폴트 0.0
@property (nonatomic, assign) CGFloat itemSpacing; // 디폴트 0.0

@property (nonatomic, assign) BOOL needsReprepare; // 디폴트 true

- (CGPoint)contentOffsetFor:(NSIndexPath *)indexPath;
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)forceInvalidate;

@end

NS_ASSUME_NONNULL_END
//
//! 이 클래스의 itemSpacing은 UICollectionView itemSpacing과는 다른 개념이다.
//! UICollectionView의 item size (width[<-Horizontal] 또는 height[<-Vertical])와 inter item spacing을 더한 값에 해당하는 개념이다.
//!
