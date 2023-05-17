//
//  MGRFavSwitchCircleLayer.h
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 21/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGUFavoriteSwitch.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUFavSwitchRippleLayer : CALayer

@property (nonatomic, assign) CGFloat timeDuration;
@property (nonatomic, copy, nullable) void (^completionBlock)(void); // shine 일때. 사용한다.

- (void)setupRippleLayerAnimation;
- (void)startRippleAnimation;
- (void)stopRippleAnimation;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
