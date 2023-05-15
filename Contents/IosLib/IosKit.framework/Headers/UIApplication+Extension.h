//
//  UIApplication+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-28
//  ----------------------------------------------------------------------
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Extension)
+ (UIWindow * _Nullable)mgrKeyWindow;  // keyWindow 관련하여 iOS 15에서 또 바뀌었다.


+ (nullable __kindof UIViewController *)mgrTopViewController:(nullable __kindof UIViewController *)viewController;
+ (UIInterfaceOrientation)mgrInterfaceOrientation;
+ (UIDeviceOrientation)mgrDeviceOrientation;

+ (CGFloat)mgrScreenShortLength; // 스크린의 짧은쪽 길이.
+ (CGFloat)mgrScreenLongLength; // 스크린의 긴쪽 길이.
+ (CGFloat)mgrStatusBarHeight;
@end


// ----------------------------------------------------------------------


NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-03-28 : iOS 15 에서 UIApplication.windows 프라퍼티가 deprecated 되었다. keywindow를 새롭게 만들었다.
 * 2021-11-17 : mgrDeviceOrientation 추가
 * 2021-01-08 : 1.4 - 정리했다.
 * 2020-10-06 : 1.3 - 정리했다.
 * 2020-04-23 : 1.2 - 매크로 기반 mgrKeyWindow 추가
 * 2020-04-15 : 라이브러리 정리됨
 */
