//
//  UIPanGestureRecognizer+Extension.m
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//

#import "UIPanGestureRecognizer+Extension.h"

@implementation UIPanGestureRecognizer (Extension)

- (CGPoint)mgrElasticTranslationInView:(UIView * _Nullable)view
                             withLimit:(CGSize)limit
                    fromOriginalCenter:(CGPoint)center
                         applyingRatio:(CGFloat)ratio { // 0.20
    CGPoint translation = [self translationInView:view];
    UIView *sourceView = self.view;
    if (sourceView == nil) {
        return translation;
    }

    CGPoint updatedCenter = CGPointMake(center.x + translation.x, center.y + translation.y); // 실제로 얼마나 이동해서 지금의 정확한 위치.
    CGSize distanceFromCenter = CGSizeMake(ABS(updatedCenter.x - CGRectGetMidX(sourceView.bounds)),
                                           ABS(updatedCenter.y - CGRectGetMidY(sourceView.bounds))); // 실제 이동한 거리. 무조건 양수(>=0)이다.
    CGFloat inverseRatio = 1.0 - ratio; // 실제 이동한거리에서 보여질 이동거리의 비율(ratio)의 역. 뺄셈을 이용하기 위해 역을 사용한다.
    
    CGFloat scaleX = updatedCenter.x < CGRectGetMidX(sourceView.bounds) ? -1.0 : 1.0; // 방향을 의미한다. 상식적인 방향이 맞다.
    CGFloat scaleY = updatedCenter.y < CGRectGetMidY(sourceView.bounds) ? -1.0 : 1.0; // 방향을 의미한다. 상식적인 방향이 맞다.

    //! limit를 초과할 경우. 끌어당기는 효과를 준다는 것. limit 가 CGPointZero일 경우. 무조건 끌어당기겠다는 뜻이다.
    CGFloat x = updatedCenter.x - (distanceFromCenter.width > limit.width ? inverseRatio * (distanceFromCenter.width - limit.width) * scaleX : 0);
    CGFloat y = updatedCenter.y - (distanceFromCenter.height > limit.height ? inverseRatio * (distanceFromCenter.height - limit.height) * scaleY : 0);

    return CGPointMake(x, y);
}
// FrictionCurves
@end
