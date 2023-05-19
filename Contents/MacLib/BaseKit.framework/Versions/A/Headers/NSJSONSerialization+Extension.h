//
//  NSJSONSerialization+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-06
//  ----------------------------------------------------------------------
//
// https://secretlab.games/blog/2012/07/31/using-json-to-load-objective-c-objects
// https://babbab2.tistory.com/72?category=828997
// http://wiki.mulgrim.net/page/Api:Foundation/NSJSONSerialization

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @abstract      스위프트에는 JSONDecoder 클래스가 존재하여 바로 객체를 뽑아내지만, objc에는 존재하지 않아서 만들었다.
 @discussion    json string을 가지고 만든 NSData 객체를 가지고 원하는 Objective - C 인스턴스 객체 한개를 만들어 낸다.
 
 NSJSONWritingFragmentsAllowed 옵션을 설정하지 않는 한 top level 객체는 NSArray 또는 NSDictionary이다.
 모든 객체는 NSString, NSNumber, NSArray, NSDictionary 또는 NSNull의 인스턴스이다.
 모든 딕셔너리의 키는 NSString의 인스턴스 객체이다.
 Numbers NaN이나 infinity가 아니다.
 
*/
@interface NSJSONSerialization (Extension)

#pragma mark - Decoder : JSONDecoder(스위프트에만 존재) 해당하는 기능을 구현하기 위해 만든 메서드
/**
 * @brief json string을 가지고 만든 NSData 객체를 가지고 원하는 Objective - C 인스턴스 객체 한개를 만들어 낸다.
 * @param aClass 반환될 인스턴스 객체의 클래스. 단, new로 초기화 가능해야한다.
 * @param data 반환될 인스턴스 객체(1개)에 대한 정보를 가지고 있는 NSData 인스턴스(json string으로 만들어짐)
 * @param outError Error 가 발생했을 때, 건내줄 에러객체.
 * @discussion 원하는 Objective - C 인스턴스 객체 하나를 반환할 것이다.
 * @remark NSData는 Objective - C 인스턴스 객체 하나에 대한 정보를 표현한 json string(NSString)에서 만들어진 데이터 인스턴스이다.
 * @code
        NSMutableString *jsonString = @"{\n\
                                        \"identifier\": 0, \n\
                                        \"title\": \"New Recipe\", \n\
                                        \"prepTime\": 0, \n\
                                        \"cookTime\": 0, \n\
                                        \"servings\": \"\", \n\
                                        \"ingredients\": \"\", \n\
                                        \"directions\": \"\", \n\
                                        \"isFavorite\": false, \n\
                                        \"collections\": [], \n\
                                        \"imageNames\": [\"SONKONI\"] \n\
                                        }".mutableCopy;
        
        NSRange range = [jsonString rangeOfString:@"SONKONI"];
        [jsonString replaceCharactersInRange:range withString:NSUUID.new.UUIDString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        Recipe *result = [NSJSONSerialization mgrDecodeObjectOfClass:[Recipe class] fromData:jsonData error:&error];
 * @endcode
 * @return 원하는 인스턴스 객체 1개.
*/
+ (id)mgrDecodeObjectOfClass:(Class)aClass fromData:(NSData *)data error:(NSError * _Nullable *)outError;

/*!
 @method        mgrDecodeObject:fromData:
 @abstract      위와 기능은 동일하지만, + new로 초기화가 불가능할 경우. 단순한 초기화만하여 집어 넣어 만든다.
 @param         instance
                + new로 초기화가 불가능한 객체일 때, 단순한 초기화만하여 건내준다.
 @param         data
                + mgrDecodeObjectOfClass:fromData:의 인수와 동일
 @param         outError
                + mgrDecodeObjectOfClass:fromData:의 인수와 동일
*/
+ (id)mgrDecodeObject:(id)instance fromData:(NSData *)data error:(NSError * _Nullable *)outError; // new 로 못 만들때



#pragma mark - Encoder : JSONEncoder(스위프트에만 존재) 해당하는 기능을 구현하기 위해 만든 메서드

@end

NS_ASSUME_NONNULL_END
