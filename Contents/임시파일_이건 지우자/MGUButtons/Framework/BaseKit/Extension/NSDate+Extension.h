//
//  NSDate+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-30
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)
@property (nonatomic, assign, readonly) BOOL mgrIsPast;
- (NSString *)mgrRelativeDateDescriptionWithTime:(BOOL)showTimeDescription
                                   currentLocale:(NSLocale * _Nullable)currentLocale;
@end

NS_ASSUME_NONNULL_END
