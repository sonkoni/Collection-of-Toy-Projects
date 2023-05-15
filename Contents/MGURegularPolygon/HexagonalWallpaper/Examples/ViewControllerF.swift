//
//  ViewControllerF.swift
//  HexagonalWallpaper
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import GraphicsKit
import IosKit

final class ViewControllerF: UIViewController {
    
    // MARK: - Property
    private var hexagonalWallpaperView: MGUHexagonalWallpaperView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "IV Drop 앱에서 사용한 예"
        
        hexagonalWallpaperView = MGUHexagonalWallpaperView(mainColor: .secondarySystemBackground,
                                                           radius: 10.0,
                                                           direction: .southEast)
        guard let hexagonalWallpaperView = hexagonalWallpaperView else {
            return
        }
        hexagonalWallpaperView.hsbRange = [0.0, 0.0, 0.02]
        hexagonalWallpaperView.useHsbMode = true
        hexagonalWallpaperView.progress = 1.0
        hexagonalWallpaperView.showRadiusRatio = 0.97
        hexagonalWallpaperView.lineColor = .secondarySystemBackground
        view.addSubview(hexagonalWallpaperView)
        hexagonalWallpaperView.mgrPinEdgesToSuperviewEdges()
    }
}
