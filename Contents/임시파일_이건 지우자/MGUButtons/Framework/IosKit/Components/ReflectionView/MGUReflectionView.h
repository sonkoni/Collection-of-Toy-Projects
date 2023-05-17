//
//  MGUReflectionView.h
//
//  Created by Kwan Hyun Son on 2020/07/30.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGUReflectionView
 @abstract      내부에서 MGUVisualEffectView 클래스가 필요하다.
 @discussion    Reflection_koni 프로젝트에서 예를 확이할 수 있다.
*/

IB_DESIGNABLE @interface MGUReflectionView : UIView

@property (nonatomic, strong, nullable) IBInspectable UIImage *image;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger contentMode;
#else
@property (nonatomic, assign) UIViewContentMode contentMode; // 디폴트 : UIViewContentModeScaleToFill
#endif

/************ 설정 ************/
// @property (nonatomic, assign) CGFloat alpha; <- 조정가능하다.
- (void)updateGradientLocation:(CGFloat)value; //! 1.0 이면 전체적으로 Reflection이 적용된다. 0.0이면 Reflection이 아예 보이지 않을 것이다.
- (void)updateIntensity:(CGFloat)intensity;
/**
 * @brief 호수, 거울, 유리에 반사된 이미지를 보여준다.
 * @param frame 뷰의 frame rectangle
 * @param alpha 뷰의 alpha 값.
 * @param location gradient로 표현할 비율. 1.0 이면 처음부터 끝까지 gradient 적용. 0.0이면 아무것도 보이지 않는다.
 * @param intensity Blur의 효과 정도. 0.0이면 블러가 없다. 0.5 정도가 적당하다. intensity는 수정할 수 없다. 아예 다시 심는 것이다. 콜렉션 뷰에서 버그가 있다. 콜렉션뷰에서는 0.0으로 반드시 설정하자.
 * @param originalImageView 참고할 원본 뷰이다. 초기화 단계에서 설정하면, 이미지 설정 및 contentMode를 KVO를 통해 자동으로 따라간다.
 * @discussion 0.5, 0.5, 0.5 면 적당히 나올듯하다.  0.4, 0.6, 0.5 도 괜찮다.
 * @remark 원본 이미지와 약간의 거리가 있는 것이 더 자연스럽다. 이것은 frame에 관련된 요소이므로 이 객체를 사용하는 객체에서 정하는 것이 좋다.
 * @code
    self.reflectionView = [[MGUReflectionView alloc] initWithFrame:CGRectZero
                                                             alpha:0.5
                                                          location:0.5
                                                         intensity:0.5
                                                 originalImageView:imageView];
 * @endcode
 * @return 주어진 MGUReflectionView 인스턴스를 반환한다.
*/
- (instancetype)initWithFrame:(CGRect)frame
                        alpha:(CGFloat)alpha
                     location:(CGFloat)location
                    intensity:(CGFloat)intensity
            originalImageView:(UIImageView * _Nullable)originalImageView;

@end

NS_ASSUME_NONNULL_END
