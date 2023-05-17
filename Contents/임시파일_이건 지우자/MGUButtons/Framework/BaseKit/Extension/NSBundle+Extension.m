//
//  NSBundle+Base.m
//  Created by Kiro on 2022/11/09.
//

#import "NSBundle+Extension.h"

static NSURL * _Nullable BundleURLFor(NSString *res) {
    NSURL *bundleUrl = [[NSBundle mainBundle] URLForResource:res withExtension:@"bundle"];
    if (!bundleUrl) {
        bundleUrl = [[[NSBundle mainBundle] builtInPlugInsURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", res]];
    }
    NSCAssert(bundleUrl, @"지정된 경로에 번들이 없다. 킷 번들 Embed 확인해봐");
    return bundleUrl;
}

@implementation NSBundle (KitResource)
#if TARGET_OS_OSX
+ (NSBundle *)mgrMacRes {
    static id _bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bundle = [NSBundle bundleWithURL:BundleURLFor(@"MacRes")];
    });
    return _bundle;
}
#elif TARGET_OS_IPHONE
+ (NSBundle *)mgrIosRes {
    static id _bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bundle = [NSBundle bundleWithURL:BundleURLFor(@"IosRes")];
    });
    return _bundle;
}
#endif
@end




#if TARGET_OS_OSX
#import <TargetConditionals.h>
#import <AppKit/AppKit.h>
#endif

@implementation NSBundle (Extension)

#if TARGET_OS_OSX
- (NSString *)mgrAppName {
//  localized 된 CFBundleDisplayName 값이있는 경우 이를 리턴하고 그렇지 않으면 CFBundleName 값으로 대체된다.
    NSString *appName = [NSRunningApplication currentApplication].localizedName;
//    NSString *appName = infoDictionary[@"CFBundleDisplayName"];
//    if (appName == nil) {
//        appName = infoDictionary[@"CFBundleName"];
//    }
    if (appName == nil) {
        appName = [self objectForInfoDictionaryKey:@"CFBundleExecutable"]; // appName = self.infoDictionary[@"CFBundleExecutable"];
    }
    if (appName == nil) {
      appName = @"<Unknown App Name>";
    }
    
    return appName;
}
#endif

@end
