//
//  MGUAssets.m
//

#import "MGUAssets.h"
@import BaseKit;

@implementation UIColor (Assets)
+ (UIColor *)mgrTestColor {
    return [UIColor colorNamed:MASColorTestColor inBundle:NSBundle.mgrIosRes compatibleWithTraitCollection:nil];
}
@end


@implementation UIImage (Assets)
+ (UIImage *)mgrLogoImage {
    return [UIImage imageNamed:MASImageLogo inBundle:NSBundle.mgrIosRes withConfiguration:nil];
}

+ (UIImage *)mgrTestCornImage {
    return [UIImage imageNamed:MASImageTestCorn inBundle:NSBundle.mgrIosRes withConfiguration:nil];
}
+ (UIImage *)mgrTestPlaySymbol {
    return [UIImage systemImageNamed:MASSymbolTestPlay];
}
@end

@implementation UIFont (Assets)
@end

