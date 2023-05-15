//
//  ViewControllerC.swift
//  HexagonalWallpaper
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import GraphicsKit
import IosKit

final class ViewControllerC: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var centerView: UIView! // 300.0 X 600.0
    private var shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hexagonal WallPaper 정적으로 확인"
        centerView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = centerView.bounds
        shapeLayer.lineWidth = 0.5
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeLayer.frame = centerView.bounds
        
        let center = CGPoint(x: centerView.bounds.size.width / 2.0, y: centerView.bounds.size.height / 2.0)
        let radius = 13.0
        let diameter = radius * 2.0
        let interItemSpacing = diameter
        let lineSpacing = interItemSpacing * sqrt(3)
        
        let halfRectWidthPlusAlpha = (centerView.bounds.size.width / 2.0) + (interItemSpacing)
        let baseWidthHalfCount = Int(ceil(halfRectWidthPlusAlpha / (interItemSpacing)))
        let baseWidthCount = (baseWidthHalfCount * 2) + 1
    
        let halfRectHeightPlusAlpha = (centerView.bounds.size.height / 2.0) + (lineSpacing)
        let baseHeightHalfCount = Int(ceil(halfRectHeightPlusAlpha / (lineSpacing)))
        let baseHeightCount = (baseHeightHalfCount * 2) + 1

        var initialCenterpoint = CGPoint(x: center.x - (interItemSpacing * Double(baseWidthHalfCount)), y: center.y)
        initialCenterpoint = CGPointMake(initialCenterpoint.x, center.y - (lineSpacing * Double(baseHeightHalfCount)));

        let bezierPath = UIBezierPath()
        for i in 0..<baseHeightCount {
            let currentLineStartCenterPoint = CGPoint(x: initialCenterpoint.x, y: initialCenterpoint.y + lineSpacing * CGFloat(i))
            
            for j in 0..<baseWidthCount {
                let currentCenterPoint = CGPoint(x: currentLineStartCenterPoint.x + interItemSpacing * CGFloat(j), y: currentLineStartCenterPoint.y)
                
                let path = UIBezierPath.init(bigRegularPolygonAtCenter: currentCenterPoint, radius: radius, numberOfSides: 6)
                bezierPath.append(path)
            }
        }
        
        //! 사이에 끼인 것 line을 만든다.
        let transform = CGAffineTransform(translationX: -radius, y: lineSpacing / 2.0)
        let secondInitialCenterpoint = initialCenterpoint.applying(transform)
        let secondBaseWidthCount = baseWidthCount + 1
        let secondBaseHeightCount = baseHeightCount - 1
        
        for i in 0..<secondBaseHeightCount {
            let currentLineStartCenterPoint = CGPoint(x: secondInitialCenterpoint.x, y: secondInitialCenterpoint.y + lineSpacing * CGFloat(i))
            for j in 0..<secondBaseWidthCount {
                let currentCenterPoint = CGPoint(x: currentLineStartCenterPoint.x + interItemSpacing * CGFloat(j), y: currentLineStartCenterPoint.y)
                let path = UIBezierPath.init(bigRegularPolygonAtCenter: currentCenterPoint, radius: radius, numberOfSides: 6)
                   bezierPath.append(path)
            }
        }
        shapeLayer.path = bezierPath.cgPath
    }
}
