//
//  MGUFlowVegaTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowVegaTransformer.h"
#import "MGUFlowCellLayoutAttributes.h"
#import "MGUFlowView.h"
#import "MGUFlowLayout.h"

#pragma mark - MGUFlowVegaTransformer
@interface MGUFlowVegaTransformer ()
@property (nonatomic, assign) BOOL bothSides;
@end

@implementation MGUFlowVegaTransformer

//! MGUFlowCollectionViewLayout에서 이 값을 사용하지만, MGUFlowWheelTransformer에서는 큰 의미가 없다.
//! 현재 클래스에서 레이아웃을 다시 조정한다. 즉, MGUFlowCollectionViewLayout에서 proposedInteritemSpacing 메서드의 사용은 이
//! 타입에서는 contentSize 계산 및 스크롤에 따른 이동의 측정에 이용된다.. 대신, 본 클래스의 - applyTransformTo:에서 이용할 것이다.
- (CGFloat)proposedInteritemSpacing {
    if (self.flowView == nil) {
        return 0.0f;
    }
    return self.flowView.interitemSpacing;
}

- (void)applyTransformTo:(MGUFlowCellLayoutAttributes *)attributes {
    if (self.flowView == nil) {
        return;
    }
    
    MGUFlowLayout *collectionViewLayout = (MGUFlowLayout *)(self.flowView.collectionViewLayout);
    CGFloat itemSpacing = collectionViewLayout.itemSpacing;
    if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
        if (attributes.position >= 0.0) {
            attributes.alpha = 1.0;
            attributes.transform3D = CATransform3DIdentity;
            attributes.zIndex = 0;
        } else {
            CGFloat yTranslate = (self.flowView.reversed == YES) ? attributes.position * itemSpacing : -attributes.position * itemSpacing;
            
    //        CGFloat position = attributes.center.y - self.collectionView.contentOffset.y - self.sectionInset.top - self.itemSize.height * 0.5;
    //        position = position / self.itemSize.height;
    //        position = MIN(0.0, position); // 0.0 초기화면(offset = 0.0)의 첫 번째 셀. 두 번째 셀은 1.0이지만 0.0 으로 바뀜
    //
    //        CGFloat yTranslate = -position * self.itemSize.height; // 기준선을 넘어가는 만큼 댕긴다.
            CGFloat scaleFactor = (attributes.position / 10.0) + 1.0; // 분모를 작게 하면 확 줄어든다.
            scaleFactor = MIN(1.0, MAX(0.0, scaleFactor));
    //
            CGFloat alphaFactor = (attributes.position / 5.0) + 1.0;
            alphaFactor = MIN(1.0, MAX(0.0, alphaFactor));
            
            CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0.0, yTranslate, 0.0);
            transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1.0);
            //! FIXME: Test 코드
    //        transform = CATransform3DRotate(transform, M_PI, 0.0, 0.0, 1.0);
            attributes.transform3D = transform;
            attributes.zIndex = (NSInteger)(floor(attributes.position) - 1.0);
            attributes.alpha = alphaFactor;
        }
    } else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
        if ([attributes.representedElementKind isEqualToString:MGUFlowElementKindVegaLeading]) {
            CGFloat margin =
            (itemSpacing - self.proposedInteritemSpacing + collectionViewLayout.actualLeadingSpacing) / 2.0;
            margin = margin + (attributes.position * itemSpacing);
            if (self.flowView.reversed == YES) {
                margin = margin * -1.0;
            }
            
            if (attributes.position >= 0.0) {
                attributes.alpha = 0.0;
            } else if (attributes.position <= -1.0) {
                attributes.alpha = 1.0;
            } else { // - 1 < < 0.0 => 알파1.0 ~ 알파0.0
                attributes.alpha = ABS(attributes.position);
            }

            attributes.center = CGPointMake(attributes.center.x,
                                            attributes.center.y - margin);
//            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
//            transform3D = CATransform3DRotate(transform3D, theta + M_PI_2, -1.0, 0.0, 0.0);
//            transform3D = CATransform3DRotate(transform3D, M_PI, 0.0, 1.0, 0.0);
////                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, -1 *(radius + 0.01));
//            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, (self.depth - radius)); // (radius + 0.01 - self.depth)
            attributes.zIndex = 1000;
        }
    }
    
    
