//
//  MGRCoder.m
//  Copyright © 2021 Mulgrim. All rights reserved.
//

#import "MGRCoder.h"

@implementation MGRCoder
+ (NSISO8601DateFormatter *)defaultDateFormatter {
    static NSISO8601DateFormatter * _dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSISO8601DateFormatter alloc] init];
    });
    return _dateFormatter;
}

+ (NSString *)stringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)dataFromString:(NSString *)string {
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [[MGRCoder defaultDateFormatter] stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [[MGRCoder defaultDateFormatter] dateFromString:string];
}

+ (NSString *)encodeJSON:(id)jsonObject {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingWithoutEscapingSlashes error:&error];
    if (error) { // [NSJSONSerialization isValidJSONObject:jsonPlain] 로 검사하지 않아도 유효하지 않으면 인코딩 에러 뱉음
        @throw([NSException exceptionWithName:@"Invalid Data Type" reason:@"Valid Type = Array, Dictionary, String, Number, Null" userInfo:nil]);
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeJSONPretty:(id)jsonObject {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonObject options:(NSJSONWritingWithoutEscapingSlashes | NSJSONWritingPrettyPrinted) error:&error];
    if (error) {@throw([NSException exceptionWithName:@"Invalid Data Type" reason:@"Valid Type = Array, Dictionary, String, Number, Null" userInfo:nil]);}
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)decodeJSON:(NSString *)jsonString {
    NSError *error;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {@throw([NSException exceptionWithName:@"Invalid Data Type" reason:@"Valid Type = Array, Dictionary, String, Number, Null" userInfo:nil]);}
    return object;
}
@end
