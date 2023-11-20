//
//  MGERingProgressView.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-30
//  ----------------------------------------------------------------------
//

#import <GraphicsKit/MGEAvailability.h>
#import <GraphicsKit/CAMediaTimingFunction+Extension.h>
#import <GraphicsKit/MGERingProgressLayer.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 인터페이스

IB_DESIGNABLE @interface MGERingProgressView : MGEView

@property (nonatomic) IBInspectable CGFloat ringWidth; // 디폴트 20.0f
@property (nonatomic) IBInspectable CGFloat progress; // @dynamic 0.0 ~ 2.0 : 1.0 -> 360°, 2.0 -> 720°
@property (nonatomic) MGERingProgressViewStyle style; // 디폴트 MGERingProgressViewStyleRound 프로그레스 라인의 말단 부분의 스타일
@property (nonatomic) MGRMediaTimingFunctionName mediaTimingFunctionName; // 디폴트 MGRMediaTimingFunctionEaseInOutCubic
@property (nonatomic) CGFloat animationDuration; // 디폴트 0.5

// The opacity of the shadow below progress line end. Defaults to `1.0`.
// Values outside the [0,1] range will be clamped.
@property (nonatomic) IBInspectable CGFloat shadowOpacity; // 디폴트 1.0
@property (nonatomic) IBInspectable BOOL hidesRingForZeroProgress; // 디폴트 NO. 프로그레스가 zero 일때. 링을 감출것인가.

// IBInspectable 은 매크로를 인식하지 못한다.
#if TARGET_OS_OSX
@property (nonatomic) IBInspectable NSColor *startColor;
@property (nonatomic) IBInspectable NSColor *endColor;
@property (nonatomic, nullable) IBInspectable NSColor *backgroundRingColor;
#elif TARGET_OS_IPHONE
@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic, nullable) IBInspectable UIColor *backgroundRingColor;
#endif
//
// The color of backdrop circle, visible at progress values between 0.0 and 1.0.
// If not specified, `startColor` with 15% opacity will be used.

// The scale of the generated gradient image.
// Use lower values for better performance and higher values for more precise gradients.
@property (nonatomic) IBInspectable CGFloat gradientImageScale;

@property (nonatomic, copy, nullable) void (^animationCompletionHandler)(void); // 성공이든 실패든 종료시 호출된다.
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
