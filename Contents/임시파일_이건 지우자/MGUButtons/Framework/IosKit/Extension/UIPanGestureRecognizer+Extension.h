//
//  UIPanGestureRecognizer+Extension.h
//  Copyright © 2021 Mulgrim Co. All rights reserved.
//  ----------------------------------------------------------------------
//  VERSION_DATE    2021-04-29
//  ----------------------------------------------------------------------
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIPanGestureRecognizer (Extension)

/**
 * @brief 제스처가 특정한 거리(구역)을 넘어가는 순간 저항을 받는 것으로 계산하여 덜 이동되게하는 현재 좌표를 반환한다.
 * @param view 제스처의 좌표를 해석할 view
 * @param limit 한계값 - 이 값이 넘어가는 순간. 저항을 받게 된다. CGSizeZero이면 움직이는 순간부터 저항.
 * @param originalCenter touch begin에서의 움직이려는 view의 center 좌표.
 * @param ratio 적용할 비율이고, 디폴트 값은 0.2를 사용하자.
 * @discussion 스크롤뷰에서 max, min content offset이 넘어가면 저항을 받는 것과 같은 효과를 낼 수 있게 만든다.
 * @remark 좌표를 계산할 때, begin에서의 최초 기준값을 사용하므로, gesture changed에서 [gestureRecognizer setTranslation:CGPointZero inView:gestureRecognizer.view]; 를 해서는 안된다. 누적의 원리를 이용하여 현재 상태를 파악하므로 최초값이 필요하며 현재 시점이 ratio 적용시점인지를
   알기 위해 limit가 필요하다.
 * @code
        CGPoint targetCenter = target.center;
        targetCenter.x = [gesture mgrElasticTranslationIn:target
                                                withLimit:CGSizeZero
                                       fromOriginalCenter:CGPointMake(self.originalCenter, 0.0)
                                            applyingRatio:0.2].x;
        target.center = targetCenter;
 * @endcode
 * @return 이동되어야할 view의 center 좌표를 반환한다.
*/

- (CGPoint)mgrElasticTranslationInView:(UIView * _Nullable)view
                             withLimit:(CGSize)limit
                    fromOriginalCenter:(CGPoint)originalCenter
                         applyingRatio:(CGFloat)ratio; // 0.20
@end


// ----------------------------------------------------------------------


NS_ASSUME_NONNULL_END
/* ----------------------------------------------------------------------
 * 2021-04-29 : elastic
 */


// SwipeCellKit 프로젝트에서 영감을 받아서 만들었다.
// FrictionCurves 이런 프로젝트도 있다. 좀 모르겠다.
//- (CGFloat)sqrtConstraintValueForXPosition:(CGFloat)xPosition {
//        CGFloat linearValue = [self linearConstraintValueForXPosition:xPosition];
//        return [self finalConstraintValue] + sqrt(linearValue - [self finalConstraintValue]);
//}
//
//- (CGFloat)lognConstraintValueForXPosition:(CGFloat)xPosition {
//        CGFloat linearValue = [self linearConstraintValueForXPosition:xPosition];
//        return [self finalConstraintValue] * (1 + log10(linearValue/[self finalConstraintValue]));
//}
//
//
//- (CGFloat)powConstraintValueForXPosition:(CGFloat)xPosition {
//        CGFloat linearValue = [self linearConstraintValueForXPosition:xPosition];
//        CGFloat powValue = pow(linearValue/[self finalConstraintValue], 4.0) - 1.0;
//        return linearValue - powValue;
//}
