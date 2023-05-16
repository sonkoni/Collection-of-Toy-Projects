//
//  SceneDelegate.m
//  IosObjcSample
//
//  Created by Kiro on 2022/11/12.
//

#import "SceneDelegate.h"
#import "MainTableViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {
    [self setupAppearanceProxy];
    if ([scene isKindOfClass:[UIWindowScene class]] == NO) {
        return;
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        NSLog(@"아이패드");
    } else {
        NSLog(@"아이폰!!");
    }
    
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; <- 구형 스타일
    /** 다음과 같은 방식도 가능한 듯.
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc]initWithFrame:windowScene.coordinateSpace.bounds];
    self.window.windowScene = windowScene;
    */
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window.backgroundColor = [UIColor cyanColor];
    MainTableViewController *tv = [MainTableViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tv];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


#pragma mark - Appearance Proxy
- (void)setupAppearanceProxy {
    UIColor *barColor = [UIColor colorWithRed:49.0/255.0 green:186.0/255.0 blue:81.0/255.0 alpha:1.0];
    if (@available(iOS 13, *)) {
        UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
        appearance.backgroundColor = barColor; // 내비게이션 바 자체 색
        appearance.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura" size:18.0], NSForegroundColorAttributeName : UIColor.whiteColor}; // 가운데 타이틀 색
        appearance.shadowColor = UIColor.clearColor;
        
        UIBarButtonItemAppearance *backButtonAppearance  = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
        backButtonAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.blueColor};
        appearance.backButtonAppearance = backButtonAppearance;
        UIImage *backIndicatorImage = [appearance.backIndicatorImage.copy imageWithTintColor:UIColor.blueColor
                                                                               renderingMode:UIImageRenderingModeAlwaysOriginal];
        [appearance setBackIndicatorImage:backIndicatorImage transitionMaskImage:backIndicatorImage];
        
//        [appearance configureWithOpaqueBackground];
//        [appearance configureWithTransparentBackground];
//        [appearance configureWithDefaultBackground];
        [UINavigationBar appearance].standardAppearance = appearance;
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].compactAppearance = appearance;
        if (@available(iOS 15, *)) {
            [UINavigationBar appearance].compactScrollEdgeAppearance = appearance;
        }
    } else {
        [UINavigationBar appearance].barTintColor = barColor; // 내비게이션 바 자체 색
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor}; // 가운데 타이틀 색
        [UINavigationBar appearance].largeTitleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor}; // 가운데 타이틀 색
        [UINavigationBar appearance].shadowImage = UIImage.new; // 내비게이션 바의 경계를 감춘다.
    }
}

@end
//
// - (void)sceneDidDisconnect:(UIScene *)scene {}
// - (void)sceneDidBecomeActive:(UIScene *)scene {}
// - (void)sceneWillResignActive:(UIScene *)scene {}
// - (void)sceneWillEnterForeground:(UIScene *)scene {}
// - (void)sceneDidEnterBackground:(UIScene *)scene {}
