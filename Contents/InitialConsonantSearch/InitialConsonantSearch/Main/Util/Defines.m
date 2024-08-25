//
//  Defines.m
//  IndicatorSettingsTest
//
//  Created by Kwan Hyun Son on 10/12/23.
//

#import "Defines.h"

@interface Defines ()

@end

@implementation Defines

+ (UIImage * _Nullable)imageNamed:(DefinesImageName)imageName
           imageWithRenderingMode:(UIImageRenderingMode)renderingMode {
    NSBundle *designTimeBundle = [NSBundle bundleForClass:[Defines class]];
    UIImage *result = [UIImage imageNamed:imageName inBundle:designTimeBundle compatibleWithTraitCollection:nil];
    result = [result imageWithRenderingMode:renderingMode];
    return result;
}

@end
