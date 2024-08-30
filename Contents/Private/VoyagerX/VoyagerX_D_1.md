# Auto Layout의 장단점

## 장점

### 1. **유연한 화면 레이아웃**
   Auto Layout은 다양한 기기 화면 크기와 방향에 따라 유연하게 레이아웃을 조정할 수 있다. iPhone, iPad, 다양한 해상도를 지원해야 하는 경우에도 Auto Layout을 사용하면 하나의 레이아웃으로 모든 기기에서 일관된 UI를 제공한다.

   - **예시**: 아래 코드에서는 버튼이 화면의 중앙에 배치되고, 화면 크기에 상관없이 항상 일정한 간격을 유지한다.

   ```swift
   button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
   ```

### 2. **동적 컨텐츠에 대응 가능**
   Auto Layout은 텍스트 길이 또는 동적 데이터에 따라 뷰의 크기나 위치를 자동으로 조정할 수 있다. 이는 특히 다국어 지원 앱에서 유용하며, 길이가 다른 언어로 번역된 텍스트도 문제없이 처리할 수 있다.

   - **예시**: UILabel의 텍스트 길이에 따라 부모 뷰의 크기가 동적으로 조정된다.

   ```swift
   label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
   label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
   ```

### 3. **[기기 방향에 따른 자동 조정](https://github.com/sonkoni/Collection-of-Toy-Projects/tree/main/Contents/AutoLayout_Adaptivity)**
   Auto Layout을 사용하면 기기의 방향이 변경될 때 자동으로 레이아웃을 조정할 수 있다. 이는 가로 모드와 세로 모드를 모두 지원하는 앱에서 필수적이다.

   - **예시**: 가로, 세로 모드 전환 시에도 레이아웃이 자연스럽게 조정된다. [자세한 서술 문서](https://github.com/sonkoni/Collection-of-Toy-Projects/tree/main/Contents/AutoLayout_Adaptivity)

    ```swift
    // 방향전환에 따른 Present/Dismiss
    var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        observer = NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] _ in

            guard let self = self
            else {
                return
            }

            if self.presentedViewController == nil,
               UIDevice.current.orientation.isLandscape {
                let vc = ViewControllerX()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    ```
   
방향변화에 따른 Layout 변경 | 방향변화에 따른 Present/Dismiss 
---|---
<img src="../../AutoLayout_Adaptivity/screenshot/Simulator_Screen_Recording_iPhone_14_2023-05-13 at 9.00.05.gif" width="450">|<img src="../../AutoLayout_Adaptivity/screenshot/Screen Recording 2023-05-15 at 12.00.52.gif" width="450">
    
   
### 4. **[암묵적 애니메이션 지원](https://github.com/sonkoni/Collection-of-Toy-Projects/tree/main/Contents/AutoLayout_Animation)**
   Auto Layout을 사용하면 레이아웃 변경 시 암묵적 애니메이션이 자동으로 적용된다. 이는 사용자 경험을 향상시키는 중요한 요소로, 뷰의 위치나 크기 변경이 부드럽게 나타나도록 한다.

   - **예시**: 아래 코드에서는 버튼의 위치가 변경될 때 부드러운 애니메이션이 자동으로 적용된다. [자세한 서술 문서](https://github.com/sonkoni/Collection-of-Toy-Projects/tree/main/Contents/AutoLayout_Animation)

    ```swift
    @objc private func switchToggled(_ sender: UISwitch) {
        sender.isEnabled = false
        centerYConstraint.isActive = false
        if sender.isOn == true {
            centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            widthConstraint.constant = 100.0
        } else {
            centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
            widthConstraint.constant = 50.0
        }
        centerYConstraint.isActive = true
        
        let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) {
            self.view.layoutIfNeeded() // 애니메이션 블락 안에서 layoutIfNeeded 메서드를 호출해야한다. 
        }
        animator.addCompletion { _ in
            sender.isEnabled = true
        }
        animator.startAnimation()
    }
    ```

   이와 같은 암묵적 애니메이션은 사용자가 레이아웃 변화를 자연스럽게 인식할 수 있게 해주며, 별도의 애니메이션 코드를 작성하지 않아도 되어 개발 시간을 단축할 수 있다.   

## 단점

### 1. **학습 곡선**
   Auto Layout은 초기 학습이 다소 어려울 수 있다. 특히 복잡한 레이아웃을 구성할 때 제약 조건이 많아질수록 이해하고 관리하기가 어려워진다. Constraint 충돌이 발생하면 디버깅도 까다로울 수 있다.

   - **예시**: 아래와 같은 복잡한 제약 조건은 디버깅 시 어려움을 겪을 수 있다.

   ```swift
   button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
   button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
   ```

### 2. **런타임 오버헤드**
   Auto Layout은 런타임에 제약 조건을 계산하기 때문에, 복잡한 레이아웃이 많아지면 성능에 영향을 줄 수 있다. 성능 최적화가 중요한 앱에서는 코드로 직접 뷰의 프레임을 설정하는 것이 더 나을 수 있다.

   - **예시**: 수동으로 프레임을 설정하는 코드와 비교했을 때, Auto Layout은 더 많은 시스템 리소스를 사용한다.

   ```swift
   // 수동 프레임 설정 예시
   button.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
   ```

### 3. **복잡한 UI 구현의 어려움**
   Auto Layout은 복잡한 UI를 구현할 때 제약 조건이 복잡해지기 쉽다. 특히 여러 개의 뷰가 서로 상호작용하는 경우 제약 조건 충돌이 발생할 수 있다.

   - **예시**: 여러 뷰가 서로 종속된 제약 조건을 가질 때 충돌 가능성 증가.

   ```swift
   view1.leadingAnchor.constraint(equalTo: view2.trailingAnchor, constant: 8).isActive = true
   view2.trailingAnchor.constraint(equalTo: view1.leadingAnchor, constant: -8).isActive = true
   ```
