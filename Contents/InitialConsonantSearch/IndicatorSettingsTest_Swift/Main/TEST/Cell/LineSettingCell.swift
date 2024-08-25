//
//  ChartSettingCell.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit
import IosKit

final class LineSettingCell: UITableViewCell {
    
    // MARK: - Property
    
    weak var data: DTOLineSetting? {
        didSet {
            guard let model = data
            else {
                return
            }
            
            if let selectionBtn = selectionBtn {
                selectionBtn.setTitle(model.title, for: .normal)
            }
            
            if reuseIdentifier == LineSettingCellID.colorFill.rawValue {
                colorBtn.backgroundColor = model.color
                if let selectionBtn = selectionBtn, selectionBtn.isSelected != model.isSelected {
                    selectionBtn.isSelected = model.isSelected
                }
            } else if reuseIdentifier == LineSettingCellID.color.rawValue {
                colorBtn.backgroundColor = model.color
            } else if reuseIdentifier == LineSettingCellID.colorDrop.rawValue {
                colorBtn.backgroundColor = model.color
                dropButton.selectedIndex = model.dropBtnSelectedIndex
            } else if reuseIdentifier == LineSettingCellID.toggle.rawValue {
                toggleSwitch.isOn = model.isToggleOn
            } else if reuseIdentifier == LineSettingCellID.textInput.rawValue {
                textInputButton.setTitle(model.textInputBtnTitle, for: .normal)
            } else if reuseIdentifier == LineSettingCellID.drop.rawValue {
                if let dropBtnTitles = model.dropBtnTitles, dropBtnTitles.count > 0 {
                    dropButton.dropdownData = dropBtnTitles
                }
                dropButton.selectedIndex = model.dropBtnSelectedIndex
            } else if reuseIdentifier == LineSettingCellID.font.rawValue {
                if boldButton.isSelected != model.isBold {
                    boldButton.isSelected = model.isBold
                }
                if dropButton.selectedIndex != model.dropBtnSelectedIndex {
                    dropButton.selectedIndex = model.dropBtnSelectedIndex
                }
            } else if reuseIdentifier == LineSettingCellID.geometricShapes.rawValue {
                geometricShapesView.geometricShapesType = model.geometricShapesType
                geometricShapesView.borderColor = model.geometricShapesBorderColor ?? .clear
                geometricShapesView.borderWidth = model.geometricShapesBorderWidth
                geometricShapesView.backColor = model.geometricShapesBackColor ?? .white
            }
        }
    }
    
    @IBOutlet weak var dropButtonWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selectionBtn: UIButton?
    @IBOutlet private weak var contentContainer: UIView!
    
    @IBOutlet private weak var colorBtn: SKUBrightnessBorderButton!
    @IBOutlet private weak var boldButton: UIButton!
    @IBOutlet private weak var dropButton: SKUDropdownButton!
    @IBOutlet private weak var toggleSwitch: UISwitch!
    @IBOutlet private weak var textInputButton: UIButton!
    
