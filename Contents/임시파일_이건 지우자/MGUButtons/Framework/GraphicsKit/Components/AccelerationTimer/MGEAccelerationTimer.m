//
//  MGEAccelerationTimer.m
//  GMStepperExample
//
//  Created by Kwan Hyun Son on 2020/11/11.
//

#import "MGEAccelerationTimer.h"

static NSTimeInterval const timerInterval = 0.05;

@interface MGEAccelerationTimer ()
@property (nonatomic, strong, nullable) NSTimer *timer; // Target을 weak로 잡자.
@property (nonatomic, assign) NSInteger timerFireCount; //  디폴트 0 타이머가 시작되면 0부터 센다.

#if DEBUG
@property (nonatomic, copy) void (^printTimerGaps)(void);
#endif
@end

@implementation MGEAccelerationTimer

+ (instancetype)accelerationTimerWithUpdateBlock:(void(^__nullable)(void))updateBlock {
    MGEAccelerationTimer *accelerationTimer = [[super alloc] init];
    if (self) {
        accelerationTimer.updateBlock = updateBlock;
#if DEBUG
        __block CFAbsoluteTime prevTime = 0.0f; // typedef CFTimeInterval CFAbsoluteTime;
        accelerationTimer.printTimerGaps = ^void(void) {
            CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
            if (prevTime != 0.0) {
                printf("now - prevTime : %f \n", now - prevTime);
            }
            prevTime = now;
        };
#endif
    }
    return accelerationTimer;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
#if DEBUG
    NSLog(@"MGEAccelerationTimer Dealloc");
#endif
}


#pragma mark - control
- (void)startAccelerationTimer {
    if (self.timer != nil) {
#if DEBUG
        NSAssert(FALSE, @"타이머가 존재하는데, 타이머를 만들려고 시도했다.");
#endif
        [self invalidate];
    }
    
    __weak __typeof(self)weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:timerInterval
                                     target:weakSelf
                                   selector:@selector(timerTick:)
                                   userInfo:nil
                                    repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes]; // <- NSRunLoopCommonModes 해야 인터렉션 딜레이 방지할 수 있다. NSDefaultRunLoopMode
    self.timer.tolerance = 0.1; // 허용오차. 약간의 오차를 줘야지 프로그램이 메모리를 덜먹는다. 보통 0.1
}

- (void)timerTick:(NSTimer *)timer {
    self.timerFireCount = self.timerFireCount + 1;
    if (self.timerFireCount % [self timerFireCountModulo] == 0) {
        if (self.updateBlock == nil) {
            NSAssert(FALSE, @"updateBlock이 nil인데, timer를 작동시켰다.");
        }
        self.updateBlock();
#if DEBUG
        self.printTimerGaps();
#endif
    }
}

//! 현재 존재하는 Timer를 무력화 시킨다. nil
- (void)invalidate {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
        self.timerFireCount = 0; // 갯수 세는 것을 다시 0로 만든다.
    }
}


#pragma mark - Helper
//! 애플과 동일한 방식이다. 타이머가 가속도를 가지고 움직이는 것처럼 골라준다.
- (NSInteger)timerFireCountModulo {
    if (self.timerFireCount > 80) { // 0.05(81) -> 0.05(82) -> 0.05(83) -> 0.05(84) -> 0.05(85)
        return 1; // 0.05 sec * 1 = 0.05 sec : (리턴값 * 0.05)는 호출되는 간격
    } else if (self.timerFireCount > 50) { // 0.1(52) -> 0.1(54) -> 0.1(56) -> 0.1(58) -> 0.1(60)
        return 2; // 0.05 sec * 2 = 0.1 sec : (리턴값 * 0.05)는 호출되는 간격
    } else { // 0.5(10) -> 0.5(20) -> 0.5(30) -> 0.5(40) -> 0.5(50)
        return 10; // 0.05 sec * 10 = 0.5 sec : (리턴값 * 0.05)는 호출되는 간격
    }
    //
    // self.timerFireCount % [self timerFireCountModulo] == 0 에 대한 호출.
    // 1. 0.5초마다 호출된다.(2.5초 동안 = 50 * 0.05) 즉, 5회 호출된다.
    // 2. 0.1초마다 호출된다.(1.5초 동안 = 30 * 0.05) 즉, 15회 호출된다.
    // 3. 0.05초마다 호출된다. 계속.
}

@end
//
//now - prevTime : 0.499124
//now - prevTime : 0.501052
//now - prevTime : 0.499933
//now - prevTime : 0.500004
//
//now - prevTime : 0.098978
//now - prevTime : 0.100108
//now - prevTime : 0.099901
//now - prevTime : 0.100880
//now - prevTime : 0.099517
//now - prevTime : 0.099717
//now - prevTime : 0.099924
//now - prevTime : 0.100079
//now - prevTime : 0.099970
//now - prevTime : 0.100033
//now - prevTime : 0.100933
//now - prevTime : 0.099740
//now - prevTime : 0.099236
//now - prevTime : 0.100106
//now - prevTime : 0.099888
//
//now - prevTime : 0.050141
//now - prevTime : 0.049968
//now - prevTime : 0.050854
//now - prevTime : 0.049048
//......
