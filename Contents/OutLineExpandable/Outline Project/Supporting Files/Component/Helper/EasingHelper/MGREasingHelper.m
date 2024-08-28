//
//  asdfasdf.m
//  MGRMorphingLabel
//
//  Created by Kwan Hyun Son on 25/02/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGREasingHelper.h"


#pragma mark - private Declaration
//! Linear
static CGFloat MGREaseLinear(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Sine
static CGFloat MGREaseInSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quad
static CGFloat MGREaseInQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Cubic
static CGFloat MGREaseInCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quart
static CGFloat MGREaseInQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quint
static CGFloat MGREaseInQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Expo
static CGFloat MGREaseInExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Circ
static CGFloat MGREaseInCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Back
static CGFloat MGREaseInBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Elastic
static CGFloat MGREaseInElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Bounce
static CGFloat MGREaseInBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGREaseInOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);


#pragma mark - EasingFunction

CGFloat MGREasingFunction(MGREasingFunctionType functionType,
                          CGFloat currentTime,
                          CGFloat startValue,
                          CGFloat finalValue,
                          CGFloat duration) {
    return MGREasingFunction_C(functionType, currentTime, startValue, finalValue - startValue, duration);
}

CGFloat MGREasingFunction_C(MGREasingFunctionType functionType,
                            CGFloat currentTime,
                            CGFloat startValue,
                            CGFloat changeAmount,
                            CGFloat duration) {
    
    if (currentTime <= 0.0) {
        return startValue;
    } else if (currentTime >= duration) {
        return startValue + changeAmount;
    }
    
    if (functionType == MGREasingFunctionTypeEaseLinear) {
        return MGREaseLinear(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInSine) {
        return MGREaseInSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutSine) {
        return MGREaseOutSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutSine) {
        return MGREaseInOutSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInQuad) {
        return MGREaseInQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutQuad) {
        return MGREaseOutQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutQuad) {
        return MGREaseInOutQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInCubic) {
        return MGREaseInCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutCubic) {
        return MGREaseOutCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutCubic) {
        return MGREaseInOutCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInQuart) {
        return MGREaseInQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutQuart) {
        return MGREaseOutQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutQuart) {
        return MGREaseInOutQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInQuint) {
        return MGREaseInQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutQuint) {
        return MGREaseOutQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutQuint) {
        return MGREaseInOutQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInExpo) {
        return MGREaseInExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutExpo) {
        return MGREaseOutExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutExpo) {
        return MGREaseInOutExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInCirc) {
        return MGREaseInCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutCirc) {
        return MGREaseOutCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutCirc) {
        return MGREaseInOutCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInBack) {
        return MGREaseInBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutBack) {
        return MGREaseOutBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutBack) {
        return MGREaseInOutBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInElastic) {
        return MGREaseInElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutElastic) {
        return MGREaseOutElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInOutElastic) {
        return MGREaseInOutElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseInBounce) {
        return MGREaseInBounce(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGREasingFunctionTypeEaseOutBounce) {
        return MGREaseOutBounce(currentTime, startValue, changeAmount, duration);
    } else { // MGREasingFunctionTypeEaseInOutBounce
        return MGREaseInOutBounce(currentTime, startValue, changeAmount, duration);
    }
}


#pragma mark - Special EaseOut - EaseOut의 농도를 변경하면서 입맛에 맞게 써보자.
CGFloat MGREaseOutSpecial(CGFloat density, CGFloat currentTime) {
    //! y = 1 - (1 - x)ᴾ : p가 density이다.
    density = MAX(1.0, density); // 아마도 1차 함수도 안쓸 것이다.
    currentTime = MIN(1.0, MAX(0.0, currentTime));
    return 1.0 - pow((1 - currentTime), density);
}

CGFloat MGREaseInOutSpecial(CGFloat density, CGFloat currentTime) { // 1이면 1차함수이다. density 커질수록 꺽어진다.
    //! y = 0.5(2x)ᴾ : p가 density이다. x <= 0.5
    //! y = 1 - 0.5(2-2x)ᴾ : p가 density이다. x > 0.5
    density = MAX(1.0, density); // 아마도 1차 함수도 안쓸 것이다.
    currentTime = MIN(1.0, MAX(0.0, currentTime));
    if (currentTime <= 0.5) {
        return 0.5 * pow((2.0 * currentTime), density);
    } else {
        return 1.0 - 0.5 * pow((2.0 - 2.0 * currentTime), density);
    }
}


#pragma mark - Trans
CGFloat MGREasingTransProgress(CGFloat linearProgress ,MGREasingFunctionType anotherFunctionType) {
    if (anotherFunctionType == MGREasingFunctionTypeEaseLinear) {
        NSLog(@"Linear 인데 왜 넣어니?");
        return linearProgress;
    }
    
    CGFloat final = linearProgress;
    CGFloat input = 0.0;
    CGFloat minValue = 0.0;
    CGFloat maxValue = 1.0;
    for (int i = 0; i < 100; i++) {
        if (i == 0) {
            input = final;
        }
        
        CGFloat result = MGREasingFunction(anotherFunctionType, input, 0.0, 1.0, 1.0);
        if (result < final) {
            minValue = input;
        } else {
            maxValue = input;
        }

        input = (minValue + maxValue) / 2.0;
    }

    return MIN(1.0, MAX(0.0, input));
}


#pragma mark - private Implementation
//! Linear
static CGFloat MGREaseLinear(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime) + beginning;
}


//! Sine
static CGFloat MGREaseInSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    return (-change * cos(currentTime / duration * M_PI_2)) + change + beginning;
}

