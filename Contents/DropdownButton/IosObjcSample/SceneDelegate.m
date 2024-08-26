//
//  SceneDelegate.m
//  MGRLatex
//
//  Created by Kwan Hyun Son on 2021/07/20.
//

#import "SceneDelegate.h"
#import "MainTableViewController.h"

@interface SceneDelegate ()

@end


//! info.plist에서 Main 관련 스토리 보드에 대한 탭을 2개 삭제하라. 하나는 숨겨져 있다.
//! Project 화면에서 Requires full screen을 체크하자.

@implementation SceneDelegate

// 이 메서드를 이용하여 UIWindow`window`를 제공된 UIWindowScene`scene`에 선택적으로 구성하고 연결한다.
// 스토리 보드를 사용하는 경우`window` 프라퍼티가 자동으로 초기화되어 scene에 부착된다.
// 이 델리게이트는 connecting scene 또는 session이 new임을 의미하지 않는다
// (application:configurationForConnectingSceneSession 메서드를 참고하라).
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
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
    /* self.window 에서도 확인가능.
    if (self.window.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        NSLog(@"아이패드");
    } else {
        NSLog(@"아이패드");
    }
    */
    
    MainTableViewController *tv = [MainTableViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tv];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}
- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}
- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}
- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}
- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

- (void)setupAppearanceProxy {
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    appearance.backgroundColor = [UIColor systemYellowColor];
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
//    [UINavigationBar appearance].translucent = NO;
   
    //[UINavigationBar appearance].barStyle = UIBarStyleBlack; // 이렇게 하면 promptView의 텍스트 색이 흰색이 된다.
    //[UILabel appearanceWhenContainedInInstancesOfClasses:@[NSClassFromString(@"_UINavigationBarModernPromptView")]].textColor = [UIColor whiteColor];
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];  Use -[UIViewController prefersStatusBarHidden]
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; Use -[UIViewController preferredStatusBarStyle]
}

@end


