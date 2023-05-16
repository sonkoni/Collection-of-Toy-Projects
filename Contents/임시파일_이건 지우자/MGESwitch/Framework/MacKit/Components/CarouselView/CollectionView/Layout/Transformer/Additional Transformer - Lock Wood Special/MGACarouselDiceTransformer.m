//
//  MGACarouselDiceTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

@import BaseKit;
@import GraphicsKit;
#import "MGACarouselDiceTransformer.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"
#import "MGACarouselView_Internal.h"
#import "MGACarouselLayout.h"


#pragma mark - MGACarouselDiceTransformer
@interface MGACarouselDiceTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;
@property (nonatomic, assign) BOOL inverted;
@property (nonatomic, assign) CGFloat radiusRadian; // 새로운 면이 보일 때의 각

/** Floating Supplementary View 의 up down을 위해 **/
@property (nonatomic, strong) MGEDisplayLink *MGEDisplayLink;
@property (nonatomic, assign) CGFloat toggle;
@end

@implementation MGACarouselDiceTransformer
@dynamic floatingType;

//! MGACarouselCollectionViewLayout에서 이 값을 사용하지만, MGACarouselWheelTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGACarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    return 0.0;
}

- (void)applyTransformTo:(MGACarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    NSScrollView *scrollView = self.carouselView.scrollView;
    CGFloat itemSizeWidth;
    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        itemSizeWidth = self.carouselView.itemSize.width;
    } else {
        itemSizeWidth = self.carouselView.itemSize.height;
    }
    
    CGRect rect = scrollView.contentView.bounds;
    attributes.mgrCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));  // 우선 중앙으로 모은다.

    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0 / self.eyePosition;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
    
    //! 면이 4개 이다.
    NSInteger count = 4;
    CGFloat theta = (M_PI * 2.0) / count * attributes.position;
    
    // 큰 원(내접원)의 반지름
    CGFloat radius = MAX(0.01, itemSizeWidth * 1.0 / 2.0 / tan(M_PI/count)); // 1.0를 보다 살짝 크게하면 간격이 늘어난다.
    
    
    //! 설명은 MGACarouselCylinderTransformer.graffle 참고하라. 회전 시 화면을 넘치지 않게 중심축을 적당히 밀었다가 당겨준다.
    CGFloat centralAxisMoving = ABS(attributes.position);
    centralAxisMoving = centralAxisMoving - (NSInteger)centralAxisMoving;
    centralAxisMoving = ABS(0.5 - centralAxisMoving);
    CGFloat radian = centralAxisMoving * M_PI_2; // 45∘ ~ 0∘ 단위는 라디안이다.
    // a = r × √2
    // x = (cosθ × a) - r
    CGFloat a = radius * sqrt(2);
    CGFloat x = (cos(radian) * a) - radius;
    CGFloat centralAxis = -radius - x;
//    CGFloat centralAxis = -radius; 밀어
    
    //! 라디어스 조절.
    if (radian == M_PI_4) {
        attributes.diceRadiusRatio = 1.0; // 원래의 라디어스를 그대로 쓴다.
    } else if (radian <= self.radiusRadian) {
        attributes.diceRadiusRatio = 0.0; // 완전히 쫙 핀다.
    } else { // radian : M_PI_4 ~ self.radiusRadian (45∘ ~ 30(이건 계산된 값 30이 아니다))
        attributes.diceRadiusRatio = (1.0 / (M_PI_4-self.radiusRadian)) * radian - 1 * ( self.radiusRadian/ (M_PI_4-self.radiusRadian));
    }
    
    if (self.inverted == YES) {
        radius = -radius;
        theta = -theta;
        //! 뒤로 많이 돌아가버리면, system이 멈춰버린다. 아마도 eyeposition 뒤로 돌아가는 것을 말하는 듯.
        if (theta > M_PI_2) {
            theta = M_PI_2;
        } else if (theta < -M_PI_2) {
            theta = -M_PI_2;
        }
    }
    
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        if (attributes.representedElementCategory == NSCollectionElementCategoryItem) {
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
            transform3D = CATransform3DRotate(transform3D, theta, 0.0, 1.0, 0.0);
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
        } else if (attributes.representedElementCategory == NSCollectionElementCategorySupplementaryView) {
            if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceBack]) {
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, theta - M_PI_2, 0.0, 1.0, 0.0);
//                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, self.depth - radius); // self.depth - (radius + 0.01)
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceSideA]) { // top
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, 1.0, 0.0, 0.0);
                transform3D = CATransform3DRotate(transform3D, theta+M_PI_2, 0.0, 0.0, -1.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceSideB]) { // bottom
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, -1.0, 0.0, 0.0);
                transform3D = CATransform3DRotate(transform3D, theta+M_PI_2, 0.0, 0.0, 1.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceFloating]) { // floating 미정...
            }
        }
        
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(self.eyePositionXY, 1.0, 0.0, 0.0));
    } else {
        if (attributes.representedElementCategory == NSCollectionElementCategoryItem) {
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
            transform3D = CATransform3DRotate(transform3D, theta, -1.0, 0.0, 0.0);
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
        } else if (attributes.representedElementCategory == NSCollectionElementCategorySupplementaryView) {
            if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceBack]) {
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, theta + M_PI_2, -1.0, 0.0, 0.0);
                transform3D = CATransform3DRotate(transform3D, M_PI, 0.0, 1.0, 0.0);
