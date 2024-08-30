## Method Swizzling이란

### 정의

Method Swizzling은 Objective-C에서 메서드의 구현을 런타임에서 교환하는 기술입니다. 이 기법을 사용하면 기존의 메서드 구현을 수정하거나 새로운 동작을 주입할 수 있습니다. 주로 디버깅, 테스트, 그리고 애플리케이션의 기능을 확장하기 위해 사용됩니다.

### 사용 목적

Method Swizzling은 다음과 같은 상황에서 유용하게 사용될 수 있습니다:

1. **디버깅 및 로깅**: 기존 메서드 호출 시점에 로깅을 추가하거나, 디버깅 정보를 수집할 수 있습니다.
2. **기능 확장**: 기존의 클래스나 메서드를 수정하지 않고도 추가 기능을 제공할 수 있습니다.
3. **테스트**: 테스트 시나리오에 맞게 특정 메서드의 동작을 변경하여 테스트 환경을 조정할 수 있습니다.

### 구현 예시

다음은 Method Swizzling의 기본적인 예시입니다. `ViewController` 클래스에서 `methodA`와 `methodB`의 구현을 교환하는 방법을 보여줍니다.

```objective-c
#import "ViewController.h"
#import <objc/runtime.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class cls = self.class;
    Method m1 = class_getInstanceMethod(cls, @selector(methodA));
    Method m2 = class_getInstanceMethod(cls, @selector(methodB));
    method_exchangeImplementations(m1, m2);

    [self methodA];
    // methodB called
}

- (void)methodA {
    NSLog(@"methodA called");
}

- (void)methodB {
    NSLog(@"methodB called");
}

@end
```

이 코드에서는 `viewDidLoad` 메서드 내에서 `methodA`와 `methodB`의 구현을 교환합니다. 그 결과, `[self methodA]` 호출 시 실제로는 `methodB`가 호출됩니다.

또 다른 예시는 다음과 같습니다:

```objective-c
#import "ViewController.h"
#import <objc/runtime.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class cls = self.class;
    Method m1 = class_getInstanceMethod(cls, @selector(methodA));
    Method m2 = class_getInstanceMethod(cls, @selector(methodB));
    method_exchangeImplementations(m1, m2);

    [self methodA];
    // methodB called
    // methodA called
}

- (void)methodA {
    NSLog(@"methodA called");
}

- (void)methodB {
    NSLog(@"methodB called");
    [self methodB];
}

@end
```

이 예시에서는 `methodB`에서 `methodB`를 다시 호출하는 무한 루프를 설정했습니다. 이로 인해 `methodA` 호출 시 `methodB`가 먼저 호출되고, 그 뒤에 `methodA`가 호출됩니다. 이 방식은 메서드의 재귀 호출을 통해 추가적인 로직을 테스트할 수 있는 방법을 제공합니다.

### 주의사항

Method Swizzling을 사용할 때는 다음과 같은 점에 주의해야 합니다:

- **디버깅 어려움**: 메서드 교환으로 인해 디버깅이 어려워질 수 있습니다. 메서드의 원래 동작과 변경된 동작이 혼동될 수 있습니다.
- **동기화 문제**: 멀티스레딩 환경에서는 스위즐링된 메서드의 호출이 예상치 못한 동작을 일으킬 수 있습니다.
- **호환성**: iOS 또는 macOS의 업데이트로 인해 Swizzling된 메서드의 동작이 변경될 수 있습니다.

Method Swizzling은 매우 강력한 기술이지만, 올바르게 사용해야 하며, 코드의 유지보수성에 영향을 미칠 수 있음을 염두에 두어야 합니다.
