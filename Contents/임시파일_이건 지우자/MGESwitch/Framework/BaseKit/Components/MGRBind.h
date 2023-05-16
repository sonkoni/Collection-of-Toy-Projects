//
//  MGRBind.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-28
//  ----------------------------------------------------------------------
//  값 바인딩. Thread-Safe 하다.

#ifndef MGRBind_h
#define MGRBind_h
#import <BaseKit/MGRPub.h>

// ----------------------------------------------------------------------
// MGR_BIND
// 단일 바인딩 선언 : interface 에서 작성
#define MGR_BIND(TYPE, name)                            \
(nonatomic) TYPE name;                                  \
- (void)name##Bind:(void(^)(TYPE value))action;         \
@property (nonatomic, nullable, readonly) void (^name##Action)(TYPE value); \

// 단일 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BIND_SETTER(TYPE, name, Name, ...)          \
- (void)set##Name:(TYPE)name {                          \
    _##name = name;                                     \
    if (_##name##Action) {_##name##Action(name);}       \
    __VA_ARGS__;                                        \
}                                                       \
- (void)name##Bind:(void (^)(TYPE value))action {       \
    _##name##Action = ^(TYPE value){                    \
        dispatch_async(dispatch_get_main_queue(), ^{action(value);}); \
    };                                                  \
    _##name##Action(_##name);                           \
}


// ----------------------------------------------------------------------
// MGR_BINDS
// 다중 바인딩 선언 : interface 에서 작성
#define MGR_BINDS(TYPE, name)                           \
(nonatomic) TYPE name;                                  \
- (void)name##Bind:(void(^)(TYPE value))action;         \
@property (nonatomic) MGRBind * name##Actions;          \

// 객체형 다중 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BINDS_SETTER(TYPE, name, Name, ...)         \
@synthesize name##Actions = _##name##Actions;           \
@dynamic name;                                          \
- (MGRBind *)name##Actions {                            \
    if (_##name##Actions) {return _##name##Actions;}    \
    MGRBind *actions = [MGRBind bind];                  \
    return _##name##Actions = actions;                  \
}                                                       \
- (void)set##Name:(TYPE)name {                          \
    [self.name##Actions setValue:name];                 \
    __VA_ARGS__;                                        \
}                                                       \
- (TYPE)name {                                          \
    return [self.name##Actions value];                  \
}                                                       \
- (void)name##Bind:(void (^)(TYPE value))action {       \
    [self.name##Actions mainBindNow:self sink:action];  \
}                                                       \

// 스칼라 다중 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BINDS_SETTER_SCALAR(UNBOX, TYPE, name, Name, ...)    \
@synthesize name##Actions = _##name##Actions;           \
@dynamic name;                                          \
- (MGRBind *)name##Actions {                            \
    if (_##name##Actions) {return _##name##Actions;}    \
    MGRBind *actions = [MGRBind bind];                  \
    return _##name##Actions = actions;                  \
}                                                       \
- (void)set##Name:(TYPE)name {                          \
    [self.name##Actions setValue:@(name)];              \
    __VA_ARGS__;                                        \
}                                                       \
- (TYPE)name {                                          \
    return [[self.name##Actions value] UNBOX];          \
}                                                       \
- (void)name##Bind:(void (^)(TYPE value))action {       \
    [self.name##Actions mainBindNow:self sink:^(NSNumber *valueObj) { \
        action([valueObj UNBOX]);                       \
    }];                                                 \
}                                                       \


// ----------------------------------------------------------------------


NS_ASSUME_NONNULL_BEGIN

@interface MGRBind<__covariant ObjectType> : NSObject
@property (nonatomic, nullable) ObjectType value;
+ (instancetype)bind;
+ (instancetype)bind:(ObjectType _Nonnull)initial;
/* Sink */
- (void)bind:(id)owner sink:(void(^)(ObjectType value))work;
- (void)bindNow:(id)owner sink:(void(^)(ObjectType value))work;
/* async Sink */
- (void)mainBind:(id)owner sink:(void(^)(ObjectType value))work;
- (void)mainBindNow:(id)owner sink:(void(^)(ObjectType value))work;
/* async Keypath */
- (void)mainBind:(id)owner keypath:(NSString *)keypath;
- (void)mainBindNow:(id)owner keypath:(NSString *)keypath;
/* async Selector */
- (void)mainBind:(id)owner selector:(SEL)selector;
- (void)mainBindNow:(id)owner selector:(SEL)selector;
@end


@interface MGRPub<ObjectType> (Bind)
- (MGRBind<ObjectType> *)bind;
- (MGRBind<ObjectType> *)mainBind;
@end

NS_ASSUME_NONNULL_END
#endif /* MGRBind_h */


