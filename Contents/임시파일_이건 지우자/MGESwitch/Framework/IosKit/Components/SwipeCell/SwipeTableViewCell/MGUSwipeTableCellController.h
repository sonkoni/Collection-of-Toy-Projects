//
//  MGUSwipeTableCellController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import "MGUSwipeActionsView.h" // 필요. SwipeActionsViewDelegate
@class MGUSwipeTableCellController;
@class MGUSwipeTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol MGUSwipeTableCellControllerDelegate <NSObject> // SwipeTableViewCell 이 따른다.
@optional
@required

- (BOOL)swipeController:(MGUSwipeTableCellController *)controller
canBeginEditingSwipeableForOrientation:(MGUSwipeActionsOrientation)orientation;

- (MGUSwipeActionsConfiguration * _Nullable)leftSwipeActionsConfigurationForSwipeController:(MGUSwipeTableCellController *)controller;
- (MGUSwipeActionsConfiguration * _Nullable)rightSwipeActionsConfigurationForSwipeController:(MGUSwipeTableCellController *)controller;

- (void)swipeController:(MGUSwipeTableCellController *)controller willBeginSwipeForOrientation:(MGUSwipeActionsOrientation)orientation;

- (void)swipeController:(MGUSwipeTableCellController *)controller didEndSwipeForOrientation:(MGUSwipeActionsOrientation)orientation;

- (CGRect)swipeController:(MGUSwipeTableCellController *)controller visibleRectForTableView:(UITableView *)tableView;
@end



@interface MGUSwipeTableCellController : NSObject <MGUSwipeActionsViewDelegate, UIGestureRecognizerDelegate>

//@property (nonatomic, assign) UIEdgeInsets originalLayoutMargins; // 디폴트 zero
@property (nonatomic, weak, nullable) id <MGUSwipeTableCellControllerDelegate>delegate;
@property (nonatomic, weak, nullable) UITableView *tableView;

- (instancetype)initWithSwipeableCell:(MGUSwipeTableViewCell *)swipeableCell
                 actionsContainerView:(UIView *)actionsContainerView;

- (void)setSwipeOffset:(CGFloat)offset
              animated:(BOOL)animated
            completion:(void(^ _Nullable)(BOOL))completion;

- (void)hideSwipeAnimated:(BOOL)animated completion:(void(^ _Nullable)(BOOL))completion;

//! 회전시 열려있는 셀에 대하여 적절한 레이아웃 safe area등에 대하여 잘 작동할 수 있게 해준다.
- (void)traitCollectionDidChangeFromPreviousTraitCollrection:(UITraitCollection * _Nullable)previousTraitCollrection
                                   toCurrentTraitCollrection:(UITraitCollection *)currentTraitCollrection;

- (void)reset;


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new __attribute__((unavailable("new not available. Use - initWithSwipeableCell:actionsContainerView: instead")));
- (instancetype)init __attribute__((unavailable("init not available. Use - initWithSwipeableCell:actionsContainerView: instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END



