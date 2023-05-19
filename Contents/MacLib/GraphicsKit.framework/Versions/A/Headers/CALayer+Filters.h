//
//  CALayer+Filters.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-05
//  ----------------------------------------------------------------------
//
// https://developer.apple.com/documentation/quartzcore/calayer/1410748-compositingfilter
// https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/uid/TP30000136-SW71
// http://wiki.mulgrim.net/page/Api:Core_Animation/CALayer/compositingFilter
// https://stackoverflow.com/questions/16407396/how-to-get-multiply-blend-mode-on-a-plain-uiview-not-uiimage
// https://stackoverflow.com/questions/61732692/blend-uiview-overlay-with-app-background
// https://github.com/arthurschiller/CompositingFilters
// https://github.com/dagronf/CIFilterFactory

#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CIFilter.h>
#import <CoreImage/CIFilterBuiltins.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_OSX
typedef NSString * CICategoryCompositeOperation NS_TYPED_EXTENSIBLE_ENUM; //! 28개.
extern CICategoryCompositeOperation const CIAdditionCompositing;
extern CICategoryCompositeOperation const CIMultiplyBlendMode;
extern CICategoryCompositeOperation const CIMultiplyCompositing;
extern CICategoryCompositeOperation const CIMaximumCompositing;
extern CICategoryCompositeOperation const CIMinimumCompositing;

//! Darkening
extern CICategoryCompositeOperation const CIDarkenBlendMode;
//case multiply
extern CICategoryCompositeOperation const CIColorBurnBlendMode;
extern CICategoryCompositeOperation const CILinearBurnBlendMode; // ----- SwiftUI plusDarker 해당

//! Lightening
extern CICategoryCompositeOperation const CILightenBlendMode;
extern CICategoryCompositeOperation const CIScreenBlendMode;
extern CICategoryCompositeOperation const CIColorDodgeBlendMode;
extern CICategoryCompositeOperation const CILinearDodgeBlendMode; // ----- SwiftUI plusLighter 해당
extern CICategoryCompositeOperation const CIPinLightBlendMode;

//! Adding contrast
extern CICategoryCompositeOperation const CIOverlayBlendMode;
extern CICategoryCompositeOperation const CISoftLightBlendMode;
extern CICategoryCompositeOperation const CIHardLightBlendMode;

//! Inverting (Comparative)
extern CICategoryCompositeOperation const CIDifferenceBlendMode;
extern CICategoryCompositeOperation const CIExclusionBlendMode;
extern CICategoryCompositeOperation const CISubtractBlendMode;
extern CICategoryCompositeOperation const CIDivideBlendMode;

//! Mixing color components
extern CICategoryCompositeOperation const CIHueBlendMode;
extern CICategoryCompositeOperation const CISaturationBlendMode;
extern CICategoryCompositeOperation const CIColorBlendMode;
extern CICategoryCompositeOperation const CILuminosityBlendMode;

//! Accessing porter-duff modes
// super 의 opactity 0.0 초과부분에 대한 색을 자신의 색으로
extern CICategoryCompositeOperation const CISourceAtopCompositing; // 자신의 외부는 언제나 신경쓰지 않는다.
extern CICategoryCompositeOperation const CISourceOverCompositing; // 디폴트 또는 nil ----- SwiftUI normal 해당
extern CICategoryCompositeOperation const CISourceOutCompositing;

extern CICategoryCompositeOperation const CISourceInCompositing;   // CISourceInCompositing 동일. 단 masksToBounds NO 일때는 자신의 외부 투명.

//! iOS 는 layer.compositingFilter = CISourceOverCompositing; 바로 때린다.
#endif

