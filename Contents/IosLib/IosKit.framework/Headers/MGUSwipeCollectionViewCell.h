//
//  MGUSwipeCollectionViewCell.h
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

static const CGFloat UICollectionViewDeleteItemDuration = 0.4; // UICollectionViewDeleteInsertRowDuration

@protocol MGUSwipeCollectionViewCellDelegate <NSObject>
@required
- (MGUSwipeActionsConfiguration * _Nullable)collectionView:(UICollectionView *)collectionView
leading_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath;

- (MGUSwipeActionsConfiguration * _Nullable)collectionView:(UICollectionView *)collectionView
trailing_SwipeActionsConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath;

//! TODO: 반드시 collectionView.delegate에 해당하는 객체는 - collectionView:willDisplayCell:forItemAtIndexPath: 내부에서
//! 다음과 같은 처리를 해야한다.  스크롤 왔다갔다하면 frame을 못찾는다.
/*
 - (void)collectionView:(UICollectionView *)collectionView
        willDisplayCell:(UICollectionViewCell *)cell
     forItemAtIndexPath:(NSIndexPath *)indexPath {
     if (cell.maskView != nil) {
         cell.maskView.frame = cell.bounds;
     }
 }
 */

@optional
- (void)collectionView:(UICollectionView *)collectionView
willBeginLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView
willBeginTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView
didEndLeadingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView
didEndTrailingSwipeAtIndexPath:(NSIndexPath *)indexPath;

- (CGRect)visibleRectForCollectionView:(UICollectionView *)collectionView;

@end

@interface MGUSwipeCollectionViewCell : UICollectionViewCell <MGUSwipeableInterface>

@property (nonatomic, weak, nullable) id <MGUSwipeCollectionViewCellDelegate>delegate;
@property (nonatomic, strong, nullable) MGUSwipeActionsView *actionsView;
@property (nonatomic, weak, nullable) UICollectionView *collectionView;
@property (nonatomic, weak, nullable, readonly) UIScrollView *scrollView; // @dynamic 호환성을 위해
@property (nonatomic, strong, nullable, readonly) NSIndexPath *indexPath; // [self.collectionView indexPathForCell:self]; // @dynamic
@property (nonatomic, assign) MGUSwipeState state; // 디폴트 SwipeStateCenter
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CACornerMask maskedCorners;
@property (nonatomic, assign, getter = isClip) BOOL clip; // 디폴트 YES; 셀을 벗어나는 것을 허용하지 않는다.
@property (nonatomic, assign) BOOL deleteDirectionReverse; // 디폴트 NO. 아래에서 위로 작아줄며 삭제되는 것. reverse는 위에서 아래로.
@property (nonatomic, strong, nullable) UIColor *swipeDecoLeftColor;
@property (nonatomic, strong, nullable) UIColor *swipeDecoRightColor;

- (void)hideSwipeAnimated:(BOOL)animated completion:(void(^ _Nullable)(BOOL))completion;
- (void)didAddActionsView:(UIView *)actionsView NS_REQUIRES_SUPER;
- (void)didRemoveActionsView:(UIView *)actionsView NS_REQUIRES_SUPER;

//! 디바이스가 horizontal일때, contentView 자체가 움직이지 않는다. swipeableContentView를 사용하자.
@property (nonatomic, readonly) UIView *swipeableContentView;
@property (nonatomic, readonly) NSLayoutConstraint *swipeableContentViewCenterXConstraint;


#pragma mark - NS_UNAVAILABLE
@property (nonatomic, readonly) UIView *contentView __attribute__((unavailable("contentView 사용을 막자. 대신 swipeableContentView를 이용하라.")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (void)awakeFromNib NS_UNAVAILABLE;

@end


@interface UICollectionView (MGUSwipeCellKit)
- (NSArray <MGUSwipeCollectionViewCell *>*)swipeCells;
- (void)hideSwipeCell;
@end

@interface UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType> (MGUSwipeCellKit)

- (void)mgrSwipeApplySnapshot:(NSDiffableDataSourceSnapshot *)snapshot
               collectionView:(UICollectionView *)collectionView
                   completion:(void(^_Nullable)(void))completion;
@end


NS_ASSUME_NONNULL_END
