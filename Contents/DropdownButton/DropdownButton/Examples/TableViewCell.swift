//
//  TableViewCell.swift
//  DropdownButton
//
//  Created by Kwan Hyun Son on 11/25/23.
//

import UIKit
import IosKit

enum TableViewCellID: String {
    case text = "text"
    case subPlus = "subPlus"
    case subMinus = "subMinus"
    case subNormal = "subNormal"
    case favorite = "favorite"
    case favoriteSub = "favoriteSub"
    case search = "search"
}

class TableViewCell: UITableViewCell {
    
    var data: (any Equatable)? {
        didSet {
            if let stringArr = data as? [String] {
                
            }
        }
    }

    @IBOutlet private weak var container1: UIView!
    @IBOutlet private weak var container2: UIView!
    @IBOutlet private weak var dropdownButton1: SKUDropdownButton!
    @IBOutlet private weak var dropdownButton2: MGUDropdownButton!
    @IBOutlet private weak var widthLayoutConstraint1: NSLayoutConstraint!
    @IBOutlet private weak var widthLayoutConstraint2: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
        // MARK: - 생성 & 소멸
    private func commonInit() {
        selectionStyle = .none
        dropdownButton1.backgroundColor = .clear
        dropdownButton2.backgroundColor = .clear
        if reuseIdentifier == TableViewCellID.text.rawValue {
            dropdownButton1.cellClass = SKUTextDropdownCell.self
            dropdownButton1.dropdownData = ["목업0", "목업1", "목업2"]
            dropdownButton1.selectedIndex = 1
            dropdownButton1.placeHolderTextAlignment = .center
            dropdownButton1.textAlignment = .center
            
            dropdownButton2.cellClass = MGUTextDropdownCell.self
            dropdownButton2.dropdownData = ["목업0", "목업1", "목업2"]
            dropdownButton2.selectedIndex = 1
            dropdownButton2.placeHolderTextAlignment = .center
            dropdownButton2.textAlignment = .center
        } else if reuseIdentifier == TableViewCellID.subPlus.rawValue {
            
        }
    }
}
