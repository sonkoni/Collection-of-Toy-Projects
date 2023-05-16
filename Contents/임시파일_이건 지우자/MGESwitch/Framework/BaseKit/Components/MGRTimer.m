//
//  MGRTimer.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGRTimer.h"

#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

enum TimerState {
    TimerIsInitialed    = -2,   // 초기화 후 한 번도 실행 안 한 상태. Suspend 된 채 생성됨
    TimerIsCanceled     = -1,
    TimerIsSuspended    = 0,    // 명시적으로 Pause 를 때린 경우
    TimerIsRunning      = 1,
    TimerIsRunSleep     = 2     // 런 동작 중에 잠든 경우 Suspend 된 채 잠든다.
};

@implementation MGRTimer {
    NSInteger _state;
}
- (void)dealloc {
    if (_timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        // 타이머가 Suspend 상태라면 활성화 한 뒤 취소해야 한다.
        if (_state == TimerIsInitialed || _state == TimerIsSuspended || _state == TimerIsRunSleep) {dispatch_resume(_timerCore);}
        dispatch_source_cancel(_timerCore);
    }
    _timerCore = nil;
#if (TARGET_OS_OSX || TARGET_OS_IPHONE)
    if (_isSyncAppLife) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
#endif
#if DEBUG
    printf("* DEBUG: dealloc : <%s: %p>\n", object_getClassName(self), self);
#endif
}

+ (instancetype)timerInterval:(NSTimeInterval)dueTime work:(dispatch_block_t)workBlock {
    return [[self alloc] initWithStart:0 isStartWall:NO interval:dueTime max:0 on:dispatch_get_main_queue() work:workBlock started:nil canceled:nil];
}

+ (instancetype)timerInterval:(NSTimeInterval)dueTime on:(dispatch_queue_t)queue work:(dispatch_block_t)workBlock {
    return [[self alloc] initWithStart:0 isStartWall:NO interval:dueTime max:0 on:queue work:workBlock started:nil canceled:nil];
}

+ (instancetype)timerStart:(NSTimeInterval)start interval:(NSTimeInterval)dueTime max:(NSUInteger)max on:(dispatch_queue_t)queue work:(dispatch_block_t)workBlock started:(dispatch_block_t _Nullable)startedBlock canceled:(dispatch_block_t)canceledBlock {
    return [[self alloc] initWithStart:start isStartWall:NO interval:dueTime max:max on:queue work:workBlock started:startedBlock canceled:canceledBlock];
}

+ (instancetype)timerStartWall:(NSTimeInterval)start interval:(NSTimeInterval)dueTime max:(NSUInteger)max on:(dispatch_queue_t)queue work:(dispatch_block_t)workBlock started:(dispatch_block_t _Nullable)startedBlock canceled:(dispatch_block_t _Nullable)canceledBlock {
    return [[self alloc] initWithStart:start isStartWall:YES interval:dueTime max:max on:queue work:workBlock started:startedBlock canceled:canceledBlock];
}

- (instancetype)initWithStart:(NSTimeInterval)start isStartWall:(BOOL)isStartWall interval:(NSTimeInterval)dueTime max:(NSUInteger)max on:(dispatch_queue_t)queue work:(dispatch_block_t)workBlock started:(dispatch_block_t _Nullable)startedBlock canceled:(dispatch_block_t _Nullable)canceledBlock {
    self = [super init];
    if (self) {
        MGRDispatchTimerConfig config = MGRDispatchTimerConfigMake(start, isStartWall, dueTime, max);
        _timerCore = MGRDispatchTimerCreate(config, queue, workBlock, startedBlock, canceledBlock);
        _state = TimerIsInitialed;
    }
    return self;
}

- (void)setTimerCore:(dispatch_source_t)timerCore {
    NSCAssert(!_timerCore, @"타이머가 있으면 중복으로 할당되지 않는다. cancel 뒤 할당하거나 새로운 객체를 만들어라.");
    _timerCore = timerCore;
    _state = TimerIsInitialed;
}

- (void)setIsSyncAppLife:(BOOL)isSyncAppLife {
    if (isSyncAppLife) {
        [self setAppSyncToActive];
    } else {
        _isSyncAppLife = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setAppSyncToActive {
    _isSyncAppLife = YES;
#if TARGET_OS_OSX
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:NSApplicationDidResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wake) name:NSApplicationDidBecomeActiveNotification object:nil];
#elif TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wake) name:UIApplicationDidBecomeActiveNotification object:nil];
#endif
}

- (void)setAppSyncToHide {
    _isSyncAppLife = YES;
#if TARGET_OS_OSX
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:NSApplicationWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wake) name:NSApplicationWillUnhideNotification object:nil];
#elif TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wake) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
}

- (void)setAppSyncToSleep:(NSNotificationName)sleepName wake:(NSNotificationName)wakeName {
    _isSyncAppLife = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sleep) name:sleepName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wake) name:wakeName object:nil];
}

- (BOOL)isInitiated {
    return _state == TimerIsInitialed ? YES : NO;;
}

- (BOOL)isRuning {
    return _state == TimerIsRunning ? YES : NO;
}

- (void)resume {
    if (_timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        if (_state != TimerIsRunning) {dispatch_resume(_timerCore);}
        _state = TimerIsRunning;
    }
    // 타이머가 cancel 을 받고 리소스가 제거된 상태이면 dispatch_source_testcancel 에 0이 아닌 어떤 수가 나온다.
    // 즉, 타이머의 리소스가 살아있는 상태이면 dispatch_source_testcancel(..) == 0 이다.
}

- (void)pause {
    if (_state == TimerIsInitialed) {return;}
    if (_timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        if (_state == TimerIsRunning) {dispatch_suspend(_timerCore);}
        _state = TimerIsSuspended;
    }
}

- (void)cancel {
    if (_timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        // 타이며가 Suspend 상태라면 활성화 한 뒤 취소해야 한다.
        if (_state == TimerIsInitialed || _state == TimerIsSuspended || _state == TimerIsRunSleep) {dispatch_resume(_timerCore);}
        dispatch_source_cancel(_timerCore);
    }
    _timerCore = nil;
    _state = TimerIsCanceled;
}

#pragma mark - SyncAppLife
// 앱이 잠자기로 들어갈 때 타이머가 running 상태라면 suspend 시킨다.
// 앱이 활성화로 돌아올 때 직전 상태가 running 이었을 경우에만 resume 된다.

- (void)sleep {
    if (_state == TimerIsRunning && _timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        dispatch_suspend(_timerCore);
        _state = TimerIsRunSleep;
    }
}

- (void)wake {
    if (_state == TimerIsRunSleep && _timerCore && 0 == dispatch_source_testcancel(_timerCore)) {
        _state = TimerIsRunning;
        dispatch_resume(_timerCore);
    }
}

@end
