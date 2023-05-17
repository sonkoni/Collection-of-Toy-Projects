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
    return [NSColor colorNamed:MASColorTestColor bundle:NSBundle.mgrMacRes];
}
@end

@implementation NSImage (Assets)
+ (NSImage *)mgrLogoImage {
    return [NSBundle.mgrMacRes imageForResource:MASImageLogo];
}

+ (NSImage *)mgrTestSunflowerImage {
    return [NSBundle.mgrMacRes imageForResource:MASImageTestSunflower];
}
+ (NSImage *)mgrTestStopSymbol {
    return [NSImage imageWithSystemSymbolName:MASSymbolTestStop accessibilityDescription:@"play"];
}
@end

@implementation NSFont (Assets)
@end
