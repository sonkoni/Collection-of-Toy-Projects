//
//  SceneDelegate.swift
//  HexagonalWallpaper
//
//  Created by Kwan Hyun Son on 2022/10/08.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Property
    var window: UIWindow?
    var mainViewController : MainTableViewController?
    

    // MARK: - UIWindowSceneDelegate Function
    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        setupAppearanceProxy() // 기본 환경설정.
        if (UIDevice.current.userInterfaceIdiom == .pad) { print("아이패드") } else { print("아이폰") }
        
        window = UIWindow.init(windowScene:scene)
        window?.backgroundColor = UIColor.cyan
        let mainViewController = MainTableViewController()
        self.mainViewController = mainViewController
        let nav = UINavigationController.init(rootViewController:mainViewController)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    
    // MARK: - 생성 & 소멸
    private func setupAppearanceProxy() {
        let appearance = UINavigationBarAppearance.init();
        appearance.backgroundColor = .systemMint // 내비게이션 바 자체 색
        appearance.shadowColor = UIColor.clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name:"Futura", size:18.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white  // 가운데 타이틀 색
        ]
        
        let backButtonAppearance = UIBarButtonItemAppearance.init(style:UIBarButtonItem.Style.plain)
        backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemBlue]
        appearance.backButtonAppearance = backButtonAppearance
        
        var backIndicatorImage = appearance.backIndicatorImage.copy() as! UIImage
        backIndicatorImage = backIndicatorImage.withTintColor(UIColor.systemBlue, renderingMode:UIImage.RenderingMode.alwaysOriginal)
        appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        if #available(iOS 15, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }
}

