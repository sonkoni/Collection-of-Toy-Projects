//
//  MGUCarouselWheelTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselWheelTransformer.h"
#import "MGUCarouselCellLayoutAttributes.h"
#import "MGUCarouselView.h"
#import "MGUCarouselView_Internal.h"


#pragma mark - MGUCarouselWheelTransformer
@interface MGUCarouselWheelTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;
@property (nonatomic, assign) BOOL inverted;
@end

@implementation MGUCarouselWheelTransformer

//! MGUCarouselCollectionViewLayout에서 이 값을 사용하지만, MGUCarouselWheelTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGUCarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    if (self.carouselView == nil) {
        return 0.0;
    }

    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        return self.carouselView.itemSize.width * (0.09); // 9 %
    } else {
        return self.carouselView.itemSize.height * (0.09); // 9 %
    }
}

- (void)applyTransformTo:(MGUCarouselCellLayoutAttributes *)attributes {
    if (self.carouselView == nil) {
        return;
    }
    
    CGFloat itemSizeWidth;
    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        itemSizeWidth = self.carouselView.itemSize.width;
    } else {
        itemSizeWidth = self.carouselView.itemSize.height;
    }
    
    CGRect rect = self.carouselView.collectionView.bounds;
    attributes.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); // 우선 중앙으로 모은다.

    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0 / self.eyePosition;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
    
    // wrap 모드 도입으로 인하여.
    NSInteger _numberOfItems =
    (self.carouselView.volumeType == MGUCarouselVolumeTypeFiniteWrap) ? self.carouselView.numberOfItems + 2 : self.carouselView.numberOfItems;
    NSInteger count = MIN(12, _numberOfItems);
    
    CGFloat theta = (M_PI * 2.0) / count;
    // radius = 큰 원의 반지름
    CGFloat radius = itemSizeWidth * count / (M_PI * 2.0); // 원의 둘레의 길이는 itemSizeWidth * count
    
    if (self.inverted == YES) {
        radius = -radius;
        theta = -theta;
    }
    
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        transform3D = CATransform3DTranslate(transform3D, 0.0, radius, 0.0);
        transform3D = CATransform3DRotate(transform3D, theta * attributes.position, 0.0, 0.0, 1.0);
        transform3D = CATransform3DTranslate(transform3D, 0.0, -radius, attributes.position * 0.01);
    } else {
        transform3D = CATransform3DTranslate(transform3D, -radius, 0.0, 0.0);
        transform3D = CATransform3DRotate(transform3D, theta * attributes.position, 0.0, 0.0, 1.0);
        transform3D = CATransform3DTranslate(transform3D, radius, 0.0, attributes.position * 0.01);
    }
    
    attributes.transform3D = transform3D;
    if (ABS(attributes.position) >= 6.0 && attributes.position != 6.0) { // 최대 12개만 허용.
        attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
    }
    
    if (self.carouselView.volumeType == MGUCarouselVolumeTypeInfinite &&
        self.carouselView.numberOfItems < 12) { // 무한에서 겹치면 진해지는 것을 막자.
        CGFloat numberOfItems = floor((CGFloat)(self.carouselView.numberOfItems)) / 2.0;
        if (ABS(attributes.position) >= numberOfItems && attributes.position != numberOfItems) {
            attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
        }
    }
    
    attributes.zIndex = (NSInteger)(attributes.position);
    return;
}


#pragma mark - 생성 & 소멸
+ (instancetype)wheelTransformerWithInverted:(BOOL)inverted {
    return [[self alloc] initWithWheelTransformerWithInverted:inverted];
}

- (instancetype)initWithWheelTransformerWithInverted:(BOOL)inverted {
    self = [super initWithType:MGUCarouselTransformerTypeLockWoodSpecial];
    if (self) {
        self.eyePosition = 500.0;
        self.minimumAlpha = 1.0;
        self.minimumScale = 0.5; // layoutAttributesForElementsInRect:에서 범위를 넓게 잡기 위해!!
        self.inverted = inverted;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end
