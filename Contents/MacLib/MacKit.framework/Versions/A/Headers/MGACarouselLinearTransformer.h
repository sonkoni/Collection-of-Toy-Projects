//
//  MGACarouselLinearTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//
// - proposedInteritemSpacing 를 주로 수정하여 layout을 결정한다. 크게 두 가지 방식이 존재한다.

#import <MacKit/MGACarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - MGACarouselLinearTransformer 클래스
@interface MGACarouselLinearTransformer : MGACarouselTransformer

/**
 * @brief 오직 이것 하나로 초기화한다.
 * @param minimumScale 최대로 작아지는 스케일
 * @param minimumAlpha 최대로 옅어지는 알파값
 * @param isRegular 아이템을 3개만 표시하는지, 아니면 일정한 간격으로 표시할 것인지를 결정하는 BOOL 값.
 * @param ratio isRegular 값에 따라 regularSpaceRatio를 쓰던지 ratioShownAtTheEnd를 쓰던지 둘 중에 하나로 설정한다.
 * @discussion 스케일과 ratio만 조정하면, Overlap도 가능하다. 구조적으로 동일하다.
 * @remark 단순히 - proposedInteritemSpacing를 0.0 으로 하고, 스케일만 줄여서 줄어든 스케일이 간격으로 보이게 하는 효과를 볼 수있다. 이런 것을 흉내내고 싶다면, 만약 minimumScale = 0.55 로 했다면, regularSpaceRatio = (1.0 - 0.55) / 2.0 로 하면된다. 즉, regularSpaceRatio = (1.0 - minimumScale) / 2.0
 * @code
    self.carouselView.transformer = [MGACarouselLinearTransformer linearTransformerWithMinimumScale:0.6
                                                                                           MinimumAlpha:0.6
                                                                                              isRegular:NO
                                                                                                  ratio:0.2];
 * @endcode
 * @return 주어진 MGACarouselLinearTransformer 인스턴스를 반환한다.
*/
+ (instancetype)linearTransformerWithMinimumScale:(CGFloat)minimumScale
                                     MinimumAlpha:(CGFloat)minimumAlpha
                                        isRegular:(BOOL)isRegular
                                            ratio:(CGFloat)ratio; // 유일한 초기화 클래스 메서드이다.

- (instancetype)initWithLinearTransformerWithMinimumScale:(CGFloat)minimumScale
                                             MinimumAlpha:(CGFloat)minimumAlpha
                                                isRegular:(BOOL)isRegular
                                                    ratio:(CGFloat)ratio; // 유일한 초기화 인스턴스 메서드이다.

#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGACarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
//
// 한 화면에 세 개가 등장하고 양 끝은 중앙의 크기에 대비하여 0.6의 크기를 갖는 아이템이며
// 양 끝의 아이템은 중앙 아이템의 길이의 0.193만 보인다. 자세한 설명은 옴니 그래플을 참고하라.


/************************ 자주 사용할 포멧. ************************/
//! 아이템 3개만 보이는 것 : isRegular를 NO로 설정한다.
//
//! [MGACarouselLinearTransformer linearTransformerWithMinimumScale:0.6 MinimumAlpha:0.6 isRegular:NO ratio:0.2];
// 위 처럼 하면 총 세 개의 아이템이 보이며, 양 끝은 가운데에 비해 0.6의 크기를 갖고 멈췄을 때, 맨 끝에 보이는 길이는 가운데 아이템이 0.2만 보인다.
// 가운데를 제외한 나머지 아이템의 알파는 0.6이며 가운데로 올수록 알파가 1.0에 가깝게 변한다.

//! 아이템을 일정한 간격(가운데 아이템의 일정 비율)으로 배치 : isRegular를 YES로 설정한다.
//
//! [MGACarouselLinearTransformer linearTransformerWithMinimumScale:0.6 MinimumAlpha:0.6 isRegular:YES ratio:0.2];

// isRegular가 YES 일때, 단순히 minimumScale만 정해주고 적당히 간격을 유지하고 싶다면(줄어든 크기가 시각적으로 간격을 보여주는 형태)
//! [MGACarouselLinearTransformer linearTransformerWithMinimumScale:minimumScale
//!                                                         MinimumAlpha:0.6
//!                                                           isRegular:YES
//!                                                              ratio:(1.0 - minimumScale) / 2.0];
