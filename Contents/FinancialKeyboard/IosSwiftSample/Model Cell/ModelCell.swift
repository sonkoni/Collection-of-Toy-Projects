//
//  File.swift
//  IosSwiftFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

import IosKit
import UIKit

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet var separatorConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
    }
}

class FTableViewCell: UITableViewCell {
    @IBOutlet var separatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var minCheckBtn: UIButton!
    @IBOutlet weak var tickCheckBtn: UIButton!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var tickModifyBtn: UIButton!
    @IBOutlet weak var minField: SKUFinancialTextField!
    @IBOutlet weak var financialTextField: SKUFinancialTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorConstraint.constant = 1.0 / UIScreen.main.scale
        tickModifyBtn.layer.cornerRadius = 4.0
        tickModifyBtn.layer.masksToBounds = true
        tickModifyBtn.layer.borderColor = UIColor.darkGray.cgColor
        tickModifyBtn.layer.borderWidth = 1.0 / UIScreen.main.scale
        tickModifyBtn.backgroundColor = UIColor.white

        for button in [minCheckBtn, tickCheckBtn] {
            if #available(iOS 13.0, *) {
                button?.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
                button?.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            } else {
                let selectedImage = UIImage(named: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
                let normalImage = UIImage(named: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
                button?.imageView?.contentMode = .center
                button?.tintColor = UIColor.systemRed
            }
        }
    }
}

class DTOMinTick: NSObject {
    var selected: Bool = false
    var cycle: Int = 0

    class func dto(with cycle: Int, selected: Bool) -> DTOMinTick {
        let result = DTOMinTick()
        result.cycle = cycle
        result.selected = selected
        return result
    }
}
