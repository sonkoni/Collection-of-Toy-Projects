//
//  UICubicTimingParameters+Extension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-04-20
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MGRViewAnimationCurve) {
    MGRViewAnimationCurveEaseInSine = 1, // 0은 피하는 것이 좋다.
    MGRViewAnimationCurveEaseOutSine,
    MGRViewAnimationCurveEaseInOutSine,
    
    MGRViewAnimationCurveEaseInQuad,
    MGRViewAnimationCurveEaseOutQuad,
    MGRViewAnimationCurveEaseInOutQuad,
    
    MGRViewAnimationCurveEaseInCubic,
    MGRViewAnimationCurveEaseOutCubic,
    MGRViewAnimationCurveEaseInOutCubic,
    
    MGRViewAnimationCurveEaseInQuart,
    MGRViewAnimationCurveEaseOutQuart,
    MGRViewAnimationCurveEaseInOutQuart,
    
    MGRViewAnimationCurveEaseInQuint,
    MGRViewAnimationCurveEaseOutQuint,
    MGRViewAnimationCurveEaseInOutQuint,
    
    MGRViewAnimationCurveEaseInExpo,
    MGRViewAnimationCurveEaseOutExpo,
    MGRViewAnimationCurveEaseInOutExpo,

    MGRViewAnimationCurveEaseInCirc,
    MGRViewAnimationCurveEaseOutCirc,
    MGRViewAnimationCurveEaseInOutCirc,

    MGRViewAnimationCurveEaseInBack,
    MGRViewAnimationCurveEaseOutBack,
    MGRViewAnimationCurveEaseInOutBack
};

//! Elastic과 Bounce는 cubic - bezier로 만들 수 없다.
//    MGRViewAnimationCurveEaseInElastic,
//    MGRViewAnimationCurveEaseOutElastic,
//    MGRViewAnimationCurveEaseInOutElastic,
//    MGRViewAnimationCurveEaseInBounce,
//    MGRViewAnimationCurveEaseOutBounce,
//    MGRViewAnimationCurveEaseInOutBounce
//
//    typedef NS_ENUM(NSInteger, UIViewAnimationCurve) {
//        UIViewAnimationCurveEaseInOut,         // slow at beginning and end
//        UIViewAnimationCurveEaseIn,            // slow at beginning
//        UIViewAnimationCurveEaseOut,           // slow at end
//        UIViewAnimationCurveLinear,
//    };
//
// [[UICubicTimingParameters alloc] initWithAnimationCurve:UIViewAnimationCurveEaseInOut];

@interface UICubicTimingParameters (MGRGraphics_TimingParameters)
+ (instancetype)mgrParametersWithCustomCurve:(MGRViewAnimationCurve)curve;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2020-04-20 : UIKit 관련 확장을 Mulgrim 에서 하고 있으므로, 이름 섞일까봐 MGRGraphicsExtension 으로 변경
 * 2020-04-15 : 라이브러리 정리됨
 */
