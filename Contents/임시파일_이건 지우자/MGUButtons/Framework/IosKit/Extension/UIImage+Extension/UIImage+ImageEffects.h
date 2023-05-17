/**
     File: UIImage+ImageEffects.h
 Abstract: This is a category of UIImage that adds methods to apply blur and tint effects to an image. This is the code you’ll want to look out to find out how to use vImage to efficiently calculate a blur.
  Version: 1.0
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 */

//! 2013년 3월 5일(5/3/2013) Apple WWDC에서 공개했던 카테고리이다.
//! UIImage에 블러 및 틴트 효과를 적용하는 카테고리 메서드이다.
//! 현재는 UIVisualEffetView를 이용하는 것이 더 편리할 듯하다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImageEffects)

/** convenience 메서드 3종 *****/
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;

/** tint를 직접 적용가능 *****/
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

/** 실제로 작동하는 메서드 : 이거 하나면 다 가능하다. *****/
- (UIImage * _Nullable)applyBlurWithRadius:(CGFloat)blurRadius
                                 tintColor:(UIColor *)tintColor
                     saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                                 maskImage:(UIImage * _Nullable)maskImage;
@end

NS_ASSUME_NONNULL_END
