//
//  MGUActionSheet.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import "MGUAlertView.h"
@class MGUActionSheetConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface MGUActionSheet : MGUAlertView

@property (nonatomic, strong) UIView *bottomContainerView;
- (instancetype)initWithConfiguration:(MGUActionSheetConfiguration *)configuration;


#pragma mark - NS_UNAVAILABLE
@property (nonatomic, strong) UIView *thirdContentView NS_UNAVAILABLE;
@property (nonatomic, assign) CGFloat maximumWidth NS_UNAVAILABLE;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewCenterYConstraint NS_UNAVAILABLE;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewCenterXConstraint NS_UNAVAILABLE;
@property (nonatomic, strong) NSLayoutConstraint *alertContainerViewHeightConstraint NS_UNAVAILABLE;

@property (nonatomic, strong) NSArray <UITextField *>*textFields NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
