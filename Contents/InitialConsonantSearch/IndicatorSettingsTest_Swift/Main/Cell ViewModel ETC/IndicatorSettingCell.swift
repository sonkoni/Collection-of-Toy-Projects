//
//  IndicatorSettingCell.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit
import BaseKit
import IosKit

final class IndicatorSettingCell: UITableViewCell {
    
    // MARK: - Property
    
    var data: DTOIndicatorSetting? {
        didSet {
            adjustOutlineData()
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            let prettyName = DTOIndicatorSetting.prettyName(data?.title ?? "")
            selectionBtn.setTitle(prettyName, for: .normal)

            if reuseIdentifier == IndicatorSettingCellID.section.rawValue {
            } else if reuseIdentifier == IndicatorSettingCellID.subPlus.rawValue ||
                      reuseIdentifier == IndicatorSettingCellID.subMinus.rawValue ||
                      reuseIdentifier == IndicatorSettingCellID.subNormal.rawValue ||
                      reuseIdentifier == IndicatorSettingCellID.region.rawValue ||
                      reuseIdentifier == IndicatorSettingCellID.favorite.rawValue ||
                      reuseIdentifier == IndicatorSettingCellID.favoriteSub.rawValue {
                
                selectionBtn.isSelected = data?.isSelected ?? false
                
                if data?.isSelected ?? false {
                    settingBtn.alpha = 1.0
                    settingBtn.isUserInteractionEnabled = true
                } else {
                    settingBtn.alpha = 0.0
                    settingBtn.isUserInteractionEnabled = false
                }
                
                if reuseIdentifier == IndicatorSettingCellID.subPlus.rawValue ||
                   reuseIdentifier == IndicatorSettingCellID.subNormal.rawValue ||
                   reuseIdentifier == IndicatorSettingCellID.region.rawValue ||
                   reuseIdentifier == IndicatorSettingCellID.favorite.rawValue {
                    self.favBtn.isSelected = data?.isFavorite ?? false
                    if favBtn.isSelected {
                        favBtn.imageView?.tintColor = .systemYellow
                        favBtn.tintColor = .systemYellow
                    } else {
                        favBtn.imageView?.tintColor = .lightGray
                        favBtn.tintColor = .lightGray
                    }
                }
                
                if reuseIdentifier == IndicatorSettingCellID.favorite.rawValue ||
                   reuseIdentifier == IndicatorSettingCellID.favoriteSub.rawValue {
                    applyCategoryLabel(favoriteCategoryLabel)
                }
            } else if reuseIdentifier == IndicatorSettingCellID.search.rawValue {
                applyCategoryLabel(searchCategoryLabel)
            }
            
            CATransaction.commit()
        }
    }
    var isExpanded = false {
        didSet {
            if self.reuseIdentifier == IndicatorSettingCellID.section.rawValue {
                configureChevron()
            }
        }
    }
    
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var pmBtn: UIButton!
    @IBOutlet weak var disclosureImageView: UIImageView!
    @IBOutlet weak var indentImageView: UIImageView!
    @IBOutlet weak var searchCategoryLabel: UILabel!
    private lazy var favoriteCategoryLabel: UILabel = {
        let result = UILabel()
        setupCategoryLabel(result)
        result.isUserInteractionEnabled = false // 디폴트
        selectionBtn.addSubview(result)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        result.heightAnchor.constraint(equalToConstant: 12.0).isActive = true
        result.centerYAnchor.constraint(equalTo: selectionBtn.centerYAnchor).isActive = true
        result.leadingAnchor.constraint(equalTo: selectionBtn.leadingAnchor, constant: 30.0).isActive = true
        return result
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if selectionBtn != nil {
            selectionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            selectionBtn.titleLabel?.minimumScaleFactor = 0.5
            selectionBtn.tintAdjustmentMode = .normal
            selectionBtn.setTitleColor(.black, for: .normal)
        }
        commonInit()
    }
    
    override var indentationLevel: Int {
        didSet {
            separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        }
    }
    
