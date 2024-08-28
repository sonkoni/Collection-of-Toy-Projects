//
//  SceneDelegate.m
//  OutlineProject
//
//  Created by Kwan Hyun Son on 2021/07/20.
//

#import "SceneDelegate.h"
#import "MainTableViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

// 이 메서드를 이용하여 UIWindow`window`를 제공된 UIWindowScene`scene`에 선택적으로 구성하고 연결한다.
// 스토리 보드를 사용하는 경우`window` 프라퍼티가 자동으로 초기화되어 scene에 부착된다.
// 이 델리게이트는 connecting scene 또는 session이 new임을 의미하지 않는다
// (application:configurationForConnectingSceneSession 메서드를 참고하라).
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if ([scene isKindOfClass:[UIWindowScene class]] == NO) {
        return;
    }
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.window.backgroundColor = [UIColor cyanColor];
    
    MainTableViewController *tv = [[MainTableViewController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tv];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene {}
- (void)sceneDidBecomeActive:(UIScene *)scene {}
- (void)sceneWillResignActive:(UIScene *)scene {}
- (void)sceneWillEnterForeground:(UIScene *)scene {}
- (void)sceneDidEnterBackground:(UIScene *)scene {}

@end