//                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, -1 *(radius + 0.01));
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, (self.depth - radius)); // (radius + 0.01 - self.depth)
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceSideA]) {
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, 0.0, -1.0, 0.0);
                transform3D = CATransform3DRotate(transform3D, theta+ M_PI_2, 0.0, 0.0, 1.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceSideB]) {
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, 0.0, 1.0, 0.0);
                transform3D = CATransform3DRotate(transform3D, theta + M_PI_2, 0.0, 0.0, -1.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceFloating]) {
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, theta, -1.0, 0.0, 0.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.02); // 기본 셀이 0.01 이므로 이거 위에 보여야함.
                //!- 여기 까지는 첫 번째 면과 동일.
                
                // 0 ~ -2 : 0º ~ 180 º : 0 radian ~ M_PI radian
                CGFloat floatingRadian = attributes.position * (-1.0 * M_PI_2);
                floatingRadian = MAX(0.0, MIN(floatingRadian, M_PI_2)); // 90도까지만 가능하게 하자.
                //CGFloat constant = 1.0; // 이걸 변화시킴. // 세움.
//                CGFloat constant = 0.0; // 이걸 변화시킴. // 눞힘.
                floatingRadian = floatingRadian * _toggle;
                CGFloat movingZ = radius * sin(floatingRadian);
                CGFloat movingY = -movingZ * tan(floatingRadian / 2.0);
                transform3D = CATransform3DRotate(transform3D, floatingRadian, -1.0, 0.0, 0.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, movingZ+0.02); // 기본 셀이 0.01 이므로 이거 위에 보여야함.
                transform3D = CATransform3DTranslate(transform3D, 0.0, movingY, 0.0);
                
                /** 구형 코드. 위의 신형 코드는 각 하나로 끝내버린다. 
                if (attributes.position >= -1) { // 0 ~ -1 최초 부터 90∘ 최초부터 회전 한 바퀴
                    // a = r × √2
                    // p = sin(θ) × a = sin(θ) × r × √2
                    CGFloat p = sin(radian) * radius * sqrt(2);
                    CGFloat translation = 0.0;
                    if (attributes.position >= -0.5) { // 최초부터 반 회전.
                        translation = radius - p; // r - p
                    } else {
                        translation = radius + p; // r + p
                    }
                    transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, 0.02); // 기본 셀이 0.01 이므로 이거 위에 보여야함.
                    transform3D = CATransform3DTranslate(transform3D, 0.0, -translation, 0.0);
                } else { // -1 ~ -2 그 다음 회전.
                    transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                    transform3D = CATransform3DRotate(transform3D, theta + M_PI_2, -1.0, 0.0, 0.0);
                    transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.02); // 기본 셀이 0.01 이므로 이거 위에 보여야함.
                    transform3D = CATransform3DTranslate(transform3D, 0.0, (radius * -2.0), 0.0);
                }
                 */
            } else if ([attributes.representedElementKind isEqualToString:MGACarouselElementKindDiceFloatingBar]) {
                //! Floating 이 UP 인 상태와 동일하다.
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
                transform3D = CATransform3DRotate(transform3D, theta, -1.0, 0.0, 0.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.02); // 기본 셀이 0.01 이므로 이거 위에 보여야함.
                CGFloat floatingRadian = attributes.position * (-1.0 * M_PI_2);
                floatingRadian = MAX(0.0, MIN(floatingRadian, M_PI_2)); // 90도까지만 가능하게 하자.
                CGFloat movingZ = radius * sin(floatingRadian);
                CGFloat movingY = -movingZ * tan(floatingRadian / 2.0);
                transform3D = CATransform3DRotate(transform3D, floatingRadian, -1.0, 0.0, 0.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, movingZ+0.03); // 기본 셀이 0.01, Floating이 0.02
                transform3D = CATransform3DTranslate(transform3D, 0.0, movingY, 0.0);
            }
        }
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(self.eyePositionXY, 0.0, 1.0, 0.0));
    }
    
    if (_inverted == YES) {
        //we can't just set the layer.doubleSided property because it doesn't block interaction
        //instead we'll calculate if the view is front-facing based on the transform
        if (transform3D.m33 <= 0.0) {
            attributes.hidden = YES;
        }
        if (ABS(attributes.position) >= 3.0 && attributes.position != 3.0) { // 최대 6개만 허용. 반 허용.
            attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
        }
        attributes.zIndex = (NSInteger)(ABS(attributes.position));
    } else {
        if (ABS(attributes.position) >= 6.0 && attributes.position != 6.0) { // 최대 12개만 허용.
            attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
        }
        
        if (self.carouselView.volumeType == MGACarouselVolumeTypeInfinite &&
            self.carouselView.numberOfItems < 12) { // 무한에서 겹치면 진해지는 것을 막자.
            CGFloat numberOfItems = floor((CGFloat)(self.carouselView.numberOfItems)) / 2.0;
            if (ABS(attributes.position) >= numberOfItems && attributes.position != numberOfItems) {
                attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
            }
        }
        
        attributes.zIndex = - (NSInteger)(ABS(attributes.position));
        if (attributes.representedElementCategory == NSCollectionElementCategorySupplementaryView) {
            attributes.zIndex = 1;
        }
    }
    
    attributes.dumyFrame = attributes.frame;
    attributes.dumyTransform = transform3D;
    
    attributes.dumyLayer.frame = attributes.frame;
    attributes.dumyLayer.transform = transform3D;
    attributes.dumyLayer.zPosition = (CGFloat)attributes.zIndex;
    
    CALayer *collectionViewLayer = self.carouselView.collectionView.layer;
    [attributes.dumyLayer removeFromSuperlayer];
    [collectionViewLayer addSublayer:attributes.dumyLayer];
    
    CGRect myRect = [attributes.dumyLayer convertRect:attributes.dumyLayer.bounds toLayer:collectionViewLayer];
    attributes.frame = myRect;
    
    //! content view frame 설정
    attributes.dumyLayer.transform = CATransform3DIdentity;
    attributes.dumyLayer.frame = attributes.frame;
    CGRect dumyFrame = [collectionViewLayer convertRect:attributes.dumyFrame toLayer:attributes.dumyLayer];
    attributes.dumyFrame = [self convertDumyFrame:dumyFrame];
    return;
}


