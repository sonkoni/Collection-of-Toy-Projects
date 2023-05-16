//
//  MGRPub+Pipe.m
//  Created by Kiro on 2022/12/07.
//

#import <os/lock.h>
#import "MGRPub.h"
#import "MGRDebugMacro.h"
#import "MGRTagObject.h"

#if DEBUG && MGRPUB_DEBUG
#define PUB_DEBUG_LINE              MGR_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)          MGR_DEBUG_LOG(OBJ)
#else
#define PUB_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)
#endif


@implementation MGRPubPipe
- (instancetype)initFrom:(MGRPub *)pub {
    self = [super init];
    if (self) {_parent = pub;}
    return self;
}
- (void)subscribe:(MGRPubToken *)listener {
    if (_prototype) {listener.stream = _prototype(listener.group, listener.queue, listener.stream);}
    [_parent subscribe:listener];
}
- (MGRPubQueue)queueType {
    return [_parent queueType];
}
@end


@implementation MGRPubPipeLine
- (MGRPubQueue)queueType {
    return _queueType;
}
@end



#pragma mark - PipeHub
@implementation MGRPubPipeHub
@dynamic parent;
- (void)subscribe:(MGRPubToken *)listener {
    if (self.prototype) {listener.stream = self.prototype(listener.group, listener.queue, listener.stream);}
    listener.pub = self;
}
- (MGRPubQueue)queueType {
    return 0;
}
-(MGRPub *)parent {return nil;}
- (void)setParent:(MGRPub *)parent {}
@end



#pragma mark - Share
@implementation MGRPub (Share)
- (MGRPub *)share {
    if (!self.parent) {return self;}
    return [[MGRPubShare alloc] initFrom:self queue:[MGRPub queue:[self queueType]]];
}
@end



#pragma mark - Line
@implementation MGRPub (Line)
- (MGRPub *)line:(MGRPubQueue)type {
    MGRPubPipeLine *pipe = [[MGRPubPipeLine alloc] initFrom:self];
    pipe.queueType = type;
    return pipe;
}
@end



#pragma mark - Map
@implementation MGRPub (Map)
- (MGRPub *)map:(id(^)(id))mapBlock {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        MGRPubStreamBlock resolver = MGRPubResolver(group, queue, next);
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            resolver(mapBlock(data));
        };
    }];
    return pipe;
}
- (MGRPub *)mapError:(MGRPubMapErrorBlock)mapBlock {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        return ^(id _Nullable data) {
            if (!data || ![data isKindOfClass:[NSError class]]) {next(data); return;}
            next(mapBlock(data));
        };
    }];
    return pipe;
}
@end



#pragma mark - Filter
@implementation MGRPub (Filter)
- (MGRPub *)filter:(BOOL (^)(id))filterBlock {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]] || filterBlock(data)) {next(data);}
        };
    }];
    return pipe;
}
@end



#pragma mark - At
@implementation MGRPub (At)
- (MGRPub *)atFirst {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            next(data); next(nil);
        };
    }];
    return pipe;
}
- (MGRPub *)atLast {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        __block id _value = nil;
        return ^(id _Nullable data) {
            if (data) {_value = data;}
            if (!data || [data isKindOfClass:[NSError class]]) {
                next(_value); next(nil);
            }
        };
    }];
    return pipe;
}
@end



#pragma mark - Count
@implementation MGRPub (Count)
- (MGRPub<NSNumber *> *)count {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        __block NSUInteger _count = 0;
        return ^(id _Nullable data) {
            if (!data) {next(@(_count)); next(nil); return;}
            if ([data isKindOfClass:[NSError class]]) {next(data); return;}
            _count++;
        };
    }];
    return pipe;
}
@end



#pragma mark - Drop
@implementation MGRPub (Drop)
- (MGRPub *)dropFirst {return [self drop:1];}
- (MGRPub *)drop:(NSUInteger)count {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        __block NSUInteger _count = count;
        return ^(id _Nullable data) {
            if (!_count || !data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            _count--;
        };
    }];
    return pipe;
}
@end



#pragma mark - Take
@implementation MGRPub (Take)
- (MGRPub *)takeFirst {return [self take:1];}
- (MGRPub *)take:(NSUInteger)count {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        __block NSUInteger _count = count;
        return ^(id _Nullable data) {
            if (!_count) {return;}
            if (!data || [data isKindOfClass:[NSError class]]) {_count = 0; next(data); return;}
            if (_count--) {next(data);}
            if (!_count) {next(nil);}
        };
    }];
    return pipe;
}
@end



#pragma mark - Delay
@implementation MGRPub (Delay)
- (MGRPub *)delay:(NSTimeInterval)interval {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        dispatch_queue_t _queue = queue ? queue : dispatch_get_main_queue();
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), _queue, ^{
                next(data);
            });
        };
    }];
    return pipe;
}
- (MGRPub *)debounce:(NSTimeInterval)interval {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        dispatch_queue_t _queue = queue ? queue : dispatch_get_main_queue();
        __weak __block id tag;
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            __weak __block dispatch_block_t weakOperation;
            dispatch_block_t operation = ^{
                if (tag != weakOperation) {return;};
                tag = nil; next(data);
            };
            tag = weakOperation = operation;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), _queue, operation);
        };
    }];
    return pipe;
}
- (MGRPub *)throttle:(NSTimeInterval)interval {
    MGRPubPipe *pipe = [[MGRPubPipe alloc] initFrom:self];
    [pipe setPrototype:^MGRPubStreamBlock _Nonnull(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
        dispatch_queue_t _queue = queue ? queue : dispatch_get_main_queue();
        __weak __block id tag;
        return ^(id _Nullable data) {
            if (!data || [data isKindOfClass:[NSError class]]) {next(data); return;}
            if (tag) {return;}
            dispatch_block_t operation = ^{
                tag = nil; next(data);
            };
            tag = operation;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), _queue, operation);
        };
    }];
    return pipe;
}
@end



