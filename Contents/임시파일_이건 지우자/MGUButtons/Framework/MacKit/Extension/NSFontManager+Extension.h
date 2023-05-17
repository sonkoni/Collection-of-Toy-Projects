//
//  NSFontManager+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-03-03
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFontManager (Extension)

// 실제 존재하는 font 이름을 알려준다. iOS 는 UIFont로 한다. 
+ (void)mgrDescription;

@end

NS_ASSUME_NONNULL_END
