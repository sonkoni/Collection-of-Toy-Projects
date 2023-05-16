//
//  MGAAssets.m
//  MacKit
//
//  Created by Kiro on 2022/11/15.
//

#import "MGAAssets.h"
@import BaseKit;

@implementation NSColor (Assets)
+ (NSColor *)mgrTestColor {
    return [NSColor colorNamed:MARColorTestColor bundle:NSBundle.mgrMacRes];
}
@end

@implementation NSImage (Assets)
+ (NSImage *)mgrLogoImage {
    return [NSBundle.mgrMacRes imageForResource:MARImageLogo];
}

+ (NSImage *)mgrTestSunflowerImage {
    return [NSBundle.mgrMacRes imageForResource:MARImageTestSunflower];
}
+ (NSImage *)mgrTestStopSymbol {
    return [NSImage imageWithSystemSymbolName:MARSymbolTestStop accessibilityDescription:@"play"];
}
@end

@implementation NSFont (Assets)
@end
