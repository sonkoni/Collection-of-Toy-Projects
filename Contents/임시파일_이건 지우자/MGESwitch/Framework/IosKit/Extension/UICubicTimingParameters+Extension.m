//
//  UICubicTimingParameters+Extension.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//


#import "UICubicTimingParameters+Extension.h"

@implementation UICubicTimingParameters (MGRGraphics_TimingParameters)
+ (instancetype)mgrParametersWithCustomCurve:(MGRViewAnimationCurve)curve {
    switch (curve) {
        case MGRViewAnimationCurveEaseInSine:  {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.47, 0.0)
                                                            controlPoint2:CGPointMake(0.745, 0.715)];
            break;
        }
        case MGRViewAnimationCurveEaseOutSine:  {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.39, 0.575)
                                                            controlPoint2:CGPointMake(0.565, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutSine: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.445, 0.05)
                                                            controlPoint2:CGPointMake(0.55, 0.95)];
            break;
        }
        case MGRViewAnimationCurveEaseInQuad: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.55, 0.085)
                                                            controlPoint2:CGPointMake(0.68, 0.53)];
            break;
        }
        case MGRViewAnimationCurveEaseOutQuad: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.25, 0.46)
                                                            controlPoint2:CGPointMake(0.45, 0.94)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutQuad: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.455, 0.03)
                                                            controlPoint2:CGPointMake(0.515, 0.955)];
            break;
        }
        case MGRViewAnimationCurveEaseInCubic: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.55, 0.055)
                                                            controlPoint2:CGPointMake(0.675, 0.19)];
            break;
        }
        case MGRViewAnimationCurveEaseOutCubic: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.215, 0.61)
                                                            controlPoint2:CGPointMake(0.355, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutCubic: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.645, 0.045)
                                                            controlPoint2:CGPointMake(0.355, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInQuart: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.895, 0.03)
                                                            controlPoint2:CGPointMake(0.685, 0.22)];
            break;
        }
        case MGRViewAnimationCurveEaseOutQuart: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.165, 0.84)
                                                            controlPoint2:CGPointMake(0.44, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutQuart: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.77, 0)
                                                            controlPoint2:CGPointMake(0.175, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInQuint: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.755, 0.05)
                                                            controlPoint2:CGPointMake(0.855, 0.06)];
            break;
        }
        case MGRViewAnimationCurveEaseOutQuint: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.23, 1.0)
                                                            controlPoint2:CGPointMake(0.32, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutQuint: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.86, 0.0)
                                                            controlPoint2:CGPointMake(0.07, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInExpo: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.95, 0.05)
                                                            controlPoint2:CGPointMake(0.795, 0.035)];
            break;
        }
        case MGRViewAnimationCurveEaseOutExpo: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.19, 1.0)
                                                            controlPoint2:CGPointMake(0.22, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutExpo: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(1.0, 0.0)
                                                            controlPoint2:CGPointMake(0.0, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInCirc: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.6, 0.04)
                                                            controlPoint2:CGPointMake(0.98, 0.335)];
            break;
        }
        case MGRViewAnimationCurveEaseOutCirc: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.075, 0.82)
                                                            controlPoint2:CGPointMake(0.165, 1.0)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutCirc: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.785, 0.135)
                                                            controlPoint2:CGPointMake(0.15, 0.86)];
            break;
        }
        case MGRViewAnimationCurveEaseInBack: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.6, -0.28)
                                                            controlPoint2:CGPointMake(0.735, 0.045)];
            break;
        }
        case MGRViewAnimationCurveEaseOutBack: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.175, 0.885)
                                                            controlPoint2:CGPointMake(0.32, 1.275)];
            break;
        }
        case MGRViewAnimationCurveEaseInOutBack: {
            return [[UICubicTimingParameters alloc] initWithControlPoint1:CGPointMake(0.68, -0.55)
                                                            controlPoint2:CGPointMake(0.265, 1.55)];
            break;
        }
        default: {
            NSCAssert(false, @"인수가 잘못넘어왔다.");
            return nil;
            break;
        }
    }
}

@end

