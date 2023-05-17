//  UITableView+Extension.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-05-03
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const UITableViewRowAnimation UITableViewRowAnimationMask = -1;
static const CGFloat UITableViewDeleteRowDuration = 0.4; // UITableViewDeleteInsertRowDuration

@interface UITableView (Extension)

/**
 * @brief 열(들)을 삭제한 후의 completionBlock 을 추가하였다.
 * @param indexPaths 삭제할 인덱스의 배열
 * @param animation 삭제시 사용할 UITableViewRowAnimation
 * @param completionBlock 삭제 후 발동할 completionBlock
 * @discussion 삭제 후에 발동할 블락을 넣을 수 있다.
 * @remark CATransaction 을 이용하여 더 섬세하게 조정할 수 도 있다.
 * @code
        [tableView mgrDeleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationFade
                            completionBlock:^{
            //! 삭제된 후에 실행된다.
        }];
        
    
        //! 다음과 같은 방식도 존재한다.
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            //! 삭제 후, 첫 번째로 실행된다.
        }];
        
        __weak __typeof(tableView) weakTableView = tableView;
        [tableView performBatchUpdates:^{
            __strong __typeof(weakTableView) tableView = weakTableView;
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
        } completion:^(BOOL finished) {
            //! 삭제 후, 두 번째로 실행된다.
        }];
 *        
        [CATransaction commit];
 * @endcode
*/
- (void)mgrDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation
                  completionBlock:(void(^_Nullable)(void))completionBlock;

/**
 * @brief UITableViewRowAnimationMask 추가. 애니메이션이 발동되는 시간 설정. 열(들)을 삭제한 후의 completionBlock 을 추가.
 * @param indexPaths 삭제할 인덱스의 배열
 * @param animation 삭제시 사용할 UITableViewRowAnimation. UITableViewRowAnimationMask를 내가 추가했다. 유용할 것이다.
 * @param duration 애니메이션이 발동되는 시간
 * @param completionBlock 삭제 후 발동할 completionBlock
 * @discussion 애니메이션이 발동되는 시간 설정 및 삭제 후에 발동할 블락을 넣을 수 있다.
 * @remark UITableViewRowAnimationMask 을 이용하여 내가 추가하였다.
 * @code
        [tableView mgrDeleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationMask
                                    duration:UITableViewDeleteRowDuration
                            completionBlock:^{
            //! 삭제된 후에 실행된다.
        }];
 * @endcode
*/
- (void)mgrDeleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation
                         duration:(CGFloat)duration
                  completionBlock:(void(^_Nullable)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2021-05-12 : duration 추가하였다.
 * 2021-05-03 : completionBlock 추가하였다.
 */
