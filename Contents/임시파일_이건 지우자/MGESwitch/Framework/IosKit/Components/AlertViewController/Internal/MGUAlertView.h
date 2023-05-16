//
//  MGUAlertView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>
#import "MGUAlertViewConfiguration.h"
@class MGUAlertViewButton;

@interface MGUAlertView : UIView

@property (nonatomic, strong) UIView *alertContainerView; // controller에서 center position을 조정할 수 있다.
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UITextView *messageTextView; // MGUAlertTextView 클래스이다. 컨트롤러에 많은 설명을 피하기 위해서다.
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *secondContentView;
@property (nonatomic, strong) UIView *thirdContentView;

@property (nonatomic, assign) CGFloat maximumWidth;

@property (nonatomic, strong, readonly) NSLayoutConstraint *alertContainerViewCenterYConstraint; // 스와이프로 날릴 수 있기 위해.
@property (nonatomic, strong, readonly) NSLayoutConstraint *alertContainerViewCenterXConstraint; // iPad에서 Sheet Mode 일경우 없애야함.
@property (nonatomic, strong, readonly) NSLayoutConstraint *alertContainerViewHeightConstraint; // iPad에서 Sheet Mode 일경우 없애야함.


@property (nonatomic, strong) NSArray <MGUAlertViewButton *>*actionButtons;
@property (nonatomic, strong) NSArray <UITextField *>*textFields;

- (instancetype)initWithConfiguration:(MGUAlertViewConfiguration *)configuration;

#pragma mark - NS_UNAVAILABLE
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
