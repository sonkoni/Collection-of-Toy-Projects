//
//  MGURippleView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGURippleView : UIView

@property (nonatomic) UIColor *rippleColor;
@property (nonatomic) BOOL    rippleOverBounds;

@property (nonatomic) BOOL    trackTouchLocation;
@property (nonatomic) CGPoint touchCenterLocation;

@property (nonatomic) CFTimeInterval touchDownAnimationDuration;
@property (nonatomic) CFTimeInterval touchUpAnimationDuration;


- (void)animateToRippleState;
- (void)animateToNormal;

@end

NS_ASSUME_NONNULL_END