    // MARK: - 생성 & 소멸
    
    private func commonInit() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let reuseIdentifier = self.reuseIdentifier {
            if reuseIdentifier == IndicatorSettingCellID.section.rawValue {
                setupSectionMode()
            } else if reuseIdentifier == IndicatorSettingCellID.subPlus.rawValue {
                setupSubPlus()
            } else if reuseIdentifier == IndicatorSettingCellID.subMinus.rawValue {
                setupSubMinus()
            } else if reuseIdentifier == IndicatorSettingCellID.subNormal.rawValue {
                setupSubNormal()
            } else if reuseIdentifier == IndicatorSettingCellID.region.rawValue {
                setupRegion()
            } else if reuseIdentifier == IndicatorSettingCellID.favorite.rawValue {
                setupFavorite()
            } else if reuseIdentifier == IndicatorSettingCellID.favoriteSub.rawValue {
                setupFavoriteSub()
            } else if reuseIdentifier == IndicatorSettingCellID.search.rawValue {
                setupSearch()
            }
        }
        CATransaction.commit()
    }
    
    private func setupSectionMode() {
        countLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        countLabel.adjustsFontSizeToFitWidth = true
        countLabel.minimumScaleFactor = 0.5
        countLabel.textAlignment = .left
        disclosureImageView.image = Defines.imageNamed(.chevronForward, renderingMode: .alwaysTemplate)
    }
    
    private func setupSubPlus() {
        setupSelectionBtn()
        setupSettingBtn()
        setupFavBtn()
        setupPlusBtn()
    }
    
    private func setupSubMinus() {
        favBtn.setImage(nil, for: .normal)
        favBtn.setImage(nil, for: .selected)
        setupIndentBtn()
        setupSelectionBtn()
        setupSettingBtn()
        setupMinusBtn()
    }
    
    private func setupSubNormal() {
        setupSelectionBtn()
        setupSettingBtn()
        setupFavBtn()
    }
    
    private func setupRegion() {
        setupSelectionBtn()
        setupSettingBtn()
        setupFavBtn()
    }
    
    private func setupFavorite() {
        setupSelectionBtn()
        setupSettingBtn()
        setupFavBtn()
    }
    
    private func setupFavoriteSub() {
        favBtn.setImage(nil, for: .normal)
        favBtn.setImage(nil, for: .selected)
        setupIndentBtn()
        setupSelectionBtn()
        setupSettingBtn()
    }
    
    private func setupSearch() {
        setupCategoryLabel(searchCategoryLabel)
        selectionBtn.isUserInteractionEnabled = false
        selectionBtn.setImage(nil, for: .normal)
        selectionBtn.setImage(nil, for: .selected)
    }
    
    // MARK: - Private
    
    private func adjustOutlineData() {
        guard let outlineItem = data?.outlineItem else {
            return
        }
        
        isExpanded = outlineItem.isExpanded
        indentationLevel = outlineItem.indentationLevel
        if reuseIdentifier == IndicatorSettingCellID.section.rawValue, 
           let recurrenceAllSubitems = outlineItem.recurrenceAllSubitems {
            let recurrenceAllActiveSubitems = recurrenceAllSubitems.filter({ $0.contentItem?.isSelected == true })
            let activeCount = recurrenceAllActiveSubitems.count
            if activeCount > 0 {
                countLabel.alpha = 1.0
                countLabel.text = "(\(activeCount))"
            } else {
                countLabel.alpha = 0.0
            }
        }
    }
    
    private func configureChevron() {
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let rtlMultiplier: CGFloat = rtl ? -1.0 : 1.0
        let rotationTransform = isExpanded ? CGAffineTransform(rotationAngle: rtlMultiplier * .pi / 2) : CGAffineTransform.identity
        disclosureImageView.transform = rotationTransform
    }

    private func applyCategoryLabel(_ label: UILabel) {
        guard let data = data else {
            return
        }
        if data.mainCategory == .indicators {
            label.text = IndiSetMainCategory.indicators.rawValue
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.textColor = UIColor.darkGray
        } else if data.mainCategory == .signals {
            label.text = IndiSetMainCategory.signals.rawValue
            label.layer.borderColor = UIColor.systemGreen.cgColor
            label.textColor = UIColor.systemGreen
        } else if data.mainCategory == .patterns {
            label.text = IndiSetMainCategory.patterns.rawValue
            label.layer.borderColor = UIColor.systemYellow.cgColor
            label.textColor = UIColor.systemYellow
        } else if data.mainCategory == .ranges {
            label.text = IndiSetMainCategory.ranges.rawValue
            label.layer.borderColor = UIColor.systemBlue.cgColor
            label.textColor = UIColor.systemBlue
        } else if data.mainCategory == .fill {
            label.text = IndiSetMainCategory.fill.rawValue
            if #available(iOS 15, *) {
                label.layer.borderColor = UIColor.systemMint.cgColor
                label.textColor = UIColor.systemMint
            } else {
                label.layer.borderColor = UIColor.brown.cgColor
                label.textColor = UIColor.brown
            }
        }
    }

}

