//
//  MGRMathHelper.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "MGRMathHelper.h"

//! value 는 0.0 ~ 1.0
static CGFloat MGRFocus1(CGFloat value);
static CGFloat MGRFocus2(CGFloat value);
static CGFloat MGRFocus3(CGFloat value);


#pragma mark - Prime Number : MGRPrimeNumber_
BOOL MGRPrimeNumber(NSInteger number) {
    if (number < 2) {
#if DEBUG
        NSLog(@"2보다 작은 자연수는 당연히 Prime Number가 아니다.");
#endif
        return NO;
    }
    
    if (number == 2) {
        return YES;
    }
    
    if (number % 2 == 0) {
        return NO;
    }
    
    for (int div = 3; div <= sqrt(number); div+=2) {
        if (number % div == 0) {
            return NO;
            break;
        }
    }

    return YES;
//    아래 식이 더 깔끔하게 보이지만, 위의 식이 더 최적화인듯.
//    if (number < 2) {
//        NSLog(@"2보다 작은 자연수는 당연히 Prime Number가 아니다.");
//        return NO;
//    }
//
//    for (int div = 2; div <= sqrt(number); div++) { // 2가 들어왔을 때에는 1.424로 해석되어 for 문이 실행되지 않는다.
//        if (number % div == 0) {
//            return NO;
//            break;
//        }
//    }
//
//    return YES;
}


#pragma mark - Random Function
BOOL MGRRandomBOOL(void) {
    //! 0 또는 1 반환
    if (arc4random_uniform(2) == 1) {
        return YES;
    } else {
        return NO;
    }
}

CGFloat MGRRandomFloat(void) {
    return (CGFloat)(arc4random()) / (CGFloat)(UINT32_MAX);
}

CGFloat MGRRandomFloatRange(CGFloat start, CGFloat end) {
    CGFloat random = MGRRandomFloat();
    return (end - start) * random + start;
}

CGFloat MGRRandomFocus3(NSInteger focus) {
    CGFloat randomValue = MGRRandomFloat();
    if (focus == 1) {
        return MGRFocus1(randomValue);
    } else if (focus == 2) {
        return MGRFocus2(randomValue);
    } else {
        return MGRFocus3(randomValue);
    }
}


//! private
//! 0.0 에 가까운 값을 더 많이 뽑아준다.
static CGFloat MGRFocus1(CGFloat value) {
    if (value < (2.0 / 3.0)) {
        return value / 2.0;
    } else {
        return ((value * 2.0) - 1.0);
    }
}

//! 0.5 에 가까운 값을 더 많이 뽑아준다.
static CGFloat MGRFocus2(CGFloat value) {
    if (value < (1.0 / 3.0)) {
        return value * 2.0;
    } else if (value < (2.0 / 3.0)) {
        return ((value / 2.0) + (1.0 / 4.0));
    } else {
        return ((value * 2.0) - 1.0);
    }
}

//! 1.0 에 가까운 값을 더 많이 뽑아준다.
static CGFloat MGRFocus3(CGFloat value) {
    if (value < (1.0 / 3.0)) {
        return value * 2.0;
    } else {
        return ((value / 2.0) + (1.0 / 2.0));
    }
}


#pragma mark - Equation Function : MGR_Equation
void MGRLinearEquation(double a , double b, double * realRoot) {
    if (a == 0) {
        NSCAssert(false, @"1차방정식이 아니다. 1차항의 계수가 0.0");
        return;
    }
    
    *realRoot = -b / a;
}

void MGRQuadraticEquation(double a, double b, double c, double realRoot[], double complRoot[], int * nRealRootCount) {
    if (a == 0) {
        NSCAssert(false, @"2차방정식이 아니다. 2차항의 계수가 0.0");
        return;
    }
    /* 2차 방정식의 판별식 */
    double D = b * b - 4 * a *c;
    
    if(D == 0) { // 중근(실근)
        *nRealRootCount = 1;
        complRoot[0] = 0;
        complRoot[1] = 0;
        realRoot[0] = -b / (2 * a);
        realRoot[1] = realRoot[0];
        
    } else if(D < 0) { // 허근
        *nRealRootCount = 0;
        complRoot[0] = sqrt(-D) / (2 * a);
        complRoot[1] = -1 * (sqrt(-D) / (2 * a));
        realRoot[0] = -b / (2 * a);
        realRoot[1] = -b / (2 * a);
        
    } else { // 두 개의 실근
        *nRealRootCount = 2;
        complRoot[0] = 0;
        complRoot[1] = 0;
        realRoot[0] = -b / (2 * a) + sqrt(D) / (2 * a);
        realRoot[1] = -b / (2 * a) - sqrt(D) / (2 * a);
    }
}

