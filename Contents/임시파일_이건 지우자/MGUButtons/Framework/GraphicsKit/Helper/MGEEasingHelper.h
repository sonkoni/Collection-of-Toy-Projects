//
//  MGEEasingHelper.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-30
//  ----------------------------------------------------------------------
// http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js
// https://easings.net/en


#ifndef MGEEasingHelper_h
#define MGEEasingHelper_h
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef NS_ENUM(NSInteger, MGEEasingFunctionType) {
    MGEEasingFunctionTypeEaseLinear = 1, // 0은 피하는 것이 좋다.
    
    MGEEasingFunctionTypeEaseInSine,
    MGEEasingFunctionTypeEaseOutSine,
    MGEEasingFunctionTypeEaseInOutSine,
    
    MGEEasingFunctionTypeEaseInQuad,
    MGEEasingFunctionTypeEaseOutQuad,
    MGEEasingFunctionTypeEaseInOutQuad,
    
    MGEEasingFunctionTypeEaseInCubic,
    MGEEasingFunctionTypeEaseOutCubic,
    MGEEasingFunctionTypeEaseInOutCubic,
    
    MGEEasingFunctionTypeEaseInQuart,
    MGEEasingFunctionTypeEaseOutQuart,
    MGEEasingFunctionTypeEaseInOutQuart,
    
    MGEEasingFunctionTypeEaseInQuint,
    MGEEasingFunctionTypeEaseOutQuint,
    MGEEasingFunctionTypeEaseInOutQuint,
    
    MGEEasingFunctionTypeEaseInExpo,
    MGEEasingFunctionTypeEaseOutExpo,
    MGEEasingFunctionTypeEaseInOutExpo,
    
    MGEEasingFunctionTypeEaseInCirc,
    MGEEasingFunctionTypeEaseOutCirc,
    MGEEasingFunctionTypeEaseInOutCirc,
    
    MGEEasingFunctionTypeEaseInBack,
    MGEEasingFunctionTypeEaseOutBack,
    MGEEasingFunctionTypeEaseInOutBack,
    
    MGEEasingFunctionTypeEaseInElastic,
    MGEEasingFunctionTypeEaseOutElastic,
    MGEEasingFunctionTypeEaseInOutElastic,
    
    MGEEasingFunctionTypeEaseInBounce,
    MGEEasingFunctionTypeEaseOutBounce,
    MGEEasingFunctionTypeEaseInOutBounce
};

typedef CGFloat (^MGEEasingBlock)(CGFloat currentTime, CGFloat startValue, CGFloat finalValue, CGFloat duration);


#pragma mark - EasingFunction

//! 둘 중 어떤 것을 사용해도 같다. 단 final value를 사용하냐 변화량을 사용하냐의 차이일 뿐이다.
CGFloat MGEEasingFunction(MGEEasingFunctionType functionType,
                          CGFloat currentTime,
                          CGFloat startValue,
                          CGFloat finalValue,
                          CGFloat duration);

CGFloat MGEEasingFunction_C(MGEEasingFunctionType functionType,
                            CGFloat currentTime,
                            CGFloat startValue,
                            CGFloat changeAmount,
                            CGFloat duration);

//! Block으로도 만들었다. 나중에 지금의 알고리즘을 수정할 수도 있을 것 같다.
MGEEasingBlock MGEMakeEasingBlock(MGEEasingFunctionType functionType);


#pragma mark - Special EaseOut - EaseOut의 농도를 변경하면서 입맛에 맞게 써보자. EaseInOut
//! density 가 1.0이면 1차함수, 2.0이면 2차함수로 easeout을 만든 것과 같다. floating 값을 이용하여 정밀하게 조절할 수 있다.
CGFloat MGEEaseOutSpecial(CGFloat density, CGFloat currentTime); // 0.0 ~1.0까지로 상정했다.

CGFloat MGEEaseInOutSpecial(CGFloat density, CGFloat currentTime); // 0.0 ~1.0까지로 상정했다.


#pragma mark - Trans
//! 선형함수의 progress를 다른 함수의 progress로 반환하라.
//! EX) : 선형함수가 만약 0.7의 progress 일때, 그에 해당하는 값이 있을 것이다. 그 값에 대응하는 다른함수의 progress를 반환한다.
CGFloat MGEEasingTransProgress(CGFloat linearProgress ,MGEEasingFunctionType anotherFunctionType);


#pragma mark - ETC.
// Easing 함수가 아니다. 0.0 ~ 1.0 => 1.0->0.0->1.0 diving 함수이다. 0.0 ~ 1.0 으로 변화할 때. 처음과 끝에서 1.0이고
// 가운데에서 0.0인 선형 다이빙함수이다.
CGFloat MGEDivingFunction(CGFloat progress); // 0.0 ~1.0까지로 상정했다.

// UIKit Spring 곡선 duration 0.45 damp 0.9 initialVelocity:0.0 의 곡선에서
// settle down 쪽 부분을 제거하고 남은 70%의 유의미한 곡선 부분을 모방했다.
// 사인함수를 베이스로 놓고 더해질 값을 가공된 코사인 함수로 제공해준다. 눈 대중으로 모방했으므로 정확하게 일치하지는 않으나 매우 유사할 것이다.
CGFloat MGEMimicSpring(CGFloat progress); // 0.0 ~1.0까지로 상정했다.