static CGFloat MGREaseOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return (change * sin(currentTime / duration * M_PI_2)) + beginning;
}

static CGFloat MGREaseInOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return (-change / 2.0 * (cos(M_PI * currentTime / duration) - 1)) + beginning;
}


//! Quad
static CGFloat MGREaseInQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime) + beginning;
}

static CGFloat MGREaseOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration);
    return (-change * currentTime * (currentTime - 2.0)) + beginning;
}

static CGFloat MGREaseInOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / (duration / 2.0);
    
    if (currentTime < 1.0) {
        return ((change / 2.0) * currentTime * currentTime) + beginning;
    } else {
        currentTime--;
        return ((-change / 2.0) * (currentTime * (currentTime - 2.0) - 1.0)) + beginning;
    }
}


//! Cubic
static CGFloat MGREaseInCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime * currentTime) + beginning;
}

static CGFloat MGREaseOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return change * ( currentTime * currentTime * currentTime + 1.0 ) + beginning;
}

static CGFloat MGREaseInOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / (duration / 2.0);
    if (currentTime < 1.0) {
        return (change / 2.0 * currentTime * currentTime * currentTime)+ beginning;
    } else {
        currentTime = currentTime - 2;
        return (change / 2.0 * ( currentTime * currentTime * currentTime + 2.0)) + beginning;
    }
}


//! Quart
static CGFloat MGREaseInQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime * currentTime * currentTime) + beginning;
}

static CGFloat MGREaseOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return (-change * (currentTime * currentTime * currentTime * currentTime - 1.0)) + beginning;
}

static CGFloat MGREaseInOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / (duration / 2.0);
    
    if (currentTime < 1.0) {
        return ((change / 2.0) * currentTime * currentTime * currentTime * currentTime) + beginning;
    } else {
        currentTime = currentTime - 2.0;
        return (-change / 2.0 * (currentTime * currentTime * currentTime * currentTime - 2.0)) + beginning;
    }
}


//! Quint
static CGFloat MGREaseInQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration);
    return (change * (pow(currentTime, 5.0)) + beginning);
}

static CGFloat MGREaseOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration) - 1.0;
    return (change * (pow(currentTime, 5.0) + 1.0) + beginning);
}

static CGFloat MGREaseInOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / (duration / 2.0);
    
    if (currentTime < 1.0) {
        return ((change/2.0) * pow(currentTime, 5.0)) + beginning;
    } else {
        currentTime = currentTime - 2.0;
        return (change/2.0)*(pow(currentTime, 5.0) + 2.0) + beginning;
    }
}


//! Expo
static CGFloat MGREaseInExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime == 0.0) {
        return beginning;
    } else {
        return change * pow(2.0, 10.0 * (currentTime / duration - 1.0)) + beginning;
    }
}

static CGFloat MGREaseOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    if (currentTime == duration) {
        return beginning + change;
    } else {
        return change * (-pow(2.0, -10 * currentTime / duration) + 1.0) + beginning;
    }
}

static CGFloat MGREaseInOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime == 0.0) {
        return beginning;
    } else if (currentTime == duration) {
        return beginning + change;
    }
    
    currentTime = currentTime / (duration / 2.0);
    if (currentTime < 1.0) {
        return (change / 2.0) * pow(2.0, 10.0 * (currentTime - 1.0)) + beginning;
    } else {
        --currentTime;
        return (change / 2.0) * (-pow(2.0, -10.0 * currentTime) + 2.0) + beginning;
    }
}


