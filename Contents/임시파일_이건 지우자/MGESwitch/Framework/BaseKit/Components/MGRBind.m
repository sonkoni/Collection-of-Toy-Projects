//
//  MGRBind.m
//

#import "MGRBind.h"
#import <os/lock.h>

#if DEBUG && MGRPUB_DEBUG
#define BIND_DEBUG_LINE              MGR_DEBUG_LINE
#else
#define BIND_DEBUG_LINE
#endif

@implementation MGRBind {
    os_unfair_lock _lock;
    id _data;
    NSMutableArray<void(^)(id)> * _actions;
}
@dynamic value;
+ (instancetype)bind {
    return [[[self class] alloc] init];
}
+ (instancetype)bind:(id)initial {
    return [[[self class] alloc] initWithInitial:initial];
}
- (void)dealloc {BIND_DEBUG_LINE;}
- (instancetype)initWithInitial:(id)initial {
    self = [super init];
    if (self) {_lock = OS_UNFAIR_LOCK_INIT; _data = initial;}
    return self;
}
- (instancetype)init {
    return [self initWithInitial:nil];
}
- (void)setValue:(id)value {
    if (!value) {return;}
    os_unfair_lock_lock(&_lock);
    NSArray *copiedActions = [_actions count] ? [_actions copy] : nil;
    _data = value;
    os_unfair_lock_unlock(&_lock);
    for (void(^action)(id) in copiedActions) {
        action(value);
    }
}
- (id)value {
    os_unfair_lock_lock(&_lock);
    id value = _data;
    os_unfair_lock_unlock(&_lock);
    return value;
}
- (void)addAction:(void(^)(id))action isNow:(BOOL)isNow {
    os_unfair_lock_lock(&_lock);
    if (!_actions) {_actions = [NSMutableArray array];}
    [_actions addObject:action];
    id data = _data;
    os_unfair_lock_unlock(&_lock);
    if (isNow && data) {action(data);}
}
- (void)removeAction:(void(^)(id))action {
    if (!action) {return;}
    os_unfair_lock_lock(&_lock);
    [_actions removeObject:action];
    os_unfair_lock_unlock(&_lock);
}
// Sink
- (void)isNow:(BOOL)isNow bind:(id)owner sink:(void(^)(id))work {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(owner) weakOwner = owner;
    __weak __block void (^weakAction)(id);
    void (^action)(id);
    weakAction = action = ^(id value) {
        if (!weakOwner) {[weakSelf removeAction:weakAction]; return;}
        work(value);
    };
    [self addAction:action isNow:isNow];
}
- (void)bind:(id)owner sink:(void (^)(id _Nonnull))work {
    [self isNow:NO bind:owner sink:work];
}
- (void)bindNow:(id)owner sink:(void (^)(id _Nonnull))work {
    [self isNow:YES bind:owner sink:work];
}
- (void)isNow:(BOOL)isNow mainBind:(id)owner sink:(void(^)(id))work {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(owner) weakOwner = owner;
    __weak __block void (^weakAction)(id);
    void (^action)(id);
    weakAction = action = ^(id value) {
        if (!weakOwner) {[weakSelf removeAction:weakAction]; return;}
        dispatch_async(dispatch_get_main_queue(), ^{work(value);});
    };
    [self addAction:action isNow:isNow];
}
- (void)mainBind:(id)owner sink:(void (^)(id _Nonnull))work {
    [self isNow:NO mainBind:owner sink:work];
}
- (void)mainBindNow:(id)owner sink:(void (^)(id _Nonnull))work {
    [self isNow:YES mainBind:owner sink:work];
}
// Keypath
- (void)isNow:(BOOL)isNow  mainBind:(id)owner keypath:(NSString *)keypath {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(owner) weakOwner = owner;
    __weak __block void (^weakAction)(id);
    void (^action)(id);
    weakAction = action = ^(id value) {
        if (!weakOwner) {[weakSelf removeAction:weakAction]; return;}
        dispatch_async(dispatch_get_main_queue(), ^{[weakOwner setValue:value forKeyPath:keypath];});
    };
    [self addAction:action isNow:isNow];
}
- (void)mainBind:(id)owner keypath:(NSString *)keypath {
    [self isNow:NO mainBind:owner keypath:keypath];
}
- (void)mainBindNow:(id)owner keypath:(NSString *)keypath {
    [self isNow:YES mainBind:owner keypath:keypath];
}
// Selector
- (void)isNow:(BOOL)isNow mainBind:(id)owner selector:(SEL)selector {
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(owner) weakOwner = owner;
    __weak __block void (^weakAction)(id);
    IMP impPtr = [owner methodForSelector:selector];
    void (*setObject)(id, SEL, id) = (void (*)(id, SEL, id))impPtr;
    void (^action)(id);
    weakAction = action = ^(id value) {
        if (!weakOwner) {[weakSelf removeAction:weakAction]; return;}
        dispatch_async(dispatch_get_main_queue(), ^{setObject(weakOwner, selector, value);});
    };
    [self addAction:action isNow:isNow];
    // (!참고!)
    //   IMP impPtr = [weakOwner methodForSelector:selector];
    //   void (*setObject)(id, SEL, id) = (void (*)(id, SEL, id))impPtr;
    //   setObject(weakOwner, selector, value);
    // 셀렉터 관련하여, objc.h 헤더에 다음이 정의되어 있다.
    //   typedef struct objc_selector  *SEL; // 메서드를 가리키는 구조체 별칭
    // 실제 사용은 IMP 로 캐스팅하게 된다.
    //   SEL aSel = @selector(sampleMethod); // 실제 사용
    //   typedef id (*IMP)(id self,SEL _cmd,...); // 캐스팅.
    // IMP는 id를 리턴하고 (타겟, 셀렉터명령, 인자)를 받는 함수 포인터를 typedef한 것이다.
    // 사실 objc 메서드는 컴파일 하면 c 함수로 트랜스폼 된다.
    //   - (int) doComputeWithNum:(int)aNum; // 이 메서드는 컴파일 하면
    //   int aClass_doComputeWithNum(aClass *self,SEL _cmd,int aNum); // 이렇게 바뀐다.
    // 이는 다음 처럼 접근 가능하며
    // methodForSelector is COCOA & not ObjC Runtime
    // gets the same function pointer objc_msgSend gets
    //    computeNum = (int (*)(id,SEL,int))[target methodForSelector:@selector(doComputeWithNum:)];
    // 아래와 같이 실행시킬 수도 있는 것이다.
    // execute the C function pointer returned by the runtime
    //    computeNum(obj, @selector(doComputeWithNum:), aNum);
    //
}
- (void)mainBind:(id)owner selector:(SEL)selector {
    [self isNow:NO mainBind:owner selector:selector];
}
- (void)mainBindNow:(id)owner selector:(SEL)selector {
    [self isNow:YES mainBind:owner selector:selector];
}
@end


