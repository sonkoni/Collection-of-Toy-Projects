//
//  MGURippleButton.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-21
//  ----------------------------------------------------------------------
//
// Configuration 을 만들지는 못했다. 너무 오래전에 만들었음. 예제는 MGUButtons 프로젝트에서 확인하라.
// https://github.com/zoonooz/ZFRippleButton ZFRippleButton(swift)를 재구성하였다.
// https://github.com/bfeher/BFPaperButton (objective - C)의 연타 기능을 추가하였다. 논리는 완전히 다르다.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * @abstract    @c MGURippleButton
 * @discussion  나중에 실제로 앱에서 사용하게 되면 그때는 Configuration을 만들자.
 *              ...
 */
IB_DESIGNABLE @interface MGURippleButton : UIButton

@property (nonatomic) IBInspectable UIColor *rippleColor;
@property (nonatomic) IBInspectable UIColor *rippleBackgroundColor;

/** shadowRippleEnable default YES */
@property (nonatomic) IBInspectable BOOL rippleShadowEnabled;
/** rippleShadowRadius, rippleShadowOpacity는 shadowRippleEnable 이 YES 일때만 사용된다.*/
@property (nonatomic) IBInspectable CGFloat rippleShadowRadius;
@property (nonatomic) IBInspectable CGFloat rippleShadowOpacity;
@property (nonatomic) IBInspectable CGSize  rippleShadowOffset;

@property (nonatomic) IBInspectable CGFloat defaultShadowRadius;
@property (nonatomic) IBInspectable CGFloat defaultShadowOpacity;
@property (nonatomic) IBInspectable CGSize  defaultShadowOffset;


/** 단순하게 Button의 layer의 radius에 연결되어있다. */
@property (nonatomic) IBInspectable CGFloat buttonCornerRadius;

@property (nonatomic) IBInspectable CFTimeInterval touchDownAnimationDuration;
@property (nonatomic) IBInspectable CFTimeInterval touchUpAnimationDuration;

/** ripple이 버튼의 바운드에 구애 받지 않고 퍼져 나갈 수 있는지의 여부를 말한다. default NO */
@property (nonatomic) IBInspectable BOOL rippleOverBounds; // <- YES이면, 리플이 넘어가게 넘어가게 된다.

/** 손가락이 떨어진 점에서 리플이 생기게 할지 여부를 결정한다. default NO */
@property (nonatomic) IBInspectable BOOL trackTouchLocation; // <- YES이면, 손가락이 떨어진 점에서 리플이 생긴다.

@end

NS_ASSUME_NONNULL_END

