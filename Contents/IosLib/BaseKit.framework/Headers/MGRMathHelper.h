//
//  MGRMathHelper.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-13
//  ----------------------------------------------------------------------

#ifndef MGRMathHelper_h
#define MGRMathHelper_h
#import <complex.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>   /* for CGFloat, CGPoint, CGSize, CGVector, CGRect, CGMacro */

#pragma mark - Macro : MGRMATH_

// (BOOL) 두 수의 FLT_EPSILON 동일 비교
#define MGR_FLT_EQUAL(lvar, rvar)      (fabs(lvar - rvar) <= FLT_EPSILON)
#define MGR_EPSILON (4.94065645841247E-224) // LDBL_EPSILON 보다 작다.

typedef double _Complex DoubleComplex; // 컴파일러 에러 때문에

// ----------------------------------------------------------------------

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Prime Number : MGRPrimeNumber_
BOOL MGRPrimeNumber(NSInteger number); // Prime Number이면 YES를 반환한다.


#pragma mark - GCD, LCM https://cocoon1787.tistory.com/97
NSInteger mgr_math_gcd(NSInteger a, NSInteger b); // 최대공약수
NSInteger mgr_math_lcm(NSInteger a, NSInteger b); // 최소공배수


#pragma mark - Random Function : MGRRandom_
BOOL MGRRandomBOOL(void); //! 임의의 YES 또는 NO 값을 뽑아준다.

CGFloat MGRRandomFloat(void); //! 0.0 ~ 1.0 사이의 임의의 CGFloat 값을 뽑아준다.

CGFloat MGRRandomFloatRange(CGFloat start, CGFloat end); //! start ~ end 사이의 임의의 CGFloat 값을 뽑아준다.

//! 0.0 ~ 1.0 사이의 임의의 CGFloat 값을 뽑아주는 데 Focus를 주어서 뽑아낸다.
//! focus 1, 2, 3 단계가 존재한다.
CGFloat MGRRandomFocus3(NSInteger focus);


#pragma mark - Equation Function : MGREquation_
/*** 1차 방정식, 2차 방정식, 3차 방정식, 4차 방정식 ****/
void MGRLinearEquation(double a , double b, double * realRoot); // 1차
void MGRQuadraticEquation(double a, double b, double c, DoubleComplex roots[_Nonnull], int * nRealRootCount); // 2차
/**
* 3차 방정식의 해를 구한다.
* @param a                 3차 항의 계수 : 0.0을 대입하면 터지게 설게되어있다.
* @param b                 2차 항의 계수
* @param c                 1차 항의 계수
* @param d                 상수
* @param roots             복수소를 담은 배열
* @param nRealRootCount    실근의 갯수
* @discussion              #include <complex.h> 헤더를 받아야 double complex 타입을 사용할 수 있다.
* @code
 
    double complex roots3[3]; // 3은 3차 방정식이므로
    int cubicRealRootCount = 0;

    MGRCubicEquation(5, -4, -22, 100.0, roots3, &cubicRealRootCount);
 
    NSLog(@"(%f) + (%f)i,
            (%f) + (%f)i,
            (%f) + (%f)i] 실근 갯수 %d",
            creal(roots3[0]), cimag(roots3[0]),
            creal(roots3[1]), cimag(roots3[1]),
            creal(roots3[2]), cimag(roots3[2]),
            count);
 @endcode
*/
void MGRCubicEquation(double a, double b, double c, double d, DoubleComplex roots[_Nonnull], int * nRealRootCount); // 3차
void MGRQuarticEquation(double a , double b, double c, double d, double e, DoubleComplex roots[_Nonnull], int * nRealRootCount); // 4차


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


#pragma mark - Time : MGRTime_
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
#pragma mark - 반올림: MGRRound_  소숫점 n 번째 자리에서 반올림한다.
float MGRRoundFloatDecimal(float arg, int place);
double MGRRoundDoubleDecimal(double arg, int place);
long double MGRRoundLongDoubleDemical(long double arg, int place);
#pragma mark - 올림: MGRCeil_  소숫점 n 번째 자리에서 가능하게한다.
float MGRCeilFloatDecimal(float arg, int place);
double MGRCeilDoubleDecimal(double arg, int place);
long double MGRCeilLongDoubleDecimal(long double arg, int place);
#pragma mark - 버림: MGRFloor_  소숫점 n 번째 자리에서 가능하게한다.
float MGRFloorFloatDecimal(float arg, int place);
double MGRFloorDoubleDecimal(double arg, int place);
long double MGRFloorLongDoubleDecimal(long double arg, int place);


