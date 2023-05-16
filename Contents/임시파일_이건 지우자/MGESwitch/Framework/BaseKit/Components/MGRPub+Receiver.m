//
//  MGRPub+Receiver.m
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

#pragma mark - Resolver
MGRPubStreamBlock MGRPubResolver(dispatch_group_t _Nullable group, dispatch_queue_t _Nullable queue, MGRPubStreamBlock next) {
    __block id _store;
    return ^(id _Nullable data) {
        if ([data isKindOfClass:[MGRPub class]]) {
            if (!_store) {_store = [NSMutableSet set];}
            [(MGRPub *)data inner:group queue:queue storage:_store next:next];
        } else {
            next(data);
        }
    };
}


// Token cancel 시 채울 빈 스트림
static MGRPubStreamBlock EmptySteam = ^(id value){};  // Global block



#pragma mark - Hub TokenObject
@implementation MGRPubHubTokenObject
- (instancetype)init {
    return [self initWith:(MGRPubToken *)[NSNull null]]; // don 감지를 위해 첫 항목에 NSNull 을 꽂고 간다.
}
- (instancetype)initWith:(MGRPubToken *)token {
    self = [super init];
    if (self) {_token = token;}
    return self;
}
- (void)cancel {
    [_token cancel];
    _token = nil;
}
@end

@implementation MGRPubHubUnit
@end



#pragma mark - Share
@interface MGRPubShare ()
@property (nonatomic, nullable) id value;
@property (nonatomic, nullable) NSHashTable<id<MGRPubReceiving>> * subscribers;
@end
@implementation MGRPubShare
- (void)dealloc {
    PUB_DEBUG_LINE;
    [_pub unsubscribe:self];
}
- (instancetype)initFrom:(MGRPub *)pub queue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _pub = pub;
        _queue = queue;
        __weak __typeof(self) weakSelf = self;
        _stream = ^(id _Nullable data){
            if (data) {weakSelf.value = data;}
            NSArray *listeners = [weakSelf.subscribers allObjects];
            for (id<MGRPubReceiving> listener in listeners) {
                [listener setData:data];
            }
        };
    }
    return self;
}
- (dispatch_group_t)group {return nil;}
- (void)setData:(id _Nullable)data {
    // 큐는 반드시 있다. 시리얼큐이다.
    MGRPubStreamBlock stream = _stream;
    dispatch_async(_queue, ^{stream(data);});
    if (!data || [data isKindOfClass:[NSError class]]) {
        dispatch_async(_queue, ^{
            self.subscribers = nil;
            self.value = nil;
        });
    }
}
- (void)subscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:self];
    dispatch_async(_queue, ^{
        if (!self.subscribers) {
            self.subscribers = [NSHashTable weakObjectsHashTable];
            [self.pub subscribe:self];
        }
        [self.subscribers addObject:listener];
        if (self.value) {[listener setData:self.value];}
    });
}
- (void)unsubscribe:(id<MGRPubReceiving>)listener {
    if (!listener) {return;}
    [listener setPub:nil];
    dispatch_async(_queue, ^{
        [self.subscribers removeObject:listener];
        if (!self.subscribers.allObjects.count) {
            self.subscribers = nil;
            self.value = nil;
        }
    });
}
@end



#pragma mark - Token
@implementation MGRPubToken
- (void)dealloc {
    MGR_DEBUG_LINE;  // 이건 중요하니까 나오게 한다.
    [_pub unsubscribe:self];
    if (!_group) {return;}
    dispatch_queue_t queue = _queue ? _queue : dispatch_get_main_queue();
    dispatch_group_t group = _group;
    dispatch_async(queue, ^{dispatch_group_leave(group);});
}
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group {
    self = [super init];
    if (self) {
        _group = group;
        if (group) {dispatch_group_enter(group);}
    }
    return self;
}
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t)queue {
    self = [self initWithGroup:group];
    if (self) {_queue = queue;}
    return self;
}
- (void)cancel {
    [_pub unsubscribe:self];
    _stream = EmptySteam;  // unsubscribe 이후 연속적인 값 할당 시 안전하게.
    if (!_group) {return;}
    dispatch_queue_t queue = _queue ? _queue : dispatch_get_main_queue();
    dispatch_group_t group = _group; _group = nil;
    dispatch_async(queue, ^{dispatch_group_leave(group);});
}
- (void)setData:(id _Nullable)data {
    if (!_queue) {_stream(data); return;}
    MGRPubStreamBlock stream = _stream;
    // dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_async(_queue, ^{
        stream(data);
        // dispatch_semaphore_signal([MGRPub sema]);
    });
}
- (void)setQueueType:(MGRPubQueue)queueType {
    if (_queue || !queueType) {return;}
    _queueType = queueType;
    _queue = [MGRPub queue:queueType];
}
@end



