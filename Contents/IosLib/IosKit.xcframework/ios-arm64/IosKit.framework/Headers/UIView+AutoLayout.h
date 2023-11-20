//
//  UIView+AutoLayout.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-25
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AutoLayout)

#pragma mark - AutoresizingMask
- (void)mgrPinEdgesToSuperviewEdgesUsingAutoresizingMask;


#pragma mark - Pure
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewEdges;
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewLayoutMarginsGuide;
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuide;
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewCustomMargins:(UIEdgeInsets)customMargins; // 인셋만큼 파고든다.

- (NSArray <NSLayoutConstraint *>*)mgrPinHorizontalEdgesToSuperviewEdges; // leading, trailing만 super view에 맞춘다.
- (NSArray <NSLayoutConstraint *>*)mgrPinVerticalEdgesToSuperviewEdges;   // top, bottom만 super view에 맞춘다.

- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithSameSize; // super view의 센터 및 사이즈와 맞춘다. mgrPinEdgesToSuperviewEdges 와 효과는 거의 동일하다.
- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenter; // super view의 센터에 맞춘다.
- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithInner; // super view의 센터에 맞추고, 각 anchor가 super 경계 포함 안쪽에
- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithOuter; // super view의 센터에 맞추고, 각 anchor가 super 경계 포함 바깥쪽에
- (NSArray <NSLayoutConstraint *>*)mgrPinCenterToSuperviewCenterWithFixSize:(CGSize)size;  // super view의 센터에 맞추고, 주어진 사이즈로
- (NSLayoutConstraint *)mgrPinCenterXToSuperviewCenterXWithMultiplier:(CGFloat)multiplier;  // super view의 센터X에서 multiplier 적용.
- (NSLayoutConstraint *)mgrPinCenterYToSuperviewCenterYWithMultiplier:(CGFloat)multiplier;  // super view의 센터Y에서 multiplier 적용.

- (NSLayoutConstraint *)mgrPinTrailingToSuperviewTrailingWithMultiplier:(CGFloat)multiplier;  // super view의 trailing에서 multiplier 적용.
- (NSLayoutConstraint *)mgrPinBottomToSuperviewBottomWithMultiplier:(CGFloat)multiplier;  // super view의 Bottom에서 multiplier 적용.

- (NSArray <NSLayoutConstraint *>*)mgrPinSizeToSuperviewSize;  // super view와 사이즈만 동일하게
- (NSArray <NSLayoutConstraint *>*)mgrPinFixSize:(CGSize)size; // 가로와 세로만 정해준다.


#pragma mark - Mix
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewEdgesAndSafeAreaLayoutGuides; // 상하 superview 좌우 safeArea
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewEdgesAndMargins; // 상하 superview 좌우 MarginsGuide
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndEdges; // 상하 safeArea 좌우 superview
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndMargins; // 상하 safeArea 좌우 MarginsGuide
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewMarginsAndEdges; // 상하 Margins 좌우 superview
- (NSArray <NSLayoutConstraint *>*)mgrPinEdgesToSuperviewMarginsAndSafeAreaLayoutGuides; // 상하 Margins 좌우 safeArea


#pragma mark - other
- (UIEdgeInsets)safeAreaInsetsOfSuperview;


#pragma mark - Remove
// https://stackoverflow.com/questions/24418884/remove-all-constraints-affecting-a-uiview
//! 조상이 자신을 잡고 있는 모든 constraint들과 자신이 소유한 모든 constraint들을 제거한다.
//! 1. 조상이 자신을 잡고 있는 모든 constraint들을 제거한다.
//! 2. 자기 자신이 자신을 잡고 있는 constraint(widthAnchor, heightAnchor)들을 제거한다.
//! 3. 자신이 자손들에 행사하는 constraint(자신과의 leading, 자손들 사이의 거리 등...)들을 제거한다.
- (void)mgrRemoveAllConstraints:(BOOL)translatesAutoresizingMaskIntoConstraints;

//! 오직 자기 자신과 관련된 모든 constraint을 제거한다.
//! 1. 조상이 자신을 잡고 있는 모든 constraint들을 제거한다.
//! 2. 자기 자신이 자신을 잡고 있는 constraint(widthAnchor, heightAnchor)들을 제거한다.
// ** 자신이 자손들에 행사하는 constraint(자신과의 leading, 자손들 사이의 거리 등...)들은 건드리지 않는다.
- (void)mgrRemoveAllConstraintsRelatedToMe:(BOOL)translatesAutoresizingMaskIntoConstraints;


//! * 1. 조상이 자신을 잡고 있는 모든 constraint들을 제거한다.
// ** 자기 자신이 자신을 잡고 있는 constraint(widthAnchor, heightAnchor)들은 건드리지 않는다.
// ** 자신이 자손들에 행사하는 constraint(자신과의 leading, 자손들 사이의 거리 등...)들은 건드리지 않는다.
- (void)mgrRemoveAllConstraintsAncestorsHoldOnToMe:(BOOL)translatesAutoresizingMaskIntoConstraints;


#pragma mark - Active / Inactive
- (void)mgrSelfConstraints:(BOOL)isActive; // 조상이 자신에 대해 행사하는, 자기가 자신에 행사하는 constraints 를 활성화/비활성화 한다
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-05-25 : 반환값 추가함.
*/
// 
// view.safeAreaLayoutGuide.layoutFrame.width,
// view.safeAreaInsets.bottom;
// http://wiki.mulgrim.net/page/Project:Mac-ObjC/뷰_전환
