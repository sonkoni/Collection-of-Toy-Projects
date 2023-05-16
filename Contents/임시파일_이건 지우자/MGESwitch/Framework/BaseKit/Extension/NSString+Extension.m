//
//  NSString+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSString+Extension.h"
#import "MGRMathHelper.h"
#define STRSET_LEN     62
static NSString * const _alphaNumericCharacterSet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
static NSString * const _matrixCharacterSet = @"012Ɛᔭट6ㄥ8୧ヲァイぅエオヤユヨッソアイう工才力キクケつサツスセメA𐐒ↃDƎℲ⅁HIJK⅂MNOPQRSTUVWX⅄Z";

@implementation NSString (Parsing)
/**
// C 형태 랜덤 문자열
// ----------------------------------------------------------------------
#define CHARSET_LEN     62
static char * const _asciiCharSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 
+ (NSString *)mgrRandAsciiChar {
    char str[] = {_asciiCharSet[arc4random_uniform(CHARSET_LEN)], '\0'};
    return [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
}

+ (NSString *)mgrRandAsciiStrLength:(NSUInteger)length {
    char str[length + 1];
    for (int i = 0; i < length; i++) {
        str[i] = _asciiCharSet[arc4random_uniform(CHARSET_LEN)];
    }
    str[length] = '\0';
    return [NSString stringWithCString:str encoding:NSASCIIStringEncoding];
}

+ (NSString *)mgrRandAsciiStrMinLen:(NSUInteger)minLen maxLen:(NSUInteger)maxLen {
    uint32_t length = arc4random_uniform((uint32_t)(maxLen - minLen + 1)) + (uint32_t)minLen;
    return [self mgrRandAsciiStrLength:length];
}
 */

+ (NSString *)mgrRandAlphaNumericCharacter {
    return [NSString stringWithFormat:@"%C", [_alphaNumericCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(STRSET_LEN))]];
}

+ (NSString *)mgrRandAlphaNumericStringLength:(NSUInteger)length {
    unichar str[length + 1];
    for (int i = 0; i < length; i++) {
        str[i] = [_alphaNumericCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(STRSET_LEN))];
    }
    str[length] = '\0';
    return [NSString stringWithCharacters:str length:length];
}

+ (NSString *)mgrRandAlphaNumericStringMinLen:(NSUInteger)minLen maxLen:(NSUInteger)maxLen {
    uint32_t length = arc4random_uniform((uint32_t)(maxLen - minLen + 1)) + (uint32_t)minLen;
    return [self mgrRandAlphaNumericStringLength:length];
}

//!----------------------------------------------------------------------------
+ (NSString *)mgrRandMatrixCharacter {
    return [NSString stringWithFormat:@"%C", [_matrixCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(STRSET_LEN))]];
}

+ (NSString *)mgrRandMatrixStringLength:(NSUInteger)length {
    unichar str[length + 1];
    for (int i = 0; i < length; i++) {
        str[i] = [_matrixCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(STRSET_LEN))];
    }
    str[length] = '\0';
    return [NSString stringWithCharacters:str length:length];
}

+ (NSString *)mgrRandMatrixStringMinLen:(NSUInteger)minLen maxLen:(NSUInteger)maxLen {
    uint32_t length = arc4random_uniform((uint32_t)(maxLen - minLen + 1)) + (uint32_t)minLen;
    return [self mgrRandMatrixStringLength:length];
}


//!----------------------------------------------------------------------------
- (NSArray <NSString *>*)mgrCharacterArray {
    NSMutableArray *arr = NSMutableArray.array;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL * _Nonnull stop) {
        [arr addObject:substring];
    }];
    return arr.copy;
}

- (NSUInteger)mgrCountOfCharacter {
    __block NSUInteger characterCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL * _Nonnull stop) {
        characterCount = characterCount + 1;
    }];
    return characterCount;
}

- (NSString *)mgrRandomOneCharacter {
    NSArray <NSString *>*total = [self mgrCharacterArray];
    uint32_t idx = arc4random_uniform((uint32_t)total.count);
    return total[idx];
}

