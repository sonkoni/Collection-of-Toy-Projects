//
//  AppDelegate.m
//  MGRLatex
//
//  Created by Kwan Hyun Son on 2021/07/20.
//

#import "AppDelegate.h"

/** Important Note:
    With the application scene life cycle, UIKit no longer calls the following functions on the UIApplicationDelegate.
        - (void)applicationWillEnterForeground:(UIApplication *)application
        - (void)applicationDidEnterBackground:(UIApplication *)application
        - (void)applicationDidBecomeActive:(UIApplication *)application
        - (void)applicationWillResignActive:(UIApplication *)application
    These UISceneDelegate functions replace them:
        - (void)sceneWillEnterForeground:(UIScene *)scene
        - (void)sceneDidEnterBackground:(UIScene *)scene
        - (void)sceneDidBecomeActive:(UIScene *)scene
        - (void)sceneWillResignActive:(UIScene *)scene
 
    If you choose to use the app scene life cycle (opting in with UIApplicationSceneManifest in the Info.plist),
    but still deploy to iOS 12.x, you need both sets of delegate functions.
 */

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
