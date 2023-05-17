//
//  MGRDispatchTimer.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGRDispatchTimerHelper.h"
#import <os/lock.h>

static const uint64_t DefaultLeewayTime = 0.1 * NSEC_PER_SEC;  // 여백시간 0.1 초

// ----------------------------------------------------------------------

dispatch_source_t
MGRDispatchTimerCreate(MGRDispatchTimerConfig config, dispatch_queue_t queue, dispatch_block_t workBlock, dispatch_block_t _Nullable startedBlock, dispatch_block_t _Nullable canceledBlock) {
    NSCAssert(queue && workBlock, @"Parameter Empty");
    // 세팅
    dispatch_time_t startTime = config.isStartWall ? dispatch_walltime(DISPATCH_TIME_NOW, config.start * NSEC_PER_SEC) : dispatch_time(DISPATCH_TIME_NOW, config.start * NSEC_PER_SEC);
    uint64_t interval = (config.interval > 0.f) ? config.interval * NSEC_PER_SEC : DISPATCH_TIME_FOREVER;
    // 타이머 설정
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, startTime, interval, DefaultLeewayTime);
    if (config.max) {
        __block NSUInteger countMax = config.max;  // critical
        __block os_unfair_lock _lock = OS_UNFAIR_LOCK_INIT;
        __weak dispatch_source_t weakTimer = timer;
        dispatch_source_set_event_handler(timer, ^{
            workBlock();
            os_unfair_lock_lock(&_lock);
            if (!--countMax) {
                os_unfair_lock_unlock(&_lock);
                dispatch_source_cancel(weakTimer);
                return;
            }
            os_unfair_lock_unlock(&_lock);
        });
    } else {
        dispatch_source_set_event_handler(timer, workBlock);
    }
    // 등록블락: resume 시 최초 1회 실행
    if (startedBlock) {
        dispatch_source_set_registration_handler(timer, ^{
            dispatch_async(queue, startedBlock);
        });
    }
    // 취소블락
    if (canceledBlock) {
        dispatch_source_set_cancel_handler(timer, ^{
            dispatch_async(queue, canceledBlock);
        });
    }
    return timer;
}


//! Koni 주석. 나는 이렇게 사용할란다.
//    @property (nonatomic, strong) dispatch_queue_t queue;
//    @property (nonatomic, strong, nullable) dispatch_source_t gcdTimer;
    
//    dispatch_queue_main_t mainQueue = dispatch_get_main_queue(void);
    
//    dispatch_queue_global_t globalQueue = dispatch_get_global_queue(long identifier, unsigned long flags);
//    dispatch_queue_global_t globalQueue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
//                                                                    QOS_CLASS_USER_INTERACTIVE
//                                                                    QOS_CLASS_USER_INITIATED
//                                                                    QOS_CLASS_DEFAULT
//                                                                    QOS_CLASS_UTILITY
//                                                                    QOS_CLASS_BACKGROUND
//                                                                    QOS_CLASS_UNSPECIFIED <- 사용금지
//                                                                    이렇게 글로벌 큐는 총 6가지.
    
//    dispatch_queue_t privateQueue = dispatch_queue_create(const char *label, dispatch_queue_attr_t attr);
//    dispatch_queue_t privateQueue = dispatch_queue_create("GCDTimerQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, -1);
//    dispatch_queue_t privateQueue = dispatch_queue_create("work", attr);
