//
//  UNUserNotificationCenter+Extension.h
//  Copyright © 2022 mulgrim. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface UNUserNotificationCenter (Extension)
/* Schedule */
// repeats YES 로 할 경우 반드시 나중에 필요없어진 경우 제거해줘야 한다.
- (void)mgrScheduleFor:(NSString *)requestIdentifier date:(NSDate *)date repeats:(BOOL)repeats content:(UNNotificationContent *)content completion:(void(^ _Nullable)(NSError *_Nullable error))completion;
- (void)mgrScheduleFor:(NSString *)requestIdentifier interval:(NSTimeInterval)interval repeats:(BOOL)repeats content:(UNNotificationContent *)content completion:(void(^ _Nullable)(NSError *_Nullable error))completion;

/* Check then Schedule */
- (void)mgrCheck:(UNAuthorizationOptions)options authorized:(dispatch_block_t)authorizedHandler denied:(dispatch_block_t _Nullable)deniedHandler etc:(dispatch_block_t _Nullable)etcHandler;

@end

NS_ASSUME_NONNULL_END
