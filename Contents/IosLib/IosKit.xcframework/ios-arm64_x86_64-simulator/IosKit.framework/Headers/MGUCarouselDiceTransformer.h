//
//  MGUCarouselDiceTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <IosKit/MGUCarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MGUCarouselElementKindDice NS_TYPED_EXTENSIBLE_ENUM;
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceBack  = @"MGUCarouselElementKindDiceBack";
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceSideA  = @"MGUCarouselElementKindDiceSideA"; // vertival scroll, horizontal -> top
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceSideB  = @"MGUCarouselElementKindDiceSideB"; // vertival scroll, horizontal -> bottom
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceTop    = MGUCarouselElementKindDiceSideA; // vertival scroll, horizontal -> top
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceBottom = MGUCarouselElementKindDiceSideB; // vertival scroll, horizontal -> bottom
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceFloating = @"MGUCarouselElementKindDiceFloating"; // Floating
static MGUCarouselElementKindDice const MGUCarouselElementKindDiceFloatingBar = @"MGUCarouselElementKindDiceFloatingBar"; // Floating Bar


/*!
 @enum       MGUCarouselDiceFloatingType
 @abstract   Floating Supplementary View의 up mode OR down mode
 @constant   MGUCarouselDiceFloatingTypeUp     센터로 오며서 Floating Supplementary View 가 선다.
 @constant   MGUCarouselDiceFloatingTypeDown   항상 탑에 붙어있다.
 */
typedef NS_ENUM(NSUInteger, MGUCarouselDiceFloatingType) {
    MGUCarouselDiceFloatingTypeUp = 0,
    MGUCarouselDiceFloatingTypeDown
};

/*!
 @class         MGUCarouselDiceTransformer
 @abstract      셀 3개짜리 고정. Supplementary View 3개 이용. MGUCarouselCylinderTransformer를 참고하여 만들었다.
 @discussion    mini focus 전용.
*/
@interface MGUCarouselDiceTransformer : MGUCarouselTransformer

 // 위, 아래, 왼쪽, 오른쪽에서 쳐다보는 효과를 가져다 준다. 디폴트 0.0 (-0.1 ~ 0.1)
@property (nonatomic, assign) CGFloat eyePositionXY;
@property (nonatomic, assign) CGFloat depth; // 깊이.
@property (nonatomic, assign) CGSize itemSize; // view controller 에서 viewDidLayoutSubviews 에서 결정된 사이즈를 입력해주면 새롭게 등장하는 면에서의 각도를 계산한다.

@property (nonatomic, assign) MGUCarouselDiceFloatingType floatingType; // 디폴트 MGUCarouselDiceFloatingTypeUp @dynamic _toggle에 의해 결정된다.
- (void)setFloatingType:(MGUCarouselDiceFloatingType)floatingType animated:(BOOL)animated;

/*!
 @method        + diceTransformer
 @abstract      클래스 초기화 메서드.
 @discussion    사실 이 클래스에서 inverted를 사용할 일이 없을 듯하다. 이 메서드를 이용하자.
 @param         depth 깊이에 해당하는 길이
*/
+ (instancetype)diceTransformerWithDepth:(CGFloat)depth;
+ (instancetype)diceTransformerWithInverted:(BOOL)inverted depth:(CGFloat)depth;
- (instancetype)initWithDiceTransformerWithInverted:(BOOL)inverted depth:(CGFloat)depth;


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
