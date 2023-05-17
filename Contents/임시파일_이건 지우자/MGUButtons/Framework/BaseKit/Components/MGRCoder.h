//
//  MGRCoder.h
//  Copyright © 2021 Mulgrim. All rights reserved.
//

#import <Foundation/Foundation.h>

// json     : NSArray, NSDictionary, NSString, NSNumber + NSNull(blank)
// plist    : NSArray, NSDictionary, NSString, NSNumber, NSDate, NSData + NSNull(blank)
// Plain    : NSArray, NSDictionary, NSString, NSDecimalNumber, NSNumber, NSDate, NSData, NSURL, NSUUID + NSNull(blank)

NS_ASSUME_NONNULL_BEGIN

@interface MGRCoder : NSObject
+ (NSISO8601DateFormatter *)defaultDateFormatter;
+ (NSString *)stringFromData:(NSData *)data;
+ (NSData *)dataFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)encodeJSON:(id)jsonObject NS_SWIFT_UNAVAILABLE("Swift에서는 JSONEncoder");
+ (NSString *)encodeJSONPretty:(id)jsonObject NS_SWIFT_UNAVAILABLE("Swift에서는 JSONEncoder");
+ (id)decodeJSON:(NSString *)jsonString NS_SWIFT_UNAVAILABLE("Swift에서는 JSONDecoder");
@end

NS_ASSUME_NONNULL_END
