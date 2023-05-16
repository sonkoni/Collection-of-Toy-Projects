//
//  MGACarouselDiceTransformer.h
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-11-25
//  ----------------------------------------------------------------------
//

#import <MacKit/MGACarouselTransformer.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MGACarouselElementKindDice NS_TYPED_EXTENSIBLE_ENUM;
static MGACarouselElementKindDice const MGACarouselElementKindDiceBack  = @"MGACarouselElementKindDiceBack";
static MGACarouselElementKindDice const MGACarouselElementKindDiceSideA  = @"MGACarouselElementKindDiceSideA"; // vertival scroll, horizontal -> top
static MGACarouselElementKindDice const MGACarouselElementKindDiceSideB  = @"MGACarouselElementKindDiceSideB"; // vertival scroll, horizontal -> bottom
static MGACarouselElementKindDice const MGACarouselElementKindDiceTop    = MGACarouselElementKindDiceSideA; // vertival scroll, horizontal -> top
static MGACarouselElementKindDice const MGACarouselElementKindDiceBottom = MGACarouselElementKindDiceSideB; // vertival scroll, horizontal -> bottom
static MGACarouselElementKindDice const MGACarouselElementKindDiceFloating = @"MGACarouselElementKindDiceFloating"; // Floating
static MGACarouselElementKindDice const MGACarouselElementKindDiceFloatingBar = @"MGACarouselElementKindDiceFloatingBar"; // Floating Bar


/*!
 @enum       MGACarouselDiceFloatingType
 @abstract   Floating Supplementary View의 up mode OR down mode
 @constant   MGACarouselDiceFloatingTypeUp     센터로 오며서 Floating Supplementary View 가 선다.
 @constant   MGACarouselDiceFloatingTypeDown   항상 탑에 붙어있다.
 */
typedef NS_ENUM(NSUInteger, MGACarouselDiceFloatingType) {
    MGACarouselDiceFloatingTypeUp = 0,
    MGACarouselDiceFloatingTypeDown
};

/*!
 @class         MGACarouselDiceTransformer
 @abstract      셀 3개짜리 고정. Supplementary View 3개 이용. MGACarouselCylinderTransformer를 참고하여 만들었다.
 @discussion    mini focus 전용.
*/
@interface MGACarouselDiceTransformer : MGACarouselTransformer

 // 위, 아래, 왼쪽, 오른쪽에서 쳐다보는 효과를 가져다 준다. 디폴트 0.0 (-0.1 ~ 0.1)
@property (nonatomic, assign) CGFloat eyePositionXY;
@property (nonatomic, assign) CGFloat depth; // 깊이.
@property (nonatomic, assign) CGSize itemSize; // view controller 에서 viewDidLayoutSubviews 에서 결정된 사이즈를 입력해주면 새롭게 등장하는 면에서의 각도를 계산한다.

@property (nonatomic, assign) MGACarouselDiceFloatingType floatingType; // 디폴트 MGACarouselDiceFloatingTypeUp @dynamic _toggle에 의해 결정된다.
- (void)setFloatingType:(MGACarouselDiceFloatingType)floatingType animated:(BOOL)animated;

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
- (instancetype)initWithType:(MGACarouselTransformerType)type NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
