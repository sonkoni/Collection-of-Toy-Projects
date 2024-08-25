//
//  MGRTimerInterval.h
//  TESTTimeInterval
//
//  Created by Kwan Hyun Son on 1/25/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRTimeInterval : NSObject
+ (instancetype)sharedTimeInterval;
- (void)start;
- (void)end;
@end

NS_ASSUME_NONNULL_END
