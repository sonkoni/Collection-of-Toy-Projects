//
//  MGEGlitchLabel.h
//
//  Created by Kwan Hyun Son on 2022/03/30.
//

#import <GraphicsKit/MGEAvailability.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_IPHONE
IB_DESIGNABLE @interface MGEGlitchLabel : UILabel
#else
IB_DESIGNABLE @interface MGEGlitchLabel : NSTextField
#endif

@property (nonatomic) IBInspectable CGFloat amplitudeMIN;  // 디폴트 2.0 진폭 : 좌우로 흔들리는 거리를 의미함
@property (nonatomic) IBInspectable CGFloat amplitudeMAX;  // 디폴트 3.0 진폭 : 좌우로 흔들리는 거리를 의미함

@property (nonatomic) IBInspectable CGFloat glitchAmplitude; // 디폴트 10.0
@property (nonatomic) IBInspectable CGFloat glitchThreshold; // 디폴트 0.9

@property (nonatomic) IBInspectable CGFloat alphaMin; // 디폴트 0.8

@property (nonatomic) IBInspectable BOOL glitchEnabled; // 디폴트 YES
@property (nonatomic) IBInspectable BOOL drawScanline;  // 디폴트 YES

#if TARGET_OS_IPHONE
@property (nonatomic, assign) CGBlendMode blendMode;
#else
@property (nonatomic, assign) NSCompositingOperation compositingOperation;
#endif

- (void)startAnimation;
- (void)finishAnimation;

@end

NS_ASSUME_NONNULL_END