#pragma mark - InnerToken
@implementation MGRPubInnerToken
- (void)cancel {
    [super cancel];
    [_storage removeObject:self];
}
- (void)setStorage:(NSMutableSet *)storage {
    // pub 존재 여부에 상관없이 리테인된다.
    if (!_storage) {_storage = storage;}
    [storage addObject:self];
}
@end



#pragma mark - HubToken
@implementation MGRPubHubToken {
    NSUInteger _idx;
}
- (instancetype)initWithGroup:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t)queue at:(NSUInteger)idx {
    self = [super initWithGroup:group queue:queue];
    if (self) {_idx = idx;}
    return self;
}
- (void)cancel {
    [super cancel];
    [[_storage objectAtIndex:_idx] setToken:nil];
}
- (void)setStorage:(NSMutableArray<MGRPubHubTokenObject *> *)storage {
    // pub 존재 여부에 상관없이 리테인된다.
    if (!_storage) {_storage = storage;}
    if ([self queue]) {[[_storage objectAtIndex:_idx] setToken:self]; return;}
    NSUInteger idx = _idx;
    dispatch_async(dispatch_get_main_queue(), ^{[[storage objectAtIndex:idx] setToken:self];});
}
@end



#pragma mark - Ticket
@implementation MGRPubTicket
- (instancetype)initWithGroup:(dispatch_group_t)group type:(MGRPubQueue)queueType {
    self = [self initWithGroup:group];
    if (self) {[self setQueueType:queueType];}
    return self;
}
- (void)cancel {
    [super cancel];
    dispatch_async(dispatch_get_main_queue(), ^{[self.storage removeObject:self];});
}
- (void)setStorage:(NSMutableSet *)storage {
    NSAssert(!_storage || (_storage && (_storage == storage)), @"Don't Change the Store !!!"); // 바꾸지 마
    if (!_storage) {_storage = storage;}
    if (!self.pub) {return;}
    dispatch_async(dispatch_get_main_queue(), ^{[storage addObject:self];});
}
- (void (^)(id  _Nullable __strong * _Nullable))storeIn {
    return ^(id _Nullable __strong *_Nullable storagePtr) {
        if (!self.stream || !self.pub || self->_storage) {return;}
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!*storagePtr || ![*storagePtr isKindOfClass:[NSMutableSet class]]) {
                *storagePtr = [NSMutableSet set];
            }
            self->_storage = *storagePtr;
            [*storagePtr addObject:self];
        });
    };
}
@end



#pragma mark - Inner
@implementation MGRPub (Inner)
- (void)inner:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t _Nullable)queue storage:(NSMutableSet *)storage next:(MGRPubStreamBlock)next {
    MGRPubInnerToken *token = [[MGRPubInnerToken alloc] initWithGroup:group queue:queue];
    token.queueType = self.queueType;
    __weak MGRPubInnerToken *weakToken = token;
    __block BOOL _isFail = NO;
    dispatch_queue_t _queue = queue ? queue : dispatch_get_main_queue();
    token.stream = ^(id  _Nullable data) {
        dispatch_async(_queue, ^{
            if (_isFail) {return;}
            if (!data || (_isFail = [data isKindOfClass:[NSError class]])) {[weakToken cancel];}
            if (data) {next(data);}
        });
    };
    token.storage = storage; // pub 존재 여부에 상관없이 리테인된다.
    [self subscribe:token];
}
- (void)inner:(dispatch_group_t _Nullable)group queue:(dispatch_queue_t _Nullable)queue storage:(NSMutableArray *)storage at:(NSUInteger)idx process:(MGRPubStreamBlock)process {
    MGRPubHubToken *token = [[MGRPubHubToken alloc] initWithGroup:group queue:queue at:idx];
    token.queueType = self.queueType;
    __weak MGRPubHubToken *weakToken = token;
    __block BOOL _isFail = NO;
    dispatch_queue_t _queue = queue ? queue : dispatch_get_main_queue();
    token.stream = ^(id  _Nullable data) {
        dispatch_async(_queue, ^{
            if (_isFail) {return;}
            if (!data || (_isFail = [data isKindOfClass:[NSError class]])) {[weakToken cancel];}
            process([MGRTagObject tag:idx object:data]);
        });
    };
    token.storage = storage; // pub 존재 여부에 상관없이 리테인된다.
    [self subscribe:token];
}
@end



