//
//  ViewControllerE.swift
//  HexagonalWallpaper
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import GraphicsKit
import IosKit

final class ViewControllerE: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var slider: UISlider!
    private var hexagonalWallpaperView = MGUHexagonalWallpaperView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hexagonal WallPaper Info Object"
        
        view.insertSubview(hexagonalWallpaperView, at: 0)
        hexagonalWallpaperView.mgrPinEdgesToSuperviewEdges()
        hexagonalWallpaperView.hsbRange = [0.0, 0.0, 0.1]
        hexagonalWallpaperView.mainColor = .systemBlue
        hexagonalWallpaperView.useHsbMode = true
        hexagonalWallpaperView.useFocusRandomColor = false
        hexagonalWallpaperView.direction = .east
        hexagonalWallpaperView.radius = 30.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onboardingAnimationStart()
        hexagonalWallpaperView.layer.speed = 0.0
    }
    
    
    // MARK: - Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        hexagonalWallpaperView.layer.timeOffset = CFTimeInterval(sender.value)
    }
    
    private func onboardingAnimationStart() {
        let hexagonalProgressAnimation = self.hexagonalWallpaperView.hexagonalProgressAnimation()
        
        CATransaction.setCompletionBlock { }
        self.hexagonalWallpaperView.layer.add(hexagonalProgressAnimation, forKey: "HexagonalProgressAnimationKey")
    }
    
}

