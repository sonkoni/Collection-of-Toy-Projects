//
//  MGRJamo.h
//  Copyright © 2023 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2023-10-19
//  ----------------------------------------------------------------------
//
// MGRJamo
// UTF-8 기준의 Objective-C용 한글 자모 분해 라이브러리
//
// Caution
// 받침(종성)이 이중자음인 경우 두 개의 자음으로 분해함
// https://github.com/hyunsoogo/Jamo-swift
// https://velog.io/@woojusm/Swift-한글-자모-분리-검색
// https://developer.apple.com/documentation/foundation/nscharacterset/1414398-charactersetwithrange?language=objc
// https://miniwebtool.com/ko/hex-to-decimal-converter/?number=AC00
// https://dencode.com


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRJamo : NSObject

+ (NSString *)getJamo:(NSString *)input; // 주어진 "단어"를 자모음으로 분해해서 리턴하는 함수: @"손관현" => @"ㅅㅗㄴㄱㅗㅏㅎㅕㄴ"
+ (NSArray <NSString *>*)getJamoList:(NSString *)input; // @"손관현" => @[@"ㅅㅗㄴ", @"ㄱㅗㅏ", @"ㅎㅕㄴ"]

+ (NSString *)getCho:(NSString *)input; // 주어진 "단어"를 초성만 가져와서 리턴하는 함수: 손관현 =>ㅅㄱㅎ

+ (NSString *)getDanmo:(NSString *)input; // ㅘ => ㅏ, ㅙ => ㅐ, ㅚ => ㅣ, ㅝ => ㅓ, ㅞ => ㅔ, ㅟ => ㅣ, ㅢ => ㅣ

+ (BOOL)isDanmoDelete:(NSArray <NSString *>*)preInputList //이전 입력한 내용과 비교해서 삭제인지 추가 입력인지 확인하는 함수
               Delete:(NSArray <NSString *>*)inputList;

@end

NS_ASSUME_NONNULL_END
