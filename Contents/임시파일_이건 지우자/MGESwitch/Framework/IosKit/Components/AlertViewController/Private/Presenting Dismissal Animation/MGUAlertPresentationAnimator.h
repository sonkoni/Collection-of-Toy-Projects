//
//  MGUAlertPresentationAnimator.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-10-20
//  ----------------------------------------------------------------------
//

#import "MGUAlertViewConfiguration.h"

@interface MGUAlertPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property MGUAlertViewTransitionStyle transitionStyle;

@end
