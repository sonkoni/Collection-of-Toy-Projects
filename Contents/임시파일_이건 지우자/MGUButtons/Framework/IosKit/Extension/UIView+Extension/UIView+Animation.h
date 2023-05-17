//
//  UIView+Shake.h
//  shakeAnimation
//
//  Created by Kwan Hyun Son on 16/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Shake)

/*!
 @enum       MGRViewShakeDirection
 @abstract   ......
 @constant   MGRViewShakeDirectionHorizontal 좌우로 흔들기
 @constant   MGRViewShakeDirectionVertical   위 아래로 흔들기
 @constant   MGRViewShakeDirectionRotation   회전흔들기 할꺼냐
 */
typedef NS_ENUM(NSUInteger, MGRViewShakeDirection) {
    MGRViewShakeDirectionHorizontal = 1, // 0은 피하는 것이 좋다.
    MGRViewShakeDirectionVertical,
    MGRViewShakeDirectionRotation
} ;


/**
 * @brief 리시버에 해당하는 뷰를 흔드는 효과의 애니메이션을 발동시킨다.
 * @param times - 몇 번 흔들 것이냐.
 * @param delta - 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
 * @param interval - 만약 10번 흔들어 재낀다고 했을 때, 한번 재끼는데 필요한 시간. 따라서 총 애니메이션 시간은 interval * times
 * @param shakeDirection - 방향을 좌우로 할꺼냐? 위아래로 할꺼냐? 회전흔들기할꺼냐?
 * @param completion - 애니메이션이 종료된 후에 발동될 컴플리션 핸들러
 * @discussion - recurrence 하게 발동하면 전체적으로 흔들리는 효과를 낼 수 있다.
 * @code
        [self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            [obj mgrShake:[self.textShakes.text intValue]
                withDelta:[self.textDelta.text floatValue]
                    speed:[self.textSpeed.text floatValue]
           shakeDirection:self.shakeDirection.selectedSegmentIndex // Horizontal, Vertical, Rotation
               completion:^{
                NSLog(@"done!");
 *           }];
        }];
 * @endcode
*/
- (void)mgrShake:(int)times
       withDelta:(CGFloat)delta
           speed:(NSTimeInterval)interval
  shakeDirection:(MGRViewShakeDirection)shakeDirection
      completion:(void (^_Nullable)(void))completion;


//!---- convenience 메서드
// 사용한 적은 없다.
- (void)mgrHorizontalShake;
- (void)mgrVerticalShake;
- (void)mgrRotationShake;

// 사용한 적은 없다.
- (void)mgrHorizontalShakeAndOpacity;

@end


@interface UIView (Hinge)

/*!
 @enum       MGRViewHingeAnchor
 @abstract   경첩이 존재하는 위치를 의미한다.
 @constant   MGRViewHingeAnchorTopLeft
 @constant   MGRViewHingeAnchorTopRight
 */
typedef NS_ENUM(NSUInteger, MGRViewHingeAnchor) {
    MGRViewHingeAnchorTopLeft = 1, // 0은 피하는 것이 좋다.
    MGRViewHingeAnchorTopRight
} ;

/**
 * @brief 리시버에 해당하는 경첩에 매달려 떨어지는 효과의 애니메이션을 발동시킨다. JHChainableAnimations를 가장 많이 참고했다.
 * @param hingeAnchor - 힌지의 위치
 * @param radian - 얼마나 꺾을 것인가
 * @param tearDuration - 꺽는 duration
 * @param fallDuration - 떨어지는 duration
 * @param completion - 애니메이션이 종료된 후에 발동될 컴플리션 핸들러
 * @discussion - https://github.com/daltoniam/DCAnimationKit 의 drop 과 hinge 도 참고했다.
 * @remark - 애초에는 rotateZ(95).easeBack.thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animate(0.4); 0.5 초동안 95도 easeBack 회전하고 그 다음 무빙 및 오파시티 애니메이셔늘 easeIn으로 0.4동안 실행인데, 좀 오바다. 일괄적인것은 부자연스럽다. https://github.com/jhurray/JHChainableAnimations
 * @code
        [self.moveView mgrHingeWithAnchor:MGRViewHingeAnchorTopLeft completion:^{
            [self.moveView removeFromSuperview];
            self.moveView = nil;
        }];
 * @endcode
*/
- (void)mgrHingeWithAnchor:(MGRViewHingeAnchor)hingeAnchor
                    radian:(CGFloat)radian
              tearDuration:(NSTimeInterval)tearDuration
              fallDuration:(NSTimeInterval)fallDuration
                completion:(void(^_Nullable)(void))completion;

- (void)mgrHingeWithAnchor:(MGRViewHingeAnchor)hingeAnchor
                completion:(void(^_Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
