//
//  MGRDelegateProxy.m
//  Copyright © 2020 Mulgrim Co. All rights reserved.
//

#import "MGRDelegateProxy.h"

@implementation MGRDelegateProxy {
    Protocol * _protocol;   // assign !!! 어싸인이라고
    __weak id _agent;       // weak
}
+ (instancetype)proxy:(Protocol *)protocol to:(id)agent {
    return [[self alloc] initWithProtocol:protocol agent:agent];
}
- (instancetype)initWithProtocol:(Protocol *)protocol agent:(id)agent {
    if (self) {
        _protocol = protocol;
        if ([agent conformsToProtocol:protocol]) {
            _agent = agent;
        } else {
            NSException *exception = [NSException exceptionWithName:@"Agent Protocol Error" reason:@"agent doesn't conform to protocol." userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
- (void)setDelegate:(id _Nullable)delegate {
    if ([delegate conformsToProtocol:_protocol]) {
        _delegate = delegate;
    } else if (delegate) {
        NSException *exception = [NSException exceptionWithName:@"Delegate Protocol Error" reason:@"delegate doesn't conform to protocol." userInfo:nil];
        @throw exception;
    } else {
        _delegate = nil;
    }
}

#pragma mark - Public Require

// 메서드 있는지 반응 여부. 시스템이 체크하며, 사용자가 수동으로 때리기도 한다.
- (BOOL)respondsToSelector:(SEL)aSelector {
    return ([_delegate respondsToSelector:aSelector] || [_agent respondsToSelector:aSelector]);
}

// 인보케이션으로 넘기기 전에 한 번 더 컨트롤한다.
// - 한놈만 셀렉터에 반응하면 forwardInvocation 으로 안 넘기고 그놈한테 전권을 준다.
- (id)forwardingTargetForSelector:(SEL)aSelector {
    BOOL isAgentRespond = [_agent respondsToSelector:aSelector];
    BOOL isDelegateRespond = [_delegate respondsToSelector:aSelector];
    if (isAgentRespond && !isDelegateRespond) {
        return _agent;
    } else if (!isAgentRespond && isDelegateRespond) {
        return _delegate;
    }
    return nil;
}

// 시스템이 메서드 시그니처 확인하여 인보케이션을 만들 때 사용한다.
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    id sign = [_delegate methodSignatureForSelector:sel];
    if (!sign) {
        return [_agent methodSignatureForSelector:sel];
    }
    return sign;
}

// 시스템이 메서드를 보내고 리턴 받을 때 쓴다.
// - 복사를 통해 양쪽에 때리는 게 좋다는 의견도 있지만, 테스트 결과 리턴값 처리 컨트롤 외에는 별 문제가 없었다.
// - 현 구성에서 리턴값 처리 우선권은 _delegate 에게 있으므로 다음과 같이 간략하게 한다.
- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_agent respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_agent];
    }
    if ([_delegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_delegate];
    }
}
@end


// ----------------------------------------------------------------------
// 사용객체에서 직접 구현할 때에는 KVC 를 사용할 이유가 전혀 없다.

@implementation MGRDelegateAgent {
    MGRDelegateProxy * _proxy;
    NSString * _key;
}
- (void)dealloc {
    if ([_object valueForKey:_key] == _proxy) {
        [_object setValue:[_proxy delegate] forKey:_key];
    }
}
- (instancetype)initWith:(id)object protocol:(Protocol *)protocol key:(NSString *)key {
    self = [super init];
    if (self) {
        _object = object;
        _key = key;
        _proxy = [[MGRDelegateProxy alloc] initWithProtocol:protocol agent:self];
        [_proxy setDelegate:[object valueForKey:key]];
        [object setValue:_proxy forKey:key];
    }
    return self;
}
- (void)setDelegate:(id)delegate {
    [_proxy setDelegate:delegate];
    if ([_object valueForKey:_key] != _proxy) {
        [_object setValue:_proxy forKey:_key];
    }
}
- (id)delegate {
    return [_proxy delegate];
}
@end





// ----------------------------------------------------------------------

//  ==== NSProxy 관련 참고사항 ====
//  * 프록시는 Class isa; 를 갖고 있으며, NSObject 프로토콜을 따르고 있다,
//   [some isProxy] ==> YES 로 되어 있으므로 id 로 캐스팅해도 프록시인지 검사할 수 있다.


