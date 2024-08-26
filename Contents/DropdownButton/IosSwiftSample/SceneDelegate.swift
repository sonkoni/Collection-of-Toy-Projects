//
//  SceneDelegate.swift
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/10/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Property
    var window: UIWindow?
    var mainViewController : MainTableViewController?
    

    // MARK: - UIWindowSceneDelegate Function
    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        setupAppearanceProxy() // 기본 환경설정.
        if (scene as? UIWindowScene) == nil { return } // guard let _ = (scene as? UIWindowScene) else { return } 애플스타일
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            print("아이패드")
        } else {
            print("아이폰!!")
        }
        
        // self.window = UIWindow.init(frame: UIScreen.main.bounds) <- 구형 스타일
        /** 다음과 같은 방식도 가능한 듯.
        let windowScene = scene as? UIWindowScene
        self.window = UIWindow(frame: windowScene?.coordinateSpace.bounds ?? CGRect.zero)
        self.window?.windowScene = windowScene
        */
        
        self.window = UIWindow.init(windowScene:scene as! UIWindowScene)
        self.window?.backgroundColor = UIColor.cyan
        /* self.window 에서도 확인가능.
        if (self.window?.traitCollection.userInterfaceIdiom == .pad) {
            print("아이패드")
        } else {
            print("아이폰!!")
        }
         */
        
        self.mainViewController = MainTableViewController()
        let nav = UINavigationController.init(rootViewController:self.mainViewController!)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    
    // MARK: - 생성 & 소멸
    func setupAppearanceProxy() {
        let barColor = UIColor.init(red:49.0/255.0, green:186.0/255.0, blue:81.0/255.0, alpha:1.0)
        
        let appearance = UINavigationBarAppearance.init();
        appearance.backgroundColor = barColor // 내비게이션 바 자체 색
        appearance.shadowColor = UIColor.clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name:"Futura", size:18.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white  // 가운데 타이틀 색
        ]
        
        let backButtonAppearance = UIBarButtonItemAppearance.init(style:UIBarButtonItem.Style.plain)
        backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        let backIndicatorImage = appearance.backIndicatorImage.copy() as! UIImage
        _ = backIndicatorImage.withTintColor(UIColor.blue, renderingMode:UIImage.RenderingMode.alwaysOriginal)
        
        appearance.backButtonAppearance = backButtonAppearance
        appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
        
//        appearance.configureWithOpaqueBackground()
//        appearance.configureWithTransparentBackground()
//        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        if #available(iOS 15, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }

//        UINavigationBar.appearance().isTranslucent = false // 이걸하면 왜 타이틀이 안나오는지 모르겠네.
    }
}