#pragma mark - 생성 & 소멸
+ (instancetype)diceTransformerWithDepth:(CGFloat)depth {
    return [MGACarouselDiceTransformer diceTransformerWithInverted:NO depth:depth];
}

+ (instancetype)diceTransformerWithInverted:(BOOL)inverted depth:(CGFloat)depth {
    return [[self alloc] initWithDiceTransformerWithInverted:inverted depth:depth];
}

- (instancetype)initWithDiceTransformerWithInverted:(BOOL)inverted depth:(CGFloat)depth {
    self = [super initWithType:MGACarouselTransformerTypeLockWoodSpecial];
    if (self) {
        _eyePositionXY = 0.0;
        _depth = depth;
        _toggle = 1.0;
        self.eyePosition = 500.0;
        self.minimumAlpha = 1.0;
        self.minimumScale = 0.5; // layoutAttributesForElementsInRect:에서 범위를 넓게 잡기 위해!!
        self.inverted = inverted;
        self.MGEDisplayLink = [MGEDisplayLink displayLinkWithDuration:0.2
                                                   easingFunctionType:MGEEasingFunctionTypeEaseInOutSine
                                                        progressBlock:nil
                                                      completionBlock:nil];
    }
    return self;
}


#pragma mark - 세터 & 게터
- (void)setEyePositionXY:(CGFloat)eyePositionXY {
    eyePositionXY = MIN(MAX(eyePositionXY, -0.1), 0.1);
    _eyePositionXY = eyePositionXY;
    [self.carouselView.collectionViewLayout forceInvalidate];
}

