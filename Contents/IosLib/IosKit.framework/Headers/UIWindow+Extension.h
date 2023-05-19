//
//  UIWindow+Extension.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-06-10
//  ----------------------------------------------------------------------
//
// 확대모드에서 표준모드처럼 사용하기 위해서 만들어졌다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//! iPad라면 Requires full screen을 XCode에서 설정하자.
@interface UIWindow (Standard)
+ (instancetype)mgrStandardWindow;
+ (instancetype)mgrStandardWindowWithWindowScene:(UIWindowScene *)scene;

+ (UIWindow * _Nullable)mgrKeyWindow;

/**
NSSet <UIScene *>*connectedScenes = [[UIApplication sharedApplication] connectedScenes];
UIWindow *__window;
for (UIScene *__scene in connectedScenes) {
    // 실제 SceneDelegate 에서 만들때는  UISceneActivationStateUnattached 상태로 한놈 들어온다.
    // 이 코드는 윈도우가 이미 존재하는 상태에서 만드는 것으로 사료된다.
    if (__scene.activationState == UISceneActivationStateForegroundActive) {
        if ([__scene isKindOfClass:[UIWindowScene class]] == YES) {
            __window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)(__scene)];
        }
    }
}

if (__window == nil) {
    __window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}
*/
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2021-06-10 : - mgrStandardWindowWithWindowScene: 추가됨.
* 2021-01-20 : 라이브러리 정리됨
*/

