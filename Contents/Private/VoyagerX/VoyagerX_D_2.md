## MVC 패턴

### 정의

MVC(Model-View-Controller) 패턴은 소프트웨어 디자인 패턴 중 하나로, 애플리케이션의 구조를 세 가지 주요 역할로 나누어 구성한다. 이러한 분리는 애플리케이션의 유지보수성과 확장성을 높이고, 역할별로 코드를 독립적으로 관리할 수 있도록 한다.<br/>그러나 실제 프로그래밍에서는 MVC 패턴으로 구조를 만들었을 때, View와 Controller의 **강력한 접합**으로 문제가 발생하여 MVC 보다는 **MVVM(Model-View-View Model)** 디자인 패턴(+ Clean Architecture)이 널리 사용된다.

### 구성 요소

MVC 패턴은 세 가지 주요 구성 요소로 이루어져 있다:

1. **Model (모델)**  
   모델은 애플리케이션의 데이터와 비즈니스 로직을 관리한다. 데이터의 구조를 정의하고, 데이터베이스와의 상호작용을 처리하며, 데이터를 저장하고 불러오는 작업을 수행한다. 모델은 View나 Controller에 대해 **알지 못하며**, 독립적으로 동작한다.

   ```swift
   struct User {
       var name: String
       var age: Int
   }
   ```

   예를 들어, `User`라는 모델은 사용자의 이름과 나이를 관리하는 구조체이다. 이 모델은 데이터와 관련된 로직을 처리한다.

2. **View (뷰)**  
   뷰는 사용자 인터페이스 요소를 담당하며, 사용자에게 데이터를 시각적으로 보여준다. 뷰는 모델을 **직접적으로 참조하지 않고**, 컨트롤러를 통해 데이터를 요청하여 화면에 표시한다.

   ```swift
   class UserView: UIView {
       func displayUserName(_ name: String) {
           // 사용자 이름을 화면에 표시
           print("User Name: \(name)")
       }
   }
   ```

   예를 들어, `UserView`는 사용자 이름을 화면에 표시하는 역할을 한다. 뷰는 데이터를 처리하지 않고, 단순히 데이터를 보여주는 역할만 한다.

3. **Controller (컨트롤러)**  
   컨트롤러는 모델과 뷰 사이에서 중개자 역할을 하며, 사용자의 입력을 처리하고 그에 따라 모델을 업데이트하거나 뷰를 갱신한다. 컨트롤러는 애플리케이션의 흐름을 관리하고, 뷰와 모델을 연결하여 전체적인 로직을 처리한다.

   ```swift
   class UserController {
       var user: User?
       var userView: UserView?

       func updateUserName(to name: String) {
           user?.name = name
           userView?.displayUserName(name)
       }
   }
   ```

   예를 들어, `UserController`는 사용자의 이름을 업데이트하고, 뷰를 통해 업데이트된 이름을 화면에 표시한다.

### MVC 패턴의 동작 방식

MVC 패턴에서 애플리케이션의 동작 방식은 다음과 같다:

1. 사용자가 **View**를 통해 데이터를 입력한다.
2. **Controller**는 사용자의 입력을 받아 **Model**을 업데이트한다.
3. **Model**은 데이터 변경을 감지하고, **Controller**에 알린다.
4. **Controller**는 **View**에 모델의 변경 사항을 반영하도록 지시한다.
5. **View**는 **Model**의 데이터를 사용하여 화면을 갱신한다.

### 장점

- **유지보수 용이**: 각 구성 요소가 독립적으로 동작하기 때문에, 특정 부분만 수정해도 전체 시스템에 큰 영향을 미치지 않는다.
- **역할 분리**: 코드가 명확하게 역할별로 구분되어 있어, 팀 내에서 역할을 나눠 개발할 수 있다.
- **재사용성**: 모델과 뷰가 독립적으로 구현되기 때문에, 다른 컨트롤러에서 동일한 모델이나 뷰를 재사용할 수 있다.

### 단점

- **복잡성 증가**: 간단한 애플리케이션에서도 MVC를 적용하면 코드가 복잡해질 수 있다.
- **상호 의존성**: 컨트롤러가 모델과 뷰를 모두 알아야 하기 때문에, 컴포넌트 간의 의존성이 생길 수 있다.

### MVC의 시각적 표현

아래 다이어그램은 MVC 패턴의 동작 방식을 시각적으로 표현한 것이다:

![MVC 패턴](https://upload.wikimedia.org/wikipedia/commons/a/a0/MVC-Process.svg)

### 샘플 코드

아래는 iOS 애플리케이션에서 MVC 패턴을 적용한 예시:

```swift
// Model
struct User {
    var name: String
}

// View
class UserView: UIView {
    func displayUserName(_ name: String) {
        print("User Name: \(name)")
    }
}

// Controller
class UserController {
    var user: User
    var userView: UserView

    init(user: User, userView: UserView) {
        self.user = user
        self.userView = userView
    }

    func updateUserName(to name: String) {
        user.name = name
        userView.displayUserName(name)
    }
}

// Usage
let user = User(name: "John")
let userView = UserView()
let userController = UserController(user: user, userView: userView)

userController.updateUserName(to: "Alice")
// Output: User Name: Alice
```

### 결론

MVC 패턴은 애플리케이션의 구조를 명확히 분리하여 유지보수성과 확장성을 높이는 데 기여한다. iOS 개발에서 MVC는 애플리케이션 아키텍처의 기초로 널리 사용되며, 개발자가 명확하고 구조적인 코드를 작성하는 데 도움이 된다. MVC를 제대로 이해하고 적용하는 것은 iOS 개발의 중요한 스킬 중 하나이다.
