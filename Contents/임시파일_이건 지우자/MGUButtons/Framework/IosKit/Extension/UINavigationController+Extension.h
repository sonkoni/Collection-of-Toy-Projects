//
//  UINavigationController+Extension.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-05-03
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Extension)

/**
 * @brief push한 후의 completionBlock 을 추가하였다.
 * @param viewController 스택에 푸시할 뷰 컨트롤러. 이 객체는 탭바 컨트롤러가 될 수 없다. 뷰 컨트롤러가 이미 탐색 스택에있는 경우이 메서드는 예외를 throw한다.
 * @param animated 한계값 - 전환에 애니메이션을 적용하려면 YES를 지정하고 전환에 애니메이션을 적용하지 않으려면 NO를 지정한다.
 * @param completionBlock viewWillAppear: -> completionBlock 발동 -> viewDidAppear:
 * @param secondCompletionBlock viewDidAppear: -> secondCompletionBlock 발동
 * @discussion 원하는 시점에서 발동할 블락을 넣으면된다.
 * @remark 발동하는 시점을 정할 수 있다. 원하는 곳에 블락을 넣어라.
 * @code
        [self.navigationController mgrPushViewController:[UIViewController new]
                                                animated:YES
                                         completionBlock:^{
            NSLog(@"viewWillAppear: 발동 후 그리고 viewDidAppear: 발동 전에 실행된다.");
        } secondCompletionBlock:^{
            NSLog(@"viewDidAppear: 발동 후에 실행된다.");
        }];
        
    
        //! 다음과 같은 방식도 존재한다.
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            NSLog(@"viewWillAppear: 발동 후 그리고 viewDidAppear: 발동 전에 실행된다.");
        }];

        [self.navigationController pushViewController:[UIViewController new] animated:YES];
        [CATransaction commit];
 * @endcode
*/
- (void)mgrPushViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
              completionBlock:(void(^_Nullable)(void))completionBlock
        secondCompletionBlock:(void(^_Nullable)(void))secondCompletionBlock;


/**
 * @brief pop한 후의 completionBlock 을 추가하였다.
 * @param animated 한계값 - 전환에 애니메이션을 적용하려면 YES를 지정하고 전환에 애니메이션을 적용하지 않으려면 NO를 지정한다.
 * @param completionBlock viewWillDisappear: -> completionBlock 발동 -> viewDidDisappear:
 * @param secondCompletionBlock viewDidDisappear: -> secondCompletionBlock 발동
 * @discussion 원하는 시점에서 발동할 블락을 넣으면된다.
 * @remark 발동하는 시점을 정할 수 있다. 원하는 곳에 블락을 넣어라.
 * @code
        [self.navigationController mgrPopViewControllerAnimated:YES
                                                completionBlock:^{
            NSLog(@"viewWillDisappear: 발동 후 그리고 viewDidDisappear: 발동 전에 실행된다.");
        }
                                          secondCompletionBlock:^{
            NSLog(@"viewDidDisappear: 발동 후에 실행된다.");
        }];
 
 
        //! 다음과 같은 방식도 존재한다.
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            NSLog(@"viewWillDisappear: 발동 후 그리고 viewDidDisappear: 발동 전에 실행된다.");
        }];

        [self.navigationController popViewControllerAnimated:YES];
        [CATransaction commit];
 * @endcode
 * @return 스택에서 떨어져 나가는 viewController
*/
- (UIViewController *)mgrPopViewControllerAnimated:(BOOL)animated
                                   completionBlock:(void(^_Nullable)(void))completionBlock
                             secondCompletionBlock:(void(^_Nullable)(void))secondCompletionBlock;


@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2021-05-03 : completionBlock 추가하였다.
 */
