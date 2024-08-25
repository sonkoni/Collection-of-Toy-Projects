//
//  CATransaction+Extension.h
//  Copyright © 2024 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2024-03-25
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CATransaction (Extension)

+ (void)mgrDisableActions:(void(^_Nonnull)(void))block;

@end

NS_ASSUME_NONNULL_END
