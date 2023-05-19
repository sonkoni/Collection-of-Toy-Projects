//
//  MGRBind.h
//  ----------------------------------------------------------------------
//  VERSION_DATE    2022-12-28
//  ----------------------------------------------------------------------
//  스토리지를 미리 지정하고 리턴하는 Pub 이다.
//  - MGRBind 로 리턴한다는 것은 bind 계열 메서드를 사용해도 안전하다는 뜻이다.
//  - 만약 MGRBind 로 리턴하지 않는데 bind 계열 메서드를 사용하면 터지게 했다.
//    Objc 제네릭의 한계로 MGRBind 하위 파이프가 아닌 것에 대해 자동완성을 막을 수 없다.
//

#import <BaseKit/MGRPub.h>
NS_ASSUME_NONNULL_BEGIN
// MGRPub 의 Pipe 이며, bind 계열의 반환값으로 나오는 타입을 표시하기 위함이다.
@interface MGRBind<__covariant ObjectType> : MGRPub<ObjectType>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
// 스트림 끝단 : 성공값만 받는다
@interface MGRPub<ObjectType> (Bind)
- (MGRBind<ObjectType> * (^)(id  _Nullable __strong * _Nullable))storeIn;
- (void)bind:(id)owner action:(MGRPubSuccessBlock)success;
- (void)bindMain:(id)owner action:(MGRPubSuccessBlock)success;
- (void)bindMain:(id)owner keypath:(NSString *)keypath;
- (void)bindMain:(id)owner selector:(SEL)selector;
@end
NS_ASSUME_NONNULL_END




// DEPRECATED
// ----------------------------------------------------------------------
NS_ASSUME_NONNULL_BEGIN
@interface MGRReact<__covariant ObjectType> : NSObject
@property (nonatomic, nullable) ObjectType value;
+ (instancetype)bind;
+ (instancetype)bind:(ObjectType _Nonnull)initial;
/* Sink Action */
- (void)bind:(id)owner action:(void(^)(ObjectType value))action;
- (void)bindNow:(id)owner action:(void(^)(ObjectType value))action;
/* Sink Main Action */
- (void)bindMain:(id)owner action:(void(^)(ObjectType value))action;
- (void)bindMainNow:(id)owner action:(void(^)(ObjectType value))action;
/* Sink Main Keypath */
- (void)bindMain:(id)owner keypath:(NSString *)keypath;
- (void)bindMainNow:(id)owner keypath:(NSString *)keypath;
/* Sink Main Selector */
- (void)bindMain:(id)owner selector:(SEL)selector;
- (void)bindMainNow:(id)owner selector:(SEL)selector;
@end
NS_ASSUME_NONNULL_END

/*
#ifndef MGRBind_h
#define MGRBind_h

// MGR_BIND - 완전히 접합되는 형태로, 취소할 수 없다.
// 객체와 바인딩이 완전히 생사를 함께하는 경우에 사용한다. 때문에 바인딩 내부에 별도의 제거 코드가 없다.
// 바인딩 선언 : interface 에서 작성
#define MGR_BIND(TYPE, name)                            \
(nonatomic) TYPE name;                                  \
- (void)name##Bind:(void(^)(TYPE value))action;         \
@property (nonatomic, nullable, readonly) void (^name##React)(TYPE value); \

// 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BIND_SETTER(TYPE, name, Name, ...)          \
- (void)set##Name:(TYPE)name {                          \
    _##name = name;                                     \
    if (_##name##React) {_##name##React(name);}         \
    __VA_ARGS__;                                        \
}                                                       \
- (void)name##Bind:(void (^)(TYPE value))action {       \
    void(^_prev)(TYPE) = _##name##React;                \
    _##name##React = ^(TYPE value){                     \
        if (_prev){_prev(value);}                       \
        dispatch_async(dispatch_get_main_queue(), ^{action(value);});  \
    };                                                  \
    TYPE value = _##name;                               \
    dispatch_async(dispatch_get_main_queue(), ^{action(value);});      \
}


// ----------------------------------------------------------------------
// MGR_BINDS - 오너를 지정하는 형태로, weak 처리된다.
// 죽을 수 있는 여러 객체가 하나의 바인딩에 접합될 때 사용한다. 객체가 죽을 때 바인딩 블락도 함께 제거된다.
// 바인딩 선언 : interface 에서 작성
#define MGR_BINDS(TYPE, name)                           \
(nonatomic) TYPE name;                                  \
- (void)name##Bind:(id)owner action:(void(^)(TYPE value))action; \
@property (nonatomic) MGRReact * name##React;           \

// 오브젝트 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BINDS_SETTER(TYPE, name, Name, ...)         \
@synthesize name##React = _##name##React;               \
@dynamic name;                                          \
- (MGRReact *)name##React {                             \
    if (_##name##React) {return _##name##React;}        \
    MGRReact *actions = [MGRReact bind];                \
    return _##name##React = actions;                    \
}                                                       \
- (void)set##Name:(TYPE)name {                          \
    [self.name##React setValue:name];                   \
    __VA_ARGS__;                                        \
}                                                       \
- (TYPE)name {                                          \
    return [self.name##React value];                    \
}                                                       \
- (void)name##Bind:(id)owner action:(void(^)(TYPE value))action {  \
    [self.name##React bindMainNow:owner action:action]; \
}

// 스칼라 바인딩 구현 : implementation 에서 작성 ... 은 {}로 싸서 사용하는 후속처리 옵션.
#define MGR_BINDS_SETTER_SCALAR(UNBOX, TYPE, name, Name, ...)    \
@synthesize name##React = _##name##React;               \
@dynamic name;                                          \
- (MGRReact *)name##React {                             \
    if (_##name##React) {return _##name##React;}        \
    MGRReact *actions = [MGRReact bind];                \
    return _##name##React = actions;                    \
}                                                       \
- (void)set##Name:(TYPE)name {                          \
    [self.name##React setValue:@(name)];                \
    __VA_ARGS__;                                        \
}                                                       \
- (TYPE)name {                                          \
    return [[self.name##React value] UNBOX];            \
}                                                       \
- (void)name##Bind:(id)owner action:(void(^)(TYPE value))action {      \
    [self.name##React bindMainNow:owner action:^(NSNumber *valueObj) { \
        action([valueObj UNBOX]);                       \
    }];                                                 \
}

#endif
*/