    @IBOutlet private weak var geometricShapesView: GeometricShapesView!
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let selectionBtn = self.selectionBtn {
            selectionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            selectionBtn.titleLabel?.minimumScaleFactor = 0.5
            
            selectionBtn.tintAdjustmentMode = .normal
            selectionBtn.isUserInteractionEnabled = false
            selectionBtn.translatesAutoresizingMaskIntoConstraints = false
            let constraint = selectionBtn.heightAnchor.constraint(equalToConstant: 44.0)
            constraint.priority = .defaultHigh
            constraint.isActive = true
            selectionBtn.setTitleColor(.black, for: .normal)
        }
        commonInit()
    }
    
    // MARK: - 생성 & 소멸
    
    private func commonInit() {
        contentContainer?.backgroundColor = .clear
        if reuseIdentifier == LineSettingCellID.colorFill.rawValue {
            setupColorFillMode()
        } else if reuseIdentifier == LineSettingCellID.color.rawValue {
            setupColorMode()
        } else if reuseIdentifier == LineSettingCellID.colorDrop.rawValue {
            setupColorDropMode()
        } else if reuseIdentifier == LineSettingCellID.toggle.rawValue {
            setupToggleMode()
        } else if reuseIdentifier == LineSettingCellID.textInput.rawValue {
            setupTextInputMode()
        } else if reuseIdentifier == LineSettingCellID.drop.rawValue {
            setupDropMode()
        } else if reuseIdentifier == LineSettingCellID.font.rawValue {
            setupFontMode()
        } else if reuseIdentifier == LineSettingCellID.geometricShapes.rawValue {
            setupGeometricShapesMode()
        }
    }
    
    private func setupColorFillMode() {
        colorBtn.backgroundColor = .systemMint
        colorBtn.layer.cornerRadius = 4.0
        selectionBtn?.isUserInteractionEnabled = true
        
        guard let selectionBtn = selectionBtn
        else {
            return
        }
        
        if #available(iOS 13, *) {
            if #available(iOS 15, *) {
                var configuration = selectionBtn.configuration
                configuration?.baseBackgroundColor = .clear
                selectionBtn.configuration = configuration
            }
            //
            // let config = UIImage.SymbolConfiguration(scale: .medium)
            // selectedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
            // normalImage = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        } else {
            selectionBtn.imageView?.contentMode = .center
            let tintColor = UIColor(red: 15.0/255.0, green: 40.0/255.0, blue: 71.0/255.0, alpha: 1.0)
            selectionBtn.tintColor = tintColor
            selectionBtn.imageView?.tintColor = tintColor
            //
            // let designTimeBundle = Bundle(for: type(of: self)) // Bundle(for: classForCoder) 이렇게도 가능할 듯
            // selectedImage = UIImage(named: "checkmark.circle.fill", in: designTimeBundle, compatibleWith: nil)
            // normalImage = UIImage(named: "checkmark.circle", in: designTimeBundle, compatibleWith: nil)
            // selectedImage = selectedImage?.withRenderingMode(.alwaysTemplate)
            // normalImage = normalImage?.withRenderingMode(.alwaysTemplate)
        }
        let designTimeBundle = Bundle(for: Self.self)
        var selectedImage = UIImage(named: "checkmark.circle.fill", in: designTimeBundle, compatibleWith: nil)
        selectedImage = selectedImage?.withRenderingMode(.alwaysTemplate)
        var normalImage = UIImage(named: "uncheckmark.circle", in: designTimeBundle, compatibleWith: nil)
        normalImage = normalImage?.withRenderingMode(.alwaysTemplate)
        selectionBtn.setImage(selectedImage, for: .selected)
        selectionBtn.setImage(normalImage, for: .normal)
        selectionBtn.setTitleColor(.black, for: .selected)
        selectionBtn.setTitleColor(.lightGray, for: .normal)
    }
    
    private func setupColorMode() {
        colorBtn.backgroundColor = .systemMint
        colorBtn.layer.cornerRadius = 4.0
    }

    private func setupColorDropMode() {
        colorBtn.backgroundColor = .systemMint
        colorBtn.layer.cornerRadius = 4.0
        dropButton.backgroundColor = .clear
        
        dropButton.cellClass = SKULineWidthDropdownCell.self
        dropButton.dropdownData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        dropButton.selectedIndex = 0
    }

    private func setupToggleMode() {
    }

    private func setupTextInputMode() {
        textInputButton.backgroundColor = .white
        textInputButton.layer.borderColor = UIColor.lightGray.cgColor
        textInputButton.layer.borderWidth = 1.0 / UIScreen.main.scale
        textInputButton.layer.cornerRadius = 5.0
        textInputButton.setTitleColor(.systemBlue, for: .normal)
        textInputButton.setTitleColor(.gray, for: .disabled)
        textInputButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textInputButton.titleLabel?.minimumScaleFactor = 0.5
    }

    private func setupDropMode() {
        dropButton.backgroundColor = UIColor.clear
        dropButton.cellClass = SKUTextDropdownCell.self
        dropButton.dropdownData = ["목업0", "목업1", "목업2"]
        dropButton.selectedIndex = 1
        dropButton.placeHolderTextAlignment = .center
        dropButton.textAlignment = .right
    }

    private func setupFontMode() {
        boldButton.backgroundColor = .clear
        boldButton.layer.cornerRadius = 4.0
        dropButton.backgroundColor = .clear
        dropButton.cellClass = SKUTextDropdownCell.self
        
        var dropdownData = [String]()
        for i in 10...50 {
            dropdownData.append("\(i)")
        }
        dropButton.dropdownData = dropdownData
        dropButton.layer.cornerRadius = 4.0
        dropButton.selectedIndex = 7
        dropButton.placeHolderTextAlignment = .center
        dropButton.textAlignment = .center
    }

    private func setupGeometricShapesMode() {
    }
}
