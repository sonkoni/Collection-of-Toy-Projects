//
//  MGUFlowFoldTransformer.m
//  Copyright © 2022 Mulgrim Co. All rights reserved.
//

#import "MGUFlowFoldTransformer.h"
#import "MGUFlowCellLayoutAttributes.h"
#import "MGUFlowView.h"
#import "MGUFlowLayout.h"

#pragma mark - MGUFlowFoldTransformer
@interface MGUFlowFoldTransformer ()
@property (nonatomic, assign) CGFloat eyePosition;
@end

@implementation MGUFlowFoldTransformer

- (instancetype)init {
    self = [super init];
    if (self) {
        _eyePosition = 500.0;
    }
    return self;
}

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
        if (attributes.position >= 1.0 ||
            (attributes.position >= 0.0 && attributes.indexPath.item % 2 == 0)) { // 기준선에 확 못 미치거나, 짝수 인덱스 (0, 2...) 일때에는 0.0
            attributes.alpha = 1.0;
            attributes.transform3D = CATransform3DIdentity;
            attributes.zIndex = 0;
        } else if (attributes.position <= - 2.0 ||
              (attributes.position <= - 1.0 && attributes.indexPath.item % 2 == 1) ) { // 아예 감춰라. 바때문이라도 이건 감춰야한다.
            attributes.alpha = 0.0;
            attributes.transform3D = CATransform3DIdentity;
            attributes.zIndex = 0;
            return;
        } else {
            CATransform3D transform3D = CATransform3DIdentity;
            transform3D.m34 = -1.0 / self.eyePosition;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
            attributes.center = CGPointMake(attributes.center.x, attributes.center.y - attributes.position * itemSpacing);
            if (attributes.indexPath.item % 2 == 0) { // 짝수 인덱스. 0.0 <~< -2.0 까지 변한다. 윗 부분.
                // 면적으로 결정하는 것이 합당할 듯하다.
                CGFloat area = ((itemSpacing / 2.0) * attributes.position) + itemSpacing;
                CGFloat rotateRadian = -acos(area / itemSpacing);
                CGFloat yTranslate1 = itemSpacing/2.0 + (-cos(rotateRadian) *(itemSpacing / 2.0)); // 회전으로 인해 땡겨야하는 부분.
    //            CGFloat yTranslate = (-attributes.position * itemSpacing);// - yTranslate1; // (콜렉션이 땡기는 부분.) - yTranslate1
                CGFloat zTranslate = sin(rotateRadian) * (itemSpacing / 2.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, zTranslate);
                transform3D = CATransform3DTranslate(transform3D, 0.0, -yTranslate1, 0.0);
                transform3D = CATransform3DRotate(transform3D, rotateRadian, 1.0, 0.0, 0.0);
                attributes.transform3D = transform3D;
            } else { // 홀수 인덱스. 1.0 <~< -1.0 까지 변한다. 아랫 부분.
                CGFloat area = ((itemSpacing / 2.0) * attributes.position) + itemSpacing / 2.0;
                CGFloat rotateRadian = acos(area / itemSpacing);
                CGFloat yTranslate1 = itemSpacing/2.0 - (cos(rotateRadian) *(itemSpacing / 2.0)); // 회전으로 인해 땡겨야하는 부분.
    //            CGFloat yTranslate = (-itemSpacing + yTranslate1);// - 3*yTranslate1; // (콜렉션이 땡기는 부분.) - yTranslate1
    //            CGFloat yTranslate = itemSpacing - yTranslate1;
                CGFloat yTranslate = itemSpacing - (3.0 * yTranslate1);
                CGFloat zTranslate = -sin(rotateRadian) * (itemSpacing / 2.0);
                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, zTranslate);
                transform3D = CATransform3DTranslate(transform3D, 0.0, yTranslate, 0.0);
                transform3D = CATransform3DRotate(transform3D, rotateRadian, 1.0, 0.0, 0.0);
                attributes.transform3D = transform3D;
            }
        }
    } else if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
        if ([attributes.representedElementKind isEqualToString:MGUFlowElementKindFoldLeading]) {
            CGFloat margin = (itemSpacing + collectionViewLayout.actualLeadingSpacing) / 2.0;
            if (attributes.position >= 0.0) {
                attributes.alpha = 0.0;
            } else if (attributes.position <= -2.0) {
                attributes.alpha = 1.0;
            } else { // - 2 < < 0.0 => 알파1.0 ~ 알파0.0
                attributes.alpha = -attributes.position / 2.0;
            }
            
            attributes.center = CGPointMake(attributes.center.x,
                                            attributes.center.y - (attributes.position * itemSpacing) - margin);
//            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, centralAxis);
//            transform3D = CATransform3DRotate(transform3D, theta + M_PI_2, -1.0, 0.0, 0.0);
//            transform3D = CATransform3DRotate(transform3D, M_PI, 0.0, 1.0, 0.0);
////                transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, -1 *(radius + 0.01));
//            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, (self.depth - radius)); // (radius + 0.01 - self.depth)
            attributes.zIndex = 1000;
        }
    }
    
    
    
    return;
}

