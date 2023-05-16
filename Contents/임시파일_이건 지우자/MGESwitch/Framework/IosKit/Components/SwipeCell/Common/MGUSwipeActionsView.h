//
//  MGUSwipeActionsView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import "MGUSwipeActionsConfiguration.h"
@class MGUSwipeActionsView;
@class MGUSwipeAction;
@class ActionsViewLayoutContext;
@class MGUSwipeActionsConfiguration;
@class MGUSwipeActionButton;
@class MGUSwipeTransitionLayout;
@protocol MGUSwipeExpanding;

NS_ASSUME_NONNULL_BEGIN

@protocol MGUSwipeActionsViewDelegate <NSObject>
@optional
@required
//! button이 touch up inside 되었을 때 발동한다.
- (void)swipeActionsView:(MGUSwipeActionsView *)swipeActionsView didSelect:(MGUSwipeAction *)action;
@end

@interface MGUSwipeActionsView : UIView
@property (nonatomic, weak, nullable) id <MGUSwipeActionsViewDelegate> delegate;
@property (nonatomic, strong) MGUSwipeTransitionLayout *transitionLayout;
@property (nonatomic, strong, nullable) UIViewPropertyAnimator *expansionAnimator;
@property (nonatomic, strong, nullable, readonly) id <MGUSwipeExpanding> expansionDelegate;
@property (nonatomic, weak, nullable) UIView *safeAreaInsetView;
@property (nonatomic, weak, nullable) UIView *cell;
@property (nonatomic, assign) MGUSwipeActionsOrientation orientation;
@property (nonatomic, strong) NSArray <MGUSwipeAction *>*actions;
@property (nonatomic, strong) MGUSwipeActionsConfiguration *configuration;
@property (nonatomic, strong) NSMutableArray <MGUSwipeActionButton *>*buttons;
@property (nonatomic, assign) CGFloat minimumButtonWidth; // 디폴트 0.0;
@property (nonatomic, assign, readonly) CGFloat maximumImageHeight;
@property (nonatomic, assign, readonly) CGFloat safeAreaMargin;
@property (nonatomic, assign) CGFloat visibleWidth; // 디폴트 0.0;
@property (nonatomic, assign, readonly) CGFloat preferredWidth;
@property (nonatomic, assign, readonly) CGSize contentSize; // SwipeActionsView의 visibleWidth 중에서 보여지는 영역
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong, nullable, readonly) MGUSwipeAction *expandableAction;


- (instancetype)initWithContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                  maxSize:(CGSize)maxSize
                        safeAreaInsetView:(UIView *)safeAreaInsetView
                            configuration:(MGUSwipeActionsConfiguration *)configuration
                              orientation:(MGUSwipeActionsOrientation)orientation;

- (void)setExpanded:(BOOL)expanded feedback:(BOOL)feedback;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
