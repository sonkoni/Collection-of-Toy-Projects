//
//  MGRDispatchDebounceHelper.m
//  Copyright © 2021 mulgrim. All rights reserved.
//

#import "MGRDispatchDebounceHelper.h"

// Debounce : 이 로직은 MGRPublisher+Debounce 에 구현된 로직과 동일하다.
MGRDispatchDebounceBlock MGRDispatchDebouncer(void) {
    __weak __block id tag;
    return ^(dispatch_queue_t queue, NSTimeInterval interval, dispatch_block_t next) {
        __weak __block dispatch_block_t weakOperation;
        dispatch_block_t operation = ^{
            if (tag != weakOperation) {return;};
            tag = nil;
            next();
        };
        tag = weakOperation = operation;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), queue, operation);
    };
}
