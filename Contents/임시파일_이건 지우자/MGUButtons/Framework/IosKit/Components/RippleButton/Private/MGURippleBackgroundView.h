//
//  MGURippleBackgroundView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGURippleBackgroundView : UIView

@property (nonatomic) CFTimeInterval touchDownAnimationDuration;
@property (nonatomic) CFTimeInterval touchUpAnimationDuration;

- (void)animateToRippleState;
- (void)animateToNormal;
@end

NS_ASSUME_NONNULL_END
