//
//  NSString+MGRCore.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-01-24
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// ----------------------------------------------------------------------
//  문자열 파싱 지원
@interface NSString (Parsing)

//! Alpha Numeric
+ (NSString *)mgrRandAlphaNumericCharacter; // 한글자
+ (NSString *)mgrRandAlphaNumericStringLength:(NSUInteger)length; // 문장
+ (NSString *)mgrRandAlphaNumericStringMinLen:(NSUInteger)minLen maxLen:(NSUInteger)maxLen; // 문장(최소,최대)

+ (NSString *)mgrRandMatrixCharacter; // 한글자
+ (NSString *)mgrRandMatrixStringLength:(NSUInteger)length; // 문장
+ (NSString *)mgrRandMatrixStringMinLen:(NSUInteger)minLen maxLen:(NSUInteger)maxLen; // 문장(최소,최대)


//! ---------------------------------------------------------------------
- (NSArray <NSString *>*)mgrCharacterArray; // 한 글자씩 뽑아서 배열을 만들어준다. 스페이스도 넣어준다.

- (NSUInteger)mgrCountOfCharacter; // 글자의 갯수를 알려준다.
- (NSString *)mgrRandomOneCharacter; // 랜덤으로 한글자를 뽑아준다. ex) abcdefXYZ관현 => a 또는 관 또는 ...
- (NSString *)mgrSubStringPrefix:(NSInteger)n; // 앞에서 글자 n 개만 뽑아서 반환한다. 글자가 모자르면 전체 글자 반환.
- (NSString *)mgrSubStringSuffix:(NSInteger)n; // 뒤에서 글자 n 개만 뽑아서 반환한다. 글자가 모자르면 전체 글자 반환.
- (NSString *)mgrRemoveLastCharacter; // 마지막 글자를 제거한다.

- (NSUInteger)mgrWordCountOfString; // 단어의 갯수를 알려준다.
- (BOOL)mgrOnlyWhitespaceAndNewlineCharacterSet; // sting이 whitespace OR newline 이면 YES를 반환한다.

- (NSString *)mgrSeparateCamelToString; // 'ThisStringIsJoined' -> 'This String Is Joined'
- (NSArray <NSString *>*)mgrSeparateCamelToArray; // 'ThisStringIsJoined' -> @[@(This), @(String), @(Is), @(Joined)];
- (NSArray <NSString *>*)mgrSeparateArrByNewLine; // 개행 단위로 분해한다.

/*!
 * @abstract 매개변수로 주어지는 문자열을 모두 찾아 한꺼번에 지워버린다.
 */
- (NSString *)mgrStringByRemovingOccurrencesOfString:(NSString *)str;

/*!
 * @abstract    첫 번째 매개변수로 주어지는 문자열을 모두 찾아 두 번째 문자열로 치환한 결과를 대문자로 바꿔서 반환한다.
 * @discussion  첫 번째 인자에 @"-"를 넣고 두 번째 인자에 @" "를 넣으면 다음과 같은 결과를 얻을 수 있다.
 *              h-haha ==> H HAHA
 */
- (NSString *)mgrUppercaseStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;


#pragma mark - Cutting
/**
 * @brief 규정된 boundary에 벗어나면 마지막 입력(무조건 제일 오른쪽) 글자를 삭제한다.
 * @param number 상한에 해당하는 숫자. 즉, 이 숫자보다 크면 마지막 입력된 값을 취소.(맨 오른쪽 문자 삭제.)
 * @param count 소숫점 몇자리까지 표기할 것인가
 * @discussion 천자리를 의미하는 ','(쉼표)는 존재 하지 않는 것으로 가정한다.
 * @remark 올바르지 않은 표현은 없는 것으로 가정한다. 음수는 가정하지 않는다.
 * @code
    // 123.896 => 123.89
    // 76.2 => 76.2
    // 76.10 => 76.10
    // 55.0 => 55.0
    // 55. => 55.
    // 55 => 55
    // 100 => 100
    NSString *result = [string mgrCuttingNumWithUpperNumber:100000000
                                      maximumFractionDigits:2];
 
 * @endcode
 * @return Cutting 된 문자열을 반환한다.
*/
- (NSString *)mgrCuttingNumWithUpperNumber:(CGFloat)number maximumFractionDigits:(NSUInteger)count;


#pragma mark - Decimal
/**
 * @brief 천 자리가 넘어가면 쉼표를 넣어준다.
 * @param count 소숫점 몇자리까지 표기할 것인가.
 * @discussion 소숫점 자리는 인수로 건낸 카운트까지는 보장하며, 없을 경우에는 표기하지 않는다.
 * @remark 올바르지 않은 표현은 없는 것으로 가정한다. 음수는 가정하지 않는다. 이미 컷팅된 자료가 들어와야한다. 여기서 컷팅은 하지 않는다.
 * @code
    // 1223.89 => 1,223.89
    // 76.2 => 76.2
    // 76.10 => 76.10
    // 55.0 => 55.0
    // 55. => 55.
    // 55 => 55
    // 100 => 100
    NSString *result = [string mgrDecimalNumWithmaximumFractionDigits:2];
 
 * @endcode
 * @return 현재 입력된 글자까지 Decimal Style 로 표기한다.
*/
- (NSString *)mgrDecimalNumWithmaximumFractionDigits:(NSUInteger)count;


#pragma mark - Time:
//! 주어진 시간(초 float 소숫점 첫 째짜리 반올림)을 14:58:34로 반환한다. 1시간이 안되면, 58:34로 반환한다. 음수도 가능하다.
+ (NSString *)mgrTimeHMS:(CGFloat)time;
@end

@interface NSString (Transform)
+ (NSString *)mgrStringWithRepeating:(NSString *)repeatedValue count:(NSInteger)count; // 반복해서 붙여준다. 1 이상 넣어라. 그 이하면 터지게 할 것이다.
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-01-24 : @interface NSString (Transform) 추가함.
 * 2021-07-01 : - mgrOnlyWhitespaceAndNewlineCharacterSet 추가함.
 * 2021-06-30 : - mgrRemoveLastCharacter 추가함.
 * 2021-01-18 : 라이브러리 정리됨
 */
