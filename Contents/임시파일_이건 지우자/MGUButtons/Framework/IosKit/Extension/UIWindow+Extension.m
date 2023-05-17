//
//  UIWindow+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIWindow+Extension.h"
#import <BaseKit/BaseKit.h>

@implementation UIWindow (Standard)

+ (UIWindow *)mgrKeyWindow {
    NSInteger (^sortPriorityBlock)(UISceneActivationState) = ^NSInteger(UISceneActivationState state) {
        if (state == UISceneActivationStateForegroundActive) {
            return 1;
        } else if (state == UISceneActivationStateForegroundInactive) {
            return 2;
        } else if (state == UISceneActivationStateBackground) {
            return 3;
        } else if (state == UISceneActivationStateUnattached) {
            return 4;
        }
        return 5;
    };
    
    NSSet <UIScene *>*connectedScenes = [UIApplication sharedApplication].connectedScenes;
    NSArray <UIScene *>*sorted = [connectedScenes.allObjects sortedArrayUsingComparator:^NSComparisonResult(UIScene *obj1, UIScene *obj2) {
        NSInteger priority1 = sortPriorityBlock(obj1.activationState);
        NSInteger priority2 = sortPriorityBlock(obj2.activationState);
        return [@(priority1) compare:@(priority2)];
    }];
    
    NSArray <UIWindowScene *>*windowScenes = (NSArray <UIWindowScene *>*)[sorted mgrFilter:^BOOL(UIScene *obj) {
        if ([obj isKindOfClass:[UIWindowScene class]]) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    NSArray <UIWindow *>*windows = [windowScenes mgrMap:^id (UIWindowScene *obj) {
        UIWindow *window = obj.windows.firstObject;
        if (window.isKeyWindow == YES) {
            return window;
        } else {
            return nil;
        }
    }];
    
    return windows.firstObject;
}


#if TARGET_OS_SIMULATOR && TARGET_OS_IPHONE // 아이폰, 아이패드 시뮬레이터

+ (instancetype)mgrStandardWindow { // 시뮬레이터에서는 Down Scaling이 없다.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat nativeScale = [UIScreen mainScreen].nativeScale;

    if (ABS(scale - nativeScale) < FLT_EPSILON) { // 아마도 0일 것이다. 표준 모드이다.
        return [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }

    // 확대 모드를 의미한다.
    CGFloat zoomRatio = scale / nativeScale;
    CGFloat inverseZoomRatio = 1.0 / zoomRatio;

    CGSize size = CGSizeMake(screenSize.width * inverseZoomRatio, screenSize.height * inverseZoomRatio);
    CGPoint origin = CGPointMake(-((size.width - screenSize.width) /2.0), -((size.height - screenSize.height) /2.0));
    CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectIntegral(rect)];
    window.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomRatio, zoomRatio, 1.0);
    window.layer.contentsScale = [UIScreen mainScreen].scale;      // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.rasterizationScale = [UIScreen mainScreen].scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.shouldRasterize = YES;
    return window;
}

+ (instancetype)mgrStandardWindowWithWindowScene:(UIWindowScene *)scene {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:scene];
    
    // 시뮬레이터에서는 Down Scaling이 없다.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat nativeScale = [UIScreen mainScreen].nativeScale;

    if (ABS(scale - nativeScale) < FLT_EPSILON) { // 아마도 0일 것이다. 표준 모드이다.
        return window;
    }

    // 확대 모드를 의미한다.
    CGFloat zoomRatio = scale / nativeScale;
    CGFloat inverseZoomRatio = 1.0 / zoomRatio;

    CGSize size = CGSizeMake(screenSize.width * inverseZoomRatio, screenSize.height * inverseZoomRatio);
    CGPoint origin = CGPointMake(-((size.width - screenSize.width) /2.0), -((size.height - screenSize.height) /2.0));
    CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
    window.frame = CGRectIntegral(rect);
    window.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomRatio, zoomRatio, 1.0);
    window.layer.contentsScale = [UIScreen mainScreen].scale;      // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.rasterizationScale = [UIScreen mainScreen].scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.shouldRasterize = YES;
    return window;
}