#pragma mark - Sink
@implementation MGRPub (Sink)
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock _Nullable)failure finish:(MGRPubFinishBlock)finish isMain:(BOOL)isMain {
    NSParameterAssert(success);
    NSParameterAssert(finish);
    dispatch_group_t group = dispatch_group_create();
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:group type:self.queueType];
    __weak MGRPubTicket *weakToken = token;
    __block BOOL _isFail = NO;
    __block BOOL _isFinish = NO;
    // 최종스트림
    MGRPubStreamBlock stream = ^(id _Nullable value) {
        if (_isFail) {return;} // Error 처리되면 나머지를 기다리지 않는다.
        if (!value && !_isFinish) { // 이미 nil 과 Error 를 받았으면 더 이상 nil을 받지 않는다.
            _isFinish = YES; [weakToken cancel];
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (!_isFail) {finish();} // nil 받고 finish 를 기다리는 동안 error 를 받으면 무시된다.
            });
        } else if ([value isKindOfClass:[NSError class]]) {
            _isFail = YES; [weakToken cancel];
            if (failure) {failure(value);}
        } else if (value) {
            success(value);
        }
    };
    // isMain 면 async main 래핑하고, 토큰이 라인큐를 지정하지 않았다는 것은 시리얼이 아닐 수도 있다는 뜻이므로 이 경우도 래핑한다.
    token.stream = (!isMain && token.queue) ? stream : ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{stream(value);});
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock _Nullable)failure isMain:(BOOL)isMain {
    NSParameterAssert(success);
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:nil type:self.queueType];
    __weak MGRPubTicket *weakToken = token;
    __block BOOL _isFail = NO;
    // 최종스트림
    MGRPubStreamBlock stream = ^(id _Nullable value) {
        if (_isFail) {return;} // Error 처리되면 나머지를 기다리지 않는다.
        if (!value || (_isFail = [value isKindOfClass:[NSError class]])) {
            [weakToken cancel];
            if (_isFail && failure) {failure(value);}
        } else {
            success(value);
        }
    };
    // isMain 면 async main 래핑하고, 토큰이 라인큐를 지정하지 않았다는 것은 시리얼이 아닐 수도 있다는 뜻이므로 이 경우도 래핑한다.
    token.stream = (!isMain && token.queue) ? stream : ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{stream(value);});
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success {
    return [self sink:success failure:nil isMain:NO];
}
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success finish:(MGRPubFinishBlock)finish {
    return [self sink:success failure:nil finish:finish isMain:NO];
}
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure {
    return [self sink:success failure:failure isMain:NO];
}
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish {
    return [self sink:success failure:failure finish:finish isMain:NO];
}
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success {
    return [self sink:success failure:nil isMain:YES];
}
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success finish:(MGRPubFinishBlock)finish {
    return [self sink:success failure:nil finish:finish isMain:YES];
}
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure {
    return [self sink:success failure:failure isMain:YES];
}
- (MGRPubTicket *)mainSink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish {
    return [self sink:success failure:failure finish:finish isMain:YES];
}
@end


#pragma mark - Assign
@implementation MGRPub (Assign)
- (MGRPubTicket *)owner:(id)owner mainAssign:(MGRPubSuccessBlock)success finish:(MGRPubFinishBlock)finish {
    NSParameterAssert(owner);
    NSParameterAssert(success);
    NSParameterAssert(finish);
    __weak __typeof(owner) weakOwner = owner;
    dispatch_group_t group = dispatch_group_create();
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:group type:self.queueType];
    __weak MGRPubTicket *weakToken = token;
    __block BOOL _isFail = NO;
    __block BOOL _isFinish = NO;
    // 최종스트림
    token.stream = ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isFail) {return;}
            if (!value && !_isFinish) {
                _isFinish = YES; [weakToken cancel];
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    if (!_isFail) {finish();}
                });
            } else if (!weakOwner || [value isKindOfClass:[NSError class]]) {
                _isFail = YES; [weakToken cancel];
            } else if (value) {
                success(value);
            }
        });
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
- (MGRPubTicket *)owner:(id)owner mainAssign:(MGRPubSuccessBlock)success {
    NSParameterAssert(owner);
    NSParameterAssert(success);
    __weak __typeof(owner) weakOwner = owner;
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:nil type:self.queueType];
    __weak MGRPubTicket *weakToken = token;
    __block BOOL _isFail = NO;
    // 최종스트림
    token.stream = ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isFail) {return;}
            if (!value || (_isFail = (!weakOwner || [value isKindOfClass:[NSError class]]))) {
                [weakToken cancel];
            } else {
                success(value);
            }
        });
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
- (MGRPubTicket *)mainAssign:(id)owner keypath:(NSString *)keypath {
    __weak __typeof(owner) weakOwner = owner;
    return [self owner:owner mainAssign:^(id  _Nonnull value) {
        [weakOwner setValue:value forKeyPath:keypath]; // KVC
    }];
}
- (MGRPubTicket *)mainAssign:(id)owner keypath:(NSString *)keypath finish:(MGRPubFinishBlock)finish {
    __weak __typeof(owner) weakOwner = owner;
    return [self owner:owner mainAssign:^(id  _Nonnull value) {
        [weakOwner setValue:value forKeyPath:keypath]; // KVC
    } finish:finish];
}
- (MGRPubTicket *)mainAssign:(id)owner selector:(SEL)selector {
    __weak __typeof(owner) weakOwner = owner;
    IMP impPtr = [owner methodForSelector:selector];
    void (*setObject)(id, SEL, id) = (void (*)(id, SEL, id))impPtr;
    return [self owner:owner mainAssign:^(id  _Nonnull value) {
        setObject(weakOwner, selector, value);
    }];
}
- (MGRPubTicket *)mainAssign:(id)owner selector:(SEL)selector finish:(MGRPubFinishBlock)finish {
    __weak __typeof(owner) weakOwner = owner;
    IMP impPtr = [owner methodForSelector:selector];
    void (*setObject)(id, SEL, id) = (void (*)(id, SEL, id))impPtr;
    return [self owner:owner mainAssign:^(id  _Nonnull value) {
        setObject(weakOwner, selector, value);
    } finish:finish];
}
@end





