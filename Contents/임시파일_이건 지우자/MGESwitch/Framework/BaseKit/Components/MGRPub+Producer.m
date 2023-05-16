//
//  MGRPub+Producer.m
//  Created by Kiro on 2022/12/07.
//

#import <os/lock.h>
#import "MGRPub.h"
#import <BaseKit/MGRDebugMacro.h>

#if DEBUG && MGRPUB_DEBUG
#define PUB_DEBUG_LINE              MGR_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)          MGR_DEBUG_LOG(OBJ)
#else
#define PUB_DEBUG_LINE
#define PUB_DEBUG_LOG(OBJ)
#endif

#pragma mark - __Once
// 원스는 listener.pub 에 아무 것도 제공하지 않는다.
// 따라서 subscribe 하면 취소할 수 없다.
@interface __MGRPubOnce : MGRPub @end
@implementation __MGRPubOnce {
    id _data;
}
- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {_data = data;}
    return self;
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    if ([_data isKindOfClass:[MGRPub class]]) {
        [(MGRPub *)_data subscribe:listener];
        return;
    }
    [listener setData:_data];
    [listener setData:nil];
}
@end

MGRPub * MGRPubOnce(id data) {
    return [[__MGRPubOnce alloc] initWithData:data];
}


#pragma mark - OnceFuture
// 퓨처는 내부에서 NSHashTable 이 아니라 NSMutableSet 을 사용하여 Token 을 strong 으로 잡는다.
// 또한 listener.pub 에 아무 것도 제공하지 않는다. 따라서 subscribe 하면 수동으로 cancel 을 때려야 취소된다.
@implementation MGRFuture {
    os_unfair_lock _lock;
    id _data;
    NSMutableSet * _subscribers;
}
@dynamic data;
+ (instancetype)data:(id)data {
    return [[[self class] alloc] initWithData:data];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _subscribers = [NSMutableSet set];
    }
    return self;
}
- (instancetype)initWithData:(id)data {
    self = [self init];
    if (self) {_data = data;}
    return self;
}
- (id)data {
    os_unfair_lock_lock(&_lock);
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    return data;
}
- (void)setData:(id)data {
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    NSArray *subscribers = [_subscribers allObjects];
    _subscribers = nil;
    if (data) {_data = data;}
    os_unfair_lock_unlock(&_lock);
    if ([data isKindOfClass:[MGRPub class]]) {
        for (id<MGRPubReceiving> listener in subscribers) {
            [(MGRPub *)data subscribe:listener];
        }
    } else {
        for (id<MGRPubReceiving> listener in subscribers) {
            [listener setData:data];
            [listener setData:nil];
        }
    }
}
- (void)emit:(id)value {
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    NSArray *subscribers = [_subscribers allObjects];
    _data = value;
    os_unfair_lock_unlock(&_lock);
    if ([value isKindOfClass:[MGRPub class]]) {
        for (id<MGRPubReceiving> listener in subscribers) {
            [(MGRPub *)value subscribe:listener];
        }
    } else {
        for (id<MGRPubReceiving> listener in subscribers) {
            [listener setData:value];
        }
    }
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    os_unfair_lock_lock(&_lock);
    if (_subscribers) {
        [listener setPub:self];
        [_subscribers addObject:listener];
        os_unfair_lock_unlock(&_lock);
        return;
    }
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    if ([data isKindOfClass:[MGRPub class]]) {
        [(MGRPub *)data subscribe:listener];
    } else {
        if (data) {[listener setData:data];}
        [listener setData:nil];
    }
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:nil];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    [_subscribers removeObject:listener];
    os_unfair_lock_unlock(&_lock);
}
@end



#pragma mark - __OnceEmit
@interface __MGRPubOnceEmit : MGRPub @end
@implementation __MGRPubOnceEmit {
    void (^_emitter)(id<MGRPubReceiving> listener);
}
- (instancetype)initWith:(void (^)(id<MGRPubReceiving> listener))emitter {
    self = [super init];
    if (self) {_emitter = emitter;}
    return self;
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    _emitter(listener);
}
@end



#pragma mark - Just
MGRPub * MGRPubJust(id value) {
    return [MGRPub just:value];
}
@implementation MGRPub (Just)
+ (MGRPub *)just:(id)value {
    NSCAssert(![value isKindOfClass:[NSError class]], @"Arg Type Error!");
    return [[__MGRPubOnce alloc] initWithData:value];
}
@end



#pragma mark - Fail
MGRPub * MGRPubFail(NSError *error) {
    return [MGRPub fail:error];
}
@implementation MGRPub (Fail)
+ (MGRPub *)fail:(NSError *)error {
    NSCAssert([error isKindOfClass:[NSError class]], @"Arg Type Error!");
    return [[__MGRPubOnce alloc] initWithData:error];
}
@end