//! 3차 방정식 근 구하기. 카르다노 해법.
void MGRCubicEquation(double a, double b, double c, double d, double realRoot[], double complRoot[], int * nRealRootCount) {
    if (a == 0) {
        NSCAssert(false, @"3차방정식이 아니다. 3차항의 계수가 0.0");
        return;
    }
    
    b = b / a;
    c = c / a;
    d = d / a;
    
    double disc, q, r, dum1, s, t, term1, r13;
    
    q = (3.0*c - (b*b))/9.0;
    r = -(27.0*d) + b*(9.0*c - 2.0*(b*b));
    r = r / 54.0;
    disc = q*q*q + r*r;
    complRoot[0] = 0; // The first root is always real.
    term1 = b / 3.0;
    
    if (disc > 0) { // 한 개의 real 근, 두 개의 complex 근
        s = r + sqrt(disc);
        s = ((s < 0) ? -pow(- s, (1.0/3.0)) : pow(s, (1.0/3.0)));
        t = r - sqrt(disc);
        t = ((t < 0) ? -pow(- t, (1.0/3.0)) : pow(t, (1.0/3.0)));
        realRoot[0] = -term1 + s + t;
        term1 += (s + t)/2.0;
        realRoot[1] = -term1;
        realRoot[2] = -term1;
        term1 = sqrt(3.0)*(-t + s)/2;
        complRoot[1] = term1;
        complRoot[2] = -term1;
        *nRealRootCount = 1;
        return;
    } else if (disc == 0) { // 모두 실근, 최소 두 개는 중근. 즉, 2중근 또는 3중근.
        complRoot[2] = complRoot [1] = 0;
        r13 = ((r < 0) ? -pow(- r,(1.0/3.0)) : pow(r,(1.0/3.0)));
        realRoot[0] = -term1 + 2.0*r13;
        realRoot[2] = realRoot[1] = -(r13 + term1);
        *nRealRootCount = 2;
        return;
    } else { // Only option left is that all roots are real and unequal (to get here, q < 0)
        q = -q;
        dum1 = q*q*q;
        dum1 = acos(r / sqrt(dum1));
        r13 = 2.0 * sqrt(q);
        realRoot[0] = -term1 + r13 * cos(dum1 / 3.0);
        realRoot[1] = -term1 + r13 * cos((dum1 + 2.0 * M_PI) / 3.0);
        realRoot[2] = -term1 + r13 * cos((dum1 + 4.0 * M_PI) / 3.0);
        *nRealRootCount = 3;
    }
    return;
}


#pragma mark - Bezier path : MGRCubicBezier_
void MGRCubicBezierEquation(double p0 , double ctrP1, double ctrP2, double p3, CGFloat xORy, double realRoot[]) {
    double a = (p3 - 3 * ctrP2 + 3 * ctrP1 - p0);
    double b = (3 * ctrP2 - 6 * ctrP1 + 3 * p0);
    double c = (3 * ctrP1 - 3 * p0);
    double d = p0 - xORy;
    
    double complRoot[3]; // 필요 없는 것. 인수 자리만 채우자.
    int domi;            // 필요 없는 것. 인수 자리만 채우자.
    MGRCubicEquation(a, b, c, d, realRoot, complRoot, &domi);
}

CGFloat MGRCubicBezierFun(double p0 , double ctrP1, double ctrP2, double p3, CGFloat t) {
    if (t < 0.0 || t > 1.0) {
        NSCAssert(false, @"t ∉ [0.0, 1] 이다. 이렇게 되면 안된다.");
    }
    
    double nt = (1 - t);
    return (p0 * nt * nt * nt) + (3 * ctrP1 * t * (nt * nt)) + (3 * ctrP2 * t * t * nt) + (p3 * t * t * t);
}