#pragma mark - 특수 반올림:
// 0.5 단위로 입력한 수에 대한 제일 가까운 수를 반환한다.
// 0.5 단위. 593.363624 => 593.5, -593.463624 => -593.5, 1.342787 => 1.5, -1.342787 => -1.5
double MGRHalfRound(double arg);


#pragma mark - 소숫점 자릿수 계산
//! 소숫점의 자릿수를 알려준다.
//! 3.0 => 0, 128.336 => 3, 34.0580 => 3, 88934.12430900 => 6, 88000.0000 =>0
int MGRCalculateNumberOfDecimalPlaces(double number);


#pragma mark - BitMask
// http://wiki.mulgrim.net/page/Inbox:비트연산자
// https://dojang.io/mod/page/view.php?id=184
// 비트마스크에서 0 값은 아무런 의미가 없다. 어떠한 것도 하지 않는 것을 의미한다.
//
//! mask(한 개)가 flag에 존재하는지를 알려준다. 마스크가 합성 마스크인 경우에는 의미가 없다. 마스크가 0 인경우에는 의미가 없다.
BOOL MGRBitMaskContain(NSUInteger flag, NSUInteger mask);

//! mask(한 개)가 flag에 없으면 더하여 새로운 flag를 반환한다.
//! 즉, mask 에 (1) 해당하는 자리에 flag도 (1)을 갖게된다.(원래 뭐든간에) 나머지는 flag 숫자 유지. mask 0인자리는 신경쓰지 않는다.
NSUInteger MGRBitMaskAdd(NSUInteger flag, NSUInteger mask);

//! mask(한 개)가 flag에 존재하면 빼서 새로운 flag를 반환한다.
//! 즉, mask 에 (1) 해당하는 자리에 flag는 (0)을 갖게된다.(원래 뭐든간에) 나머지는 flag 숫자 유지. mask 0인자리는 신경쓰지 않는다.
NSUInteger MGRBitMaskRemove(NSUInteger flag, NSUInteger mask);

//! 토글(toggle) 즉, mask 에 (1) 해당하는 자리에 flag는 자신의 원래값과 반대를 갖게된다.(원래 뭐든간에) 나머지는 flag 숫자 유지. mask 0인자리는 신경쓰지 않는다.
NSUInteger MGRBitMaskSwitch(NSUInteger flag, NSUInteger mask);

//! log로 비트마스크의 비쥬얼을 보여준다.
void MGRBitMaskDisplay(NSUInteger mask);


#pragma mark - 수열의 합: 등차 수열, 등비 수열 MGRArithmeticSeries, MGRGeometricSeries
/**
 * @brief 1부터 n까지의 자연수 합(등차 수열의 합) - 가우스합
 * @param n 총 항의 갯수를 의미한다.
 * @discussion 1 + 2 + ··· + n 의 결과 값을 반환한다.
 * @code
        NSUInteger result = MGRArithmeticGaussSeries(4);
        // 1 + 2 + 3 + 4 ==> 즉, 10이 반환된다.
 * @endcode
 * @return 1부터 n까지의 합이 반환된다.
*/
NSUInteger MGRArithmeticGaussSeries(NSUInteger n); // 등차 수열의 합 1부터 n까지 합 - 가우스합

/**
 * @brief a1 부터 시작된 값이 일정한 값(공차:commonDifference)을 더하여 n 개의 항을 이룰 때, 그 모든 항의 값을 더한 등차 수열의 합을 의미한다.
 * @param a1 초항(최초의 항)
 * @param commonDifference 공차 : 공통적으로 더해지는 값(항이 올라 갈때, 일정하게 더해지는 값)
 * @param n 총 항의 갯수를 의미한다.
 * @discussion a1 + a2 + a2 + ··· + an 의 결과 값을 반환한다.
               a1 + (a1 + commonDifference) + (a1 + commonDifference * 2) + ··· + (a1 + commonDifference * commonDifference * (n-1))와 도 같다.
 * @code
         NSUInteger result = MGRArithmeticSeriesWithDifference(5, 2, 8);
         // 5 + 7 + 9 + 11 + 13 + 15 + 17 + 19 ==> 96
 * @endcode
 * @return a1부터 commonDifference씩 더해지는 수열이 n개 존재할 때의 합이다.
*/
CGFloat MGRArithmeticSeriesWithDifference(CGFloat a1, CGFloat commonDifference, NSUInteger n); // 등차 수열의 합

