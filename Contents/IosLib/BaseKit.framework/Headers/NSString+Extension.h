//
//  NSString+MGRCore.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-01-24
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MGRRegularExpStr NS_TYPED_EXTENSIBLE_ENUM;
static MGRRegularExpStr const MGRRegularExpStrAlphabetUppercase = @"[A-Z]"; // 대문자 중 1개
static MGRRegularExpStr const MGRRegularExpStrAlphabetLowercase = @"[a-z]"; // 소문자 중 1개
static MGRRegularExpStr const MGRRegularExpStrAlphabet = @"[A-Za-z]"; // 알파벳 중 1개
static MGRRegularExpStr const MGRRegularExpStrNumber = @"[0-9]"; // 숫자 중 1개
static MGRRegularExpStr const MGRRegularExpStrHexadecimal = @"[A-Fa-f0-9]"; // 16진수
static MGRRegularExpStr const MGRRegularExpStrNonNumber = @"[^0-9]"; // 숫자가 아닌 문자
static MGRRegularExpStr const MGRRegularExpStrAlphaNumeric = @"[A-Za-z0-9]"; // 영숫자
static MGRRegularExpStr const MGRRegularExpStrKorean = @"[가-힣]"; // 한글
static MGRRegularExpStr const MGRRegularExpStrSpaceTab = @"[ \t]"; // 공백과 탭
static MGRRegularExpStr const MGRRegularExpStrWhitespace = @"[ \t\r\n]"; // 공백 문자 중 1개 [ \t\r\n\v\f], \v\f는 인쇄와 관련
static MGRRegularExpStr const MGRRegularExpStrNonWhitespace = @"[^ \t\r\n]"; // 공백이 아닌 모든 문자 중 1개 [^ \t\r\n\v\f], \v\f는 인쇄와 관련

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

// 완벽하지는 않지만 유용함
- (NSString *)mgrSubstringBefore:(NSString *)separater; // 특정 문자열을 기준으로 처음부터 특정 문자열 등장 이전까지 뽑아줌.
- (NSString *)mgrSubstringAfter:(NSString *)separater; // 특정 문자열을 기준으로 등장 이후 부터 끝까지 뽑아줌.
- (NSString *)mgrSubStringAfter:(NSString *)fromString before:(NSString *)toString; // 특정 문자열들 사이의 부분 문자열 뽑아줌

- (NSUInteger)mgrWordCountOfString; // 단어의 갯수를 알려준다.
- (BOOL)mgrOnlyWhitespaceAndNewlineCharacterSet; // sting이 whitespace OR newline 이면 YES를 반환한다.

- (NSString *)mgrSeparateCamelToString; // 'ThisStringIsJoined' -> 'This String Is Joined'
- (NSArray <NSString *>*)mgrSeparateCamelToArray; // 'ThisStringIsJoined' -> @[@(This), @(String), @(Is), @(Joined)];
- (NSArray <NSString *>*)mgrSeparateArrByNewLine; // 개행 단위로 분해한다.

/*
 /// 앞 뒤 둘 다 사용하는 것을 먼저 호출하자.
 NSString *original = @"BinaryWave기준값매수";
 NSString *result = [original mgrInsertSpacePreExpression:MGRRegularExpStrNonWhitespace
                                           postExpression:MGRRegularExpStrNonWhitespace
                                                  replace:@"기준값"
                                                  changed:@"기준값"];
 // Output: `BinaryWave 기준값 매수`
 
 NSString *original = @"Volume&PriceInSync";
 NSString *result = [original mgrInsertSpacePreExpression:MGRRegularExpStrNonWhitespace
                                           postExpression:MGRRegularExpStrNonWhitespace
                                                  replace:@"&"
                                                  changed:@"&"];
 // Output: `Volume & PriceInSync`
 
 NSString *original = @"상승횡보후재상승";
 NSString *result = [original mgrInsertSpacePreExpression:nil
                                           postExpression:MGRRegularExpStrNonWhitespace
                                                  replace:@"횡보후"
                                                  changed:@"횡보 후"];
 // Output: `상승횡보 후 재상승`
 
 NSString *original = @"AVG골든크로스";
 NSString *result = [original mgrInsertSpacePreExpression:MGRRegularExpStrAlphabet
                                           postExpression:nil
                                                  replace:@"골"
                                                  changed:@"골"];
 // Output: `AVG 골든크로스`
*/
- (NSString *)mgrInsertSpacePreExpression:(MGRRegularExpStr _Nullable)preExpression
                           postExpression:(MGRRegularExpStr _Nullable)postExpression
                                  replace:(NSString *)replace
                                  changed:(NSString *)changed;