#pragma mark - 순열, 조합, 중복순열, 중복조합 :
NSInteger MGRFactorial(NSInteger n) { // 재귀호출 𝐧! 계승
    if (n < 0) {
        NSCAssert(FALSE, @"음수의 factorial은 정의되지 않는다.");
    }
    if (n == 1 || n == 0) { // n이 1 또는 0일때.
        return 1;           // 1을 반환하고 재귀호출을 끝냄
    }
    return n * MGRFactorial(n - 1);    // n과 factorial 함수에 n - 1을 넣어서 반환된 값을 곱함
}

NSInteger MGRPermutation(NSInteger n, NSInteger r) { // 𝚗𝐏𝚛 순열
    return MGRFactorial(n) / MGRFactorial(n - r);
}
 
NSInteger MGRCombination(NSInteger n, NSInteger r) { // 𝚗𝐂𝚛 조합
    return MGRPermutation(n, r) / MGRFactorial(r);
}

NSInteger MGRRepeatedPermutation(NSInteger n, NSInteger r) { // 𝚗𝚷𝚛 중복순열
    return (NSInteger)(pow((double)n, (double)r));
}

NSInteger MGRRepeatedCombination(NSInteger n, NSInteger r) { // 𝚗𝚮𝚛 중복조합 (𝚗+𝚛-1𝐂𝚛)
    return MGRCombination(n + r - 1, r);
}


#pragma mark - Time :
NSArray <NSNumber *>* MGRTime_HMS_INT_CEIL(CGFloat time) {
    if (time < 0) {
        NSCAssert(FALSE, @"MGRTime_HMS_INT_CEIL 함수는 음수는 안된다.");
    }
    int ceiledTime = (int)ceil(time); // 올림 함수 decimal로 나오는 초를 올려버린다.

    int hours   =  ceiledTime / 3600;       // int로 계산해야함
    int minutes = (ceiledTime % 3600) / 60; // int로 계산해야함
    int seconds = (ceiledTime % 3600) % 60; // int로 계산해야함
    
    return @[@(hours), @(minutes), @(seconds)];
}


#pragma mark - 반올림, 올림, 버림 :
//! 반올림
float roundf_DecimalPlace(float arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 반올림이다.");
    }
    
    float constant = pow(10.0, (float)(place - 1));
    return roundf(arg * constant) / constant;
}

double round_DecimalPlace(double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 반올림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return round(arg * constant) / constant;
}

long double roundl_DecimalPlace(long double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 반올림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return roundl(arg * constant) / constant;
}

//! 올림
float ceilf_DecimalPlace(float arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 올림이다.");
    }
    
    float constant = pow(10.0, (float)(place - 1));
    return ceilf(arg * constant) / constant;
}

double ceil_DecimalPlace(double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 올림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return ceil(arg * constant) / constant;
}

long double ceill_DecimalPlace(long double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 올림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return ceill(arg * constant) / constant;
}

//! 버림
float floorf_DecimalPlace(float arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 버림이다.");
    }
    
    float constant = pow(10.0, (float)(place - 1));
    return floorf(arg * constant) / constant;
}

double floor_DecimalPlace(double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 버림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return floor(arg * constant) / constant;
}

long double floorl_DecimalPlace(long double arg, int place) {
    if (place < 1) {
        NSCAssert(FALSE, @"place는 1이상이다. 1이면 소숫점 첫 째자리에서 버림이다.");
    }
    float constant = pow(10.0, (float)(place - 1));
    return floorl(arg * constant) / constant;
}


#pragma mark - 소숫점 자릿수 계산
//! 소숫점의 자릿수를 알려준다.
//! 3.0 => 0, 128.336 => 3, 34.0580 => 3, 88934.12430900 => 6, 88000.0000 =>0
int MGRCalculateNumberOfDecimalPlaces(double number) {
    int count = 0;
    float threshold = 0.00001; // 허용오차.
    while ( fabs(number - round(number)) > threshold ) {
        count++;
        number *= 10;
    }
    return count;
}
