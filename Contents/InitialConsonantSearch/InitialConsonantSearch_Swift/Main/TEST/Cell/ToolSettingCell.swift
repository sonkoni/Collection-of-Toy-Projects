//
//  ChartTypeCell.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit

final class ToolSettingCell: UITableViewCell {
    
    // MARK: - Property
    
    var title: String? {
        didSet {
            titleLabel.setTitle(title, for: .normal)
        }
    }
    
    @IBOutlet private weak var titleLabel: UIButton!
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.backgroundColor = .clear
        titleLabel.isUserInteractionEnabled = false
        showsReorderControl = true
        backgroundColor = .white // 드래그 시 그림자를 나오게 해야한다
    }
}
