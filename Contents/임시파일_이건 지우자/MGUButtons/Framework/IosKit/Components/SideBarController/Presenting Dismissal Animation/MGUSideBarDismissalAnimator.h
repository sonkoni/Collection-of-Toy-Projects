//
//  MGUSideBarDismissalAnimator.h
//
//  Created by Kwan Hyun Son on 2022/06/24.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUSideBarConfig;

NS_ASSUME_NONNULL_BEGIN

@interface MGUSideBarDismissalAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithSideBarConfig:(MGUSideBarConfig *)sideBarConfig NS_DESIGNATED_INITIALIZER;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
