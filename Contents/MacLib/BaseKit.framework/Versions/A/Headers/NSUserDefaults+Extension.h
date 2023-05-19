//
//  NSUserDefaults+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-04-29
//  ----------------------------------------------------------------------
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (Extension)

- (void)mgrRemoveAllUserDefaults;
- (void)mgrRemoveUserDefaultsForKeys:(NSArray <NSString *>*)keys;
@end

NS_ASSUME_NONNULL_END
