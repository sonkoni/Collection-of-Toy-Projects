//
//  MGRMathHelper.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-06-11
//  ----------------------------------------------------------------------
// https://suhak.tistory.com/301
// https://stackoverflow.com/questions/13328676/c-solving-cubic-equations
// https://m.blog.naver.com/PostView.nhn?blogId=xtelite&logNo=50074757033&proxyReferer=https:%2F%2Fwww.google.com%2F
// https://deepdeepit.tistory.com/23
// https://www.mathsisfun.com/quadratic-equation-solver.html <- 2차방정식
// http://www.1728.org/cubic.htm <- 3차방정식

#ifndef MGRMathHelper_h
#define MGRMathHelper_h
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_OSX
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#pragma mark - Macro : MGRMATH_

// (BOOL) 두 수의 FLT_EPSILON 동일 비교
#define MGRMATH_IS_EQUAL_FLT_EPSILON(lvar, rvar)      (fabs(lvar - rvar) <= FLT_EPSILON)

// ----------------------------------------------------------------------

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Prime Number : MGRPrimeNumber_
BOOL MGRPrimeNumber(NSInteger number); // Prime Number이면 YES를 반환한다.


#pragma mark - Random Function : MGRRandom_
BOOL MGRRandomBOOL(void); //! 임의의 YES 또는 NO 값을 뽑아준다.

CGFloat MGRRandomFloat(void); //! 0.0 ~ 1.0 사이의 임의의 CGFloat 값을 뽑아준다.

CGFloat MGRRandomFloatRange(CGFloat start, CGFloat end); //! start ~ end 사이의 임의의 CGFloat 값을 뽑아준다.

//! 0.0 ~ 1.0 사이의 임의의 CGFloat 값을 뽑아주는 데 Focus를 주어서 뽑아낸다.
//! focus 1, 2, 3 단계가 존재한다.
CGFloat MGRRandomFocus3(NSInteger focus);


#pragma mark - Equation Function : MGR_Equation
/*** 1차 방정식, 2차 방정식, 3차 방정식 ****/
void MGRLinearEquation(double a , double b, double * realRoot);
void MGRQuadraticEquation(double a , double b, double c, double realRoot[_Nonnull], double complRoot[_Nonnull], int * nRealRootCount);
void MGRCubicEquation(double a , double b, double c, double d, double realRoot[_Nonnull], double complRoot[_Nonnull], int * nRealRootCount);


#pragma mark - Bezier path : MGRCubicBezier_
//! x 또는 y 값을 알때, 그 때의 t 값을 구한다. 모양을 봤을 때, 수직, 수평으로 교차점이 두 개 이상 존재하면 계산이 안된다. 3 차방정식이 2 번째 또는 3 번째
//! 해를 구해야하는 상황이 되기 때문이다.
//! 마지막 인수는 3개 짜리 배열이지만 첫 번째만 사용한다.
//! realRoot[0] ∈ [0, 1] 이며, 또한 floating 오차 때문에 결과값을 MIN(MAX(0.0, result), 1.0) 하라.
void MGRCubicBezierEquation(double p0 , double ctrP1, double ctrP2, double p3, CGFloat xORy, double realRoot[_Nonnull]);

//! t ∈ [0, 1] 에 대한 x 또는 y 값을 반환한다. t를 넣기 전에 MAX, MIN으로 조절하자. floating 미세하게 있을 수 있다.
CGFloat MGRCubicBezierFun(double p0 , double ctrP1, double ctrP2, double p3, CGFloat t);


#pragma mark - 순열, 조합, 중복순열, 중복조합 :
NSInteger MGRFactorial(NSInteger n); // 𝐧! 계승
NSInteger MGRPermutation(NSInteger n, NSInteger r); // 𝚗𝐏𝚛 순열
NSInteger MGRCombination(NSInteger n, NSInteger r); // 𝚗𝐂𝚛 조합
NSInteger MGRRepeatedPermutation(NSInteger n, NSInteger r); // 𝚗𝚷𝚛 중복순열
NSInteger MGRRepeatedCombination(NSInteger n, NSInteger r); // 𝚗𝚮𝚛 중복조합


#pragma mark - Time :
//! 주어진 시간(초 - float)을 시, 분, 초(소숫점 첫째짜리 올림)로 분해하여 integer로 반환한다. 단 60초 초과는 분으로 60분 초과는 시간으로 계산된다.
NSArray <NSNumber *>* MGRTime_HMS_INT_CEIL(CGFloat time); // 인자는 초, 양수만 받는다.


#pragma mark - 반올림, 올림, 버림 : 소숫점 n 번째 자리에서 가능하게한다.
//! 반올림
float roundf_DecimalPlace(float arg, int place);
double round_DecimalPlace(double arg, int place);
long double roundl_DecimalPlace(long double arg, int place);
//! 올림
float ceilf_DecimalPlace(float arg, int place);
double ceil_DecimalPlace(double arg, int place);
long double ceill_DecimalPlace(long double arg, int place);
//! 버림
float floorf_DecimalPlace(float arg, int place);
double floor_DecimalPlace(double arg, int place);
long double floorl_DecimalPlace(long double arg, int place);


#pragma mark - 소숫점 자릿수 계산
//! 소숫점의 자릿수를 알려준다.
//! 3.0 => 0, 128.336 => 3, 34.0580 => 3, 88934.12430900 => 6, 88000.0000 =>0
int MGRCalculateNumberOfDecimalPlaces(double number);

NS_ASSUME_NONNULL_END
#endif /* MGRMathHelper_h */
/* ----------------------------------------------------------------------
 * 2021-06-11 : BOOL MGRRandomBOOL(void); 추가
 */

//double quadraticRealRoot[2];
//double quadraticComplRoot[2];
//int quadraticRealRootCount;
//
//QuadraticEquation(1.0, 2.0, 1.0, quadraticRealRoot, quadraticComplRoot, &quadraticRealRootCount);
//
//NSLog(@"real %f %f", quadraticRealRoot[0], quadraticRealRoot[1]);
//NSLog(@"complRoot %f %f", quadraticComplRoot[0], quadraticComplRoot[1]);
//NSLog(@"nRealRootCount %d", quadraticRealRootCount);
//
//NSLog(@"-------");
//
//double cubicRealRoot[3];
//double cubicComplRoot[3];
//int cubicRealRootCount;
//
//CubicEquation(19.0, 20.0, 16.0, 1.0, cubicRealRoot, cubicComplRoot, &cubicRealRootCount);
//
//NSLog(@"real %f %f %f", cubicRealRoot[0], cubicRealRoot[1], cubicRealRoot[2]);
//NSLog(@"complRoot %f %f %f", cubicComplRoot[0], cubicComplRoot[1], cubicComplRoot[2]);
//NSLog(@"nRealRootCount %d", cubicRealRootCount);

