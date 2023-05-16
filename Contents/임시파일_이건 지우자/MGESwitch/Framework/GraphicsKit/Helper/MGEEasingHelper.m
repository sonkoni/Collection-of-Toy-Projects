//
//  MGEEasingHelper.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGEEasingHelper.h"


#pragma mark - private Declaration
//! Linear
static CGFloat MGEEaseLinear(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Sine
static CGFloat MGEEaseInSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quad
static CGFloat MGEEaseInQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Cubic
static CGFloat MGEEaseInCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quart
static CGFloat MGEEaseInQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Quint
static CGFloat MGEEaseInQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Expo
static CGFloat MGEEaseInExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Circ
static CGFloat MGEEaseInCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Back
static CGFloat MGEEaseInBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Elastic
static CGFloat MGEEaseInElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);

//! Bounce
static CGFloat MGEEaseInBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);
static CGFloat MGEEaseInOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration);


#pragma mark - EasingFunction

CGFloat MGEEasingFunction(MGEEasingFunctionType functionType,
                          CGFloat currentTime,
                          CGFloat startValue,
                          CGFloat finalValue,
                          CGFloat duration) {
    return MGEEasingFunction_C(functionType, currentTime, startValue, finalValue - startValue, duration);
}

CGFloat MGEEasingFunction_C(MGEEasingFunctionType functionType,
                            CGFloat currentTime,
                            CGFloat startValue,
                            CGFloat changeAmount,
                            CGFloat duration) {
    
    if (currentTime <= 0.0) {
        return startValue;
    } else if (currentTime >= duration) {
        return startValue + changeAmount;
    }
    
    if (functionType == MGEEasingFunctionTypeEaseLinear) {
        return MGEEaseLinear(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInSine) {
        return MGEEaseInSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutSine) {
        return MGEEaseOutSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutSine) {
        return MGEEaseInOutSine(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInQuad) {
        return MGEEaseInQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuad) {
        return MGEEaseOutQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuad) {
        return MGEEaseInOutQuad(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInCubic) {
        return MGEEaseInCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutCubic) {
        return MGEEaseOutCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutCubic) {
        return MGEEaseInOutCubic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInQuart) {
        return MGEEaseInQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuart) {
        return MGEEaseOutQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuart) {
        return MGEEaseInOutQuart(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInQuint) {
        return MGEEaseInQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuint) {
        return MGEEaseOutQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuint) {
        return MGEEaseInOutQuint(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInExpo) {
        return MGEEaseInExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutExpo) {
        return MGEEaseOutExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutExpo) {
        return MGEEaseInOutExpo(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInCirc) {
        return MGEEaseInCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutCirc) {
        return MGEEaseOutCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutCirc) {
        return MGEEaseInOutCirc(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInBack) {
        return MGEEaseInBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutBack) {
        return MGEEaseOutBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutBack) {
        return MGEEaseInOutBack(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInElastic) {
        return MGEEaseInElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutElastic) {
        return MGEEaseOutElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInOutElastic) {
        return MGEEaseInOutElastic(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseInBounce) {
        return MGEEaseInBounce(currentTime, startValue, changeAmount, duration);
    } else if (functionType == MGEEasingFunctionTypeEaseOutBounce) {
        return MGEEaseOutBounce(currentTime, startValue, changeAmount, duration);
    } else { // MGEEasingFunctionTypeEaseInOutBounce
        return MGEEaseInOutBounce(currentTime, startValue, changeAmount, duration);
    }
}


#pragma mark - Special EaseOut - EaseOut의 농도를 변경하면서 입맛에 맞게 써보자.
CGFloat MGEEaseOutSpecial(CGFloat density, CGFloat currentTime) {
    //! y = 1 - (1 - x)ᴾ : p가 density이다.
    density = MAX(1.0, density); // 아마도 1차 함수도 안쓸 것이다.
    currentTime = MIN(1.0, MAX(0.0, currentTime));
    return 1.0 - pow((1 - currentTime), density);
}

CGFloat MGEEaseInOutSpecial(CGFloat density, CGFloat currentTime) { // 1이면 1차함수이다. density 커질수록 꺽어진다.
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
CGFloat MGEEasingTransProgress(CGFloat linearProgress ,MGEEasingFunctionType anotherFunctionType) {
    if (anotherFunctionType == MGEEasingFunctionTypeEaseLinear) {
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
        
        CGFloat result = MGEEasingFunction(anotherFunctionType, input, 0.0, 1.0, 1.0);
        if (result < final) {
            minValue = input;
        } else {
            maxValue = input;
        }

        input = (minValue + maxValue) / 2.0;
    }

    return MIN(1.0, MAX(0.0, input));
}


#pragma mark - ETC.
CGFloat MGEDivingFunction(CGFloat progress) {
    progress = MIN(MAX(progress, 0.0), 1.0);
    CGFloat p = ABS(progress - 0.5);
    return 2.0 * p; // 가운데에서 0.0, 양 끝에서 1.0 uniform 변환
}

CGFloat MGEMimicSpring(CGFloat progress) {
    progress = MIN(MAX(0.0, progress), 1.0);
    CGFloat newX = (progress * M_PI) - M_PI_2; // M_PI_2 ~ M_PI_2
    CGFloat newY = sin(newX); // - 1.0 ~ 1.0 일반적인 사인함수이다.
    newY = newY + 1.0; // 0.0 ~ 2.0
    newY = newY / 2.0; // 0.0 ~ 1.0
    
    //! 더할것: 코사인 함수를 더할 것이다.
    // 0.36 => 0.5
    if (progress <= 0.36) {
        progress = progress * ( 0.5 / 0.36);
    } else {
        progress = 0.5 + ( (progress - 0.36) * (0.5 / 0.64) );
    }
    CGFloat addY = -cos(progress * M_PI * 2.0) + 1.0;
    addY = addY / 2.0;
    addY = addY * 0.38; // 0.383973288814691  높이
    return MIN(MAX(0.0, newY + addY), 1.0);
}


#pragma mark - private Implementation
//! Linear
static CGFloat MGEEaseLinear(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime) + beginning;
}


//! Sine
static CGFloat MGEEaseInSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    return (-change * cos(currentTime / duration * M_PI_2)) + change + beginning;
}

static CGFloat MGEEaseOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return (change * sin(currentTime / duration * M_PI_2)) + beginning;
}

static CGFloat MGEEaseInOutSine(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return (-change / 2.0 * (cos(M_PI * currentTime / duration) - 1)) + beginning;
}


//! Quad
static CGFloat MGEEaseInQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime) + beginning;
}

static CGFloat MGEEaseOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration);
    return (-change * currentTime * (currentTime - 2.0)) + beginning;
}

static CGFloat MGEEaseInOutQuad(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime * currentTime) + beginning;
}

static CGFloat MGEEaseOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return change * ( currentTime * currentTime * currentTime + 1.0 ) + beginning;
}

static CGFloat MGEEaseInOutCubic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration);
    return (change * currentTime * currentTime * currentTime * currentTime) + beginning;
}

