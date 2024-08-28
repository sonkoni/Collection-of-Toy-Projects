#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AutoLayout)

- (void)mgrPinEdgesToSuperviewEdges;
- (void)mgrPinEdgesToSuperviewLayoutMarginsGuide;
- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuide;
- (void)mgrPinEdgesToSuperviewCustomMargins:(UIEdgeInsets)customMargins; // 인셋만큼 파고든다.

- (void)mgrPinHorizontalEdgesToSuperviewEdges; // leading, trailing만 super view에 맞춘다.
- (void)mgrPinVerticalEdgesToSuperviewEdges;   // top, bottom만 super view에 맞춘다.

- (void)mgrPinCenterToSuperviewCenter; // super view의 센터에 맞춘다.
- (void)mgrPinCenterToSuperviewCenterWithInner; // super view의 센터에 맞추고, 각 anchor가 super 경계 포함 안쪽에
- (void)mgrPinCenterToSuperviewCenterWithOuter; // super view의 센터에 맞추고, 각 anchor가 super 경계 포함 바깥쪽에
- (void)mgrPinCenterToSuperviewCenterWithFixSize:(CGSize)size;  // super view의 센터에 맞추고, 주어진 사이즈로
- (void)mgrPinSizeToSuperviewSize;  // super view와 사이즈만 동일하게
- (void)mgrPinFixSize:(CGSize)size; // 가로와 세로만 정해준다.

- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndEdges;
- (void)mgrPinEdgesToSuperviewSafeAreaLayoutGuidesAndMargins;

- (UIEdgeInsets)safeAreaInsetsOfSuperview;
@end

NS_ASSUME_NONNULL_END

// 
// view.safeAreaLayoutGuide.layoutFrame.width,
// view.safeAreaInsets.bottom;
