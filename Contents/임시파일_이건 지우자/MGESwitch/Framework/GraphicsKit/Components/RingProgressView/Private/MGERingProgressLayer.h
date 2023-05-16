//
//  MGERingProgressLayer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-30
//  ----------------------------------------------------------------------
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef NS_ENUM(NSInteger, MGERingProgressViewStyle) {
    MGERingProgressViewStyleRound,
    MGERingProgressViewStyleSquare
};


#pragma mark - 인터페이스
@interface MGERingProgressLayer : CALayer

@property (nonatomic) CGFloat ringWidth; // 디폴트 20.0f

@property (nonatomic) MGERingProgressViewStyle progressStyle;

/// The opacity of the shadow under the progress end.
@property (nonatomic) CGFloat endShadowOpacity;  // 0.0 ~ 1.0

/// Whether or not to hide the progress ring when progress is zero.
@property (nonatomic) BOOL hidesRingForZeroProgress;

@property (nonatomic) CGColorRef startColor;
@property (nonatomic) CGColorRef endColor;

/// The color of the background ring.
@property (nonatomic, nullable) CGColorRef backgroundRingColor;

/// The scale of the generated gradient image.
/// Use lower values for better performance and higher values for more precise gradients.
@property (nonatomic) CGFloat gradientImageScale;

@property (nonatomic) CGFloat progress; // @dynamic 0.0 ~ 2.0

@end

NS_ASSUME_NONNULL_END
