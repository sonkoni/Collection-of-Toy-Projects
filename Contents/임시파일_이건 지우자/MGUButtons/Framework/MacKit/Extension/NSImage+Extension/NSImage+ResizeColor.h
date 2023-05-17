//  NSImage+ResizeColor.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-10
//  ----------------------------------------------------------------------
//
// https://stackoverflow.com/questions/11949250/how-to-resize-nsimage
// https://stackoverflow.com/questions/45028530/set-image-color-of-a-template-image
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (ResizeColor)

//! Aspect Fill. 꽉 채운 스타일(빈틈없이)로 만들어준다. 스케일을 유지한다. 짜부가 되지 않는다.
- (NSImage *)mgrThumbnailImageWithSize:(CGSize)thumbnailSize cornerRadius:(CGFloat)cornerRadius;

- (NSImage *_Nullable)mgrImageWithSize:(CGSize)newSize;

// AppIcon 에서 NSImageRep 객체를 골라서 적절히 반환. 기존의 존재하는 - bestRepresentationForRect:context:hints:가 완벽하지 못함.
- (NSImage *)mgrBestRepresentationForSize:(NSSize)size;

- (NSImage *)mgrImageWithCornerRadius:(CGFloat)cornerRadius;

- (NSImage *)mgrImageWithColor:(NSColor *_Nonnull)newColor;

/**
 * @brief 원형안에 이미지를 넣어서 반환한다.
 * @param circularColor 밑바닥에 해당하는 원의 색
 * @param circularSize 밑바닥에 해당하는 원의 사이즈, 이미지보다 circularSize 커야한다.
 * @discussion 색이 칠해진 원안의 가운데 이미지를 넣어서 새로운 이미지를 생성해낸다.
 * @remark 이미지의 사아즈와 색은 이미 정해진 상태로 넣어야하며, 이미지보다 circularSize 커야한다.
 * @code
        NSImageSymbolConfiguration *config =
          [NSImageSymbolConfiguration configurationWithPointSize:40.0
                                                          weight:NSImageSymbolWeightRegular
                                                           scale:NSImageSymbolScaleMedium];
 
        NSImage *image = [NSImage systemImageNamed:@"trash" withConfiguration:config];
        image = [image imageWithTintColor:[NSColor whiteColor] renderingMode:NSImageRenderingModeAlwaysTemplate];
        image = [image mgrImageWithCircularColor:NSColor.redColor circularSize:CGSizeMake(60.0, 60.0)];
 * @endcode
 * @return 색이 칠해진 원위에 그려진 이미지를 반환한다.
*/
- (NSImage *)mgrImageWithCircularColor:(NSColor *)circularColor circularSize:(CGSize)circularSize;

//! 색으로 이미지를 만든다. 색, 사이즈, radius를 조정할 수 있다.
+ (NSImage *)mgrImageWithColor:(NSColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

//! CALayer로 이미지를 만든다. 우선은 CAGradientLayer를 염두해서 만들었다. 사이즈는 인자로 주어지는 layer를 기준으로 삼는다.
//! 살짝 연하게 나오는데, 더 이상의 방법은 모르겠다. 방법은 4가지 정도 만들었으며, 크게는 두 종류라고 볼 수 있다. 퀄리티는 똑같은 것으로 사료됨.
+ (NSImage *)mgrImageWithLayer:(CALayer *)layer cornerRadius:(CGFloat)cornerRadius;

/** shadow Image **/
// https://stackoverflow.com/questions/2936443/create-new-NSImage-by-adding-shadow-to-existing-uiimage
// 그림자를 덧붙임으로써 크기 자체가 커지는 것을 막을 수는 없다.
- (NSImage *)mgrImageWithShadowBlurSize:(CGFloat)blurSize
                           shadowOffset:(CGSize)shadowOffset
                            shadowColor:(NSColor *)shadowColor
                          shadowOpacity:(CGFloat)shadowOpacity;

//! 위와 효과는 동일하다. 방식이 다르다.
- (NSImage *)mgrAddingShadowBlur:(CGFloat)blur shadowColor:(NSColor *)shadowColor offset:(CGSize)offset;


/** image 의 중심에서의 일정 부분의 rect는 유지한채 다른 부분을 늘려서 이미지를 늘린다. **/
// https://stackoverflow.com/questions/15427317/how-to-stretch-a-NSImageview-without-stretching-the-center
/**
 * @brief 이미지의 중심에서의 rect를 늘리지 않고 그 외 부분을 늘려서 이미지를 만들어낸다.
 * @param preserveWidthRatio  원본의 가로의 길이를 1.0로 보았을 때, 얼마만큼을 보존할 것인가. 보존 데이터는 센터를 중심
 * @param preserveHeightRatio 원본의 가로의 길이를 1.0로 보았을 때, 얼마만큼을 보존할 것인가. 보존 데이터는 센터를 중심
 * @param stretchWidthRatio   원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
 * @param stretchHeightRatio  원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
 * @discussion 유지되는 이미지의 사각형의 중심은 그대로 유지된다.
 * @remark 가로의 한쪽만 늘어나거나 새로의 한쪽만 늘어나지는 않는다. 한쪽만 늘리고 싶다면, convenience 메서드를 이용하라.
 * @code
        NSImage *tiger = [NSImage imageNamed:@"Tiger"];
        NSImage *stetchTiger = [tiger mgrStretchSideWidthPreserveWidthRatio:0.9
                                                        preserveHeightRatio:0.9
                                                          stretchWidthRatio:3.0
                                                         stretchHeightRatio:3.0];
        [self.imageView setImage:stetchTiger];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
 * @endcode
 * @return 늘려진 새로운 이미지
*/
- (NSImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                               preserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio
                                stretchHeightRatio:(CGFloat)stretchHeightRatio;

// convenience
- (NSImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio;
// convenience
- (NSImage *)mgrStretchSideWidthPreserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchHeightRatio:(CGFloat)stretchHeightRatio;


@end

NS_ASSUME_NONNULL_END
