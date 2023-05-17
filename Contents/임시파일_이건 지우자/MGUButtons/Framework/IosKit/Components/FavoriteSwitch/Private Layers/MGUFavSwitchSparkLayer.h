//
//  MGUFavSwitchSparkLayer.h
//  MGRFavoriteButton
//
//  Created by Kwan Hyun Son on 21/05/2020.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MGUFavoriteSwitch.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGUFavSwitchSparkLayer : CALayer

@property (nonatomic, assign) MGUFavoriteSwitchSparkMode sparkMode;
@property (nonatomic, assign) BOOL useRandomColorOnShineMode; // 디폴트 값 YES
@property (nonatomic, assign) BOOL useFlashOnShineMode;       // 디폴트 값 YES

@property (nonatomic, assign) CGFloat timeDuration;
@property (nonatomic, strong) UIColor *sparkColor;
@property (nonatomic, strong) UIColor *sparkColor2;


- (void)setupSparkLayerAnimation;
- (void)startSparkAnimation;
- (void)stopSparkAnimation;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