/**
 * @brief 현재 string에서 좌*우측의 공백을 제거한 후, 공백을 기준으로 문자열을 나누어 배열로 반환한다.
 * @discussion search textField로 문자열이 들어왔을 때, predicate에 적용될 수 있도록 기본준비를 하게 해준다.
 * @remark 실전 예제를 보고 싶다면 SearchDisplayingSearchableContentByUsingASearchController_koni
 *         SuggestedSearch_koni 프로젝트를 참고하고 위키는 Project:Mac-ObjC/필터링을 보면된다.
 * @code
        NSString *searchString = @"    AAa vvV cCc ddD  ";
        NSArray <NSString *>*searchItems = [searchString mgrSearchItems];
        for (NSString *str in searchItems) {
            NSLog(@"==>[%@]", str);
        }
        // Output
        // ==>[aaa]
        // ==>[vvv]
        // ==>[ccc]
        // ==>[ddd]
 * @endcode
 * @return 검색할 문자열들의 배열이 반환된다.
*/
- (NSArray <NSString *>*)mgrSearchItems;

// 한글도 가능하게 만듬. ex) "스위프트" 검색 시 => ㅅ, 승, 스우, 스윞 모두 가능
// 초성검색도 가능하게 만들었다. "스위프트" 검색 시 => ㅅㅇㅍㅌ
// 검색 알고리즘 좋은 예
//  SearchDisplayingSearchableContentByUsingASearchController_koni
//  SuggestedSearch_koni
- (NSRange)mgrRangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask;

// - mgrRangeOfString:options: 메서드에서 & 검색이 되게 만들었다. 기존 메서드의 기능을 포함한다.
// 단, 반환형은 BOOL ∵ 여러 단어를 포함하므로 range로 표현하기 곤란하다
// ex) "Bollinger Bands" 검색 시 Bol & Ban 으로 검색이 가능하게 만들었음 두 단어가 모두 들어간 것을 찾는다
// Bol 만 검색해도 찾기는 하는데, Ban을 띄어쓰기하고 넣으면 두 입력 단어를 모두 포함하는 것으로 검색해준다
- (BOOL)mgrContainOfMultiString:(NSString *)searchString options:(NSStringCompareOptions)mask;

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

// 문자열 마지막에 숫자가 등장한다면 숫자를 제거해준다. space + 숫자일 경우, space까지 지울지 선택할 수 있다.
// NSString *str2 = @"ADX 2"; => "ADX " OR "ADX"
- (NSString *)mgrRemoveLastNumberWithSpaceRemove:(BOOL)spaceRemove;


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

#pragma mark - ETC

//! 두 번째 줄부터 indent를 준다. ex) 14.0 괜찮은듯
- (NSAttributedString *)mgrAttrStrWithHeadIndent:(CGFloat)headIndent;

//! EUC-KR 인식
// https://developer.apple.com/documentation/corefoundation/cfstring/external_string_encodings?language=objc
// kCFStringEncodingMacKorean
// kCFStringEncodingDOSKorean <- 요놈
// kCFStringEncodingWindowsKoreanJohab
+ (NSString *)mgrEUCKRCompatibleContentsOfFile:(NSString *)path
                                         error:(NSError *__autoreleasing  _Nullable * _Nullable)error;

#pragma mark - DEPRECATED
// 공백 포함하여 글자를 하나씩 배열로 분리한다.
- (NSArray<NSString*> *)mgrSplit DEPRECATED_MSG_ATTRIBUTE("- mgrCharacterArray; 이 메서드를 대신 사용하라. 완전히 똑같다.");
@end

@interface NSString (Transform)
+ (NSString *)mgrStringWithRepeating:(NSString *)repeatedValue count:(NSInteger)count; // 반복해서 붙여준다. 1 이상 넣어라. 그 이하면 터지게 할 것이다.
@end

@interface NSString (Save)
- (void)mgrSaveJSON;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-01-24 : @interface NSString (Transform) 추가함.
 * 2021-07-01 : - mgrOnlyWhitespaceAndNewlineCharacterSet 추가함.
 * 2021-06-30 : - mgrRemoveLastCharacter 추가함.
 * 2021-01-18 : 라이브러리 정리됨
 */
