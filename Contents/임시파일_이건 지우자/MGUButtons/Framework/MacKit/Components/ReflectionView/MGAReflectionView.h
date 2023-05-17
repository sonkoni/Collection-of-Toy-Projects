//
//  MGAReflectionView.h
//
//  Created by Kwan Hyun Son on 2020/07/30.
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import <AppKit/AppKit.h>
@class MGAImageView;

NS_ASSUME_NONNULL_BEGIN

/*!
 @class         MGAReflectionView
 @abstract      ...
 @discussion    MGEReflectionView 프로젝트에서 예를 확인할 수 있다.
*/

@interface MGAReflectionView : NSView

@property (nonatomic, strong, nullable) IBInspectable NSImage *image;

@property (nonatomic, assign) CALayerContentsGravity contentMode; // 디폴트 : kCAGravityResize

/************ 설정 ************/
 @property (nonatomic, assign) CGFloat alpha; //  @dynamic [0.0 ~ 1.0]
- (void)updateGradientLocation:(CGFloat)value; //! 1.0 이면 전체적으로 Reflection이 적용된다. 0.0이면 Reflection이 아예 보이지 않을 것이다.
/**
 * @brief 호수, 거울, 유리에 반사된 이미지를 보여준다.
 * @param frame 뷰의 frame rectangle
 * @param alpha 뷰의 alpha 값.
 * @param location gradient로 표현할 비율. 1.0 이면 처음부터 끝까지 gradient 적용. 0.0이면 아무것도 보이지 않는다.
 * @param originalImageView 참고할 원본 뷰이다. 초기화 단계에서 설정하면, 이미지 설정 및 contentMode를 KVO를 통해 자동으로 따라간다.
 * @discussion 0.5, 0.5, 0.5 면 적당히 나올듯하다.  0.4, 0.6, 0.5 도 괜찮다.
 * @remark 원본 이미지와 약간의 거리가 있는 것이 더 자연스럽다. 이것은 frame에 관련된 요소이므로 이 객체를 사용하는 객체에서 정하는 것이 좋다.
 * @code
    self.reflectionView = [[MGAReflectionView alloc] initWithFrame:CGRectZero
                                                             alpha:0.5
                                                          location:0.5
                                                 originalImageView:imageView];
 * @endcode
 * @return 주어진 MGAReflectionView 인스턴스를 반환한다.
*/
- (instancetype)initWithFrame:(CGRect)frame
                        alpha:(CGFloat)alpha
                     location:(CGFloat)location
            originalImageView:(MGAImageView * _Nullable)originalImageView;

@end

NS_ASSUME_NONNULL_END
