## KVC와 KVO

### 1. Key-Value Coding (KVC)

Key-Value Coding(KVC)는 주로 Objective-C에서 사용되는 메커니즘으로, 객체의 프라퍼티에 간접적으로 접근할 수 있는 방법이다. KVC를 사용하면 프라퍼티의 이름을 문자열(`Key`)로 지정하여 해당 프라퍼티에 접근하거나 값을 설정할 수 있다. 이는 동적으로 프라퍼티에 접근할 수 있는 방법으로, 런타임에 객체의 프로퍼티를 설정하거나 조회할 수 있다.

Swift에서도 KVC를 사용할 수 있지만, Swift의 엄격한 타입 시스템과 옵셔널 체계로 인해 몇 가지 요구 사항이 있다:

- **NSObject 상속**: KVC를 사용하려면 해당 클래스가 `NSObject`를 상속받아야 한다.
- **@objc 속성**: KVC로 접근할 프로퍼티는 `@objc`로 선언되어야 하며, Swift에서 KVC를 사용하려면 해당 프로퍼티가 Objective-C 런타임에 노출되어 있어야 한다.

#### KVC의 주요 메서드

- `value(forKey:)`: 객체의 프라퍼티 값을 가져오는 데 사용된다. Objective-C에서는 `[object valueForKey:]` 메서드로 호출된다.
- `setValue(_:forKey:)`: 객체의 프라퍼티 값을 설정하는 데 사용된다. Objective-C에서는 `[object setValue:forKey:]` 메서드로 호출된다.

#### KVC 사용 예제

아래는 KVC를 사용하여 객체의 프라퍼티에 접근하고, 그 값을 설정하는 예제:

```swift
// Swift 에서 KVC 사용 예제
import Foundation

class Person: NSObject {
    @objc var name: String
    @objc var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let person = Person(name: "John Doe", age: 30)

// KVC를 사용하여 프라퍼티에 접근
let name = person.value(forKey: "name") as? String
print(name) // 출력: Optional("John Doe")

// KVC를 사용하여 프라퍼티 값을 변경
person.setValue(35, forKey: "age")
print(person.age) // 출력: 35
```

KVC는 특히 딕셔너리와 같이 키-값 쌍으로 데이터를 관리하는 구조와 함께 사용할 때 유용하다. 또한, 유연한 코딩을 가능하게 하여 런타임에 프라퍼티 이름을 동적으로 결정할 수 있다.

### 2. Key-Value Observing (KVO)

Key-Value Observing(KVO)은 객체의 특정 프라퍼티의 변화를 관찰할 수 있는 메커니즘이다. KVO를 사용하면 객체의 프라퍼티가 변경될 때, 그 변화를 감지하고 특정 로직을 수행할 수 있다. 이는 주로 모델 객체의 상태 변화에 따라 뷰를 업데이트하거나, 다른 로직을 수행해야 할 때 유용하다.

#### KVO 사용 예제

아래는 KVO를 사용하여 객체의 프라퍼티 변화를 감지하고 처리하는 예제:

```swift
import Foundation

class Person: NSObject {
    @objc dynamic var name: String
    @objc dynamic var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Observer: NSObject {
    var person: Person
    
    init(person: Person) {
        self.person = person
        super.init()
        
        // KVO를 사용하여 'age' 프라퍼티를 관찰
        person.addObserver(self, forKeyPath: #keyPath(Person.age), options: [.new, .old], context: nil)
    }
    
    // 관찰된 프라퍼티의 변화 처리
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Person.age) {
            if let newValue = change?[.newKey] as? Int, let oldValue = change?[.oldKey] as? Int {
                print("나이 변경: \(oldValue) -> \(newValue)")
            }
        }
    }
    
    deinit {
        person.removeObserver(self, forKeyPath: #keyPath(Person.age))
    }
}

let person = Person(name: "John Doe", age: 30)
let observer = Observer(person: person)

// KVO를 통해 age 프라퍼티의 변경을 감지
person.age = 35 // 출력: 나이 변경: 30 -> 35
```

### KVC와 KVO의 활용

KVC와 KVO는 iOS 개발에서 매우 유용한 기능이다. KVC는 코드의 유연성을 높이고, KVO는 객체의 상태 변화에 따른 반응형 프로그래밍을 가능하게 한다. 이 두 기능은 MVC 패턴을 따르는 애플리케이션에서 모델과 뷰 간의 데이터 바인딩을 구현할 때 자주 사용된다.

### KVC와 KVO의 장점

- **동적 프라퍼티 접근**: KVC를 사용하면 프라퍼티를 런타임에 동적으로 접근할 수 있어, 더욱 유연한 코드를 작성할 수 있다.
- **변화 감지**: KVO를 통해 객체의 프라퍼티 변화에 반응하여, 뷰를 자동으로 갱신하거나 다른 작업을 수행할 수 있다.
- **모델과 뷰의 바인딩**: KVO는 MVC 구조에서 모델과 뷰를 자동으로 동기화하는 데 도움을 준다.

### KVC와 KVO의 단점

- **오류 가능성**: KVC는 문자열 기반의 접근 방식을 사용하므로, 잘못된 키를 사용할 경우 컴파일 타임에 오류를 잡을 수 없다.
- **복잡성 증가**: KVO를 사용할 때, 관찰을 시작하고 중단하는 로직이 복잡해질 수 있으며, 잘못된 관리로 인해 메모리 누수가 발생할 수 있다.

### 결론

KVC와 KVO는 iOS 개발에서 객체의 프라퍼티 관리와 상태 변화를 처리하는 도구이다. 적절히 사용하면 코드의 유연성과 반응성을 높일 수 있지만, 그에 따른 복잡성과 잠재적인 오류 가능성도 존재한다. 이러한 특성을 이해하고, 상황에 맞게 활용하는 것이 중요하다.
