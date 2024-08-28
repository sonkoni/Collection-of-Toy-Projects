//
//  UIView+Shake.m
//  shakeAnimation
//
//  Created by Kwan Hyun Son on 16/05/2019.
//  Copyright © 2019 Mulgrim Inc. All rights reserved.
//

#import "UIView+Shake.h"

@implementation UIView (Shake)

- (void)simpleHShake {
    
    [self shake:10
      withDelta:5.0
          speed:0.04
 shakeDirection:ShakeDirectionHorizontal
     completion:^{
        NSLog(@"done!"); }];
}

- (void)simpleVShake {
    
    [self shake:10
      withDelta:5.0
          speed:0.04
 shakeDirection:ShakeDirectionVertical
     completion:^{
         NSLog(@"done!"); }];
}

- (void)simpleRShake {
    
    [self shake:10
      withDelta:5.0
          speed:0.04
 shakeDirection:ShakeDirectionRotation
     completion:^{
         NSLog(@"done!"); }];
}

- (void) shake:(int)times
     withDelta:(CGFloat)delta
         speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
    completion:(nullable void (^)(void))completion {
    
    [self _shake:times
       direction:1  /// <- 고정
    currentTimes:0  /// <- 고정
       withDelta:delta
           speed:interval
  shakeDirection:shakeDirection
      completion:completion];
      
      /** 문제가 있다. 조금 UITextField가 조금 늦게 따라온다.
      [self _shake:times
         withDelta:delta
             speed:interval
    shakeDirection:shakeDirection
        completion:completion]; */
    
}

/// 실제로 작동하는 메서드이다! UIViewPropertyAnimator 로 구성해보았다.
/// direction:과 currentTimes:가 추가됨!
- (void)_shake:(int)times
     direction:(int)direction           /// <- 고정:1
  currentTimes:(int)current             /// <- 고정:0
     withDelta:(CGFloat)delta           /// 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
         speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
    completion:(void (^)(void))completionHandler {
    
    /** 다음과 같이 나눠서 할 수도 있다. SlideSideBarMenu1 프로젝트 참고.
     UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:*** curve:*** animations:***];
     [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {}];
     [animator startAnimationAfterDelay:0.0]; */
    
    /// 위키에서는 블락 내부에서 self를 호출할때는 밖에서 weakSelf를 잡고 내부에서는 UIView *strongSelf = weakSelf; 로 쓰라고 하는데(위키) 안써도 잘되네.
    /// Project:Mac-ObjC/노티피케이션 센터와 블락, Project:ObjC/블락과 메모리관리 를 참고하라.
    __weak UIView *weakSelf = self;
    
    [UIViewPropertyAnimator
     runningPropertyAnimatorWithDuration:interval
                                   delay:0.0
                                 options:UIViewAnimationOptionCurveEaseInOut
                              animations:^{ switch (shakeDirection) {
                                             case ShakeDirectionVertical:
                                                 weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(0, delta * direction);
                                        /// 똑같다 weakSelf.transform = CGAffineTransformMakeTranslation(0, delta * direction);
                                                 break;
                                             case ShakeDirectionRotation:
                                                 weakSelf.layer.affineTransform = CGAffineTransformMakeRotation(M_PI * delta / 1000.0f * direction);
                                                 break;
                                             case ShakeDirectionHorizontal:
                                                 weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(delta * direction, 0);
                                             default:
                                                break;
                                            } }
                              completion:^(UIViewAnimatingPosition finalPosition) {
                                  
                                            if(current >= times) { /// 원하는 숫자만큼 흔들었드면 재자리로 돌아와서 끝내라. return!!
                                                [UIViewPropertyAnimator
                                                 runningPropertyAnimatorWithDuration:interval
                                                                               delay:0.0
                                                                             options:UIViewAnimationOptionCurveEaseInOut
                                                                          animations:^{weakSelf.layer.affineTransform=CGAffineTransformIdentity;}
                                                                          completion:^(UIViewAnimatingPosition finalPosition) {
                                                                                        if(completionHandler != nil) {
                                                                                            completionHandler();
                                                                                        } }];
                                                
                                                return; /// 즉, return이 실행되면 아래의 메서드는 실행되지 않고 최종 종료된다.
                                            } // if 문의 괄호 닫기
         
                                            [weakSelf _shake:times
                                                   direction:direction * -1
                                                currentTimes:current + 1
                                                   withDelta:delta
                                                       speed:interval
                                              shakeDirection:shakeDirection
                                                  completion:completionHandler]; }];
}