#pragma mark - Future
MGRPub * MGRPubFuture(void (NS_NOESCAPE ^fulfill)(MGRPubPromiseBlock promise)) {
    return [MGRPub future:fulfill];
}
MGRPub * MGRPubFutureIn(MGRPubPromiseBlock _Nullable __strong * _Nonnull promise) {
    return [MGRPub futureIn:promise];
}
MGRPub * MGRPubOnFuture(MGRPubQueue queueType, void (NS_NOESCAPE ^fulfill)(MGRPubPromiseBlock promise)) {
    return [MGRPub on:queueType future:fulfill];
}
@implementation MGRPub (Future)
+ (MGRPub *)future:(void (NS_NOESCAPE ^)(MGRPubPromiseBlock))fulfill {
    MGRFuture *pub = [[MGRFuture alloc] init];
    MGRPubPromiseBlock promise = ^(id process) {[pub setData:process];};
    fulfill(promise);
    return pub;
}
+ (MGRPub *)futureIn:(__strong MGRPubPromiseBlock  _Nullable *)promise {
    MGRFuture *pub = [[MGRFuture alloc] init];
    void (^fulfill)(MGRPubPromiseBlock) = ^(MGRPubPromiseBlock p){};
    *promise = ^(id process) {[pub setData:process];};
    fulfill(*promise);
    return pub;
}
+ (MGRPub *)on:(MGRPubQueue)queueType future:(void (NS_NOESCAPE ^)(MGRPubPromiseBlock))fulfill {
    MGRFuture *pub = [[MGRFuture alloc] init];
    dispatch_async([MGRPub queue:queueType], ^{
        MGRPubPromiseBlock promise = ^(id process) {[pub setData:process];};
        fulfill(promise);
    });
    return pub;
}
@end



#pragma mark - Sequence
MGRPub * MGRPubSequence(NSArray *array) {
    return [MGRPub sequence:array];
}
@implementation MGRPub (Sequence)
static MGRPubStreamBlock __StreamForRecursiveSeq(NSUInteger current, NSArray *array, NSMutableSet *storage, id<MGRPubReceiving> listener, MGRSeqRefineBlock _Nullable refiner) {
    return ^(id _Nullable data){
        [listener setData:refiner ? refiner(current, data) : data];
        for (NSUInteger idx = (current + 1); idx < array.count; idx++) {
            id obj = [array objectAtIndex:idx];
            if ([obj isKindOfClass:[MGRPub class]]) {
                MGRPubStreamBlock recv = __StreamForRecursiveSeq(idx, array, storage, listener, refiner);
                [(MGRPub *)obj inner:listener.group queue:listener.queue storage:storage next:recv];
                return;
            }
            [listener setData:refiner ? refiner(idx, obj) : obj];
        }
        [listener setData:nil];
    };
}
static __MGRPubOnceEmit * _Nonnull __SequenceWithRefine(NSArray *array, MGRSeqRefineBlock _Nullable refiner) {
    __block id _store;
    __MGRPubOnceEmit *pub = [[__MGRPubOnceEmit alloc] initWith:^(id<MGRPubReceiving> listener) {
        if (!array.count) {[listener setData:nil]; return;}
        for (NSUInteger idx = 0; idx < array.count; idx++) {
            id obj = [array objectAtIndex:idx];
            if ([obj isKindOfClass:[MGRPub class]]) {
                if (!_store) {_store = [NSMutableSet set];}
                MGRPubStreamBlock recv = __StreamForRecursiveSeq(idx, array, _store, listener, refiner);
                [(MGRPub *)obj inner:listener.group queue:listener.queue storage:_store next:recv];
                return;
            }
            [listener setData:refiner ? refiner(idx, obj) : obj];
        }
        [listener setData:nil];
    }];
    return pub;
}
+ (MGRPub *)sequence:(NSArray *)array {
    return __SequenceWithRefine(array, nil);
}
+ (MGRPub *)sequence:(NSArray *)array refine:(MGRSeqRefineBlock)refiner {
    return __SequenceWithRefine(array, refiner);
}
@end



#pragma mark - Pass
@implementation MGRPubPass {
    os_unfair_lock _lock;
    NSHashTable<id<MGRPubReceiving>> * _Nullable _subscribers;
}
- (instancetype)init {
    self = [super init];
    if (self) {_lock = OS_UNFAIR_LOCK_INIT;}
    return self;
}
- (void)send:(id)data {
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    NSArray *subscribers = [_subscribers allObjects];
    if (!data || [data isKindOfClass:[NSError class]]) {_subscribers = nil;}
    os_unfair_lock_unlock(&_lock);
    for (id<MGRPubReceiving> listener in subscribers) {
        [listener setData:data];
    }
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:self];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {_subscribers = [NSHashTable weakObjectsHashTable];}
    [_subscribers addObject:listener];
    os_unfair_lock_unlock(&_lock);
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:nil];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    [_subscribers removeObject:listener];
    os_unfair_lock_unlock(&_lock);
}
@end
@implementation MGRPub (Pass)
+ (MGRPub *)pass {
    return [[MGRPubPass alloc] init];
}
@end