//  ==== 프록시 Agent 생성 관련 참고사항 ====
//  * 일반적인 id 캐스팅을 할 때 명시적으로 프로토콜을 포함하여 넣어주는 것이 좋다.
//      MGRDelegateProxy<SomeProtocol> * _delegateProxy;
//      _delegateProxy = (id<SomeProtocol>)[MGRDelegateProxy proxy:@protocol(SomeProtocol) to:someObj];
//  * 사용객체가 죽었을 때 오브젝트의 델리게이트를 복원해주기 위해 디알록에 다음과 같은 처리를 해주는 게 좋다.
//      - (void)dealloc {
//          if ([_object delegate] == _delegateProxy) {
//              [_object setDelegate:[_delegateProxy delegate]];
//          }
//      }
//  * 세터게터를 프록시로 돌려놓게 해주는 게 좋다.
//      - (void)setDelegate:(id<SomeProtocol>)delegate {
//          _delegateProxy = (id<SomeProtocol>)[[MGRDelegateProxy alloc] initWithProtocol:@protocol(SomeProtocol) agent:someObj];
//          _delegateProxy.delegate = delegate;
//          _object.delegate = _delegateProxy;
//      }
//      - (id<SomeProtocol>)delegate {
//          return [_delegateProxy delegate];
//      }
//


// ==== 메서드 포워딩 관련 참고사항 ====
// objc 의  - (BOOL)doComputeWithNum:(NSInteger)aNum  이와 같은 메서드는 컴파인하면
//    C 의  BOOL aClass_doComputeWithNum(aClass *self, SEL _cmd, NSInteger aNum); 로 바뀐다.
//         ---- ======  --------------- ============  ========  --------------
//    그 뒤 objc 런타임이 함수포인터를 이용해 해당 함수를 호출한다.
//    objc 런타임은 클래스 캐쉬와 디스패치 테이블을 찾아보고 해당 메서드가 응답하는지 확인한 다음 없으면 탐색해 나간다.
//    호출 순서
//      1. + (BOOL)resolveInstanceMethod:(SEL)sel;
//      2. + (BOOL)resolveClassMethod:(SEL)sel;
//      2. - (id)forwardingTargetForSelector:(SEL)aSelector;
//      3. - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
//      4. - (void)forwardInvocation:(NSInvocation *)invocation;
//      5. - (void)doesNotRecognizeSelector:(SEL)aSelector
// 런타임이 호출하는 resolveInstanceMethod: 에서는 메서르를 직접 정의할 수도 있다.
//      if(aSEL == @selector(doFoo:)){
//          class_addMethod([self class],aSEL,(IMP)fooMethod,"v@:"); return YES;
//      } // "v@:"은 void 리턴값의 기호. 메서드 시그니처는 @encode 에서도 사용한다. Objective-C Runtime Programming Guide / Type Encodings 참고
//      return [super resolveInstanceMethod];
// NO 를 리턴하면 forwardingTargetForSelector 가 실행되는데, 이거 중요하다.
//    일반적인 포워딩은 forwardingTargetForSelector 에서 이뤄진다. NSInvocation 객체 없이 바로 연결된다.
//    조건에 안 맞을 경우,
//       일반 NSObject 는 수퍼를 리턴한다. [super forwardingTargetForSelector:aSelector];
//       절대로 self 나 nil 을 리턴하면 안된다. 무한루프에 빠진다.
//       프록시의 경우 루트라면 self 나 nil 을 리턴하면 된다.
// 그 뒤 methodSignatureForSelector 와 forwardInvocation: 을 오버라이딩 했으면 그걸 거쳐 doesNotRecognizeSelector 에서 마무리된다.
// forwardInvocation 은 NSInvocation 객체를 매개로 이용하므로 상대적으로 느린 펑션콜이다.
//  - forwardInvocation 메서드는 expensive call 이다.
//    메서드 처리에 NSInvocation 객체를 매번 생성해 이용하기 때문에 위의 forwardingTargetForSelector 보다 10배 정도 느리다.
//  - 인보케이션의 타겟은 1개이다. 따라서 여러 타겟이 있는데 리턴값도 받아야 하는 경우라면 값을 컨트롤해야 한다.
//  - 현재 설정의 경우 agent 에게 먼저 보내지만 리턴값 우선권은 delegate 에 있다.
//  - 일반 NSObject 객체에서 이 메서드를 오버라이딩 하지 않으면 doesNotRecognizeSelector: 로 넘어가 종료된다.
//


