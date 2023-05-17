//
//  UITextView+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-24
//  ----------------------------------------------------------------------
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Extension)

// contentInset 은 고려하지 않았다. keyboard_system+customizing 프로젝트에서 사용한 예가 있다. 
- (CGRect)mgrTextBoundingBox;

@end

NS_ASSUME_NONNULL_END
