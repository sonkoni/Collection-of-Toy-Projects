//
//  UNUserNotificationCenter+Extension.m
//  Copyright © 2022 mulgrim. All rights reserved.
//

#import "UNUserNotificationCenter+Extension.h"

@implementation UNUserNotificationCenter (Extension)
- (void)mgrScheduleFor:(NSString *)requestIdentifier date:(NSDate *)date repeats:(BOOL)repeats content:(UNNotificationContent *)content completion:(void(^ _Nullable)(NSError *_Nullable error))completion {
    // 날짜시간 트리거 만들기
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:repeats];
    // 컨텐츠 + 트리거 => 리퀘스트로 합치기
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    // 등록 오류 처리
    [self addNotificationRequest:request withCompletionHandler:completion];
}

- (void)mgrScheduleFor:(NSString *)requestIdentifier interval:(NSTimeInterval)interval repeats:(BOOL)repeats content:(UNNotificationContent *)content completion:(void(^ _Nullable)(NSError *_Nullable error))completion {
    // 인터벌 트리거 만들기
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:repeats];
    // 컨텐츠 + 트리거 => 리퀘스트로 합치기
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    // 등록 및 오류 처리
    [self addNotificationRequest:request withCompletionHandler:completion];
}

- (void)mgrCheck:(UNAuthorizationOptions)options authorized:(dispatch_block_t)authorizedHandler denied:(dispatch_block_t _Nullable)deniedHandler etc:(dispatch_block_t _Nullable)etcHandler {
    __weak __typeof(self) weakSelf = self;
    [self getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined: {
                [weakSelf requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {authorizedHandler();} else if (deniedHandler) {deniedHandler();}
                }];
            } break;
            case UNAuthorizationStatusDenied:
                if (deniedHandler) {deniedHandler();}
                break;
            case UNAuthorizationStatusAuthorized:
                authorizedHandler();
                break;
            default:
                if (etcHandler) {etcHandler();}
                break;
        }
        
        
    }];
}
@end