/*
// 성공코드 : 분할 전
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish {
    dispatch_group_t group = dispatch_group_create();
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:group type:self.queueType];
    __weak MGRPubTicket *weakToken = token;
    __block BOOL _isFail = NO;
    __block BOOL _isFinish = NO;
    // 최종스트림
    MGRPubStreamBlock stream = ^(id _Nullable value) {
        if (_isFail) {return;} // Error 처리되면 나머지를 기다리지 않는다.
        if (!value && !_isFinish) { // 이미 nil 과 Error 를 받았으면 더 이상 nil을 받지 않는다.
            _isFinish = YES; [weakToken cancel];
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (finish && !_isFail) {finish();} // nil 받고 finish 를 기다리는 동안 error 를 받으면 무시된다.
            });
        } else if ([value isKindOfClass:[NSError class]]) {
            _isFail = YES; [weakToken cancel];
            if (failure) {failure(value);}
        } else if (value) {
            success(value);
        }
    };
    // 라인큐를 지정하지 않았다는 것은 시리얼이 아닐 수도 있다는 뜻이다. 따라서 메인큐로 잡아준다.
    token.stream = token.queue ? stream : ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{stream(value);});
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
*/

/*
// 실패코드 : MGRPubJointToken cancel : 이러면 익덱스 삭제에 한 템포 늦게 된다. cancel 를 때리는 시점은 이미 async 된 이후이다.
- (void)cancel {
    [super cancel];
    if ([self queue]) {[[_storage objectAtIndex:_idx] setToken:nil]; return;}
    NSMutableArray *storage = _storage; NSUInteger idx = _idx;
    dispatch_async(dispatch_get_main_queue(), ^{[[storage objectAtIndex:idx] setToken:nil];});
}
*/

/*
// 실패코드 : 다 좋은데, 내부 퍼브에서 송출하는 nil 과 error 를 여러 개 받는다.
- (MGRPubTicket *)sink:(MGRPubSuccessBlock)success failure:(MGRPubFailureBlock)failure finish:(MGRPubFinishBlock)finish {
    dispatch_group_t group = dispatch_group_create();
    MGRPubTicket *token = [[MGRPubTicket alloc] initWithGroup:group type:self.queueType];
    __block __weak MGRPubTicket *weakToken = token;
    __block MGRPubStreamBlock retainedStream = nil;
    MGRPubStreamBlock stream = ^(id _Nullable value) {
        if (!value) {
            retainedStream = weakToken.stream;  // finish 할 때 token 이 먼저 죽지만 stream 은 살아있어야 한다
            [weakToken cancel]; weakToken = nil;
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (finish && retainedStream){finish();}  // retainedStream 이 없으면 실행 안한다.
                retainedStream = nil;  // fihish 후 쌍방 retainedStream 죽임
            });
        } else if ([value isKindOfClass:[NSError class]]) {
            retainedStream = nil;  // finish 대기 상태에서 error 를 받으면 finish 가 아니라 error 로 처리됨
            [weakToken cancel]; weakToken = nil;  // 그룹알림이 쳐도 retainedStream 이 없으므로 finish가 무시된다.
            if (failure) {failure(value);}
        } else {
            success(value);
        }
    };
    // 시리얼큐만 허용하므로, 라인큐를 지정하지 않았다는 것은 시리얼이 아닐 수도 있다는 뜻이다. 따라서 메인큐로 잡아준다.
    token.stream = token.queue ? stream : ^(id _Nullable value) {
        dispatch_async(dispatch_get_main_queue(), ^{stream(value);});
    };
    // 상부로 치고 올라가며 스트림을 모은 뒤 반환.
    [self subscribe:token];
    return token;
}
*/