/**
 http://wiki.mulgrim.net/page/Project:IOs-ObjC/오토레이아웃
 https://stackoverflow.com/questions/25755443/iphone-6-plus-resolution-confusion-xcode-or-apples-website-for-development
 https://kapeli.com/cheat_sheets/iOS_Design.docset/Contents/Resources/Documents/index
 https://www.apple.com/iphone/compare/?device1=iphone12mini&device2=iphone8plus&device3=iphone6plus
 https://www.apple.com/ipad/compare/?modelList=ipad-8th-gen,ipad-pro-12-9-5th-gen,ipad-pro-11-3rd-gen
 
iPhone resolutions quick reference:
 Device                    | Points (UIKit size)   | Pixels      | Scale | Native Scale | Physical Pixels | PPI  | Ratio  | Size
 --------------------------|-----------------------|-------------|-------|--------------|-----------------|------|--------|-----
 iPhone 12 Pro Max         | 428 x 926             | 1284 x 2778 | 3x    | 3            | 1284 x 2778     | 458  | 9:19.5 | 6.7"
 iPhone 12 Pro             | 390 x 844             | 1170 x 2532 | 3x    | 3            | 1170 x 2532     | 460  | 9:19.5 | 6.1"
 iPhone 12                 | 390 x 844             | 1170 x 2532 | 3x    | 3            | 1170 x 2532     | 460  | 9:19.5 | 6.1"
 --------------------------------------------------------------------------------------------------------------------------------
 iPhone 12 Mini            | 375 x 812(Z:320 x 693)| 1125 x 2436 | 3x    | 2.88 si - 3  | 1080 x 2340     | 476  | 9:19.5 | 5.4"
 --------------------------------------------------------------------------------------------------------------------------------
 iPhone XS Max, 11 Pro Max | 414 x 896             | 1242 x 2688 | 3x    | 3            | 1242 x 2688     | 458  | 9:19.5 | 6.5"
 iPhone XR, 11             | 414 x 896             |  828 x 1792 | 2x    | 2            |  828 x 1792     | 326  | 9:19.5 | 6.1"
 iPhone X, Xs, 11 Pro      | 375 x 812             | 1125 x 2436 | 3x    | 3            | 1125 x 2436     | 458  | 9:19.5 | 5.8"
 --------------------------------------------------------------------------------------------------------------------------------
 iPhone 6+,6s+,7+,8+       | 414 x 736             | 1242 x 2208 | 3x    | 2.608  si-3  | 1080 x 1920     | 401  | 9:16   | 5.5"
 --------------------------------------------------------------------------------------------------------------------------------
 iPhone 6, 6s, 7, 8, SE2   | 375 x 667             |  750 x 1334 | 2x    | 2(2.343750)  |  750 x 1334     | 326  | 9:16   | 4.7"
 iPhone 5, 5s, SE          | 320 x 568             |  640 x 1136 | 2x    | 2            |  640 x 1136     | 326  | 9:16   | 4.0"
 iPhone 4, 4S              | 320 x 480             |  640 x  960 | 2x    | 2            |  640 x  960     | 326  | 2:3    | 3.5"
 iPhone 3GS                | 320 x 480             |  320 x  480 | 1x    | 1            |  320 x  480     | 163  | 2:3    | 3.5"
 
 iPad resolutions quick reference:
  Device                    | Points (UIKit size)   | Pixels      | Scale | Native Scale | Physical Pixels | PPI  | Ratio  | Size
  --------------------------|-----------------------|-------------|-------|--------------|-----------------|------|--------|-----
  iPad Pro 12.9-inch        |                       |             |       |              |                 |      |        |
    1st, 2nd, 3rd, 4th, 5th | 1024 x 1366           | 2048 x 2732 | 2x    | 2            | 2048 x 2732     | 264  | 3:4    | 12.9"
  --------------------------------------------------------------------------------------------------------------------------------
  iPad Pro 11-inch          |                       |             |       |              |                 |      |        |
    1st, 2nd, 3rd           | 834 x 1194            | 1668 x 2388 | 2x    | 2            | 1668 x 2388     | 264  | 3:4    | 11"
  --------------------------------------------------------------------------------------------------------------------------------
  iPad Air 10.9-inch        |                       |             |       |              |                 |      |        |
    4th                     | 820 x 1180            | 1640 x 2360 | 2x    | 2            | 1640 x 2360     | 264  | 16:23  | 10.9"
  --------------------------------------------------------------------------------------------------------------------------------
  iPad 10.5-inch            |                       |             |       |              |                 |      |        |
    Pro 10.5, Air 3rd       | 834 x 1112            | 1668 x 2224 | 2x    | 2            | 1668 x 2224     | 264  | 3:4    | 10.5"
  --------------------------------------------------------------------------------------------------------------------------------
  iPad 10.2-inch            |                       |             |       |              |                 |      |        |
    7th, 8th                | 810 x 1080            | 1620 x 2160 | 2x    | 2            | 1620 x 2160     | 264  | 3:4    | 10.2"
  --------------------------------------------------------------------------------------------------------------------------------
  iPad 9.7-inch Retina      |                       |             |       |              |                 |      |        |
    3rd, 4th, 5th, 6th      | 768 x 1024            | 1536 x 2048 | 2x    | 2            | 1536 x 2048     | 264  | 3:4    | 9.7″
    Air 1st, Air 2nd        |                       |             |       |              |                 |      |        |
    Pro 9.7-inch            |                       |             |       |              |                 |      |        |
  --------------------------------------------------------------------------------------------------------------------------------
  iPad (Legacy)             |                       |             |       |              |                 |      |        |
    1st and 2nd Generation  | 768 x 1024            | 768 x 1024  | 1x    | 1            | 768 x 1024      | 132  | 3:4    | 9.7″
  --------------------------------------------------------------------------------------------------------------------------------
  iPad Mini Retina          |                       |             |       |              |                 |      |        |
    Mini 2nd, 3rd, 4th, 5th | 768 x 1024            | 1536 x 2048 | 2x    | 2            | 1536 x 2048     | 326  | 3:4    | 7.9″
  --------------------------------------------------------------------------------------------------------------------------------
  iPad Mini (Legacy)        |                       |             |       |              |                 |      |        |
    Mini 1st Generation     | 768 x 1024            | 768 x 1024  | 1x    | 1            | 768 x 1024      | 163  | 3:4    | 7.9"
  --------------------------------------------------------------------------------------------------------------------------------

 
 

 Pixels          : 시뮬레이터 픽셀
 Physical Pixels : 실제 디바이스상의 픽셀
 6+      : (Down Sampling : 1.15030675)  디바이스 네이티브 스케일 : 2.608(확대:2.88)
 12 mini : (Down Sampling : 1.04166667)  디바이스 네이티브 스케일 : 2.88(확대:3.375)
*/
