//
//  CALayer+Filters.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "CALayer+Filters.h"
#import <CoreImage/CoreImage.h>
//#import <CoreImage/CIFilter.h>
//#import <CoreImage/CIFilterBuiltins.h>

CompositeOperation const additionCompositing = @"additionCompositing";
CompositeOperation const multiplyBlendMode = @"multiplyBlendMode";
CompositeOperation const multiplyCompositing = @"multiplyCompositing";
CompositeOperation const maximumCompositing = @"maximumCompositing";
CompositeOperation const minimumCompositing = @"minimumCompositing";
CompositeOperation const darkenBlendMode = @"darkenBlendMode";
CompositeOperation const colorBurnBlendMode = @"colorBurnBlendMode";
CompositeOperation const linearBurnBlendMode = @"linearBurnBlendMode";
CompositeOperation const lightenBlendMode = @"lightenBlendMode";
CompositeOperation const screenBlendMode = @"screenBlendMode";
CompositeOperation const colorDodgeBlendMode = @"colorDodgeBlendMode";
CompositeOperation const linearDodgeBlendMode = @"linearDodgeBlendMode";
CompositeOperation const pinLightBlendMode = @"pinLightBlendMode";
CompositeOperation const overlayBlendMode = @"overlayBlendMode";
CompositeOperation const softLightBlendMode = @"softLightBlendMode";
CompositeOperation const hardLightBlendMode = @"hardLightBlendMode";
CompositeOperation const differenceBlendMode = @"differenceBlendMode";
CompositeOperation const exclusionBlendMode = @"exclusionBlendMode";
CompositeOperation const subtractBlendMode = @"subtractBlendMode";
CompositeOperation const divideBlendMode = @"divideBlendMode";
CompositeOperation const hueBlendMode = @"hueBlendMode";
CompositeOperation const saturationBlendMode = @"saturationBlendMode";
CompositeOperation const colorBlendMode = @"colorBlendMode";
CompositeOperation const luminosityBlendMode = @"luminosityBlendMode";
CompositeOperation const sourceAtopCompositing = @"sourceAtopCompositing";
CompositeOperation const sourceOverCompositing = @"sourceOverCompositing";
CompositeOperation const sourceOutCompositing = @"sourceOutCompositing";
CompositeOperation const sourceInCompositing = @"sourceInCompositing";

#if TARGET_OS_OSX
CICategoryCompositeOperation const CIAdditionCompositing = @"CIAdditionCompositing";
CICategoryCompositeOperation const CIColorBlendMode = @"CIColorBlendMode";
CICategoryCompositeOperation const CIColorBurnBlendMode = @"CIColorBurnBlendMode";
CICategoryCompositeOperation const CIColorDodgeBlendMode = @"CIColorDodgeBlendMode";
CICategoryCompositeOperation const CIDarkenBlendMode = @"CIDarkenBlendMode";
CICategoryCompositeOperation const CIDifferenceBlendMode = @"CIDifferenceBlendMode";
CICategoryCompositeOperation const CIDivideBlendMode = @"CIDivideBlendMode";
CICategoryCompositeOperation const CIExclusionBlendMode = @"CIExclusionBlendMode";
CICategoryCompositeOperation const CIHardLightBlendMode = @"CIHardLightBlendMode";
CICategoryCompositeOperation const CIHueBlendMode = @"CIHueBlendMode";
CICategoryCompositeOperation const CILightenBlendMode = @"CILightenBlendMode";
CICategoryCompositeOperation const CILinearBurnBlendMode = @"CILinearBurnBlendMode";
CICategoryCompositeOperation const CILinearDodgeBlendMode = @"CILinearDodgeBlendMode";
CICategoryCompositeOperation const CILuminosityBlendMode = @"CILuminosityBlendMode";
CICategoryCompositeOperation const CIMaximumCompositing = @"CIMaximumCompositing";
CICategoryCompositeOperation const CIMinimumCompositing = @"CIMinimumCompositing";
CICategoryCompositeOperation const CIMultiplyBlendMode = @"CIMultiplyBlendMode";
CICategoryCompositeOperation const CIMultiplyCompositing = @"CIMultiplyCompositing";
CICategoryCompositeOperation const CIOverlayBlendMode = @"CIOverlayBlendMode";
CICategoryCompositeOperation const CIPinLightBlendMode = @"CIPinLightBlendMode";
CICategoryCompositeOperation const CISaturationBlendMode = @"CISaturationBlendMode";
CICategoryCompositeOperation const CIScreenBlendMode = @"CIScreenBlendMode";
CICategoryCompositeOperation const CISoftLightBlendMode = @"CISoftLightBlendMode";
CICategoryCompositeOperation const CISourceAtopCompositing = @"CISourceAtopCompositing";
CICategoryCompositeOperation const CISourceInCompositing = @"CISourceInCompositing";
CICategoryCompositeOperation const CISourceOutCompositing = @"CISourceOutCompositing";
CICategoryCompositeOperation const CISourceOverCompositing = @"CISourceOverCompositing"; // 디폴트 또는 nil
CICategoryCompositeOperation const CISubtractBlendMode = @"CISubtractBlendMode";
#endif


