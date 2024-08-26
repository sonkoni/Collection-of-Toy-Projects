//
//  ViewController.swift
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/10/10.
//

import UIKit
import BaseKit
import IosKit

class ViewController0: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    var dropdownButton1 = SKUDropdownButton()
    var dropdownButton2 = SKUDropdownButton()
    var dropdownButton3 = SKUDropdownButton()
    var dropdownButton4 = SKUDropdownButton()
    var dropdownButton5 = SKUDropdownButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SKUDropdownButton"
        
        dropdownButton1.cellClass = SKULineWidthDropdownCell.self
        dropdownButton1.dropdownData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        dropdownButton1.selectedIndex = 0
        dropdownButton1.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(dropdownButton1)
        
        dropdownButton1.translatesAutoresizingMaskIntoConstraints = false
        self.dropdownButton1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        self.dropdownButton1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50.0).isActive = true
        self.dropdownButton1.widthAnchor.constraint(equalToConstant: 78.0).isActive = true
        dropdownButton1.defaultBackgroundColor = SKUDropdownButton.defaultBackgroundColor
        
        dropdownButton2.cellClass = SKUTextDropdownCell.self
        dropdownButton2.dropdownData = ["전봉색상", "전값대비", "보합색"]
        dropdownButton2.selectedIndex = 0
        dropdownButton2.dismissOnRotation = false // 회전 시 안사라지게 할 수 있다.
        dropdownButton2.placeHolderTextAlignment = .right
        dropdownButton2.textAlignment = .left
        dropdownButton2.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(dropdownButton2)
        dropdownButton2.skhPinCenterToSuperviewCenterWithFixSize(CGSize(width: 90.0, height: 28.0))
        
        
        dropdownButton3.cellClass = SKULineDashDropdownCell.self
        dropdownButton3.dropdownData = [0, 1, 2, 3, 4]
        dropdownButton3.selectedIndex = 0
        dropdownButton3.dismissOnRotation = false // 회전 시 안사라지게 할 수 있다.
        contentView.addSubview(dropdownButton3)
        dropdownButton3.translatesAutoresizingMaskIntoConstraints = false
        self.dropdownButton3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-50.0).isActive = true
        self.dropdownButton3.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50.0).isActive = true
        self.dropdownButton3.widthAnchor.constraint(equalToConstant: 78.0).isActive = true
        dropdownButton3.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
        
        let image1 = UIImage.init(named: "stockfill.rect.stretch")
        let image2 = UIImage.init(named: "stockfill.oval")
        let image3 = UIImage.init(named: "stockfill.rect")
        
        dropdownButton4.cellClass = SKUImageDropdownCell.self
        dropdownButton4.dropdownData = [image1, image2, image3]
        dropdownButton4.selectedIndex = 0
        dropdownButton4.dismissOnRotation = false // 회전 시 안사라지게 할 수 있다.
        contentView.addSubview(dropdownButton4)
        dropdownButton4.translatesAutoresizingMaskIntoConstraints = false
        self.dropdownButton4.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-50.0).isActive = true
        self.dropdownButton4.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 150.0).isActive = true
        self.dropdownButton4.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        dropdownButton4.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
        
        dropdownButton5.cellClass = SKUFillTypeDropdownCell.self
        dropdownButton5.dropdownData = ["영역 채움", SKUDropdownCellFillType.horizontal, SKUDropdownCellFillType.verical, SKUDropdownCellFillType.diagonalCounterClockwise, SKUDropdownCellFillType.diagonalClockwise, SKUDropdownCellFillType.cross, SKUDropdownCellFillType.x,  SKUDropdownCellFillType.empty]
        dropdownButton5.selectedIndex = 0
        dropdownButton5.dismissOnRotation = false // 회전 시 안사라지게 할 수 있다.
        contentView.addSubview(dropdownButton5)
        dropdownButton5.translatesAutoresizingMaskIntoConstraints = false
        self.dropdownButton5.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:-50.0).isActive = true
        self.dropdownButton5.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200.0).isActive = true
        self.dropdownButton5.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        dropdownButton5.addTarget(self, action: #selector(dropdownBtnValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func dropdownBtnValueChanged(_ sender: SKUDropdownButton?) {
        if sender === dropdownButton1 {
            print("dropdownButton1 값 변화 \(String(describing: sender?.selectedIndex))")
        } else if sender === dropdownButton2 {
            print("dropdownButton2 값 변화 \(String(describing: sender?.selectedIndex))")
        } else if sender === dropdownButton3 {
            print("dropdownButton3 값 변화 \(String(describing: sender?.selectedIndex))")
        } else if sender === dropdownButton4 {
            print("dropdownButton4 값 변화 \(String(describing: sender?.selectedIndex))")
        } else if sender === dropdownButton5 {
            print("dropdownButton5 값 변화 \(String(describing: sender?.selectedIndex))")
        }
    }
    
    func hello(_ state:MGREmptyState) {
        print(state)
    }

}