//! Circ
static CGFloat MGREaseInCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / duration;
    return -change * (sqrt(1.0 - currentTime * currentTime) - 1.0) + beginning;
}

static CGFloat MGREaseOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return change * sqrt(1 - currentTime * currentTime) + beginning;
}

static CGFloat MGREaseInOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / (duration / 2.0);
    if (currentTime < 1.0) {
        return -change / 2.0 * (sqrt(1 - currentTime * currentTime) - 1.0) + beginning;
    } else {
        currentTime = currentTime - 2.0;
        return change / 2.0 * (sqrt(1.0 - currentTime * currentTime) + 1.0) + beginning;
    }
}


//! Back
static CGFloat MGREaseInBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    CGFloat s = 1.70158;
    currentTime = currentTime / duration;
    return change * currentTime * currentTime * ((s + 1.0) * currentTime - s) + beginning;
}

static CGFloat MGREaseOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    CGFloat s = 1.70158;
    currentTime = (currentTime / duration) - 1.0;
    return change * (currentTime * currentTime * ((s + 1.0) * currentTime + s) + 1.0) + beginning;
}

static CGFloat MGREaseInOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    CGFloat s = 1.70158;
    currentTime = currentTime / (duration / 2.0);
    if (currentTime < 1.0) {
        s = s * 1.525;
        return change/2*(currentTime * currentTime * ((s + 1) * currentTime - s)) + beginning;
    } else {
        currentTime = currentTime - 2;
        s = s * 1.525;
        return (change / 2.0) * (currentTime * currentTime * ((s + 1) * currentTime + s) + 2.0) + beginning;
    }
}


//! Elastic
static CGFloat MGREaseInElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime <= 0.0) {
        return beginning;
    }
    
    currentTime = currentTime / duration;
    if (currentTime >= 1.0) {
        return beginning + change;
    }
    
    CGFloat p = duration * 0.3;
    CGFloat s = p / 4.0;
    
    currentTime = currentTime - 1.0;
    
    return -(change * pow(2.0, 10 * currentTime) * sin( (currentTime * duration - s) * (2.0 * M_PI)/p)) + beginning;
}

static CGFloat MGREaseOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime <= 0.0) {
        return beginning;
    }
    
    currentTime = currentTime / duration;
    if (currentTime >= 1.0) {
        return beginning + change;
    }
    
    CGFloat p = duration * 0.3;
    CGFloat s = p / 4.0;
    
    return change * pow(2,-10.0 * currentTime) * sin((currentTime * duration - s) * (2.0 * M_PI) / p) + change + beginning;
}

static CGFloat MGREaseInOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime <= 0.0) {
        return beginning;
    }
    
    currentTime = currentTime / (duration / 2.0);
    if (currentTime >= 2.0) {
        return beginning + change;
    }
    
    CGFloat p = duration * (0.3 * 1.5);
    CGFloat s = p / 4.0;
    
    if (currentTime < 1.0) {
        currentTime = currentTime - 1.0;
        return -0.5*(change * pow(2, 10.0 * currentTime) * sin((currentTime * duration - s)*(2.0 * M_PI)/p)) + beginning;
    } else {
        currentTime = currentTime - 1.0;
        return change * pow(2, -10.0 * currentTime) * sin((currentTime * duration - s) * (2.0 * M_PI)/p) * 0.5 + change + beginning;
    }
}


//! Bounce
static CGFloat MGREaseInBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return change - MGREaseOutBounce(duration - currentTime, 0.0, change, duration) + beginning;
}

static CGFloat MGREaseOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = currentTime / duration;
    if (currentTime < (1 / 2.75)) {
        return change * (7.5625 * currentTime * currentTime) + beginning;
    } else if (currentTime < (2 / 2.75)) {
        currentTime = currentTime - (1.5 / 2.75);
        return change * (7.5625 * currentTime * currentTime + 0.75) + beginning;
    } else if (currentTime < (2.5 / 2.75)) {
        currentTime = currentTime - (2.25 / 2.75);
        return change * (7.5625 * currentTime * currentTime + 0.9375) + beginning;
    } else {
        currentTime = currentTime - (2.625 / 2.75);
        return change * (7.5625 * currentTime * currentTime + 0.984375) + beginning;
    }
}

static CGFloat MGREaseInOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime < (duration / 2.0)) {
        return MGREaseInBounce(currentTime * 2.0, 0.0, change, duration) * 0.5 + beginning;
    } else {
        return (MGREaseOutBounce(currentTime * 2.0 - duration, 0.0, change, duration) * 0.5) + (change * 0.5) + beginning;
    }
}
