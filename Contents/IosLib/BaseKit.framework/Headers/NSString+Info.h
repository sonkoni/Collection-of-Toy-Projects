//
//  NSString+Info.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-22
//  ----------------------------------------------------------------------
//

#import <Foundation/Foundation.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Info)

- (NSUInteger)mgrCountOfCharacter; // 글자의 갯수를 알려준다.

- (NSUInteger)mgrWordCountOfString; // 단어의 갯수를 알려준다.

- (BOOL)mgrOnlyWhitespaceAndNewlineCharacterSet; // sting이 whitespace OR newline 이면 YES를 반환한다.

// 문자열에서 특정 문자(≠ 문자열)의 갯수를 반환하는 메서드
//
// L 접두사는 C 언어에서 유니코드 문자나 와이드 문자를 나타내는 데 사용된다. 아스키 여부를 떠나 만능해결이다.
// 이것은 LITERAL을 의미한다. 'L' 접두사는 문자나 문자열이 유니코드 문자나 와이드 문자로 해석되어야 함을 나타낸다.
// 따라서 unichar characterToFind = L'관'; 는 '관' 이라는 유니코드 문자를 나타내는 것이다.
// 'L' 접두사는 문자가 유니코드로 해석되어야 함을 나타내며, 이는 이스케이프 시퀀스를 사용하지 않고도 유니코드 문자를
// 직접 사용할 수 있게 해준다.

// NSString *string = @"adsf\nasdf\nasdfdvv\nasdf\n";
// unichar character = L'\n'; // '\n' 문자를 unichar로 표현
// NSLog(@"'엔터'갯수 %lu", [string mgrCountOccurrencesOfCharacter:character]); // 엔터갯수 4
//
// NSString *string = @"관현천재....굿굿굿 관환형제관관관";
// unichar character = L'관'; // '관' 문자를 unichar로 표현
// NSLog(@"'관' 갯수 %lu", [string mgrCountOccurrencesOfCharacter:character]); // '관' 갯수 5
//
// NSString *string = @"관현천재....굿굿굿efe 관환e형제관관e관";
// unichar character = L'e'; // 'e' 문자를 unichar로 표현
// unichar character = 'e'; // 알파벳은 아스키이므로 이렇게도 가능하다
// NSLog(@"'e' 갯수 %lu", [string mgrCountOccurrencesOfCharacter:character]); // 'e' 갯수 4
- (NSUInteger)mgrCountOccurrencesOfCharacter:(unichar)character;

@end

NS_ASSUME_NONNULL_END
