//
//  MGUSwipeTableViewCell.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUSwipeActionsConfiguration.h>
#import <IosKit/MGUSwipeableInterface.h> // MGUSwipeTableViewCell 및 MGUSwipeCollectionViewCell 에서 받는다.
#import <IosKit/MGUSwipeActionTransitioning.h>
#import <IosKit/MGUSwipeExpansionStyle.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGUSwipeTableViewCellDelegate <NSObject>
@required
- (MGUSwipeActionsConfiguration * _Nullable)tableView:(UITableView *)tableView
leading_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath;

- (MGUSwipeActionsConfiguration * _Nullable)tableView:(UITableView *)tableView
trailing_SwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath;

//! TODO: 반드시 tableView.delegate에 해당하는 객체는 - tableView:willDisplayCell:forRowAtIndexPath: 내부에서
//! 다음과 같은 처리를 해야한다.  스크롤 왔다갔다하면 frame을 못찾는다.
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.maskView != nil) {
        cell.maskView.frame = cell.bounds;
    }
}
 */

@optional

- (void)tableView:(UITableView *)tableView
willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView
willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView
didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView
didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (CGRect)visibleRectForTableView:(UITableView *)tableView;

@end

@interface MGUSwipeTableViewCell : UITableViewCell <MGUSwipeableInterface>
@property (nonatomic, weak, nullable) id <MGUSwipeTableViewCellDelegate>delegate;
@property (nonatomic, strong, nullable) MGUSwipeActionsView *actionsView;
@property (nonatomic, weak, nullable) UITableView *tableView;
@property (nonatomic, weak, nullable, readonly) UIScrollView *scrollView; // @dynamic 호환성을 위해
@property (nonatomic, strong, nullable, readonly) NSIndexPath *indexPath; // [self.tableView indexPathForCell:self]; // @dynamic
@property (nonatomic, assign) MGUSwipeState state; // 디폴트 SwipeStateCenter

- (void)hideSwipeAnimated:(BOOL)animated completion:(void(^ _Nullable)(BOOL))completion;
- (void)didAddActionsView:(UIView *)actionsView NS_REQUIRES_SUPER;
- (void)didRemoveActionsView:(UIView *)actionsView NS_REQUIRES_SUPER;

@end

@interface UITableView (MGUSwipeCellKit)
- (NSArray <MGUSwipeTableViewCell *>*)swipeCells;
- (void)hideSwipeCell;
@end

@interface UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> (MGUSwipeCellKit)

- (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
                    tableView:(UITableView *)tableView
                   completion:(void(^_Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
