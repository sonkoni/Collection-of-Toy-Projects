# Method Swizzling

## 개요

**Method Swizzling**은 런타임 시점에서 클래스의 메서드 구현을 동적으로 교체할 수 있는 Objective-C의 강력한 기능이다. Swift에서도 Objective-C 런타임을 사용하기 때문에 Method Swizzling이 가능하다. 이 기술은 주로 기존 메서드의 동작을 수정하거나 확장할 때 사용되며, 주의해서 사용하지 않으면 앱의 안정성에 영향을 미칠 수 있기 때문에 신중한 접근이 필요하다.

### 사용 예시

Method Swizzling은 주로 아래와 같은 상황에서 사용된다:

- **로그 수집 및 분석**: 특정 메서드가 호출될 때마다 로그를 기록하거나 통계를 수집할 때.
- **기존 클래스의 동작 수정**: 서드파티 라이브러리나 프레임워크의 특정 메서드의 동작을 수정할 때.
- **UIKit 컴포넌트 확장**: UIViewController나 UIView의 기본 동작을 확장하여 추가 기능을 구현할 때.

## Method Swizzling의 기본 개념

Method Swizzling은 Objective-C 런타임의 **objc_runtime** 라이브러리의 함수를 사용하여 구현된다. 두 메서드의 구현을 서로 교체(swap)하는 방식으로 동작한다.

### Method Swizzling의 구현 과정:

1. **대상 메서드와 대체할 메서드 찾기**: `class_getInstanceMethod` 또는 `class_getClassMethod` 함수를 사용하여 교체할 메서드를 가져온다.
2. **메서드 교체**: `method_exchangeImplementations` 함수를 사용하여 두 메서드의 구현을 교체한다.

## 예제 코드

다음은 `UIViewController`의 `viewWillAppear` 메서드를 Swizzling하여, 뷰가 화면에 나타날 때마다 로그를 출력하는 예제이다.

```swift
import UIKit

extension UIViewController {
    
    static let swizzleViewWillAppear: Void = {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(swizzled_viewWillAppear(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc func swizzled_viewWillAppear(_ animated: Bool) {
        // Swizzled implementation
        self.swizzled_viewWillAppear(animated)
        
        // 추가적인 기능: 로그 출력
        print("View will appear: \(self)")
    }
}
```

### 사용 방법

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Swizzling을 활성화
    UIViewController.swizzleViewWillAppear
}
```

위 코드는 `UIViewController`의 `viewWillAppear` 메서드가 호출될 때마다 커스텀 로그가 출력되도록 한다. `swizzled_viewWillAppear` 메서드가 원래 `viewWillAppear` 메서드를 대체하며, 기존의 기능도 유지되도록 `swizzled_viewWillAppear` 내부에서 원래의 `viewWillAppear`를 호출한다.

## Method Swizzling의 장점

- **기존 클래스의 동작 확장**: 코드를 재작성하지 않고도 기존 클래스의 동작을 확장하거나 수정할 수 있다.
- **서드파티 코드 수정 가능**: 서드파티 라이브러리의 소스를 수정하지 않고도 원하는 동작을 구현할 수 있다.

## Method Swizzling의 단점 및 위험성

- **디버깅 어려움**: 메서드가 교체된 후, 코드의 흐름을 추적하기 어려워질 수 있다. 특히, 복잡한 Swizzling이 많아지면 버그 발생 가능성이 높아진다.
- **호환성 문제**: iOS 버전이나 런타임 환경에 따라 Swizzling이 예기치 않게 동작할 수 있다.
- **취약성 증가**: 교체된 메서드가 예상치 못한 방식으로 동작하면, 앱의 안정성에 큰 영향을 미칠 수 있다.

## 결론

Method Swizzling은 매우 강력한 도구이지만, 신중하게 사용해야 한다. 코드의 유연성을 높여줄 수 있지만, 잘못 사용하면 디버깅이 어렵고 유지보수가 힘든 코드가 될 수 있다. Method Swizzling을 사용하기 전에, 다른 대안이 있는지 고려하는 것이 중요하다.