#pragma mark - Pub
@interface __MGRBindPub<__covariant ObjectType> : MGRBind
@property (nonatomic) NSMutableSet *storage;
@end
@implementation __MGRBindPub
@end

@implementation MGRPub (Bind)
- (MGRBind *)bind {
    __MGRBindPub *bind = [__MGRBindPub bind];
    bind.storage = [NSMutableSet set];
    MGRPubInnerToken *token = [[MGRPubInnerToken alloc] initWithGroup:nil];
    token.queueType = self.queueType;
    __weak MGRPubInnerToken *weakToken = token;
    __weak __MGRBindPub *weakBind = bind;
    __block BOOL _isFail = NO;
    dispatch_queue_t _queue = token.queue ? token.queue : dispatch_get_main_queue();
    token.stream = ^(id  _Nullable data) {
        dispatch_async(_queue, ^{
            if (_isFail) {return;}
            if (!data || (_isFail = [data isKindOfClass:[NSError class]])) {[weakToken cancel];}
            if (data) {[weakBind setValue:data];}
        });
    };
    token.storage = bind.storage;
    [self subscribe:token];
    return bind;
}
- (MGRBind *)mainBind {
    __MGRBindPub *bind = [__MGRBindPub bind];
    bind.storage = [NSMutableSet set];
    MGRPubInnerToken *token = [[MGRPubInnerToken alloc] initWithGroup:nil];
    token.queueType = self.queueType;
    __weak MGRPubInnerToken *weakToken = token;
    __weak __MGRBindPub *weakBind = bind;
    __block BOOL _isFail = NO;
    token.stream = ^(id  _Nullable data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isFail) {return;}
            if (!data || (_isFail = [data isKindOfClass:[NSError class]])) {[weakToken cancel];}
            if (data) {[weakBind setValue:data];}
        });
    };
    token.storage = bind.storage;
    [self subscribe:token];
    return bind;
}
@end
