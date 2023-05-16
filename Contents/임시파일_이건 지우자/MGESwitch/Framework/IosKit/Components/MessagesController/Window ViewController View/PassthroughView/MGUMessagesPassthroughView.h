//
//  MGUMessagesPassthroughView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/18.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGUMessagesPassthroughView : UIControl
@property (nonatomic, copy, nullable) void (^tappedHander)(void);

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame primaryAction:(UIAction * _Nullable)primaryAction NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
