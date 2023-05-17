//
//  NSDate+Extension.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (BOOL)mgrIsPast {
    return self.timeIntervalSinceNow < 0;
}

- (NSString *)mgrRelativeDateDescriptionWithTime:(BOOL)showTimeDescription
                                   currentLocale:(NSLocale *)currentLocale {
    NSDateFormatter *relativeDateFormatter = [NSDateFormatter new];
    relativeDateFormatter.timeStyle = (showTimeDescription == YES)? NSDateFormatterShortStyle : NSDateFormatterNoStyle;
    relativeDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    if (currentLocale == nil) {
        currentLocale = [NSLocale currentLocale];
    }
    relativeDateFormatter.locale = currentLocale;
    relativeDateFormatter.doesRelativeDateFormatting = YES;
    return [relativeDateFormatter stringFromDate:self];
}

@end
