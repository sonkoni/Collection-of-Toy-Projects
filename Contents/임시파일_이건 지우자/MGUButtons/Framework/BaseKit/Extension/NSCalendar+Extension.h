//
//  NSCalendar+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (Extension)

- (NSDate * _Nullable)endOfDayForDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
