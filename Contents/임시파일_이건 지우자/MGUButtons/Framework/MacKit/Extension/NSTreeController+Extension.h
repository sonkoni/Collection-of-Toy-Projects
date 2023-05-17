//  NSTreeController+Extension.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-09-06
//  ----------------------------------------------------------------------
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTreeController (Extension)

// https://developer.apple.com/documentation/appkit/cocoa_bindings/navigating_hierarchical_data_using_outline_and_split_views?language=objc
// https://stackoverflow.com/questions/9050028/given-model-object-how-to-find-index-path-in-nstreecontroller
- (NSIndexPath * _Nullable)mgrIndexPathOfObject:(id)object;

@end


NS_ASSUME_NONNULL_END
