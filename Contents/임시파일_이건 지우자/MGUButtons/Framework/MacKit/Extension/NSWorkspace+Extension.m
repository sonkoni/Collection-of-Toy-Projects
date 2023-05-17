//
//  NSWorkspace+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSWorkspace+Extension.h"

@implementation NSWorkspace (Extension)

+ (void)mgrLaunchWithIdentifier:(MGRAppBundleIdentifier)identifier {
    BOOL isAlreadyRunning = NO;
    NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
    NSArray <NSRunningApplication *>*runningApplications = sharedWorkspace.runningApplications;
    for (NSRunningApplication *app in runningApplications) {
        NSString *bundleIdentifier = app.bundleIdentifier;
        if ([bundleIdentifier isEqualToString:identifier] == YES) {
            isAlreadyRunning = YES;
            break;
        }
    }
    if (isAlreadyRunning == NO) {
        NSURL *url = [sharedWorkspace URLForApplicationWithBundleIdentifier:identifier];
        if (url == nil) {
            return;
        }
        
        NSWorkspaceOpenConfiguration *configuration= [NSWorkspaceOpenConfiguration configuration];
        NSString *path = @"/bin";
        configuration.arguments = @[path];
        [sharedWorkspace openApplicationAtURL:url
                                configuration:configuration
                            completionHandler:nil];
        // [sharedWorkspace launchApplication:path];
    }
}


+ (void)mgrLaunchFinderWithFilePath:(NSString *)filePath {
    [[NSWorkspace sharedWorkspace] selectFile:filePath inFileViewerRootedAtPath:@""];
}

@end
