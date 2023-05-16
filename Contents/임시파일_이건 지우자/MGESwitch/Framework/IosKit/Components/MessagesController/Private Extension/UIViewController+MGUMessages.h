//
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/20.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGUMessagesConfig;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MGUMessages)

- (BOOL)sm_isVisibleView:(UIView *)view;
- (UIViewController *)sm_selectPresentationContextTopDown:(MGUMessagesConfig *)config;
- (UIViewController *)sm_selectPresentationContextBottomUp:(MGUMessagesConfig *)config;


@end

NS_ASSUME_NONNULL_END
