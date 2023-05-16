//
//  MGUCarouselCellLayoutAttributes.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUCarouselCellLayoutAttributes : UICollectionViewLayoutAttributes
// 현재 collectionView 보이는 화면의 중앙에서 얼마나 떨어져 있는지를 알려준다.
// ex) : 0.0이면 화면의 중앙에 있다. 1.0 이면 화면 중앙에서 아이템이 정지해 있다고 가정했을 때, 한 칸 오른쪽에 있는 아이템의 위치를 의미한다.
@property (nonatomic, assign) CGFloat position; // 디폴트 0.0;

//! MGUCarouselCenterExpandTransformer : Expand 된 상태가 0.0, 줄어든 상태가 1.0이다.
//! MGUCarouselCoverFlowTransformer : 아직 사용되고 있지는 않지만, 완전히 앞을 본 상태가 0.0, 옆으로 뉘어있는 상태가 1.0이다.
@property (nonatomic, assign) CGFloat centerProgress; // 가운데가 0.0 [0.0 ~ 1.0] rubber Effect에 이용될 수 있다.

@property (nonatomic, assign) CGFloat diceRadiusRatio; // 디폴트 1.0 [1.0 ~ 0.0] MGUCarouselDiceTransformer 에서만 사용함.
@end

NS_ASSUME_NONNULL_END
