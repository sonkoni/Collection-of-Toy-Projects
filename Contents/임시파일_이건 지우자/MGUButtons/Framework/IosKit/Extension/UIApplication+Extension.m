//
//  UIApplication+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "UIApplication+Extension.h"

@implementation UIApplication (Extension)

+ (UIWindow *)mgrKeyWindow {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 150000 // Deployment Target 이 15.0이다. 기계가 15 이상부터 다 들어온다.
    NSSet <UIWindowScene *>*scenes = (NSSet <UIWindowScene *>*)[UIApplication sharedApplication].connectedScenes;
    if (scenes.count <= 0) {
        NSCAssert(FALSE, @"찾을 수 없다.");
        return nil;
    }
    __block UIWindow *myWindow;
    [scenes enumerateObjectsUsingBlock:^(UIWindowScene *windowScene, BOOL *stop) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            if ([windowScene isKindOfClass:[UIWindowScene class]] == YES) {
                [windowScene.windows enumerateObjectsUsingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                    if (window.isKeyWindow  == YES) {
                        myWindow = window;
                        *stop = YES;
                    }
                }];
            }
        }
    }];
    if (myWindow != nil) {
        return myWindow;
    }
    
    UIWindow *result = scenes.anyObject.windows.firstObject;
    if (result != nil) {
        return result;
    } else {
        NSCAssert(FALSE, @"찾을 수 없다.");
        return nil;
    }
#else
    // Deployment Target 이 15 미만의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    NSArray <__kindof UIWindow *>*windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        if (window.isKeyWindow == YES) {
            return window; // first match 된 윈도우를 반환하고 검색 중지
        }
    }
    
    if (windows.firstObject != nil) {
        return windows.firstObject;
    }
    NSAssert(false, @"keyWindow를 찾지 못했다. 맙소사.");

    return nil;
#endif
}

+ (nullable __kindof UIViewController *)mgrTopViewController:(nullable __kindof UIViewController *)viewController {
    
    if (viewController == nil) {
        UIWindow *window = [UIApplication mgrKeyWindow];
        if (window != nil) {
            viewController = window.rootViewController;
        }
    }
    
    if ( [viewController isKindOfClass:[UINavigationController class]] == YES ) {
        return [UIApplication mgrTopViewController:[(UINavigationController *)viewController visibleViewController]];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]] == YES) {
        __kindof UIViewController *selectedViewController = [(UITabBarController *)viewController selectedViewController];
        if (selectedViewController != nil) {
            return [UIApplication mgrTopViewController:selectedViewController];
        }
    }
    
    if (viewController.presentedViewController != nil) {
        return [UIApplication mgrTopViewController:viewController.presentedViewController];
    }
    
    return viewController;
    
}

+ (CGFloat)mgrStatusBarHeight {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000  // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다.
    return [UIApplication mgrKeyWindow].windowScene.statusBarManager.statusBarFrame.size.height;
#else
    // Deployment Target 이 13 이하의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 13.0, *)) {
        return [UIApplication mgrKeyWindow].windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
#endif
}

+ (CGFloat)mgrScreenShortLength {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return MIN(size.width, size.height);
}

+ (CGFloat)mgrScreenLongLength {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return MAX(size.width, size.height);
}

+ (UIInterfaceOrientation)mgrInterfaceOrientation {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000 // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다.
    UIWindow *keyWindow = [UIApplication mgrKeyWindow]; // 카테고리 사용함.
    return keyWindow.windowScene.interfaceOrientation;
#else
    // Deployment Target 이 13 이하의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 13, *)) {
        UIWindow *keyWindow = [UIApplication mgrKeyWindow]; // 카테고리 사용함.
        return keyWindow.windowScene.interfaceOrientation;
    } else {
        return [UIApplication sharedApplication].statusBarOrientation;
    }
#endif
}

// 기계장치(아이폰, 아이패드)의 위치를 인식하는 메서드이다.
// 만약 기계장치(내 아이폰)를 세로고정으로 하면 무조건 포트레잇으로 인식한다.
// 기계장치를 세로고정하지 않고(중력을 인식하게 했을 때), 앱을 세로고정으로 만들어도 방향은 인식할 수 있다.
+ (UIDeviceOrientation)mgrDeviceOrientation {
    // 내가 앱을 만들 때, 포트레잇으로 고정을 했다고 하더라도, 그거와 관계 없이 현재 기계 장치의 방향을 알려준다.
    // 대신에 실제 기계에서 위치고정을 하는 것은 언제나 기계장치가 포트레잇으로 인식하겠다는 뜻이므로 그때에는 기계를 돌려도 포트레잇이다.
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    switch (orientation) {
        case UIDeviceOrientationUnknown: {
            NSLog(@"기계가 어느 방향인지 모를때");
            break;
        }
        case UIDeviceOrientationPortrait: {
            NSLog(@"그냥 포트레잇");
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            NSLog(@"뒤집힌 포트레잇");
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            NSLog(@"랜드스케이프 홈버튼 오른쪽");
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            NSLog(@"랜드스케이프 홈버튼 왼쪽");
            break;
        }
        case UIDeviceOrientationFaceUp: {
            NSLog(@"니가 탁자에 아이폰을 놓고 위에서 본다고 생각해");
            break;
        }
        case UIDeviceOrientationFaceDown: {
            NSLog(@"니가 침대에 누워서 아이폰을 천장에 놓고 본다고 생각해");
            break;
        }
        default:
            break;
    }

    return orientation;
}

@end

/**
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

-(void)OrientationDidChange:(NSNotification*)notification
{
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];

    if(Orientation==UIDeviceOrientationLandscapeLeft || Orientation==UIDeviceOrientationLandscapeRight)
    {
    }
    else if(Orientation==UIDeviceOrientationPortrait)
    {
    }
}

***/
