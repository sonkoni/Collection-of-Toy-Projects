//
//  MGUKeyboardStateListener.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUKeyboardStateListener : NSObject

@property (nonatomic, assign, readonly) BOOL isVisible; // internal set possible

- (void)start;
- (void)stop;

+ (instancetype)sharedKeyboardStateListener;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
