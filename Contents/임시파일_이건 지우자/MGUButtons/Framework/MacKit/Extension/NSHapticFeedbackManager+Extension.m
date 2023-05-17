//
//  NSHapticFeedbackManager+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSHapticFeedbackManager+Extension.h"
// #import <AudioToolbox/AudioToolbox.h>

@implementation NSHapticFeedbackManager (Extension)

+ (void)mgrPerformFeedbackPattern:(NSHapticFeedbackPattern)pattern
                  performanceTime:(NSHapticFeedbackPerformanceTime)performanceTime {
    id<NSHapticFeedbackPerformer> defaultPerformer = [NSHapticFeedbackManager defaultPerformer];
    [defaultPerformer performFeedbackPattern:pattern
                             performanceTime:performanceTime];
}
@end
