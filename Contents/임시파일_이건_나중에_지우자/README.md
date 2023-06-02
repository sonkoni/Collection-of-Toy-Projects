
# 주의사항
만약, iOS Kit 을 재컴파일할 경우, MGURulerView에 사용된, 사운드 소스를 다시 넣어서 컴파일해야한다.

### 시간이 되면 문서화하자.
* MGUFlowView - 이건 좀더 스위프트 예제로 바꿔 넣자.
* Dose Picker
* Ring Progress
* Carosel
* Inner Shadow
* Noise Effect
* Image Helper
* Gift Card
* Gini Effect
* LoadingView
* Dynamic Button
* Material Button
* Ripple Button
* Lively Button
* Graph
* Display Switcher
* 애플 뮤직 트렌지션
* PageControl

 

## VisualLizer
* SceneDelegate.swift 파일에 다음을 추가
    
    ```swift
    
        import LNTouchVisualizer
        
        
        func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        setupAppearanceProxy() // 기본 환경설정.
        if (UIDevice.current.userInterfaceIdiom == .pad) { print("아이패드") } else { print("아이폰") }
        
        window = UIWindow.init(windowScene:scene)
        window?.backgroundColor = UIColor.systemYellow
        let mainViewController = MainTableViewController()
        self.mainViewController = mainViewController
        let nav = UINavigationController.init(rootViewController:mainViewController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        //! 여기서부터 추가.
        scene.touchVisualizerEnabled = true
        let rippleConfig = LNTouchConfig.ripple
        rippleConfig.fillColor = .systemBlue
        rippleConfig.strokeColor = .systemBlue
        rippleConfig.alpha = 0.1
        let contactConfig = LNTouchConfig.touchConfig
        contactConfig.fillColor = .systemBlue
        contactConfig.strokeColor = .systemBlue
        contactConfig.alpha = 0.4
        scene.touchVisualizerWindow.touchRippleConfig = rippleConfig
        scene.touchVisualizerWindow.touchContactConfig = contactConfig
        scene.touchVisualizerWindow.isMorphEnabled = true
        scene.touchVisualizerWindow.isTouchVisualizationEnabled = true
    }
    ```
