//
//  IndicatorSettingCell.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit
import BaseKit
import IosKit

final class IndicatorSettingDetailCell: UITableViewCell {
    
    // MARK: - Property
    
    var data: DTOIndicatorDetailSetting? {
        didSet {
            if reuseIdentifier == IndicatorSettingDetailCellID.description.rawValue {
                let style = NSMutableParagraphStyle()
                style.headIndent = 14
                let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: style]
                let richText = NSAttributedString(
                    string: data?.title ?? "",
                    attributes: attributes
                )
                if #available(iOS 14, *) {
                    var content = self.defaultContentConfiguration()
                    content.attributedText = richText
                    self.contentConfiguration = content
                } else {
                    self.textLabel?.attributedText = richText
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    // MARK: - 생성 & 소멸
    
    private func commonInit() {
        selectionStyle = .none
        if let reuseIdentifier = self.reuseIdentifier {
            if reuseIdentifier == IndicatorSettingDetailCellID.normal.rawValue {
                
            } else if reuseIdentifier == IndicatorSettingDetailCellID.description.rawValue {
                setupDescriptionMode()
            }
        }
    }
    
    private func setupDescriptionMode() {
        
        if #available(iOS 14, *) {
            var content = defaultContentConfiguration()
            content.textProperties.numberOfLines = 0
            contentConfiguration = content
        } else {
            textLabel?.numberOfLines = 0
        }
        
    }
    
}