/// CALayer로 구성해보았다. 근데, UITextField가 조금 늦게 따라옴.
- (void)_shake:(int)times
   withDelta:(CGFloat)delta           /// 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
     speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
  completion:(void (^)(void))completionHandler {
  
  CABasicAnimation *animation;
  
  switch (shakeDirection) {
    case ShakeDirectionVertical: {
      animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
      animation.fromValue = [NSNumber numberWithFloat:(-1.0 * delta)];
      animation.toValue   = [NSNumber numberWithFloat:delta];
      break; }
    case ShakeDirectionRotation: {
      animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      animation.fromValue = [NSNumber numberWithFloat:(-1.0 * (M_PI * delta / 1000.0f))];
      animation.toValue   = [NSNumber numberWithFloat:(M_PI * delta / 1000.0f)];
      break; }
    case ShakeDirectionHorizontal: {
      animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
      animation.fromValue = [NSNumber numberWithFloat:(-1.0 * delta)];
      animation.toValue   = [NSNumber numberWithFloat:delta];
      break; }
    default:
      break;
  }
  
  animation.beginTime = 0.0;
  animation.duration = interval;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.repeatCount = times;
  animation.autoreverses = YES;
  //animation.fillMode = kCAFillModeForwards;
  //animation.removedOnCompletion = NO;
  /// setCompletionBlock은 - addAnimation:forKey: 보다 위에 등장해야한다.
  [CATransaction setCompletionBlock:^{
    completionHandler();
  }];
  
  [self.layer addAnimation:animation forKey:@"shake"];
  
  [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
  [CATransaction setDisableActions:YES];
  self.layer.affineTransform = CGAffineTransformIdentity;
  [CATransaction commit];
}

- (void)simpleHShakeAndOpacity {
  
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
  animation.fromValue = [NSNumber numberWithFloat:-5];
  animation.toValue   = [NSNumber numberWithFloat:5];
  animation.duration = 0.05;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  animation.repeatCount = 8;
  animation.autoreverses = YES;
  
  CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
  animation2.fromValue = @(1.0);
  animation2.toValue   = @(0.0);
  animation2.duration = 1.0;
  animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];


  /// setCompletionBlock은 - addAnimation:forKey: 보다 위에 등장해야한다.
  [CATransaction setCompletionBlock:^{
    NSLog(@"컴플리션!");
  }];
  
  [self.layer addAnimation:animation forKey:@"position"];
  [self.layer addAnimation:animation2 forKey:@"opacity"];
  
  [CATransaction begin]; /// begin과 commit 안에서 수정(변화)이 일어난다.
  [CATransaction setDisableActions:YES];
  self.layer.affineTransform = CGAffineTransformIdentity;
  self.layer.opacity = 1.0;
  
  [CATransaction commit];
  
}

@end
/** 구형 메서드 스타일
/// direction:과 currentTimes:가 추가됨!
- (void)_shake:(int)times
     direction:(int)direction           /// <- 고정:1
  currentTimes:(int)current             /// <- 고정:0
     withDelta:(CGFloat)delta           /// 얼마나 넓게 흔들어 재낄꺼냐 숫자가 커지면 흔드는 범위가 넓어진다.
         speed:(NSTimeInterval)interval
shakeDirection:(ShakeDirection)shakeDirection
    completion:(void (^)(void))completionHandler {
    
    /// 위키에서는 블락 내부에서 self를 호출할때는 밖에서 weakSelf를 잡고 내부에서는 UIView *strongSelf = weakSelf; 로 쓰라고 하는데(위키) 안써도 잘되네.
    /// Project:Mac-ObjC/노티피케이션 센터와 블락, Project:ObjC/블락과 메모리관리 를 참고하라.
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:interval
                     animations:^{ switch (shakeDirection) {
                                    case ShakeDirectionVertical:
                                        weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(0, delta * direction);
                                        break;
                                    case ShakeDirectionRotation:
                                        weakSelf.layer.affineTransform = CGAffineTransformMakeRotation(M_PI * delta / 1000.0f * direction);
                                        break;
                                    case ShakeDirectionHorizontal:
                                        weakSelf.layer.affineTransform = CGAffineTransformMakeTranslation(delta * direction, 0);
                                    default:
                                        break;
                                    } }
                     completion:^(BOOL finished) {
                                    if(current >= times) {
                                        [UIView animateWithDuration:interval
                                                         animations:^{ weakSelf.layer.affineTransform = CGAffineTransformIdentity; }
                                                         completion:^(BOOL finished){
                                                                        if(completionHandler != nil) {
                                                                            completionHandler();
                                                                        } }];
                                        return;
                                    }
                         
                                    [weakSelf _shake:times
                                           direction:direction * -1
                                        currentTimes:current + 1
                                           withDelta:delta
                                               speed:interval
                                      shakeDirection:shakeDirection
                                          completion:completionHandler]; }];
    
    
}
**/


