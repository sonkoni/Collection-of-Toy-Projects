//
//  ChartSettingCell.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit
import IosKit

final class StandardLineSettingCell: UITableViewCell {
    
    // MARK: - Property
    
    weak var data: DTOStandardLineSetting? {
        didSet {
            guard let model = data
            else {
                return
            }
            selectionBtn.setTitle(model.title, for: .normal)
            if reuseIdentifier == StandardLineSettingCellID.toggleDrop.rawValue {
                dropButton.selectedIndex = model.dropBtnSelectedIndex
                if toggleSwitch.isOn != model.isToggleOn {
                    toggleSwitch.isOn = model.isToggleOn
                }
                if dropButton.isEnabled != !model.dropBtnHidden {
                    dropButton.isEnabled = !model.dropBtnHidden
                }
                //
                // hidden에서 disable로 바뀌었다.
                // if (self.dropButton.isHidden != model.dropBtnHidden) {
                //     self.dropButton.hidden = model.dropBtnHidden;
                // }
            } else if reuseIdentifier == StandardLineSettingCellID.toggle.rawValue {
                if toggleSwitch.isOn != model.isToggleOn {
                    toggleSwitch.isOn = model.isToggleOn
                }
                
            } else if reuseIdentifier == StandardLineSettingCellID.normal.rawValue {
                if selectionBtn.isSelected != model.isSelected {
                    selectionBtn.isSelected = model.isSelected
                }
                dropButton.selectedIndex = model.dropBtnSelectedIndex
                colorBtn.backgroundColor = model.color
            } else if reuseIdentifier == StandardLineSettingCellID.user.rawValue {
                if selectionBtn.isSelected != model.isSelected {
                    selectionBtn.isSelected = model.isSelected
                }
                if ratioButton.isSelected != model.isRatio {
                    ratioButton.isSelected = model.isRatio
                }
                dropButton.selectedIndex = model.dropBtnSelectedIndex
                colorBtn.backgroundColor = model.color
                textInputButton.setTitle(model.textInputBtnTitle, for: .normal)
                textField.placeholder = model.textFieldPlaceHolderTitle
                textField.text = model.textFieldTitle
            }
        }
    }
    
    @IBOutlet weak var textField: UITextField!
        
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var contentContainer: UIView!
        
    @IBOutlet weak var colorBtn: SKUBrightnessBorderButton!
    @IBOutlet weak var ratioButton: UIButton!
    @IBOutlet weak var dropButton: SKUDropdownButton!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var textInputButton: UIButton!
    
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
        contentContainer.backgroundColor = .clear
           
        /// Top tableView
        if reuseIdentifier == StandardLineSettingCellID.toggleDrop.rawValue {
            setupToggleDropMode()
        } else if reuseIdentifier == StandardLineSettingCellID.toggle.rawValue {
            setupToggleMode()
        }
        
        /// Bottom tableView
        if reuseIdentifier == StandardLineSettingCellID.normal.rawValue {
            setupNormalMode()
        } else if reuseIdentifier == StandardLineSettingCellID.user.rawValue {
            setupUserMode()
        }
    }
    
    private func setupToggleDropMode() {
        dropButton.backgroundColor = .clear
        dropButton.defaultBackgroundColor = .white
        dropButton.disabledBackgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        dropButton.cellClass = SKUTextDropdownCell.self
        dropButton.dropdownData = ["Left", "Center", "Right"]
        dropButton.selectedIndex = 0
        dropButton.placeHolderTextAlignment = .center
        dropButton.textAlignment = .left
    }
    
    private func setupToggleMode() {
        // Implement setupToggleMode if needed
    }
    
    private func setupNormalMode() {
        setupSelectionBtn()
        setupDropdownBtn()
    }
    
    private func setupUserMode() {
        setupSelectionBtn()
        setupDropdownBtn()
            
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.returnKeyType = .done
            
        ratioButton.backgroundColor = .clear
        ratioButton.layer.cornerRadius = 4.0
            
        textInputButton.backgroundColor = .white
        textInputButton.layer.borderColor = UIColor.lightGray.cgColor
        textInputButton.layer.borderWidth = 1.0 / UIScreen.main.scale
        textInputButton.layer.cornerRadius = 5.0
        textInputButton.setTitleColor(.systemBlue, for: .normal)
        textInputButton.setTitleColor(.gray, for: .disabled)
        textInputButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textInputButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    /// Helper
    private func setupSelectionBtn() {
        selectionBtn.isUserInteractionEnabled = true
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
            // let designTimeBundle = Bundle(for: Self.self)
            // selectedImage = UIImage(named: "checkmark.circle.fill", in: designTimeBundle, compatibleWith: nil)
            // selectedImage = selectedImage?.withRenderingMode(.alwaysTemplate)
            // normalImage = UIImage(named: "checkmark.circle", in: designTimeBundle, compatibleWith: nil)
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
        
    private func setupDropdownBtn() {
        dropButton.backgroundColor = .clear
        dropButton.cellClass = SKULineWidthDropdownCell.self
        dropButton.dropdownData = [-12, 0, 1, 2, 3, 4, 5]
        dropButton.selectedIndex = 0
    }
        
    // MARK: - Actions
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        guard let data = data
        else {
            return
        }
        data.isToggleOn = sender.isOn
        self.data = data
    }
}