#pragma mark - Merge
@implementation MGRPub (Merge)
+ (MGRPub *)merge:(NSArray<MGRPub *> *)pubs {
    MGRPubHub *hub = [[MGRPubHub alloc] initWithPubs:pubs];
    [hub setPrototype:^MGRPubStreamBlock(NSUInteger count, NSArray *storage, MGRPubStreamBlock next) {
        return ^(MGRTagObject *data) {
            // 토큰이 모두 완료됐는지 검사
            BOOL isTokenAllDone = YES;
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject *cell = storage[idx];
                if (cell.token) {isTokenAllDone = NO; break;}
            }
            // 전체 완료/에러 여부 검사
            if (isTokenAllDone || [data.object isKindOfClass:[NSError class]]) {
                next(data.object); return;
            }
            if (data.object) {next(data.object);}
        };
    }];
    return hub;
}
- (MGRPub *)merge:(NSArray<MGRPub *> *)pubs {
    NSMutableArray<MGRPub *> *total = [NSMutableArray arrayWithObject:self];
    [total addObjectsFromArray:pubs];
    return [MGRPub merge:total];
}
@end



#pragma mark - Tie
@implementation MGRPub (Tie)
+ (MGRPub<NSArray *> *)tie:(NSArray<MGRPub *> *)pubs {
    MGRPubHub *hub = [[MGRPubHub alloc] initWithPubs:pubs];
    [hub setPrototype:^MGRPubStreamBlock(NSUInteger count, NSArray *storage, MGRPubStreamBlock next) {
        return ^(MGRTagObject *data) {
            // 토큰이 모두 완료됐는지 검사
            BOOL isTokenAllDone = YES;
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject *cell = storage[idx];
                if (cell.token) {isTokenAllDone = NO; break;}
            }
            // 전체 완료/에러 여부 검사
            if (!data.object && !isTokenAllDone) {return;}
            if (isTokenAllDone || [data.object isKindOfClass:[NSError class]]) {
                next(data.object); return;
            }
            // 해당 인덱스의 데이터 심기
            MGRPubHubTokenObject *cell = storage[data.tag];
            [cell setObject:data.object];
            // 채워졌으면 내리기
            NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject *cell = storage[idx];
                if (!cell.object) {result = nil; break;}
                [result addObject:cell.object];
            }
            if (result) {next(result);}
        };
    }];
    return hub;
}
- (MGRPub<NSArray *> *)tie:(NSArray<MGRPub *> *)pubs {
    NSMutableArray<MGRPub *> *total = [NSMutableArray arrayWithObject:self];
    [total addObjectsFromArray:pubs];
    return [MGRPub tie:total];
}
@end



#pragma mark - Zip
@implementation MGRPub (Zip)
+ (MGRPub<NSArray *> *)zip:(NSArray<MGRPub *> *)pubs {
    MGRPubHub *hub = [[MGRPubHub alloc] initWithPubs:pubs];
    [hub setPrototype:^MGRPubStreamBlock(NSUInteger count, NSArray *storage, MGRPubStreamBlock next) {
        return ^(MGRTagObject *data) {
            // 토큰이 모두 완료됐는지 검사
            BOOL isTokenAllDone = YES;
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject *cell = storage[idx];
                if (cell.token) {isTokenAllDone = NO; break;}
            }
            // 전체 완료/에러 여부 검사
            if (!data.object && !isTokenAllDone) {return;}
            if (isTokenAllDone || [data.object isKindOfClass:[NSError class]]) {
                next(data.object); return;
            }
            // 해당 인덱스의 데이터 심기
            MGRPubHubTokenObject *cell = storage[data.tag];
            if (!cell.object) {cell.object = [NSMutableArray array];}
            [cell.object addObject:data.object];
            // 첫 인덱스 채우기
            NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject<NSMutableArray *> *cell = storage[idx];
                id firstData = cell.object.firstObject;
                if (!firstData) {result = nil; break;}
                [result addObject:firstData];
            }
            // 결과가 없으면 나가고 있으면 첫 인덱스 제거 후 내리기
            if (!result) {return;}
            for (NSUInteger idx = 0; idx < count; idx++) {
                MGRPubHubTokenObject<NSMutableArray *> *cell = storage[idx];
                [cell.object removeObjectAtIndex:0];
            }
            next(result);
        };
    }];
    return hub;
}
- (MGRPub<NSArray *> *)zip:(NSArray<MGRPub *> *)pubs {
    NSMutableArray<MGRPub *> *total = [NSMutableArray arrayWithObject:self];
    [total addObjectsFromArray:pubs];
    return [MGRPub zip:total];
}
@end
