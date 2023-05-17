//
//  CAMediaTimingFunction+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "CAMediaTimingFunction+Extension.h"

@implementation CAMediaTimingFunction (MGRTimingFunction)

+ (instancetype)functionWithCustomName:(MGRMediaTimingFunctionName)name {
    if ([name isEqualToString:MGRMediaTimingFunctionLinear]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.0 :0.0 :1.0 :1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInSine]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.47 :0.0 :0.745 :0.715];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutSine]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.39 :0.575 :0.565 :1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutSine]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.445 :0.05 :0.55 :0.95]; //
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInQuad]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.55 :0.085 :0.68 :0.53];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutQuad]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.25: 0.46: 0.45: 0.94];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutQuad]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.455: 0.03: 0.515: 0.955];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInCubic]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.55: 0.055: 0.675: 0.19];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutCubic]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.215: 0.61: 0.355: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutCubic]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.645: 0.045: 0.355: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInQuart]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.895: 0.03: 0.685: 0.22];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutQuart]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.165: 0.84: 0.44: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutQuart]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.77: 0: 0.175: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInQuint]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.755: 0.05: 0.855: 0.06];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutQuint]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.23: 1.0: 0.32: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutQuint]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.86: 0.0: 0.07: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInExpo]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.95: 0.05: 0.795: 0.035];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutExpo]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.19: 1.0: 0.22: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutExpo]) {
        return [CAMediaTimingFunction functionWithControlPoints:1.0: 0.0: 0.0: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInCirc]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.6: 0.04: 0.98: 0.335];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutCirc]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.075: 0.82: 0.165: 1.0];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutCirc]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.785: 0.135: 0.15: 0.86];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInBack]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.6: -0.28: 0.735: 0.045];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseOutBack]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.175: 0.885: 0.32: 1.275];
    } else if ([name isEqualToString:MGRMediaTimingFunctionEaseInOutBack]) {
        return [CAMediaTimingFunction functionWithControlPoints:0.68: -0.55: 0.265: 1.55];
    } else {
        NSAssert(false, @"인수가 잘못넘어왔다.");
        return nil;
    }
}

NSArray <MGRMediaTimingFunctionName>* mgrMediaTimingFunctionNames(void) {
    return @[MGRMediaTimingFunctionLinear,
             MGRMediaTimingFunctionEaseInSine, MGRMediaTimingFunctionEaseOutSine, MGRMediaTimingFunctionEaseInOutSine,
             MGRMediaTimingFunctionEaseInQuad, MGRMediaTimingFunctionEaseOutQuad, MGRMediaTimingFunctionEaseInOutQuad,
             MGRMediaTimingFunctionEaseInCubic, MGRMediaTimingFunctionEaseOutCubic, MGRMediaTimingFunctionEaseInOutCubic,
             MGRMediaTimingFunctionEaseInQuart, MGRMediaTimingFunctionEaseOutQuart, MGRMediaTimingFunctionEaseInOutQuart,
             MGRMediaTimingFunctionEaseInQuint, MGRMediaTimingFunctionEaseOutQuint, MGRMediaTimingFunctionEaseInOutQuint,
             MGRMediaTimingFunctionEaseInExpo, MGRMediaTimingFunctionEaseOutExpo, MGRMediaTimingFunctionEaseInOutExpo,
             MGRMediaTimingFunctionEaseInCirc, MGRMediaTimingFunctionEaseOutCirc, MGRMediaTimingFunctionEaseInOutCirc,
             MGRMediaTimingFunctionEaseInBack, MGRMediaTimingFunctionEaseOutBack, MGRMediaTimingFunctionEaseInOutBack];
}
@end
