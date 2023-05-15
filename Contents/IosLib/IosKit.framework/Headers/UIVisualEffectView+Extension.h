//
//  UIVisualEffectView+MGRExtension.h
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2020-12-17
//  ----------------------------------------------------------------------
//
//! UIVisualEffectView는 크게 두 가지 방식으로 이용된다.
//! Vibrancy는 Blur 스타일을 맞춰줘야한다. 또한 Vibrancy 레벨도 설정할 수 있다.
//! ①. Blur View                 - Blur View는 단독으로 사용할 수 있다.
//! ②. Blur View + Vibrancy View - Vibrancy View는 Blur View와 함께 사용해야한다.
//!
//! Vibrancy를 사용할 경우, Vibrancy 올라가는 뷰의 background color는 투명해야 문제가 안생긴다. 투명하지 않을 경우, 원하는 효과가 나타나지 않을 수 있다. 색 자체를 마스크로 여기고 때려버리기 때문이다. vibrancy effect는 UIBlurEffect로 구성된 UIVisualEffectView의 서브뷰로 사용하거나 그 위에 계층화하기위한 것이다. vibrancy effect를 사용하면 contentView 내부에 배치된 컨텐츠가 더욱 선명해진다. vibrancy effect는 색상에 따라 다르다. contentView에 추가하는 모든 subview는 '- tintColorDidChange' 메서드를 구현하고 그에 따라 자체적으로 업데이트해야한다. 렌더링 모드가 UIImageRenderingModeAlwaysTemplate인 이미지가있는 UIImageView 객체와 UILabel 객체는 '자동'으로 업데이트된다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIVisualEffectView (Extension)
/**
 * @brief UIVibrancyEffect를 사용하지 않고, UIBlurEffect 만 사용하여 UIVisualEffectView를 만드는 편의 메서드.
 * @param style 적용할 UIBlurEffectStyle
 * @discussion UIVibrancyEffect를 사용하지 않는다. UIBlurEffect 만 사용
 * @remark 굳이 서브를 올릴 거라면 [blurView.contentView addSubview:customView]; UIVibrancyEffect 를 사용하지 않은 경우에만.
 * @code
    UIVisualEffectView *visualEffectView =
    [UIVisualEffectView mgrVisualEffectViewWithBlurEffectStyle:UIBlurEffectStyleDark];
 * @endcode
 * @return 주어진 UIBlurEffectStyle를 사용하여, UIVibrancyEffect 없이 UIBlurEffect 만을 이용하여 UIVisualEffectView 반환한다.
*/
+ (instancetype)mgrBlurViewWithBlurEffectStyle:(UIBlurEffectStyle)style;

//! 블러와 바이브런시 모두 올린 비쥬얼 이펙트 뷰.
+ (instancetype)mgrBlurVibrancyViewWithBlurEffectStyle:(UIBlurEffectStyle)style;

+ (instancetype)mgrBlurVibrancyViewWithBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                                   vibrancyEffectStyle:(UIVibrancyEffectStyle)vibrancyEffectStyle;

//! 비쥬얼 이팩트뷰에 서브뷰를 하는 것은 사실 content view에 해야한다.
//! contentView에 올릴 수 있게 편리하게 만듬. 리시버가 블러뷰일 때만 사용하는 메서드이다. 이걸로 충분하다.
//! 단독 블러뷰일 때는 자신(블러뷰)의 컨텐트 뷰의 서브뷰로 올리고
//! 바이브런시 뷰까지 가지고 있는 경우에는 바이브런시 뷰의 컨텐트뷰의 서브뷰로 올린다.
- (void)mgrAddSubview:(UIView *)view pinEdges:(BOOL)pinEdges;

@end

NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
* 2020-12-17 : 라이브러리 정리됨
*/


/**
typedef NS_ENUM(NSInteger, UIBlurEffectStyle) {
    // Traditional blur styles.
     
    UIBlurEffectStyleExtraLight,
    UIBlurEffectStyleLight,
    UIBlurEffectStyleDark,
    UIBlurEffectStyleExtraDark API_AVAILABLE(tvos(10.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos),

    // Styles which automatically show one of the traditional blur styles,
    // depending on the user interface style.
    //
    // Regular displays either Light or Dark.
    UIBlurEffectStyleRegular API_AVAILABLE(ios(10.0)),
 
    // Prominent displays either ExtraLight, Dark (on iOS), or ExtraDark (on tvOS).
    UIBlurEffectStyleProminent API_AVAILABLE(ios(10.0)),

    
    // Blur styles available in iOS 13.
    //
    // Styles which automatically adapt to the user interface style:
    UIBlurEffectStyleSystemUltraThinMaterial        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThinMaterial             API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemMaterial                 API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThickMaterial            API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemChromeMaterial           API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),

    // And always-light and always-dark versions:
    UIBlurEffectStyleSystemUltraThinMaterialLight   API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThinMaterialLight        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemMaterialLight            API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThickMaterialLight       API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemChromeMaterialLight      API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),

    UIBlurEffectStyleSystemUltraThinMaterialDark    API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThinMaterialDark         API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemMaterialDark             API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemThickMaterialDark        API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),
    UIBlurEffectStyleSystemChromeMaterialDark       API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos),

} API_AVAILABLE(ios(8.0));
*/



/**
typedef NS_ENUM(NSInteger, UIVibrancyEffectStyle) {
    // Vibrancy for text labels.
    UIVibrancyEffectStyleLabel,
    UIVibrancyEffectStyleSecondaryLabel,
    UIVibrancyEffectStyleTertiaryLabel,
    UIVibrancyEffectStyleQuaternaryLabel,

    // Vibrancy for thicker filled areas.
    UIVibrancyEffectStyleFill,
    UIVibrancyEffectStyleSecondaryFill,
    UIVibrancyEffectStyleTertiaryFill,

    // Vibrancy for separator lines.
    UIVibrancyEffectStyleSeparator,

} API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(tvos, watchos);
*/