- (void)setDepth:(CGFloat)depth {
    _depth = depth;
    [self.carouselView.collectionViewLayout forceInvalidate];
}

//! 회전 시, 새로운 면이 보여지게될 그 각을 찾기 위함이다.
- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    
    //! 설명은 MGACarouselCylinderTransformer.graffle 참고하라.
    //! 4차 방정식으로 구한다.
    CGFloat radius = (self.carouselView.scrollDirection == MGACarouselScrollDirectionHorizontal) ? itemSize.width / 2.0 : itemSize.height / 2.0;
    CGFloat a = 4.0 * ( radius * radius );
    CGFloat b = 4.0 * sqrt(2.0) * ( radius * self.eyePosition );
    CGFloat c = (2.0 * self.eyePosition * self.eyePosition) - ( 6.0 * radius * radius);
    CGFloat d = -4.0 * sqrt(2.0) * ( radius * self.eyePosition );
    CGFloat e = (2.0 * radius * radius) - (self.eyePosition * self.eyePosition);
    
    double complex roots4[4]; // 4은 4차 방정식이므로
    int cubicRealRootCount = 0;
    MGRQuarticEquation(a ,b, c, d, e, roots4, &cubicRealRootCount);
    CGFloat X = 0.0;
    for (NSInteger i = 0; i < 4; i++) {
        if (cimag(roots4[i]) == 0.0) {
            if (creal(roots4[i]) > 0.0 && creal(roots4[i]) < M_PI_2) {
                X = creal(roots4[i]);
                break;
            }
        }
    }
    
    CGFloat theta = acos(X); // 코사인의 역함수를 의미한다.
    _radiusRadian = theta;
//    NSLog(@"Radian theta %f, 디그리 %f", theta, theta * 180.0 / M_PI);
}

- (void)setFloatingType:(MGACarouselDiceFloatingType)floatingType {
    [self setFloatingType:floatingType animated:NO];
}

- (MGACarouselDiceFloatingType)floatingType {
    if (_toggle == 1.0) {
        return MGACarouselDiceFloatingTypeUp;
    } else {
        return MGACarouselDiceFloatingTypeDown;
    }
}


#pragma mark - Action
- (void)setFloatingType:(MGACarouselDiceFloatingType)floatingType animated:(BOOL)animated {
    if (animated == NO) {
        if (floatingType == MGACarouselDiceFloatingTypeUp) {
            _toggle = 1.0;
        } else {
            _toggle = 0.0;
        }
        [self.carouselView.collectionViewLayout forceInvalidate]; // [self.carouselView.collectionViewLayout invalidateLayout];
    } else {
        [self.MGEDisplayLink invalidate];
        self.MGEDisplayLink.progressBlock = nil;
        __weak __typeof(self) weakSelf = self;
        if (floatingType == MGACarouselDiceFloatingTypeUp) {
            _toggle = 0.0;
            self.MGEDisplayLink.progressBlock = ^(CGFloat progress) {
                weakSelf.toggle = progress;
                [weakSelf.carouselView.collectionViewLayout invalidateLayout]; // forceInvalidate 을 사용해서는 안된다.
            };
            self.MGEDisplayLink.completionBlock = ^{
                weakSelf.toggle = 1.0;
            };
        } else {
            _toggle = 1.0;
            self.MGEDisplayLink.progressBlock = ^(CGFloat progress) {
                weakSelf.toggle = (1.0 - progress); // 1.0 -> 0.0
                [weakSelf.carouselView.collectionViewLayout invalidateLayout]; // forceInvalidate 을 사용해서는 안된다.
            };
            self.MGEDisplayLink.completionBlock = ^{
                weakSelf.toggle = 0.0;
            };
        }
        
        [self.MGEDisplayLink startAnimationWithStartProgress:0.0];
        
    }
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGACarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end