//    CGFloat itemSizeWidth;
//    UICollectionViewScrollDirection scrollDirection = self.flowView.scrollDirection;
//    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        itemSizeWidth = self.flowView.itemSize.width;
//    } else {
//        itemSizeWidth = self.flowView.itemSize.height;
//    }
//
//    CGRect rect = self.flowView.collectionView.bounds;
//    attributes.center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); // 우선 중앙으로 모은다.
//
//    CATransform3D transform3D = CATransform3DIdentity;
//
//    NSInteger _numberOfItems =
//    (self.flowView.volumeType == MGUFlowVolumeTypeFiniteWrap) ? self.flowView.numberOfItems + 2 : self.flowView.numberOfItems;
//    NSInteger count = MIN(12, _numberOfItems);
//    CGFloat theta = (M_PI * 2.0) / count * attributes.position;
//    // 큰 원의 반지름
//    CGFloat radius = MAX(itemSizeWidth * 1.05 / 2.0, itemSizeWidth * 1.05 / 2.0 / tan(M_PI/count)); // 1.05를 곱하는 이유는 사이의 간격을 살짝 넣기위해.
//
//    if (self.inverted == YES) {
//        radius = -radius;
//        theta = -theta;
//    }
//
//    //! 뒤로 많이 돌아가버리면, system이 멈춰버린다. 아마도 eyeposition 뒤로 돌아가는 것을 말하는 듯. 내 눈 뒤로 가면 안된다.
//    CGFloat translationZ = MIN(self.eyePosition - 1.0, radius * cos(theta) - radius);
//
//    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        transform3D = CATransform3DTranslate(transform3D, radius * sin(theta), 0.0, translationZ);
//    } else {
//        transform3D = CATransform3DTranslate(transform3D, 0.0, radius * sin(theta), translationZ);
//    }
//
//    attributes.transform3D = transform3D;
//
//    if (_inverted == YES) {
//        if (ABS(attributes.position) >= 3.0 && attributes.position != 3.0) { // 최대 6개만 허용. 반 허용.
//            attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
//        }
//        attributes.zIndex = (NSInteger)(ABS(attributes.position));
//    } else {
//        if (ABS(attributes.position) >= 6.0 && attributes.position != 6.0) { // 최대 12개만 허용.
//            attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
//        }
//
//        if (self.flowView.volumeType == MGUFlowVolumeTypeInfinite &&
//            self.flowView.numberOfItems < 12) { // 무한에서 겹치면 진해지는 것을 막자.
//            CGFloat numberOfItems = floor((CGFloat)(self.flowView.numberOfItems)) / 2.0;
//            if (ABS(attributes.position) >= numberOfItems && attributes.position != numberOfItems) {
//                attributes.alpha = 0.0; // minimumAlpha가 0.0이니깐.
//            }
//        }
//
//        attributes.zIndex = - (NSInteger)(ABS(attributes.position));
//    }
    return;
}


#pragma mark - 생성 & 소멸
+ (instancetype)vegaTransformerWithBothSides:(BOOL)bothSides {
    return [[self alloc] initWithvegaTransformerWithBothSides:bothSides];
}

- (instancetype)initWithvegaTransformerWithBothSides:(BOOL)bothSides {
    self = [super init];
    if (self) {
        self.minimumAlpha = 1.0;
        self.minimumScale = 0.5; // layoutAttributesForElementsInRect:에서 범위를 넓게 잡기 위해!!
        self.bothSides = bothSides;
    }
    return self;
}


#pragma mark - NS_UNAVAILABLE
+ (instancetype)new { NSCAssert(FALSE, @"+ new 사용금지."); return nil; }
- (instancetype)init { NSCAssert(FALSE, @"- init 사용금지."); return nil; }
@end
