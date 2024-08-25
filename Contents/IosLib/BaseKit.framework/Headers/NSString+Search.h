//
//  NSString+Search.h
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

@interface NSString (Search)


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

@end

NS_ASSUME_NONNULL_END
