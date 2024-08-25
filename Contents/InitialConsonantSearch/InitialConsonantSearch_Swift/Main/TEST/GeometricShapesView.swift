//
//  GeometricShapesView.swift
//  ToolSettingTest_Swift
//
//  Created by Kwan Hyun Son on 2023/09/15.
//

import UIKit

extension GeometricShapesView {
    
    // MARK: - Nested Type
    
    enum Kind: Int {
        case ellipse = 0 // 타원
        case rectangle   // 사각형
        case triangle    // 삼각형
    }
}

final class GeometricShapesView: UIView {
    
    // MARK: - Property
    
    var geometricShapesType: Kind = .ellipse {
        didSet {
            setNeedsLayout()
        }
    }
    var borderColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    var borderWidth: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    var backColor: UIColor = .cyan {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    // MARK: - Override
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawGeometricShapes()
    }
    
    // MARK: - 생성 & 소멸
    
    convenience init(type: Kind) {
        self.init(frame: CGRect.zero)
        geometricShapesType = type
    }
    
    private func commonInit() { }
    
    // MARK: - Actions
    
    private func drawGeometricShapes() {
        switch geometricShapesType {
        case .ellipse:
            drawEllipse()
        case .rectangle:
            drawRectangle()
        case .triangle:
            drawTriangle()
        }
        
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = backColor.cgColor
    }
    
    private func drawEllipse() {
        let path = UIBezierPath(ovalIn: bounds)
        shapeLayer.path = path.cgPath
    }
    
    private func drawRectangle() {
        let path = UIBezierPath(rect: bounds)
        shapeLayer.path = path.cgPath
    }
    
    private func drawTriangle() {
        let p1 = CGPoint(x: bounds.width / 2.0, y: 0.0)
        let p2 = CGPoint(x: 0.0, y: bounds.height)
        let p3 = CGPoint(x: bounds.width, y: bounds.height)
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.close()
        shapeLayer.path = path.cgPath
    }
}

