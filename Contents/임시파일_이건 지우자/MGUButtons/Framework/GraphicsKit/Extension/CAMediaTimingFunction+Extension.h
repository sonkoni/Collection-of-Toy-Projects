//
//  CAMediaTimingFunction+Extension.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-01-20
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef

typedef NSString * MGRMediaTimingFunctionName NS_STRING_ENUM;
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionLinear = @"Linear";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInSine = @"EaseInSine";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutSine = @"EaseOutSine";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutSine = @"EaseInOutSine";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInQuad = @"EaseInQuad";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutQuad = @"EaseOutQuad";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutQuad = @"EaseInOutQuad";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInCubic = @"EaseInCubic";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutCubic = @"EaseOutCubic";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutCubic = @"EaseInOutCubic";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInQuart = @"EaseInQuart";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutQuart = @"EaseOutQuart";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutQuart = @"EaseInOutQuart";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInQuint = @"EaseInQuint";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutQuint = @"EaseOutQuint";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutQuint = @"EaseInOutQuint";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInExpo = @"EaseInExpo";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutExpo = @"EaseOutExpo";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutExpo = @"EaseInOutExpo";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInCirc = @"EaseInCirc";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutCirc = @"EaseOutCirc";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutCirc = @"EaseInOutCirc";

static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInBack = @"EaseInBack";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutBack = @"EaseOutBack";
static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutBack = @"EaseInOutBack";

//! Elastic과 Bounce는 cubic - bezier로 만들 수 없다.
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInElastic = @"MGRMediaTimingFunctionEaseInElastic";
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutElastic = @"MGRMediaTimingFunctionEaseOutElastic";
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutElastic = @"MGRMediaTimingFunctionEaseInOutElastic";
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInBounce = @"MGRMediaTimingFunctionEaseInBounce";
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseOutBounce = @"MGRMediaTimingFunctionEaseOutBounce";
//static MGRMediaTimingFunctionName const MGRMediaTimingFunctionEaseInOutBounce = @"MGRMediaTimingFunctionEaseInOutBounce";

//CAMediaTimingFunctionName const kCAMediaTimingFunctionLinear
//CAMediaTimingFunctionName const kCAMediaTimingFunctionEaseIn
//CAMediaTimingFunctionName const kCAMediaTimingFunctionEaseOut
//CAMediaTimingFunctionName const kCAMediaTimingFunctionEaseInEaseOut
//CAMediaTimingFunctionName const kCAMediaTimingFunctionDefault


#pragma mark - 인터페이스
@interface CAMediaTimingFunction (MGRTimingFunction)

+ (instancetype)functionWithCustomName:(MGRMediaTimingFunctionName)name;

NSArray <MGRMediaTimingFunctionName>* mgrMediaTimingFunctionNames(void);

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2021-01-20 : 라이브러리 정리됨
*/
