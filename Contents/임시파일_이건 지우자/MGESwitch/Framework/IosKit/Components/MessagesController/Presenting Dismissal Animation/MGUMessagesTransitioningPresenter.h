//
//  MGUMessagesTransitioningPresenter.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/28.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesViewControllerTransitioning;

NS_ASSUME_NONNULL_BEGIN

@interface MGUMessagesTransitioningPresenter : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, weak, nullable) MGUMessagesViewControllerTransitioning *owner;
@property (nonatomic, copy, nullable, readonly) void (^completeTransition)(BOOL);

@end

NS_ASSUME_NONNULL_END
