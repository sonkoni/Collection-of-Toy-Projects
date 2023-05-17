//
//  UIViewController+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-07
//  ----------------------------------------------------------------------
//
// http://wiki.mulgrim.net/page/Api:UIKit/UIViewController/-_removeFromParentViewController
// http://wiki.mulgrim.net/page/Api:UIKit/UIViewController/-_addChildViewController:

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)

//! UIAlertController 를 present 할때, Sheet Mode 이면 Auto layout Log 버그가 발생한다. 그것을 고쳐준다.
- (void)mgrPresentAlertViewController:(UIAlertController *)viewControllerToPresent
                             animated:(BOOL)flag
                           completion:(void (^_Nullable)(void))completion;


- (void)mgrAddChildViewController:(__kindof UIViewController *)childController
                       targetView:(UIView * _Nullable)view;

- (void)mgrRemoveFromParentViewController; // 자신을 부모에게서 제거할때.

// - (void)loadView; 메커니즘을 표현해봤다.
- (void)mgrLoadView;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2022-07-07 : add, remove 추가
* 2021-02-03 : 라이브러리 정리됨
*/
