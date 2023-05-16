//
//  MGACarouselCellLayoutAttributes.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-14
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGACarouselCellLayoutAttributes : NSCollectionViewLayoutAttributes

//! 사용해서는 안된다. UIKit에서만 존재하고 AppKit에서는 Private이다. 사용하면 부작용이 발생한다.
// @property (nonatomic, assign) CATransform3D transform3D;
// @property (nonatomic, assign) CGAffineTransform transform;

//! Private으로 center 프라퍼티가 존재하므로 충돌을 피하려면 이렇게 사용해야한다.
@property (nonatomic, assign) CGPoint mgrCenter; // @dynamic

// 현재 collectionView 보이는 화면의 중앙에서 얼마나 떨어져 있는지를 알려준다.
// ex) : 0.0이면 화면의 중앙에 있다. 1.0 이면 화면 중앙에서 아이템이 정지해 있다고 가정했을 때, 한 칸 오른쪽에 있는 아이템의 위치를 의미한다.
@property (nonatomic, assign) CGFloat position; // 디폴트 0.0;

//! MGUCarouselCenterExpandTransformer : Expand 된 상태가 0.0, 줄어든 상태가 1.0이다.
//! MGUCarouselCoverFlowTransformer : 아직 사용되고 있지는 않지만, 완전히 앞을 본 상태가 0.0, 옆으로 뉘어있는 상태가 1.0이다.
@property (nonatomic, assign) CGFloat centerProgress; // 가운데가 0.0 [0.0 ~ 1.0] rubber Effect에 이용될 수 있다.

@property (nonatomic, assign) CGFloat diceRadiusRatio; // 디폴트 1.0 [1.0 ~ 0.0] MGUCarouselDiceTransformer 에서만 사용함.


//! NSCollectionViewLayoutAttributes transform 을 먹일 수 없는 구조이다.
//! 따라서 그 자체는 transform을 먹이지 않고 내부 컨텐츠에 해당하는 부분을 dumyLayer에 위탁한다.
@property (nonatomic, strong, nullable) CALayer *dumyLayer;
@property (nonatomic, assign) CGRect dumyFrame;
@property (nonatomic, assign) CATransform3D dumyTransform;

- (BOOL)isVisibleOnCollectionView:(NSCollectionView *)collectionView; // 현재의 layout을 적용 시 보이는지 여부.
@end

NS_ASSUME_NONNULL_END
