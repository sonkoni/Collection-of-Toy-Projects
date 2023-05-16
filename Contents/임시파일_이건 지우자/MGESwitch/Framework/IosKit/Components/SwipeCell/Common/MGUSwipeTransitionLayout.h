//
//  MGUSwipeTransitionLayout.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
@class MGUSwipeActionsView;

NS_ASSUME_NONNULL_BEGIN

// SwipeTransitionStyleBorder
// SwipeTransitionStyleDrag
// SwipeTransitionStyleReveal
@interface MGUSwipeTransitionLayout : NSObject

+ (instancetype)transitionLayoutForActionsView:(MGUSwipeActionsView *)actionsView;

#pragma mark - Transition에 따른 ActionsView의 bounds와 WrapperView의 Frame 설정
//! SwipeActionsView에 대한 bounds 조정이다. DragTransitionLayout, RevealTransitionLayout 에서 사용된다.
- (void)swipeActionsViewBounds;

//! action button을 담고 있는 SwipeActionButtonWrapperView에 대한 frame이다.
- (void)layoutButtonWrapperView:(UIView *)view atIndex:(NSInteger)index;

#pragma mark - 특정 부분에서의 애니메이션을 위한 메서드.
//! safe visible이다. safe area를 벗어나 각 버튼이 얼마나 보여지는가. animation을 위해 사용되었다.
- (NSArray <NSNumber *>*)visibleWidthsForButtonWrapperViews; // CGFloat 반환


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("Use +layoutContextForActionsView: instead.")));
- (instancetype)init __attribute__((unavailable("Use +layoutContextForActionsView: instead.")));
@end

NS_ASSUME_NONNULL_END