//! CIFilter 객체를 이용하지 않고 바로 direct로 꽂는 방법이다. iOS, MacOS 공용이다.
typedef NSString * CompositeOperation NS_TYPED_EXTENSIBLE_ENUM; //! 28개.
extern CompositeOperation const additionCompositing;
extern CompositeOperation const multiplyBlendMode;
extern CompositeOperation const multiplyCompositing;
extern CompositeOperation const maximumCompositing;
extern CompositeOperation const minimumCompositing;
extern CompositeOperation const darkenBlendMode;
extern CompositeOperation const colorBurnBlendMode;
extern CompositeOperation const linearBurnBlendMode;
extern CompositeOperation const lightenBlendMode;
extern CompositeOperation const screenBlendMode;
extern CompositeOperation const colorDodgeBlendMode;
extern CompositeOperation const linearDodgeBlendMode;
extern CompositeOperation const pinLightBlendMode;
extern CompositeOperation const overlayBlendMode;
extern CompositeOperation const softLightBlendMode;
extern CompositeOperation const hardLightBlendMode;
extern CompositeOperation const differenceBlendMode;
extern CompositeOperation const exclusionBlendMode;
extern CompositeOperation const subtractBlendMode;
extern CompositeOperation const divideBlendMode;
extern CompositeOperation const hueBlendMode;
extern CompositeOperation const saturationBlendMode;
extern CompositeOperation const colorBlendMode;
extern CompositeOperation const luminosityBlendMode;
extern CompositeOperation const sourceAtopCompositing;
extern CompositeOperation const sourceOverCompositing;
extern CompositeOperation const sourceOutCompositing;
extern CompositeOperation const sourceInCompositing;

@interface CALayer (Filters)

//! iOS, MacOS 공용 - 효과가 같다.
- (void)mgrApplyCompositingFilter:(CompositeOperation)compositeOperation;

//!  MacOS 전용 - 같은 이름에 좀 진하다.
#if TARGET_OS_OSX
- (void)mgrApplyCompositingFilterOSX:(CICategoryCompositeOperation)compositeOperation;

/**
 * @brief 필터가 적용된 CALayer를 반환한다. 이 레이어를 붙여라.
 * @param compositeOperation 적용할 compositing Filter의 종류
 * @param color ...
 * @param masksToBounds ...
 * @discussion ...
 * @remark 샘플코드 CALayerFilterProject를 통해 실제로 보여지는 모습을 확인하라.
 * @code
        view.wantsLayer = YES;
        view.layer = [CALayer layer];
        view.layer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
        view.layerUsesCoreImageFilters = YES; //! 코드로 돌려보니깐 이거 안해도 잘 작동하는데, 혹시 모르니깐 그냥하자.
 
        CATextLayer *textLayer = [CATextLayer layer];
        CALayer *frontLayer = [CALayer layer];
        textLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
        frontLayer.contentsScale = [NSScreen mainScreen].backingScaleFactor;
        [view.layer addSublayer:textLayer];
        [textLayer addSublayer:frontLayer];
        textLayer.frame = view.layer.bounds;
        CGRect frontLayerFrame = textLayer.bounds;
        frontLayerFrame.size.width = frontLayerFrame.size.height/2.0;
        frontLayer.frame = frontLayerFrame; // 정사각형으로 만들어 앞에 붙인다.
 
        CICategoryCompositeOperation compositeOperation = self.compositeOperations[i];
        textLayer.string = compositeOperation;
        textLayer.foregroundColor = NSColor.greenColor.CGColor;
        textLayer.backgroundColor = NSColor.clearColor.CGColor;
        textLayer.alignmentMode = kCAAlignmentLeft;
        textLayer.fontSize = 15.0;
 
        frontLayer.backgroundColor = NSColor.whiteColor.CGColor;
        frontLayer.masksToBounds = YES; //! 주의 masksToBounds에 따라 달라질 수 있다.
  
        CIFilter *filter = [CIFilter filterWithName:compositeOperation];
        frontLayer.compositingFilter = filter;
 * @endcode
 * @return compositing Filter가 먹여진 CALayer가 반환된다.
*/
+ (CALayer *)mgrFilterLayerWithCompositeOperation:(CICategoryCompositeOperation)compositeOperation
                                            color:(NSColor *)color
                                    masksToBounds:(BOOL)masksToBounds;

//! 28개의 문자열.
NSArray <CICategoryCompositeOperation>* MGRCategoryCompositeOperations(void);
#endif
@end

NS_ASSUME_NONNULL_END

/* ----------------------------------------------------------------------
 * 2022-05-05 : 라이브러리 정리됨
 */
