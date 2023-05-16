//
//  MGUCarouselTimeMachineTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUCarouselTimeMachineTransformer.h"
#import "MGUCarouselCellLayoutAttributes.h"
#import "MGUCarouselView.h"
#import "MGUCarouselView_Internal.h"


#pragma mark - MGUCarouselViewTimeMachineTransformer
@interface MGUCarouselTimeMachineTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;
@property (nonatomic, assign) BOOL inverted;
@end

@implementation MGUCarouselTimeMachineTransformer

#pragma mark - Override
 //! MGUCarouselCollectionViewLayout의 - layoutAttributesForElementsInRect: 가시권 rect를 조절하는데, 사용한다.
- (CGFloat)minimumScale {
    //! README 파일 참고하라.
    //!  1. scale = eye / (eye + distance) <- 이걸 쓰겠다.
    //!  2. distance = eye * (1.0/scale - 1.0)
    //!  3. eye = distance * ( scale / (1.0-scale) )
    CGFloat eyePosition = self.eyePosition;
    MGUCarouselScrollDirection scrollDirection = self.carouselView.scrollDirection;
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        return eyePosition / (eyePosition + 10 * self.carouselView.itemSize.width * 1.05); // 총 11 개의 item을 보게한다.
    } else {
        return eyePosition / (eyePosition + 10 * self.carouselView.itemSize.height * 1.05); // 총 11 개의 item을 보게한다.
    }
}

//! MGUCarouselCollectionViewLayout에서 이 값을 사용하지만, MGUCarouselViewTimeMachineTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGUCarouselCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    if (self.carouselView == nil) {
        return 0.0f;
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
    //CGFloat itemSizeWidth = self.carouselView.itemSize.width;
    
    CGFloat translationX = attributes.position * itemSizeWidth * 0.3;
    CGFloat position = attributes.position;
    if (self.inverted == NO) {
        translationX = MIN(translationX, itemSizeWidth * 0.3);
        translationX = MAX(translationX, - 10 * itemSizeWidth * 0.3);
    } else {
        position = - position;
        translationX = MIN(translationX, 10 * itemSizeWidth * 0.3);
        translationX = MAX(translationX, - itemSizeWidth * 0.3);
    }
    
    CGFloat translationZ = position * itemSizeWidth * 1.05;
    translationZ = MIN(translationZ, itemSizeWidth * 1.05);
    translationZ = MAX(translationZ, - 10 * itemSizeWidth * 1.05);
    
    if (scrollDirection == MGUCarouselScrollDirectionHorizontal) {
        transform3D = CATransform3DTranslate(transform3D, translationX, 0.0, translationZ);
    } else {
        transform3D = CATransform3DTranslate(transform3D, 0.0, translationX, translationZ);
    }
    
    attributes.transform3D = transform3D;
    attributes.alpha = MAX(0.0, MIN(1.0, -position + 1)); // minimumAlpha가 0.0이니깐.
    attributes.zIndex = (NSInteger)(position);
    return;
}


#pragma mark - 생성 & 소멸
+ (instancetype)timeMachineTransformerWithInverted:(BOOL)inverted {
    return [[self alloc] initWithTimeMachineTransformerWithInverted:inverted];
}

- (instancetype)initWithTimeMachineTransformerWithInverted:(BOOL)inverted {
    self = [super initWithType:MGUCarouselTransformerTypeLockWoodSpecial];
    if (self) {
        self.eyePosition = 500.0;
        self.minimumAlpha = 0.0;
        self.inverted = inverted;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
- (instancetype)initWithType:(MGUCarouselTransformerType)type { NSCAssert(FALSE, @"- initWithType: 사용금지."); return nil; }
@end
