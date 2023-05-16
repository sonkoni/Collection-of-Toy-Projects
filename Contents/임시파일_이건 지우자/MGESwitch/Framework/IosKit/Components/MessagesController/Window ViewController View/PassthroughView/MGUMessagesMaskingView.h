//
//  MGUMessagesMaskingView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/18.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUMessagesPassthroughView.h"
@protocol MGUMessagesMarginAdjustable;
@class MGUMessagesKeyboardTrackingView;

NS_ASSUME_NONNULL_BEGIN

// MGUMessagesPassthroughView 서브 클래스이기도 하지만,
// MGUMessagesPassthroughView의 서브뷰로 올려지는데도 사용된다.
@interface MGUMessagesMaskingView : MGUMessagesPassthroughView

@property (nonatomic, strong) NSMutableArray <__kindof NSObject *>*accessibleElements;
@property (nonatomic, weak, nullable) UIView *backgroundView;

- (void)installKeyboardTrackingView:(MGUMessagesKeyboardTrackingView *)keyboardTrackingView;

@end

NS_ASSUME_NONNULL_END
