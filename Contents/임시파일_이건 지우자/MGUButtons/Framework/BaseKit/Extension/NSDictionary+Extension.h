//
//  NSDictionary+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)
 
// ObjectType은 배열. id는 ObjectType의 element
// 스위프트의 init(grouping:by:)를 재현함.
// https://developer.apple.com/documentation/swift/dictionary/init(grouping:by:)
/*
     NSArray <NSString *>*students = @[@"Kofi", @"Abena", @"Efua", @"Kweku", @"Akosua"];
     NSDictionary <NSString *, NSArray <NSString *>*>*studentsByLetter =
     [NSDictionary mgrDictionaryWithGroupingValues:students
                                     byKeyForValue:^NSString *(NSString *element) {
         return [element mgrSubStringPrefix:1];;
     }];
 
    NSLog(@"=====> %@", studentsByLetter);
    =====> {
        A =     (
            Abena,
            Akosua
        );
        E =     (
            Efua
        );
        K =     (
            Kofi,
            Kweku
        );
    }
 */
+ (NSDictionary <id, NSArray *>*)mgrDictionaryWithGroupingValues:(NSArray *)values
                                                   byKeyForValue:(id(^)(id))byKeyForValue;

@end

NS_ASSUME_NONNULL_END
