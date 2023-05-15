//
//  ViewControllerA.swift
//  HexagonalWallpaper
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import GraphicsKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var centerView: UIView! // 200.0 X 200.0
    private var shapeLayer1 = CAShapeLayer()
    private var shapeLayer2 = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "정적으로 확인"
        
        centerView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        centerView.layer.cornerRadius = 100.0
        centerView.layer.borderColor = UIColor.black.cgColor
        centerView.layer.borderWidth = 0.5
        
        view.layer.addSublayer(shapeLayer1)
        shapeLayer1.frame = view.bounds
        shapeLayer1.lineWidth = 0.5
        shapeLayer1.strokeColor = UIColor.red.cgColor
        shapeLayer1.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(shapeLayer2)
        shapeLayer2.frame = view.bounds
        shapeLayer2.lineWidth = 0.5
        shapeLayer2.strokeColor = UIColor.red.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeLayer1.frame = view.bounds
        shapeLayer2.frame = view.bounds
        let center = CGPoint(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0)
        var path = UIBezierPath.init(regularPolygonAtCenter: center, radius: 100.0, numberOfSides: 6)
        shapeLayer1.path = path.cgPath
        path = UIBezierPath.init(bigRegularPolygonAtCenter: center, radius: 100.0, numberOfSides: 6, rotateRatio: 0.5)
        shapeLayer2.path = path.cgPath
    }
}
