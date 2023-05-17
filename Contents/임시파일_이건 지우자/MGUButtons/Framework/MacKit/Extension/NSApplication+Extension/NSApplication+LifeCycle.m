//
//  NSApplication+LifeCycle.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSApplication+LifeCycle.h"

@implementation NSApplication (LifeCycle)

+ (void)mgrRelaunch {
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 101500 // Deployment Target 이 10.15이다. 기계가 10.15 이상부터 다 들어온다.
    NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration new];
    configuration.createsNewApplicationInstance = YES;
    [sharedWorkspace openApplicationAtURL:[NSBundle mainBundle].bundleURL
                            configuration:configuration
                        completionHandler:^(NSRunningApplication *app, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSApp terminate:nil];
        });
    }];
#else
    // Deployment Target 이 10.15 미만의 어떤 수(예 : 10.08) 10.08 이상부터의 모든 기계가 들어온다.
    if (@available(macOS 10.15, *)) {
        NSWorkspaceOpenConfiguration *configuration = [NSWorkspaceOpenConfiguration new];
        configuration.createsNewApplicationInstance = YES;
        [sharedWorkspace openApplicationAtURL:[NSBundle mainBundle].bundleURL
                                configuration:configuration
                            completionHandler:^(NSRunningApplication *app, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSApp terminate:nil];
            });
        }];
    } else {
        [sharedWorkspace launchAppWithBundleIdentifier:[NSBundle mainBundle].bundleIdentifier
                                               options:NSWorkspaceLaunchNewInstance
                        additionalEventParamDescriptor:nil
                                      launchIdentifier:nil];
        
        [NSApp terminate:nil];
    }
#endif
}
@end
