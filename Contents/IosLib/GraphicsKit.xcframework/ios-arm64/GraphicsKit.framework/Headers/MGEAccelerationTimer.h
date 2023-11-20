//
//  MGEAccelerationTimer.h
//  GMStepperExample
//
//  Created by Kwan Hyun Son on 2020/11/11.
//

#import <GraphicsKit/MGEBorderLayer.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract    @c MGEAccelerationTimer MGUStepper, MGAStepper 에서 사용하는 가속 타이머
 * @discussion  애플의 알고리즘과 거의 동일하다. 첫 타를 바로 때리는 것 빼고
 */
@interface MGEAccelerationTimer : NSObject

@property (nonatomic, copy, nullable) void (^updateBlock)(void); // 초기화 이후에도 설정할 수 있므르로.

- (void)startAccelerationTimer;
- (void)invalidate;

+ (instancetype)accelerationTimerWithUpdateBlock:(void(^__nullable)(void))updateBlock;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

/** 타이머의 간격을 체크해볼 수 있는 유용한 블락이다.
 
 @property (nonatomic, copy) void (^printTimerGaps)(void);
 
__block CFAbsoluteTime prevTime = 0.0f; // typedef CFTimeInterval CFAbsoluteTime;
self.printTimerGaps = ^void(void) {
    CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
    if (prevTime != 0.0) {
        printf("now - prevTime : %f \n", now - prevTime);
    }
    prevTime = now;
};
 
 self.printTimerGaps();
**/