#pragma mark - Post
@implementation MGRPubPost {
    id _data;
    os_unfair_lock _lock;
    NSHashTable<id<MGRPubReceiving>> * _Nullable _subscribers;
}
@dynamic data;
- (instancetype)init {
    self = [super init];
    if (self) {_lock = OS_UNFAIR_LOCK_INIT;}
    return self;
}
- (instancetype)initWithData:(id)data {
    self = [self init];
    if (self) {_data = data;}
    return self;
}
- (id)data {
    os_unfair_lock_lock(&_lock);
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    return data;
}
- (void)send:(id)data {
    os_unfair_lock_lock(&_lock);
    NSArray *subscribers = [_subscribers allObjects];
    if (!data || [data isKindOfClass:[NSError class]]) {_subscribers = nil;}
    if (data) {_data = data;}
    os_unfair_lock_unlock(&_lock);
    for (id<MGRPubReceiving> listener in subscribers) {
        [listener setData:data];
    }
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:self];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {_subscribers = [NSHashTable weakObjectsHashTable];}
    [_subscribers addObject:listener];
    if (!_data) {os_unfair_lock_unlock(&_lock); return;}
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    if (data) {[listener setData:data];}
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:nil];
    [super unsubscribe:listener];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    [_subscribers removeObject:listener];
    os_unfair_lock_unlock(&_lock);
}
@end
@implementation MGRPub (Post)
+ (MGRPubPost *)post {
    return [[MGRPubPost alloc] init];
}
+ (MGRPub *)post:(id)data {
    return [[MGRPubPost alloc] initWithData:data];
}
@end



#pragma mark - State
@implementation MGRPubState {
    id _data;
    os_unfair_lock _lock;
    NSHashTable<id<MGRPubReceiving>> * _Nullable _subscribers;
}
@dynamic value;
+ (instancetype)state:(id)data {
    return [[[self class] alloc] initWithData:data];
}
- (instancetype)init {
    self = [super init];
    if (self) {_lock = OS_UNFAIR_LOCK_INIT;}
    return self;
}
- (instancetype)initWithData:(id)data {
    self = [self init];
    if (self) {_data = data;}
    return self;
}
- (id)value {
    os_unfair_lock_lock(&_lock);
    id value = _data;
    os_unfair_lock_unlock(&_lock);
    return value;
}
- (void)update:(NS_NOESCAPE MGRPubUpdateBlock)updateBlock {
    os_unfair_lock_lock(&_lock);
    id updated = updateBlock([_data copy]);
    if (!updated) {os_unfair_lock_unlock(&_lock); return;}
    _data = updated;
    NSArray *subscribers = [_subscribers allObjects];
    os_unfair_lock_unlock(&_lock);
    for (id<MGRPubReceiving> listener in subscribers) {
        [listener setData:updated];
    }
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:self];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {_subscribers = [NSHashTable weakObjectsHashTable];}
    [_subscribers addObject:listener];
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    [listener setPub:self];
    if (data) {[listener setData:data];}
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:nil];
    [super unsubscribe:listener];
    os_unfair_lock_lock(&_lock);
    if (!_subscribers) {os_unfair_lock_unlock(&_lock); return;}
    [_subscribers removeObject:listener];
    os_unfair_lock_unlock(&_lock);
}
@end


#pragma mark - Hub
@implementation MGRPubHub {
    NSArray<MGRPub *> * _pubs;
    MGRPubStreamBlock (^_prototype)(NSUInteger, NSArray *, MGRPubStreamBlock);
    os_unfair_lock _lock;
    NSMutableArray<MGRPubHubUnit *> * _subscribers;  // critical
}
- (instancetype)initWithPubs:(NSArray<MGRPub *> *)pubs {
    self = [super init];
    if (self) {
        _pubs = pubs;
        _lock = OS_UNFAIR_LOCK_INIT;
        _subscribers = [NSMutableArray array];
    }
    return self;
}
- (void)setPrototype:(MGRPubStreamBlock (^)(NSUInteger count, NSArray *storage, MGRPubStreamBlock next))prototype {
    _prototype = prototype;
}
- (void)subscribe:(MGRPubToken *)listener {
    listener.pub = self;
    MGRPubHubUnit *unit = [MGRPubHubUnit new];
    unit.token = listener;
    unit.storage = [NSMutableArray arrayWithCapacity:_pubs.count];
    os_unfair_lock_lock(&_lock);
    [_subscribers addObject:unit];
    os_unfair_lock_unlock(&_lock);
    MGRPubStreamBlock stream = _prototype(_pubs.count, unit.storage, listener.stream);
    for (NSUInteger idx = 0; idx < _pubs.count; idx++) {
        [unit.storage addObject:[[MGRPubHubTokenObject alloc] init]];
        [_pubs[idx] inner:listener.group queue:listener.queue storage:unit.storage at:idx process:stream];
    }
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    // 줄기 토큰 취소
    if (!listener) {return;}
    os_unfair_lock_lock(&_lock);
    for (NSUInteger idx = 0; idx < _subscribers.count; idx++) {
        MGRPubHubUnit *unit = [_subscribers objectAtIndex:idx];
        if (unit.token == listener) {
            [_subscribers removeObjectAtIndex:idx];
            os_unfair_lock_unlock(&_lock); return;
        }
    }
    os_unfair_lock_unlock(&_lock);
}
@end
