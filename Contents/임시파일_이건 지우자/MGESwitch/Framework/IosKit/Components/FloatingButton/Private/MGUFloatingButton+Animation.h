//
//  JJFloatingActionButton+Animation.h
//  MGUFloatingButton
//
//  Created by Kwan Hyun Son on 16/08/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "MGUFloatingButton.h"
typedef void (^MGRCompletionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MGUFloatingButton (Animation)

//! 인수를 넣지 않은면, BOOL = YES
- (void)openAnimated:(BOOL)animated;

//! 인수를 넣지 않은면, BOOL = YES
- (void)closeAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END

