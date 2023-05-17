//
//  NSJSONSerialization+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//


#import "NSJSONSerialization+Extension.h"

@implementation NSJSONSerialization (Extension)

#pragma mark - Decoder : JSONDecoder(스위프트에만 존재) 해당하는 기능을 구현하기 위해 만든 메서드
+ (id)mgrDecodeObjectOfClass:(Class)aClass fromData:(NSData *)data error:(NSError * _Nullable *)outError {
    //! 객체 하나를 표현하므로 딕셔너리가 반환된다.
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:outError];
    id result = [aClass new];
    [result setValuesForKeysWithDictionary:dictionary];
//    for (NSString* key in dictionary) {
//        [result setValue:dictionary[key] forKey:key];
//    }
    return result;
}

+ (id)mgrDecodeObject:(id)instance fromData:(NSData *)data error:(NSError * _Nullable *)outError {
    //! 객체 하나를 표현하므로 딕셔너리가 반환된다.
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:outError];
    [instance setValuesForKeysWithDictionary:dictionary];
//    for (NSString* key in dictionary) {
//        [instance setValue:dictionary[key] forKey:key];
//    }
    return instance;
}


#pragma mark - Encoder : JSONEncoder(스위프트에만 존재) 해당하는 기능을 구현하기 위해 만든 메서드

@end
