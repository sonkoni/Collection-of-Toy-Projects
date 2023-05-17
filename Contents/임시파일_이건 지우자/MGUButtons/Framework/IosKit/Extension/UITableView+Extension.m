//
//  UITableView+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)mgrDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation
                  completionBlock:(void(^_Nullable)(void))completionBlock {
    
    __weak __typeof(self) weakSelf = self;
    [self performBatchUpdates:^{
        __strong __typeof(weakSelf) self = weakSelf;
        [self deleteRowsAtIndexPaths:indexPaths
                    withRowAnimation:animation];
    } completion:^(BOOL finished) {
        if (completionBlock!= nil) {
            completionBlock();
        }
    }];
}

- (void)mgrDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation
                         duration:(CGFloat)duration
                  completionBlock:(void(^_Nullable)(void))completionBlock {
    
    NSInteger count = indexPaths.count;
    NSMutableArray <UITableViewCell *>*cells = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray <NSNumber *>*tempMask = [NSMutableArray arrayWithCapacity:count]; // BOOL
    if (animation == UITableViewRowAnimationMask) {
        for (NSIndexPath *indexPath in indexPaths) {
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            if (cell.maskView != nil) {
                cell.maskView.frame = CGRectIntegral(cell.maskView.frame);
                [tempMask addObject:@(NO)];
            } else {
                CGSize size = cell.bounds.size;
                UIView *maskView = [UIView new];
                maskView.backgroundColor = [UIColor redColor];
                maskView.frame = CGRectIntegral(CGRectMake(-size.width, 0.0, size.width * 3.0, size.height));
                cell.maskView = maskView;
                [tempMask addObject:@(YES)];
            }
            
            [cells addObject:cell];
        }
    }
    
    UITableViewRowAnimation usingAnimation = (animation != UITableViewRowAnimationMask) ? animation : UITableViewRowAnimationNone;
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration
                                                                            dampingRatio:1.0
                                                                             animations:^{
        __weak __typeof(self) weakSelf = self;
        [self performBatchUpdates:^{
            __strong __typeof(weakSelf) self = weakSelf;
            [self deleteRowsAtIndexPaths:indexPaths
                        withRowAnimation:usingAnimation];
        } completion:^(BOOL finished) {
            if (completionBlock!= nil) {
                completionBlock();
            }
            
            if (animation == UITableViewRowAnimationMask) {
                for (NSInteger i = 0; i < cells.count; i++) {
                    UITableViewCell *cell = cells[i];
                    BOOL isTemp = [tempMask[i] boolValue];
                    if (isTemp == NO) {
                        cell.maskView.frame = cell.bounds;
                    } else {
                        [cell.maskView removeFromSuperview];
                    }
                    
                }
            }
        }];
        
        if (animation == UITableViewRowAnimationMask) {
            for (UITableViewCell *cell in cells) {
                CGRect frame = cell.maskView.frame;
                frame.size.height = 0.0;
                cell.maskView.frame = frame;
            }
        }
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {}];
    [animator startAnimationAfterDelay:0.0];
    //
    /*
    [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:duration
                                                            delay:0.0
                                                        options:UIViewAnimationOptionCurveEaseInOut
                                                        animations:^{
        __weak __typeof(self) weakSelf = self;
        [self performBatchUpdates:^{
            __strong __typeof(weakSelf) self = weakSelf;
            [self deleteRowsAtIndexPaths:indexPaths
                        withRowAnimation:animation];
        } completion:^(BOOL finished) {
            if (completionBlock!= nil) {
                completionBlock();
            }
            if (maskView != nil) {
                [maskView removeFromSuperview];
            }
        }];
    
        if (maskView != nil) {
            CGRect frame = maskView.frame;
            frame.size.height = 0.0;
            maskView.frame = frame;
        }
    
    } completion:^(UIViewAnimatingPosition finalPosition) {}];
     */
}

@end
