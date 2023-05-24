//
//  SceneDelegate.swift
//  SwipeCellProject
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
        appearance.backgroundColor = .systemGroupedBackground  // 내비게이션 바 자체 색
        appearance.shadowColor = UIColor.clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black  // 가운데 타이틀 색
        ]
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black  // 가운데 타이틀 색
        ]
        
        let backButtonAppearance = UIBarButtonItemAppearance.init(style:UIBarButtonItem.Style.plain)
        backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemBlue]
        appearance.backButtonAppearance = backButtonAppearance
        
        var backIndicatorImage = appearance.backIndicatorImage.copy() as! UIImage
        backIndicatorImage = backIndicatorImage.withTintColor(UIColor.systemBlue, renderingMode:UIImage.RenderingMode.alwaysOriginal)
        appearance.setBackIndicatorImage(backIndicatorImage, transitionMaskImage: backIndicatorImage)
        
        var newAppearance = appearance.copy()
        newAppearance.backgroundColor = .clear
        newAppearance.backgroundEffect = .init(style: .systemMaterialLight)
        UINavigationBar.appearance().standardAppearance = newAppearance // 위로 올릴때
        newAppearance = appearance.copy()
        newAppearance.configureWithTransparentBackground() // 투명
        UINavigationBar.appearance().scrollEdgeAppearance = newAppearance // 아래로 당길때
        
        newAppearance = appearance.copy()
        newAppearance.backgroundColor = .clear
        newAppearance.backgroundEffect = .init(style: .systemMaterialLight)
        UINavigationBar.appearance().compactAppearance = newAppearance // 위로 올릴때
        if #available(iOS 15, *) {
            newAppearance = appearance.copy()
            newAppearance.configureWithTransparentBackground() // 투명
            UINavigationBar.appearance().compactScrollEdgeAppearance = newAppearance // 아래로 당길때
        }
    }
}