// detail setting
private extension IndicatorSettingCell {
    func setupSelectionBtn() {
        selectionBtn.imageView?.contentMode = .center
        let tintColor = UIColor(red: 15.0/255.0, green: 40.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        selectionBtn.tintColor = tintColor
        selectionBtn.imageView?.tintColor = tintColor
        let selectedImage = Defines.imageNamed(.checkmarkCircleFill, renderingMode: .alwaysTemplate)
        let normalImage = Defines.imageNamed(.uncheckmarkCircleOpaque, renderingMode: .alwaysOriginal)
        selectionBtn.skhSetSelectedImage(selectedImage: selectedImage, normalImage: normalImage, preventHighlight: true)
        selectionBtn.setTitleColor(.black, for: .selected)
        selectionBtn.setTitleColor(.black, for: .normal)
    }
    
    func setupSettingBtn() {
        settingBtn.imageView?.contentMode = .center
        let tintColor = UIColor.lightGray
        settingBtn.tintColor = tintColor
        settingBtn.imageView?.tintColor = tintColor
        let normalImage = Defines.imageNamed(.gearshape, renderingMode: .alwaysTemplate)
        settingBtn.setImage(normalImage, for: .normal)
    }
    
    func setupFavBtn() {
        favBtn.imageView?.contentMode = .center
        let tintColor = UIColor.lightGray
        favBtn.imageView?.tintColor = tintColor
        let selectedImage = Defines.imageNamed(.starFill, renderingMode: .alwaysTemplate)
        let normalImage = Defines.imageNamed(.star, renderingMode: .alwaysTemplate)
        favBtn.setImage(selectedImage, for: .selected)
        favBtn.setImage(normalImage, for: .normal)
    }
    
    func setupPlusBtn() {
        pmBtn.imageView?.contentMode = .center
        let tintColor = UIColor.lightGray
        pmBtn.tintColor = tintColor
        pmBtn.imageView?.tintColor = tintColor
        let normalImage = Defines.imageNamed(.plus, renderingMode: .alwaysTemplate)
        pmBtn.setImage(normalImage, for: .normal)
    }
    
    func setupMinusBtn() {
        pmBtn.imageView?.contentMode = .center
        let tintColor = UIColor.lightGray
        pmBtn.tintColor = tintColor
        pmBtn.imageView?.tintColor = tintColor
        let normalImage = Defines.imageNamed(.minus, renderingMode: .alwaysTemplate)
        pmBtn.setImage(normalImage, for: .normal)
    }
    
    func setupIndentBtn() {
        indentImageView.contentMode = .center
        indentImageView.tintColor = UIColor.lightGray
        indentImageView.image = Defines.imageNamed(.indent, renderingMode: .alwaysTemplate)
    }

    func setupCategoryLabel(_ label: UILabel) {
        label.layer.borderWidth = 1.0 / UIScreen.main.scale
        label.layer.cornerRadius = 3.0
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.text = "지표"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
    }
}
