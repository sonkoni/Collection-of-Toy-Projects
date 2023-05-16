//
//  MGUSwipeTransitionLayout.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUSwipeTransitionLayout.h"
#import "MGUSwipeActionsView.h"
#import "MGUSwipeActionsConfiguration.h"

@interface MGUSwipeTransitionLayout ()
@property (nonatomic, weak) MGUSwipeActionsView *actionsView;
@end

@implementation MGUSwipeTransitionLayout

#pragma mark - 생성 & 소멸
+ (instancetype)transitionLayoutForActionsView:(MGUSwipeActionsView *)actionsView {
    return [[MGUSwipeTransitionLayout alloc] initPrivateWithActionsView:actionsView];
}

- (instancetype)initPrivateWithActionsView:(MGUSwipeActionsView *)actionsView {
    self = [super init];
    if (self) {
        _actionsView = actionsView;
    }
    return self;
}

#pragma mark - Public Action
//! SwipeActionsView에 대한 bounds 조정이다. DragTransitionLayout, RevealTransitionLayout 에서만 사용된다.
- (void)swipeActionsViewBounds  {
    if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleBorder) {
        [self _border_SwipeActionsViewBounds];
    } else if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleDrag) {
        [self _drag_SwipeActionsViewBounds];
    } else if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleReveal) {
        [self _reveal_SwipeActionsViewBounds];
    }
}

//! action button을 담고 있는 SwipeActionButtonWrapperView에 대한 frame이다.
- (void)layoutButtonWrapperView:(UIView *)view atIndex:(NSInteger)index  {
    if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleBorder) {
        [self _border_LayoutButtonWrapperView:view atIndex:index];
    } else if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleDrag) {
        [self _drag_LayoutButtonWrapperView:view atIndex:index];
    } else if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleReveal) {
        [self _reveal_LayoutButtonWrapperView:view atIndex:index];
    }
}

//! safe visible이다. safe area를 벗어나 각 버튼이 얼마나 보여지는가. animation을 위해 사용되었다.
- (NSArray <NSNumber *>*)visibleWidthsForButtonWrapperViews  {
    if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleBorder) {
        return [self _border_VisibleWidthsForButtonWrapperViews];
    } else if (self.actionsView.configuration.transitionStyle == MGUSwipeTransitionStyleDrag) {
        return [self _drag_VisibleWidthsForButtonWrapperViews];
    } else { // self.actionsView.options.transitionStyle == SwipeTransitionStyleReveal
        return [self _reveal_VisibleWidthsForButtonWrapperViews];
    }
}


#pragma mark - Private -
#pragma mark - Private - Border
- (void)_border_SwipeActionsViewBounds {}

- (void)_border_LayoutButtonWrapperView:(UIView *)view atIndex:(NSInteger)index {
    CGRect frame = view.frame;
    CGFloat diff = self.actionsView.visibleWidth - self.actionsView.contentSize.width;
    NSInteger count = self.actionsView.actions.count;
    if (self.actionsView.safeAreaMargin == 0.0) {
        frame.origin.x =
        (index * self.actionsView.contentSize.width / (CGFloat)(count) + diff) * self.actionsView.orientation;
    } else { // context.safeAreaMargin 이 0.0 아닐때.
        CGFloat preferredWidth = self.actionsView.minimumButtonWidth * count + self.actionsView.safeAreaMargin;
        if (self.actionsView.contentSize.width > preferredWidth) { // 충분히 다나왔을 때.
            frame.origin.x =
            (index * (self.actionsView.contentSize.width - self.actionsView.safeAreaMargin) / (CGFloat)(count) + diff) * self.actionsView.orientation;
        } else {  // 잠겨 있는 부분이 존재할 때.
            frame.origin.x =
            (index * (self.actionsView.minimumButtonWidth / preferredWidth * self.actionsView.contentSize.width) + diff) * self.actionsView.orientation;
        }
    }
    view.frame = frame;
}


- (NSArray <NSNumber *>*)_border_VisibleWidthsForButtonWrapperViews {
    // CGFloat 반환
    NSInteger count = self.actionsView.actions.count;
    
    CGFloat visibleWidth = self.actionsView.contentSize.width / (CGFloat)(count);
    if (self.actionsView.safeAreaMargin != 0.0) {
        CGFloat preferredWidth = self.actionsView.minimumButtonWidth * count + self.actionsView.safeAreaMargin;
        if (self.actionsView.contentSize.width > preferredWidth) { // 충분히 다나왔을 때.
            visibleWidth = (self.actionsView.contentSize.width - self.actionsView.safeAreaMargin) / (CGFloat)(count);
        } else {  // 잠겨 있는 부분이 존재할 때. 끝 부분이 safe area를 벗어난 부분을 얼만큼 통과했냐가 관건이다.
            visibleWidth = (self.actionsView.minimumButtonWidth / preferredWidth * self.actionsView.contentSize.width);
            //! 마지막 action button이 safe area에서 얼마나 벗어 났는지가 관건.
            visibleWidth = self.actionsView.contentSize.width - (visibleWidth * (count - 1)) - self.actionsView.safeAreaMargin;
        }
    }

    // visible widths are all the same regardless of the action view position
    NSMutableArray <NSNumber *>*result = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i <count; i++) {
        [result addObject:@(visibleWidth)];
    }
    
    return result.copy;

}


#pragma mark - Private - Drag
- (void)_drag_SwipeActionsViewBounds {
    CGRect bounds = self.actionsView.bounds;
    bounds.origin.x = (self.actionsView.contentSize.width - self.actionsView.visibleWidth) * self.actionsView.orientation;
    self.actionsView.bounds = bounds;
}

- (void)_drag_LayoutButtonWrapperView:(UIView *)view atIndex:(NSInteger)index {
    CGRect frame = view.frame;
    frame.origin.x = (index * self.actionsView.minimumButtonWidth) * self.actionsView.orientation;
    view.frame = frame;
}

- (NSArray <NSNumber *>*)_drag_VisibleWidthsForButtonWrapperViews {
    // CGFloat 반환
    NSInteger count = self.actionsView.actions.count;
    NSMutableArray <NSNumber *>*result = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        CGFloat element = self.actionsView.visibleWidth - self.actionsView.safeAreaMargin - (i * self.actionsView.minimumButtonWidth);
        element = MAX(- self.actionsView.safeAreaMargin, MIN(self.actionsView.minimumButtonWidth, element));
        [result addObject:@(element)];
    }
    return result.copy;

}


#pragma mark - Private - Reveal
- (void)_reveal_SwipeActionsViewBounds {
    CGRect bounds = self.actionsView.bounds;
    CGFloat preferredWidth = self.actionsView.minimumButtonWidth * self.actionsView.actions.count + self.actionsView.safeAreaMargin;
    bounds.origin.x = (preferredWidth - self.actionsView.visibleWidth) * self.actionsView.orientation;
    self.actionsView.bounds = bounds;
}

- (void)_reveal_LayoutButtonWrapperView:(UIView *)view atIndex:(NSInteger)index {
    [self _drag_LayoutButtonWrapperView:view atIndex:index];
}

- (NSArray <NSNumber *>*)_reveal_VisibleWidthsForButtonWrapperViews {
    return [[[self _drag_VisibleWidthsForButtonWrapperViews] reverseObjectEnumerator] allObjects];
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
