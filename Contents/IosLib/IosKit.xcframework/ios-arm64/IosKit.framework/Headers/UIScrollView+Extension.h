//  UIScrollView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-07-28
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Extension)
- (CGPoint)mgrMaxOffset;
- (CGPoint)mgrMinOffset;
@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2022-07-28 : 최초 작성
 */

// https://stackoverflow.com/questions/44192007/uiscrollview-max-and-min-contentoffsets
