//
//  NSCalendar+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSCalendar+Extension.h"

@implementation NSCalendar (Extension)

- (NSDate * _Nullable)endOfDayForDate:(NSDate *)date {
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 1;
    dateComponents.second = -1;
    return [self dateByAddingComponents:dateComponents toDate:[self startOfDayForDate:date] options:0];
}

@end
