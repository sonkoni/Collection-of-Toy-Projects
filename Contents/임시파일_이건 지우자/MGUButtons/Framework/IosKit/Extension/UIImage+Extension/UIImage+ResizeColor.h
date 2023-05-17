//
//  UIImage+ResizeColor.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-05-11
//  ----------------------------------------------------------------------
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ResizeColor)

//! Aspect Fill. 꽉 채운 스타일(빈틈없이)로 만들어준다. 스케일을 유지한다. 짜부가 되지 않는다.
- (UIImage *)mgrThumbnailImageWithSize:(CGSize)thumbnailSize cornerRadius:(CGFloat)cornerRadius;

//! 짜부가 된다.
- (UIImage *)mgrImageWithSize:(CGSize)newSize;

//! 이미지를 원하는 단색으로 바꾸기 뷰에 의존하지 않고 자체 tintColor 를 바꾼다.
//! iOS 13부터는 - imageWithTintColor:, - imageWithTintColor:renderingMode: 메서드가 존재한다.
- (UIImage *)mgrImageWithColor:(UIColor * _Nonnull)newColor;

/**
 * @brief 원형안에 이미지를 넣어서 반환한다.
 * @param circularColor 밑바닥에 해당하는 원의 색
 * @param circularSize 밑바닥에 해당하는 원의 사이즈, 이미지보다 circularSize 커야한다.
 * @discussion 색이 칠해진 원안의 가운데 이미지를 넣어서 새로운 이미지를 생성해낸다.
 * @remark 이미지의 사아즈와 색은 이미 정해진 상태로 넣어야하며, 이미지보다 circularSize 커야한다.
 * @code
        UIImageSymbolConfiguration *config =
          [UIImageSymbolConfiguration configurationWithPointSize:40.0
                                                          weight:UIImageSymbolWeightRegular
                                                           scale:UIImageSymbolScaleMedium];
 
        UIImage *image = [UIImage systemImageNamed:@"trash" withConfiguration:config];
        image = [image imageWithTintColor:[UIColor whiteColor] renderingMode:UIImageRenderingModeAlwaysTemplate];
        image = [image mgrImageWithCircularColor:UIColor.redColor circularSize:CGSizeMake(60.0, 60.0)];
 * @endcode
 * @return 색이 칠해진 원위에 그려진 이미지를 반환한다.
*/
- (UIImage *)mgrImageWithCircularColor:(UIColor *)circularColor circularSize:(CGSize)circularSize;

//! 색으로 이미지를 만든다. 색, 사이즈, radius를 조정할 수 있다.
+ (UIImage *)mgrImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

//! CALayer로 이미지를 만든다. 우선은 CAGradientLayer를 염두해서 만들었다. 사이즈는 인자로 주어지는 layer를 기준으로 삼는다.
//! 살짝 연하게 나오는데, 더 이상의 방법은 모르겠다. 방법은 4가지 정도 만들었으며, 크게는 두 종류라고 볼 수 있다. 퀄리티는 똑같은 것으로 사료됨.
+ (UIImage *)mgrImageWithLayer:(CALayer *)layer cornerRadius:(CGFloat)cornerRadius;

/* 알파 값을 역전 시킨다.
 // 좀 크게해야 선명하게 나온다.
UIImageSymbolConfiguration *symbolConfiguration =
[UIImageSymbolConfiguration configurationWithPointSize:85.0
                                                weight:UIImageSymbolWeightLight
                                                 scale:UIImageSymbolScaleLarge];
UIImage *image = [UIImage systemImageNamed:@"calendar" withConfiguration:symbolConfiguration];
UIImage *newImage = [image mgrInvertAlphaWithSourceOutColor:UIColor.systemGreenColor cornerRadius:10.0];
self.imageView.image = newImage;
*/
- (UIImage * _Nullable)mgrInvertAlphaWithSourceOutColor:(UIColor *)sourceOutColor cornerRadius:(CGFloat)cornerRadius;

//! 알파를 제거했을 때의 frame으로 이미지를 뽑아준다.
- (UIImage *)mgrCropAlpha;

/** shadow Image **/
// https://stackoverflow.com/questions/2936443/create-new-uiimage-by-adding-shadow-to-existing-uiimage
// 그림자를 덧붙임으로써 크기 자체가 커지는 것을 막을 수는 없다.
- (UIImage *)mgrImageWithShadowBlurSize:(CGFloat)blurSize
                           shadowOffset:(CGSize)shadowOffset
                            shadowColor:(UIColor *)shadowColor
                          shadowOpacity:(CGFloat)shadowOpacity;

//! 위와 효과는 동일하다. 방식이 다르다.
- (UIImage *)mgrAddingShadowBlur:(CGFloat)blur shadowColor:(UIColor *)shadowColor offset:(CGSize)offset;

+ (UIImage *)mgrSliderKnobWithSize:(CGFloat)size blurSize:(CGFloat)blurSize; //! 32.0, 7.0 추천. 다른 것도 괜찮을 듯.


/** image 의 중심에서의 일정 부분의 rect는 유지한채 다른 부분을 늘려서 이미지를 늘린다. **/
// https://stackoverflow.com/questions/15427317/how-to-stretch-a-uiimageview-without-stretching-the-center
/**
 * @brief 이미지의 중심에서의 rect를 늘리지 않고 그 외 부분을 늘려서 이미지를 만들어낸다.
 * @param preserveWidthRatio  원본의 가로의 길이를 1.0로 보았을 때, 얼마만큼을 보존할 것인가. 보존 데이터는 센터를 중심
 * @param preserveHeightRatio 원본의 가로의 길이를 1.0로 보았을 때, 얼마만큼을 보존할 것인가. 보존 데이터는 센터를 중심
 * @param stretchWidthRatio   원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
 * @param stretchHeightRatio  원본 가로 크기에서 몇배만큼 늘릴 것인가. 1.0 이상
 * @discussion 유지되는 이미지의 사각형의 중심은 그대로 유지된다.
 * @remark 가로의 한쪽만 늘어나거나 새로의 한쪽만 늘어나지는 않는다. 한쪽만 늘리고 싶다면, convenience 메서드를 이용하라.
 * @code
        UIImage *tiger = [UIImage imageNamed:@"Tiger"];
        UIImage *stetchTiger = [tiger mgrStretchSideWidthPreserveWidthRatio:0.9
                                                        preserveHeightRatio:0.9
                                                          stretchWidthRatio:3.0
                                                         stretchHeightRatio:3.0];
        [self.imageView setImage:stetchTiger];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
 * @endcode
 * @return 늘려진 새로운 이미지
*/
- (UIImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                               preserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio
                                stretchHeightRatio:(CGFloat)stretchHeightRatio;

// convenience
- (UIImage *)mgrStretchSideWidthPreserveWidthRatio:(CGFloat)preserveWidthRatio
                                 stretchWidthRatio:(CGFloat)stretchWidthRatio;
// convenience
- (UIImage *)mgrStretchSideWidthPreserveHeightRatio:(CGFloat)preserveHeightRatio
                                 stretchHeightRatio:(CGFloat)stretchHeightRatio;


@end

NS_ASSUME_NONNULL_END