/* 델리게이트 복원 권한을 Agent 에게 넘기기 위해 다음 코드 삭제
// ======================================================================
//  이거는 ARC 에서 performSelector 가 문제있기 때문에 다음과 같이 한다. 이 질문에 대한 고수의 답변 참고.
//  참고: https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
//
/// 셀렉터에서 함수를 복원하여 델리게이트를 get 한다.
static id GetDelegate(id object, SEL getter) {
    IMP imp = [object methodForSelector:getter];
    id (*delegateGetFunc)(id, SEL) = (id (*)(id, SEL))imp;
    return delegateGetFunc(object, getter);
}
/// 셀렉터에서 함수를 복원하여 델리게이트를 set 한다.
static void SetDelegate(id object, SEL setter, id target) {
    IMP imp = [object methodForSelector:setter];
    void (*delegateSetFunc)(id, SEL, id) = (void (*)(id, SEL, id))imp;
    delegateSetFunc(object, setter, target);
}
// Private Storage
{
    __weak id _object;      // weak
    SEL _getter;            // assign
    SEL _setter;            // assign
    Protocol * _protocol;   // assign !!! 어싸인이라고
    __weak id _agent;       // weak
}
- (void)dealloc {
    if (_object && _delegate && GetDelegate(_object, _getter) == self) {
        SetDelegate(_object, _setter, _delegate);
    }
}
- (instancetype)initWithAuto:(id)object setter:(SEL)setter getter:(SEL)getter protocol:(Protocol *)protocol agent:(id)agent {
    if (self) {
        _object = object;
        _setter = setter;
        _getter = getter;
        _protocol = protocol;
        if ([agent conformsToProtocol:protocol]) {
            _agent = agent;
            if (object) {SetDelegate(object, setter, self);}
        } else {
            NSAssert(NO, @"agent doesn't conform to protocol.");
            NSException *exception = [NSException exceptionWithName:@"Agent Protocol Error" reason:@"agent doesn't conform to protocol." userInfo:nil];
            @throw exception;
        }
    }
    return self;
}
- (void)setDelegate:(id _Nullable)delegate {
    if ([delegate conformsToProtocol:_protocol]) {
        _delegate = delegate;
        if (_object && GetDelegate(_object, _getter) != self) {
            SetDelegate(_object, _setter, self);
        }
    } else if (delegate) {
        NSAssert(NO, @"delegate doesn't conform to protocol.");
        NSException *exception = [NSException exceptionWithName:@"Delegate Protocol Error" reason:@"delegate doesn't conform to protocol." userInfo:nil];
        @throw exception;
    } else {
        _delegate = nil;
    }
}
*/

/* 현재 사용하지 않는 구성이므로 삭제
// ======================================================================
// 복사를 통해 원본과 완전 별개로 다룰 수도 있다.
// 다음 처리는 - (void)forwardInvocation:(NSInvocation *)invocation 메서드에서 한다.
//   NSInvocation *invocationCopy = [self copyInvocation:invocation];
//   [invocationCopy invokeWithTarget:_agent];
//
/// 인보케이션 복사
- (NSInvocation *)copyInvocation:(NSInvocation *)invocation {
    // 사실상 복사가 안 되므로, 쌩 인보케이션 객체를 만들어서 집어넣어줘야 한다.
    // objc 메서드를 C 펑션으로 바꾸는 것이므로, C 아규먼트 형식에 맞게 집어넣는다.
    NSInvocation *copied = [NSInvocation invocationWithMethodSignature:[invocation methodSignature]];
    NSUInteger argCount = [[invocation methodSignature] numberOfArguments];
    for (int i = 0; i < argCount; i++) {
        char buffer[sizeof(intmax_t)];
        [invocation getArgument:(void *)&buffer atIndex:i];
        [copied setArgument:(void *)&buffer atIndex:i];
        // C 구조가 그렇듯이 setArgument 에서 인덱스 0은 self, 1은 _cmd가 미리 설정되어 있다. (앞에서 설명한 구조 참고)
        // 여기서는 인보케이션의 전체 복사가 목적이므로 걍 다 처 넣어도 된다.
    }
    return copied;
    // 인보케이션 복사를 통해 forwardInvocation: 에서 쌍으로 컨트롤할 수 있다.
    // 다음을 통해 인보케이션을 복사한다.
    //      NSInvocation *invocationCopy = [self copyInvocation:invocation];
    // 인보케이션에 타겟을 지정하여 때린다.
    //      [invocationCopy invokeWithTarget:_agent];
    //      혹은
    //      invocationCopy.target = _agent;
    //      [invocationCopy invoke];
    //      둘의 차이는 없다.
    // 리턴되어 돌아온 값은 인보케이션 객체에 저장된다. 아무것도 하지 않으면 호출한 객체에게 전달된 뒤 인보케이션 객체가 죽는다.
    // 아무튼 이 값을 수동으로 빼고 넣을 수도 있다.
    // 리턴값이 객체라면
    //      void *ret;
    //      [invocationCopy getReturnValue:&ret];
    //      NSLog(@"=========>>> %@", (__bridge id)ret);    // 캐스팅해야 한다
    //      [invocation setReturnValue:&ret];               // 주소로 넣어 (void *)&ret
    // 리턴값이 스칼라이면
    //      NSInteger ret;
    //      [invocationCopy getReturnValue:&ret];
    //      NSLog(@"=========>>> %ld", ret);                // 쌩으로 꽂힌다.
    //      [invocation setReturnValue:&ret];               // 주소로 넣어 (void *)&ret
    //
    // 이런 식으로 하면 때리는 invocation 과 복사한 invocationCopy 의 값을 적절하게 컨트롤할 수 있다.
    //
}
*/