@end


/*
- (void)applyTransformTo:(MGUFlowCellLayoutAttributes *)attributes {
    CATransform3D transform3D = CATransform3DIdentity;
//    transform3D.m34 = -1.0 / 500.0;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
    transform3D.m34 = -1.0 / 2000.0;  // 음수로 커질 수록(작으질 수록) 더 많이 꺾인다.
    UICollectionView *collectionView = [self.flowView valueForKey:@"collectionView"];
    collectionView.layer.sublayerTransform = transform3D;
    
    if (self.flowView == nil) {
        return;
    }
    if (attributes.position >= 1.0 ||
        (attributes.position >= 0.0 && attributes.indexPath.item % 2 == 0)) { // 기준선에 확 못 미치거나, 짝수 인덱스 (0, 2...) 일때에는 0.0
        attributes.alpha = 1.0;
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
        
    } else if (attributes.position <= - 2.0 ||
          (attributes.position <= - 1.0 && attributes.indexPath.item % 2 == 1) ) {
        attributes.alpha = 0.0;
        attributes.transform3D = CATransform3DIdentity;
        attributes.zIndex = 0;
        return;
    } else {
        CATransform3D transform3D = CATransform3DIdentity;
        CGFloat itemSpacing = self.flowView.collectionViewLayout.itemSpacing;
        if (attributes.indexPath.item % 2 == 0) { // 짝수 인덱스. 0.0 <~< -2.0 까지 변한다. 윗 부분.
            // 면적으로 결정하는 것이 합당할 듯하다.
            CGFloat area = ((itemSpacing / 2.0) * attributes.position) + itemSpacing;
            CGFloat rotateRadian = -acos(area / itemSpacing);
            CGFloat yTranslate1 = itemSpacing/2.0 + (-cos(rotateRadian) *(itemSpacing / 2.0)); // 회전으로 인해 땡겨야하는 부분.
            CGFloat yTranslate = (-attributes.position * itemSpacing) - yTranslate1; // (콜렉션이 땡기는 부분.) - yTranslate1
            CGFloat zTranslate = sin(rotateRadian) * (itemSpacing / 2.0);
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, zTranslate);
            transform3D = CATransform3DTranslate(transform3D, 0.0, yTranslate, 0.0);
            transform3D = CATransform3DRotate(transform3D, rotateRadian, 1.0, 0.0, 0.0);
            attributes.transform3D = transform3D;
        } else { // 홀수 인덱스. 1.0 <~< -1.0 까지 변한다. 아랫 부분.
            CGFloat area = ((itemSpacing / 2.0) * attributes.position) + itemSpacing / 2.0;
            CGFloat rotateRadian = acos(area / itemSpacing);
            CGFloat yTranslate1 = itemSpacing/2.0 - (cos(rotateRadian) *(itemSpacing / 2.0)); // 회전으로 인해 땡겨야하는 부분.
            CGFloat yTranslate = ((-attributes.position * itemSpacing) + (itemSpacing)) - 3*yTranslate1; // (콜렉션이 땡기는 부분.) - yTranslate1
            CGFloat zTranslate = -sin(rotateRadian) * (itemSpacing / 2.0);
            transform3D = CATransform3DTranslate(transform3D, 0.0, 0.0, zTranslate);
            transform3D = CATransform3DTranslate(transform3D, 0.0, yTranslate, 0.0);
            transform3D = CATransform3DRotate(transform3D, rotateRadian, 1.0, 0.0, 0.0);
            attributes.transform3D = transform3D;
        }
    }

    return;
}
*/