- (NSString *)mgrSubStringPrefix:(NSInteger)n {
    NSArray <NSString *>*total = [self mgrCharacterArray];
    if (total.count <= n) {
        return [self copy];
    } else {
        NSArray <NSString *>*sub = [total subarrayWithRange:NSMakeRange(0, n)];
        return [sub componentsJoinedByString:@""];
    }
}

- (NSString *)mgrSubStringSuffix:(NSInteger)n {
    NSArray <NSString *>*total = [self mgrCharacterArray];
    if (total.count <= n) {
        return [self copy];
    } else {
        NSArray <NSString *>*sub = [total subarrayWithRange:NSMakeRange(total.count - n, n)];
        return [sub componentsJoinedByString:@""];
    }
}

- (NSString *)mgrRemoveLastCharacter {
    NSUInteger count = [self mgrCountOfCharacter];
    return [self mgrSubStringPrefix:count - 1];
}

- (NSUInteger)mgrWordCountOfString {
    __block NSUInteger wordCount = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop) {
        wordCount++;
    }];
    
    return wordCount;
}

- (BOOL)mgrOnlyWhitespaceAndNewlineCharacterSet {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""] == YES) {
        return YES;
    }
    return NO;
}

- (NSString *)mgrSeparateCamelToString {
    NSRegularExpression *regularExpression =
        [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:NULL];
    return [regularExpression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@"$1 $2"];
}

- (NSArray <NSString *>*)mgrSeparateCamelToArray {
    NSString *list = [self mgrSeparateCamelToString];
    return [list componentsSeparatedByString:@" "];
}


- (NSArray <NSString *>*)mgrSeparateArrByNewLine {
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //
    // return [self componentsSeparatedByString:@"\n"]; 또는 이렇게
}

- (NSString *)mgrStringByRemovingOccurrencesOfString:(NSString *)str {
    return [self stringByReplacingOccurrencesOfString:str withString:@"" options:NO range:NSMakeRange(0, [self length])];
}

- (NSString *)mgrUppercaseStringByReplacingOccurrencesOfString:(NSString *)target
                                                    withString:(NSString *)replacement {
    return [self.uppercaseString stringByReplacingOccurrencesOfString:target withString:replacement];
}

- (NSString *)mgrCuttingNumWithUpperNumber:(CGFloat)upperNumber
                     maximumFractionDigits:(NSUInteger)count {
    NSString *text = self.copy;
    NSRange subRange = [text rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        NSArray <NSString *>*strArr = [text componentsSeparatedByString:@"."];
        NSString *floatString = strArr.lastObject;
    
        if (floatString.length > count) {
            NSNumberFormatter *formatter = NSNumberFormatter.new;
            formatter.numberStyle = NSNumberFormatterNoStyle;
            formatter.roundingMode = NSNumberFormatterRoundFloor;
            formatter.maximumFractionDigits = count;
            formatter.minimumFractionDigits = count;
            NSString *cutNumString = [formatter stringFromNumber:@(text.doubleValue)];
            text = cutNumString;
        }
    }
    if (upperNumber < [text doubleValue]) {
        text = [text mgrRemoveLastCharacter];
    }
//    } else { // 정수에서(.가 없을 때) 맥시멈 초과가 발생할 수 있다.
//        NSInteger number = text.integerValue;
//        if (number > upperNumber) {
//            number = number / 10; // 다시 원점으로 돌린다.
//            text = [NSString stringWithFormat:@"%ld", (long)number];
//        }
//    }
    return text;
}

- (NSString *)mgrDecimalNumWithmaximumFractionDigits:(NSUInteger)count {
    NSNumberFormatter *formatter = NSNumberFormatter.new;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSRange subRange = [self rangeOfString:@"."];
    if(subRange.location != NSNotFound) { // 존재한다면
        formatter.alwaysShowsDecimalSeparator  = YES;
        formatter.maximumFractionDigits = count;
        NSString *floatStr = [self componentsSeparatedByString:@"."].lastObject;
        if (floatStr.length > count) {
            NSAssert(FALSE, @"컷팅이 제대로 되지 않았다. 컷팅된 자료를 넣어라.");
        }
        formatter.minimumFractionDigits = floatStr.length;
    } else {
        formatter.alwaysShowsDecimalSeparator  = NO;
    }
    
    return [formatter stringFromNumber:@(self.doubleValue)];
}