NS_ASSUME_NONNULL_END
#endif /* MGEEasingHelper_h */

/*
 *  t = currentTime
 *  b = beginning  초깃값
 *  c = change     변화량 : 최종값을 쓰려면, beginning + change 이다.
 *  d = duration
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1
 * to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 *
 * Open source under the BSD License.
 *
 * Copyright Â© 2008 George McGinley Smith
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
*/

// t: current time, b: begInnIng value, c: change In value, d: duration
/**
jQuery.easing['jswing'] = jQuery.easing['swing'];

jQuery.extend( jQuery.easing,
{
    def: 'easeOutQuad',
    swing: function (x, t, b, c, d) {
        //alert(jQuery.easing.default);
        return jQuery.easing[jQuery.easing.def](x, t, b, c, d);
    },
    easeInQuad: function (x, t, b, c, d) {
        return c*(t/=d)*t + b;
    },
    easeOutQuad: function (x, t, b, c, d) {
        return -c *(t/=d)*(t-2) + b;
    },
    easeInOutQuad: function (x, t, b, c, d) {
        if ((t/=d/2) < 1) return c/2*t*t + b;
        return -c/2 * ((--t)*(t-2) - 1) + b;
    },
    easeInCubic: function (x, t, b, c, d) {
        return c*(t/=d)*t*t + b;
    },
    easeOutCubic: function (x, t, b, c, d) {
        return c*((t=t/d-1)*t*t + 1) + b;
    },
    easeInOutCubic: function (x, t, b, c, d) {
        if ((t/=d/2) < 1) return c/2*t*t*t + b;
        return c/2*((t-=2)*t*t + 2) + b;
    },
    easeInQuart: function (x, t, b, c, d) {
        return c*(t/=d)*t*t*t + b;
    },
    easeOutQuart: function (x, t, b, c, d) {
        return -c * ((t=t/d-1)*t*t*t - 1) + b;
    },
    easeInOutQuart: function (x, t, b, c, d) {
        if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
        return -c/2 * ((t-=2)*t*t*t - 2) + b;
    },
    easeInQuint: function (x, t, b, c, d) {
        return c*(t/=d)*t*t*t*t + b;
    },
    easeOutQuint: function (x, t, b, c, d) {
        return c*((t=t/d-1)*t*t*t*t + 1) + b;
    },
    easeInOutQuint: function (x, t, b, c, d) {
        if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
        return c/2*((t-=2)*t*t*t*t + 2) + b;
    },
    easeInSine: function (x, t, b, c, d) {
        return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
    },
    easeOutSine: function (x, t, b, c, d) {
        return c * Math.sin(t/d * (Math.PI/2)) + b;
    },
    easeInOutSine: function (x, t, b, c, d) {
        return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
    },
    easeInExpo: function (x, t, b, c, d) {
        return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
    },
    easeOutExpo: function (x, t, b, c, d) {
        return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
    },
    easeInOutExpo: function (x, t, b, c, d) {
        if (t==0) return b;
        if (t==d) return b+c;
        if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
        return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
    },
    easeInCirc: function (x, t, b, c, d) {
        return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
    },
    easeOutCirc: function (x, t, b, c, d) {
        return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
    },
    easeInOutCirc: function (x, t, b, c, d) {
        if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
        return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
    },
    easeInElastic: function (x, t, b, c, d) {
        var s=1.70158;var p=0;var a=c;
        if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
        if (a < Math.abs(c)) { a=c; var s=p/4; }
        else var s = p/(2*Math.PI) * Math.asin (c/a);
        return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
    },
    easeOutElastic: function (x, t, b, c, d) {
        var s=1.70158;var p=0;var a=c;
        if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
        if (a < Math.abs(c)) { a=c; var s=p/4; }
        else var s = p/(2*Math.PI) * Math.asin (c/a);
        return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
    },
    easeInOutElastic: function (x, t, b, c, d) {
        var s=1.70158;var p=0;var a=c;
        if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
        if (a < Math.abs(c)) { a=c; var s=p/4; }
        else var s = p/(2*Math.PI) * Math.asin (c/a);
        if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
        return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
    },
    easeInBack: function (x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c*(t/=d)*t*((s+1)*t - s) + b;
    },
    easeOutBack: function (x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
    },
    easeInOutBack: function (x, t, b, c, d, s) {
        if (s == undefined) s = 1.70158;
        if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
        return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
    },
    easeInBounce: function (x, t, b, c, d) {
        return c - jQuery.easing.easeOutBounce (x, d-t, 0, c, d) + b;
    },
    easeOutBounce: function (x, t, b, c, d) {
        if ((t/=d) < (1/2.75)) {
            return c*(7.5625*t*t) + b;
        } else if (t < (2/2.75)) {
            return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
        } else if (t < (2.5/2.75)) {
            return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
        } else {
            return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
        }
    },
    easeInOutBounce: function (x, t, b, c, d) {
        if (t < d/2) return jQuery.easing.easeInBounce (x, t*2, 0, c, d) * .5 + b;
        return jQuery.easing.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
    }
});
*/
/*
 *
 * TERMS OF USE - EASING EQUATIONS
 *
 * Open source under the BSD License.
 *
 * Copyright Â© 2001 Robert Penner
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 *  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


