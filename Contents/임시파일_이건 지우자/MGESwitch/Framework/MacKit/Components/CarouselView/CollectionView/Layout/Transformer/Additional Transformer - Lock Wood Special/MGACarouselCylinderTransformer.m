//
//  MGACarouselCylinderTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGACarouselCylinderTransformer.h"
#import "MGACarouselCellLayoutAttributes.h"
#import "MGACarouselView.h"
#import "MGACarouselLayout.h"
#import "MGACarouselView_Internal.h"


#pragma mark - MGACarouselCylinderTransformer
@interface MGACarouselCylinderTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;
@property (nonatomic, assign) BOOL inverted;
@end

@implementation MGACarouselCylinderTransformer

//! MGACarouselCollectionViewLayout에서 이 값을 사용하지만, MGACarouselWheelTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGACarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    if (self.carouselView == nil) {
        return 0.0f;
    }

    MGACarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGACarouselScrollDirectionHorizontal) {
        return self.carouselView.itemSize.width * (0.05); // 5 %
    } else {
        return self.carouselView.itemSize.height * (0.05); // 5 %
    }
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
    
    
    // wrap 모드 도입으로 인하여.
    NSInteger _numberOfItems =
    (self.carouselView.volumeType == MGACarouselVolumeTypeFiniteWrap) ? self.carouselView.numberOfItems + 2 : self.carouselView.numberOfItems;
    NSInteger count = MIN(12, _numberOfItems);
    CGFloat theta = (M_PI * 2.0) / count * attributes.position;
    // CGFloat theta = (M_PI * 2.0) / count;
    
    // 큰 원의 반지름
    CGFloat radius = MAX(0.01, itemSizeWidth * 1.05 / 2.0 / tan(M_PI/count)); // 1.05를 곱하는 이유는 사이의 간격을 살짝 넣기위해.
    //CGFloat radius = itemSizeWidth * count / (M_PI * 2.0); // 원의 둘레의 길이는 itemSizeWidth * count
    
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
        transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, -radius);
        transform3D = CATransform3DRotate(transform3D, theta, 0.0, 1.0, 0.0);
        transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(self.eyePositionXY, 1.0, 0.0, 0.0));
    } else {
        transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, -radius);
        transform3D = CATransform3DRotate(transform3D, theta, -1.0, 0.0, 0.0);
        transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, radius + 0.01);
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
+ (instancetype)cylinderTransformerWithInverted:(BOOL)inverted {
    return [[self alloc] initWithCylinderTransformerWithInverted:inverted];
}

- (instancetype)initWithCylinderTransformerWithInverted:(BOOL)inverted {
    self = [super initWithType:MGACarouselTransformerTypeLockWoodSpecial];
    if (self) {
        _eyePositionXY = 0.0;
        self.eyePosition = 500.0;
        self.minimumAlpha = 1.0;
        self.minimumScale = 0.5; // layoutAttributesForElementsInRect:에서 범위를 넓게 잡기 위해!!
        self.inverted = inverted;
    }
    return self;
}


#pragma mark - 세터 & 게터
- (void)setEyePositionXY:(CGFloat)eyePositionXY {
    eyePositionXY = MIN(MAX(eyePositionXY, -0.1), 0.1);
    _eyePositionXY = eyePositionXY;
    [self.carouselView.collectionViewLayout forceInvalidate];
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGACarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end
