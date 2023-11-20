//
//  MGUSwipeableInterface.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-29
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
@class MGUSwipeActionsView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUSwipeState) {
    MGUSwipeStateCenter = 0,
    MGUSwipeStateLeft,
    MGUSwipeStateRight,
    MGUSwipeStateDragging,
    MGUSwipeStateAnimatingToCenter
};


@protocol MGUSwipeableInterface <NSObject>

- (MGUSwipeState)state;
- (void)setState:(MGUSwipeState)state;

- (MGUSwipeActionsView * _Nullable)actionsView;
- (void)setActionsView:(MGUSwipeActionsView * _Nullable)actionsView;
- (void)didAddActionsView:(UIView *)actionsView;
- (void)didRemoveActionsView:(UIView *)actionsView;

- (CGRect)frame;

- (UIScrollView * _Nullable)scrollView;

- (NSIndexPath * _Nullable)indexPath;

@end



NS_ASSUME_NONNULL_END