/**
 * @brief a1 부터 시작된 값이 일정한 값(공차)을 더하여 n 개의 항을 이루고 마지막항이 an일때, 그 모든 항의 값을 더한 등차 수열의 합을 의미한다.
 * @param a1 초항(최초의 항)
 * @param an 마지막 항
 * @param n 총 항의 갯수를 의미한다.
 * @discussion a1 + a2 + a2 + ··· + an 의 결과 값을 반환한다.
 * @code
         NSUInteger result = MGRArithmeticSeriesWithLastEntry(5, 19, 8);
         // 5 + 7 + 9 + 11 + 13 + 15 + 17 + 19 ==> 96
 * @endcode
 * @return a1부터 an까지 일정하게 더해지는 수열의 갯수가 n개 존재할 때의 합이다.
*/
CGFloat MGRArithmeticSeriesWithLastEntry(CGFloat a1, CGFloat an, NSUInteger n); // 등차 수열의 합

//! a1 부터 시작된 값이 일정한 값(공비:commonDifference)을 곱하여 n 개의 항을 이룰 때, 그 모든 항의 값을 더한 등차 수열의 합을 의미한다.
CGFloat MGRGeometricSeries(CGFloat a1, CGFloat commonRatio, NSUInteger n); // 등비 수열의 합

NS_ASSUME_NONNULL_END
#endif /* MGRMathHelper_h */

/* ----------------------------------------------------------------------
 * 2022-12-13 : 덧셈 추가
 * 2022-05-12 : 비트마스크 함수 추가
 * 2021-12-29 : 반올림/올림/버림 함수 이름 추가.
 *              불러오기 순서: 저수준 -> 고수준 순서로 재배치.
 *              헤더의 QuartzCore 대신 CGGeometry로 변경(최소만 가져오게)
 *              c 의 complex 헤더를 가져올 때 include 대신 import 로 변경.
 *              UIKit 은 불러올 필요가 없으므로 제거.
 * 2021-06-11 : BOOL MGRRandomBOOL(void); 추가
 */




// * BaseKit-Archive : 설명할 수 있는 추가 파일들이 많이 있다. MGRMathHelper.graffle, solving a quartic equation.docx 파일.

// https://suhak.tistory.com/301 <- 3차방정식 풀이
// https://m.blog.naver.com/PostView.nhn?blogId=xtelite&logNo=50074757033&proxyReferer=https:%2F%2Fwww.google.com%2F <- 3차방정식 풀이
// https://stackoverflow.com/questions/13328676/c-solving-cubic-equations <- 3차방정식 풀이
// https://stackoverflow.com/questions/6562867/specialised-algorithm-to-find-positive-real-solutions-to-quartic-equations <- 4차방정식 풀이
// https://stackoverflow.com/questions/12991584/c-solving-for-quartic-roots-fourth-order-polynomial <- 4차방정식 풀이
// https://stackoverflow.com/questions/37944845/most-efficient-way-to-only-solve-real-roots-of-quartic-polynomial <- 4차방정식 풀이
// http://www.1728.org/cubic.htm <- 2차 3차 4차 방정식 계산기 제공사이트.
// https://www.wolframalpha.com <- 각종 수학 계산기 및 그래프 제공
// https://demo.wiris.com/mathtype/en/developers.php#mathml-latex <- 라텍스 수식편집기.

// #include <complex.h> 복소수를 표현하는 방법이 C에 존재한다. 그러나 우선은 하지 않겠다.
// C99 표준부터 복소수 연산 라이브러리가 추가되었다. https://gammabeta.tistory.com/3014
// https://www.quora.com/How-do-I-make-an-array-of-complex-number-in-C // c 언어 복소수 배열에 넣기.
// https://answer-id.com/ko/52710526
// https://gammabeta.tistory.com/3014
/**
double complex z1 = 1.0 + 3.0 * I;
double complex z2 = 3.0 + 5.0 * I;
double complex a[] = {pi, I*pi, -pi, -I*pi};
double complex sum = z1 + z2;
printf("The sum: Z1 + Z2 = %.2f %+.2fi\n", creal(sum), cimag(sum));
*/