static NSString *superlayer = @"superlayer";

@implementation CALayer (Filters)

- (void)mgrApplyCompositingFilter:(CompositeOperation)compositeOperation {
#if TARGET_OS_OSX
    self.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.compositingFilter = compositeOperation;
#elif TARGET_OS_IPHONE
    self.contentsScale = [UIScreen mainScreen].scale;
    self.compositingFilter = compositeOperation; // ios에서는 이렇게 사용함.
#endif
}


#if TARGET_OS_OSX
// self.compositingFilter = [CIFilter overlayBlendModeFilter]; 이거와 효과가 같은 것 같다.
// #import <CoreImage/CIFilterBuiltins.h> 존재
- (void)mgrApplyCompositingFilterOSX:(CICategoryCompositeOperation)compositeOperation {
    self.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    self.compositingFilter = [CIFilter filterWithName:compositeOperation];
}

+ (CALayer *)mgrFilterLayerWithCompositeOperation:(CICategoryCompositeOperation)compositeOperation
                                            color:(NSColor *)color
                                    masksToBounds:(BOOL)masksToBounds {
    
    CALayer *resultLayer = [CALayer layer];
    resultLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    resultLayer.backgroundColor = color.CGColor;
    resultLayer.masksToBounds = masksToBounds;
    CIFilter *filter = [CIFilter filterWithName:compositeOperation];
    resultLayer.compositingFilter = filter;
    return resultLayer;
}

NSArray <CICategoryCompositeOperation>* MGRCategoryCompositeOperations(void) {
    return @[CIAdditionCompositing,
             CIColorBlendMode,
             CIColorBurnBlendMode,
             CIColorDodgeBlendMode,
             CIDarkenBlendMode,
             CIDifferenceBlendMode,
             CIDivideBlendMode,
             CIExclusionBlendMode,
             CIHardLightBlendMode,
             CIHueBlendMode,
             CILightenBlendMode,
             CILinearBurnBlendMode,
             CILinearDodgeBlendMode,
             CILuminosityBlendMode,
             CIMaximumCompositing,
             CIMinimumCompositing,
             CIMultiplyBlendMode,
             CIMultiplyCompositing,
             CIOverlayBlendMode,
             CIPinLightBlendMode,
             CISaturationBlendMode,
             CIScreenBlendMode,
             CISoftLightBlendMode,
             CISourceAtopCompositing,
             CISourceInCompositing, //! 내가 찾는것.
             CISourceOutCompositing,
             CISourceOverCompositing, // 디폴트 또는 nil
             CISubtractBlendMode];
}
#endif
@end

