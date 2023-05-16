//
//  MGUCarouselLayout.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import "MGUCarouselView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselLayout : UICollectionViewLayout

//! 바로 아래의 프라퍼티 3개는 숨겨도 될듯하다. 아직은 잘모르겠다.
@property (nonatomic, assign) CGSize contentSize; // 디폴트 CGSizeZero
@property (nonatomic, assign) CGFloat leadingSpacing; // 디폴트 0.0
@property (nonatomic, assign) CGFloat itemSpacing; // 디폴트 0.0

@property (nonatomic, assign) BOOL needsReprepare; // 디폴트 true
@property (nonatomic, assign) MGUCarouselScrollDirection scrollDirection; // 디폴트 horizontal

- (CGPoint)contentOffsetFor:(NSIndexPath *)indexPath;
- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)forceInvalidate;
@end

NS_ASSUME_NONNULL_END
//
//! 이 클래스의 itemSpacing은 UICollectionView itemSpacing과는 다른 개념이다.
//! UICollectionView의 item size (width[<-Horizontal] 또는 height[<-Vertical])와 inter item spacing을 더한 값에 해당하는 개념이다.
//!
