//
//  MGUAlertPresentationController.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import "MGUAlertViewConfiguration.h"

@interface MGUAlertPresentationController : UIPresentationController

@property MGUAlertViewTransitionStyle transitionStyle;
@property (nonatomic) BOOL backgroundTapDismissalGestureEnabled;
@property UIView *backgroundDimmingView;

@end
