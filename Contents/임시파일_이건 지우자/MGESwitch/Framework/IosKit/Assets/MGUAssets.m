//
//  MGUAssets.m
//

#import "MGUAssets.h"
@import BaseKit;

@implementation UIColor (Assets)
+ (UIColor *)mgrTestColor {
    return [UIColor colorNamed:MARColorTestColor inBundle:NSBundle.mgrIosRes compatibleWithTraitCollection:nil];
}
@end


@implementation UIImage (Assets)
+ (UIImage *)mgrLogoImage {
    return [UIImage imageNamed:MARImageLogo inBundle:NSBundle.mgrIosRes withConfiguration:nil];
}

+ (UIImage *)mgrTestCornImage {
    return [UIImage imageNamed:MARImageTestCorn inBundle:NSBundle.mgrIosRes withConfiguration:nil];
}
+ (UIImage *)mgrTestPlaySymbol {
    return [UIImage systemImageNamed:MARSymbolTestPlay];
}
@end

@implementation UIFont (Assets)
@end

