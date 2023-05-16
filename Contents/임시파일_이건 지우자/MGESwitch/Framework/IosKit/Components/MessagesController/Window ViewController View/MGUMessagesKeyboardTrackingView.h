//
//  MGUMessagesKeyboardTrackingView.h
//  Messages Project
//
//  Created by Kwan Hyun Son on 2022/01/06.
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MGUMessagesKeyboardTrackingViewChange) {
    MGUMessagesKeyboardTrackingViewChangeShow = 1, // 0은 피하는 것이 좋다.
    MGUMessagesKeyboardTrackingViewChangeHide,
    MGUMessagesKeyboardTrackingViewChangeFrame
};

@protocol MGUMessagesKeyboardTrackingViewDelegate <NSObject>
@optional
@required
- (void)keyboardTrackingViewWillChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo;
- (void)keyboardTrackingViewDidChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo;
@end

IB_DESIGNABLE @interface MGUMessagesKeyboardTrackingView : UIView

@property (nonatomic, weak, nullable) id <MGUMessagesKeyboardTrackingViewDelegate>delegate;
@property (nonatomic, assign) BOOL isPaused; // 디플토 NO

@property (nonatomic) IBInspectable CGFloat topMargin; // 디폴트 0.0

//! 서브클래스에 재정의 해야한다.
- (void)willChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo;
- (void)didChange:(MGUMessagesKeyboardTrackingViewChange)change userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
