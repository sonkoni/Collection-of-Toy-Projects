//
//  UIView+Shake.h
//  shakeAnimation
//
//  Created by Kwan Hyun Son on 16/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ShakeDirection) {
    ShakeDirectionHorizontal, // 좌우로 흔들기
    ShakeDirectionVertical,   // 위 아래로 흔들기
    ShakeDirectionRotation    // 회전흔들기 할꺼냐
};

@interface UIView (Shake)
/// shakeAnimation 프로젝트를 참고하라.
/// 편하게 쓸려고 만든 메서드이다.
- (void)simpleHShake;
- (void)simpleVShake;
- (void)simpleRShake;

- (void) shake:(int)times                           /// 몇번 흔들꺼냐?
     withDelta:(CGFloat)delta                       /// 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
         speed:(NSTimeInterval)interval             /// 만약 10번 흔들어 재낀다고 했을 때, 한번 재끼는데 필요한 시간. 따라서 총 애니메이션 시간은 interval * times
shakeDirection:(ShakeDirection)shakeDirection       /// 방향을 좌우로 할꺼냐? 위아래로 할꺼냐? 회전흔들기할꺼냐?
    completion:(nullable void (^)(void))completion; /// 컴플리션 핸들러.
    
    
- (void)simpleHShakeAndOpacity;

@end

NS_ASSUME_NONNULL_END
/** 호출시 다음과 같이 호출하면 자신이 가지고 있는 모든 서브뷰에 애니메이션을 때릴 수 있다.
[self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
    
    [obj shake:[self.textShakes.text intValue]
     withDelta:[self.textDelta.text floatValue]
         speed:[self.textSpeed.text floatValue]
shakeDirection:self.shakeDirection.selectedSegmentIndex /// ShakeDirectionHorizontal, ShakeDirectionVertical, ShakeDirectionRotation
    completion:^{
        NSLog(@"done!"); }];
    
    }]; **/