#pragma mark - Time:
+ (NSString *)mgrTimeHMS:(CGFloat)time {
    
    BOOL negative = time >= 0 ? NO : YES;
    
    time = ABS(time);
    
    NSArray <NSNumber *>*timeArr = MGRTime_HMS_INT_CEIL(time);
    int hours   = [timeArr[0] intValue];
    int mins    = [timeArr[1] intValue];
    int seconds = [timeArr[2] intValue];
    
    NSString *hourString   = [NSString stringWithFormat:@"%02d", hours];
    NSString *minString    = [NSString stringWithFormat:@"%02d", mins];
    NSString *secondString = [NSString stringWithFormat:@"%02d", seconds];
    
    NSMutableArray <NSString *>*strArr = @[hourString, minString, secondString].mutableCopy;
    
    if (hours == 0) {
        [strArr removeObjectAtIndex:0];
    }
    
    NSString *result = [strArr componentsJoinedByString:@":"];
    if (negative == NO) {
        return result;
    } else {
        return [NSString stringWithFormat:@"-%@", result];
    }
}

@end


@implementation NSString (Transform)

+ (NSString *)mgrStringWithRepeating:(NSString *)repeatedValue count:(NSInteger)count {
    if (count < 1) {
        NSCAssert(FALSE, @"0 이하의 정수가 들어오면 안된다.");
    }
    NSMutableString *repeated = [NSMutableString string];
    for (NSInteger i = 0; i < count; i++) {
        [repeated appendString:repeatedValue];
    }
    
    return repeated;
}

@end

//NSString *list = @"Karin, Carrie, David";
//NSArray *listItems = [list componentsSeparatedByString:@", "];

//! 구형버전.
//- (NSArray <NSString *>*)mgrCharacterArray {
//    NSMutableArray *arr = NSMutableArray.array;
//
//    for (NSUInteger i=0; i < self.length; i++) {
//        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:i];
//        NSUInteger length = range.length;
//        NSString *tmp_str = [self substringWithRange:NSMakeRange(i, length)];
//        [arr addObject:tmp_str];
//
//        if (length > 1) {
//            i = i + length - 1;
//        }
//    }
//    return arr;
//}
//
//- (NSUInteger)mgrCountOfCharacter {
//    NSUInteger characterCount = self.length;
//    for(NSUInteger i = 0; i < self.length; i++) {
//        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:i];
//        if(range.length == 1) {
//            continue;
//        } else {
//            NSUInteger jump = range.length - 1;
//            i = i + jump;
//            characterCount = characterCount - jump;
//        }
//    }
//
//    return characterCount;
//}

/** 구형버전
static NSString *alphaNumericCharacterSet = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 
NSString * randomAlphaNumericCharacter(void) {  // 한글자
    static uint32_t totalLength = 0;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        totalLength = (uint32_t)[alphaNumericCharacterSet length];
    });
    
    return [NSString stringWithFormat:@"%C", [alphaNumericCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(totalLength))]];
//    unichar character = [alphaNumericCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(totalLength))];
//    return [NSString stringWithCharacters:&character length:1];
}


+ (NSString *)randomAlphaNumericStringWithLength:(NSInteger)length { // 문장.
    static uint32_t totalLength = 0;
    static dispatch_once_t onceToken;          // dispatch_once_t는 long형
    dispatch_once(&onceToken, ^{
        totalLength = (uint32_t)[alphaNumericCharacterSet length];
    });
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [alphaNumericCharacterSet characterAtIndex:(NSUInteger)(arc4random_uniform(totalLength))]];
    }
    return randomString;
}
*/