static CGFloat MGEEaseOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return (-change * (currentTime * currentTime * currentTime * currentTime - 1.0)) + beginning;
}

static CGFloat MGEEaseInOutQuart(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration);
    return (change * (pow(currentTime, 5.0)) + beginning);
}

static CGFloat MGEEaseOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    currentTime = (currentTime / duration) - 1.0;
    return (change * (pow(currentTime, 5.0) + 1.0) + beginning);
}

static CGFloat MGEEaseInOutQuint(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime == 0.0) {
        return beginning;
    } else {
        return change * pow(2.0, 10.0 * (currentTime / duration - 1.0)) + beginning;
    }
}

static CGFloat MGEEaseOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    if (currentTime == duration) {
        return beginning + change;
    } else {
        return change * (-pow(2.0, -10 * currentTime / duration) + 1.0) + beginning;
    }
}

static CGFloat MGEEaseInOutExpo(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = currentTime / duration;
    return -change * (sqrt(1.0 - currentTime * currentTime) - 1.0) + beginning;
}

static CGFloat MGEEaseOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    currentTime = (currentTime / duration) - 1.0;
    return change * sqrt(1 - currentTime * currentTime) + beginning;
}

static CGFloat MGEEaseInOutCirc(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    CGFloat s = 1.70158;
    currentTime = currentTime / duration;
    return change * currentTime * currentTime * ((s + 1.0) * currentTime - s) + beginning;
}

static CGFloat MGEEaseOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    CGFloat s = 1.70158;
    currentTime = (currentTime / duration) - 1.0;
    return change * (currentTime * currentTime * ((s + 1.0) * currentTime + s) + 1.0) + beginning;
}

static CGFloat MGEEaseInOutBack(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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

static CGFloat MGEEaseOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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

static CGFloat MGEEaseInOutElastic(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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
static CGFloat MGEEaseInBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    return change - MGEEaseOutBounce(duration - currentTime, 0.0, change, duration) + beginning;
}

static CGFloat MGEEaseOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
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

static CGFloat MGEEaseInOutBounce(CGFloat currentTime, CGFloat beginning, CGFloat change, CGFloat duration) {
    if (duration <= 0.0) {
        duration = 0.1;
    }
    
    if (currentTime < (duration / 2.0)) {
        return MGEEaseInBounce(currentTime * 2.0, 0.0, change, duration) * 0.5 + beginning;
    } else {
        return (MGEEaseOutBounce(currentTime * 2.0 - duration, 0.0, change, duration) * 0.5) + (change * 0.5) + beginning;
    }
}


//! Block으로도 만들었다. 나중에 지금의 알고리즘을 수정할 수도 있을 것 같다.
MGEEasingBlock MGEMakeEasingBlock(MGEEasingFunctionType functionType) {
    if (functionType == MGEEasingFunctionTypeEaseLinear) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseLinear(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInSine) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInSine(currentTime, startValue, changeAmount, duration);
        };
    }  else if (functionType == MGEEasingFunctionTypeEaseOutSine) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutSine(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutSine) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutSine(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInQuad) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInQuad(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuad) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutQuad(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuad) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutQuad(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInCubic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInCubic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutCubic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutCubic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutCubic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutCubic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInQuart) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInQuart(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuart) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutQuart(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuart) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutQuart(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInQuint) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInQuint(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutQuint) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutQuint(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutQuint) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutQuint(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInExpo) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInExpo(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutExpo) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutExpo(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutExpo) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutExpo(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInCirc) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInCirc(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutCirc) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutCirc(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutCirc) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutCirc(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInBack) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInBack(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutBack) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutBack(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutBack) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutBack(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInElastic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInElastic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutElastic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutElastic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInOutElastic) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutElastic(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseInBounce) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInBounce(currentTime, startValue, changeAmount, duration);
        };
    } else if (functionType == MGEEasingFunctionTypeEaseOutBounce) {
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseOutBounce(currentTime, startValue, changeAmount, duration);
        };
    } else { // MGEEasingFunctionTypeEaseInOutBounce
        return ^CGFloat(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration) {
            CGFloat changeAmount = finalValue - startValue;
            if (currentTime <= 0.0) {
                return startValue;
            } else if (currentTime >= duration) {
                return startValue + changeAmount;
            }
            return MGEEaseInOutBounce(currentTime, startValue, changeAmount, duration);
        };
    }
}