#else // 실제 기계
+ (instancetype)mgrStandardWindow { // 실제 기계에서는 Down Scaling이 존재한다. 6+ 종류. 12 mini
    //! nativeBounds은 Portrait 기준으로 뱉어준다.
    CGSize nativeSize = [UIScreen mainScreen].nativeBounds.size;
    
    BOOL iPhone12Mini = NO;
    BOOL iPhone6PLUS = NO;
    if (ABS(nativeSize.width - 1080.0) < FLT_EPSILON &&
        ABS(nativeSize.height - 2340.0) < FLT_EPSILON) {
        iPhone12Mini = YES;
    } else if (ABS(nativeSize.width - 1080.0) < FLT_EPSILON &&
               ABS(nativeSize.height - 1920.0) < FLT_EPSILON) {
        iPhone6PLUS = YES;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat nativeScale = [UIScreen mainScreen].nativeScale;

    CGFloat zoomRatio = scale / nativeScale;
    // Normal
    if (iPhone6PLUS == YES) {
        zoomRatio = zoomRatio / 1.15030675; // 6+ 종류. 약 1.15 (이 값은 표준모드에서 scale / nativeScale), 정확한 값으로 계산해야한다.
        if (ABS(zoomRatio - 1.0) < FLT_EPSILON) {
            return [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    } else if (iPhone12Mini == YES) {
        zoomRatio = zoomRatio / 1.04166667; // mini 약. 1.04 (이 값은 표준모드에서 scale / nativeScale), 정확한 값으로 계산해야한다.
        if (ABS(zoomRatio - 1.0) < FLT_EPSILON) {
            return [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    } else { // Down Scale 되지 않는 나머지 기기들.
        if (ABS(scale - nativeScale) < FLT_EPSILON) { // 아마도 0일 것이다. 표준 모드이다.
            return [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
    }
    
    CGFloat inverseZoomRatio = 1.0 / zoomRatio;
    
    CGSize size = CGSizeMake(screenSize.width * inverseZoomRatio, screenSize.height * inverseZoomRatio);
    CGPoint origin = CGPointMake(-((size.width - screenSize.width) /2.0), -((size.height - screenSize.height) /2.0));
    CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectIntegral(rect)];
    window.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomRatio, zoomRatio, 1.0);
    window.layer.contentsScale = [UIScreen mainScreen].scale;      // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.rasterizationScale = [UIScreen mainScreen].scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.shouldRasterize = YES;
    return window;
}

+ (instancetype)mgrStandardWindowWithWindowScene:(UIWindowScene *)scene {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:scene];
    // 실제 기계에서는 Down Scaling이 존재한다. 6+ 종류. 12 mini
    //! nativeBounds은 Portrait 기준으로 뱉어준다.
    CGSize nativeSize = [UIScreen mainScreen].nativeBounds.size;
       
    BOOL iPhone12Mini = NO;
    BOOL iPhone6PLUS = NO;
    if (ABS(nativeSize.width - 1080.0) < FLT_EPSILON &&
        ABS(nativeSize.height - 2340.0) < FLT_EPSILON) {
        iPhone12Mini = YES;
    } else if (ABS(nativeSize.width - 1080.0) < FLT_EPSILON &&
                ABS(nativeSize.height - 1920.0) < FLT_EPSILON) {
        iPhone6PLUS = YES;
    }
       
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat nativeScale = [UIScreen mainScreen].nativeScale;

    CGFloat zoomRatio = scale / nativeScale;
    
    // Normal
    if (iPhone6PLUS == YES) {
        zoomRatio = zoomRatio / 1.15030675; // 6+ 종류. 약 1.15 (이 값은 표준모드에서 scale / nativeScale), 정확한 값으로 계산해야한다.
        if (ABS(zoomRatio - 1.0) < FLT_EPSILON) {
            return window;
        }
    } else if (iPhone12Mini == YES) {
        zoomRatio = zoomRatio / 1.04166667; // mini 약. 1.04 (이 값은 표준모드에서 scale / nativeScale), 정확한 값으로 계산해야한다.
        if (ABS(zoomRatio - 1.0) < FLT_EPSILON) {
            return window;
        }
    } else { // Down Scale 되지 않는 나머지 기기들.
        if (ABS(scale - nativeScale) < FLT_EPSILON) { // 아마도 0일 것이다. 표준 모드이다.
            return window;
        }
    }
       
    CGFloat inverseZoomRatio = 1.0 / zoomRatio;
    
    CGSize size = CGSizeMake(screenSize.width * inverseZoomRatio, screenSize.height * inverseZoomRatio);
    CGPoint origin = CGPointMake(-((size.width - screenSize.width) /2.0), -((size.height - screenSize.height) /2.0));
    CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
    
    window.frame = CGRectIntegral(rect);
    window.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomRatio, zoomRatio, 1.0);
    window.layer.contentsScale = [UIScreen mainScreen].scale;      // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.rasterizationScale = [UIScreen mainScreen].scale; // 다른 layer의 스케일이 아닌 스크린 것을 가져오자.
    window.layer.shouldRasterize = YES;
    return window;
}

#endif
@end


/** 구형 코드. 불완전하다 iPhone 12 mini 도 대응 시켜야됨. Down Scaling 또 발생했음.
// Private: Device Macro
// 1.15030675 <- 6+
// 1.04166667 <- 12 mini
#define IS_6PLUS_SIZE      (((UIScreen.mainScreen.nativeScale > 2.6) && (UIScreen.mainScreen.nativeScale < 2.9)) ? 1.15 : 1.0)
#define ZOOM_RATIO         ((UIScreen.mainScreen.scale / IS_6PLUS_SIZE) / (UIScreen.mainScreen.nativeScale))
#define INVERSE_ZOOM_RATIO ((1.0)/ (ZOOM_RATIO))


+ (instancetype)mgrStandardWindow {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize size = CGSizeMake(screenSize.width * INVERSE_ZOOM_RATIO, screenSize.height * INVERSE_ZOOM_RATIO);
    CGPoint origin = CGPointMake(-((size.width - screenSize.width) /2.0), -((size.height - screenSize.height) /2.0));
    CGRect rect = (CGRect){(CGPoint)origin, (CGSize)size};
    
    // window
    UIWindow *window = [[UIWindow alloc] initWithFrame:rect];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 130000 // Deployment Target 이 13.0이다. 기계가 13 이상부터 다 들어온다.
    window.backgroundColor = [UIColor systemBackgroundColor];
#else
    // Deployment Target 이 13 이하의 어떤 수(예 : 11.0) 11 이상부터의 모든 기계가 들어온다.
    if (@available(iOS 13, *)) {
        window.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        window.backgroundColor = [UIColor cyanColor];
    }
#endif
    
    window.transform = CGAffineTransformMakeScale(ZOOM_RATIO, ZOOM_RATIO);
    return window;
}

#undef IS_6PLUS_SIZE
#undef ZOOM_RATIO
#undef INVERSE_ZOOM_RATIO
 */
