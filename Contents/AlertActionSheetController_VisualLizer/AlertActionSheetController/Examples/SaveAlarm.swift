//
//  ViewControllerB.swift
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class SaveAlarm: UIView {
    
    // MARK: - Property
    @IBOutlet private weak var miniLabel1: UILabel!
    @IBOutlet private weak var mainLabel1: UILabel!
    @IBOutlet private weak var switch1: UISwitch!
    @IBOutlet private weak var miniLabel2: UILabel!
    @IBOutlet private weak var mainLabel2: UILabel!
    @IBOutlet private weak var switch2: UISwitch!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    // MARK: - 생성 & 소멸
    private func commonInit() {
        let containerView = Bundle.main.loadNibNamed(String(describing: SaveAlarm.self), owner: self)?.last
        if let containerView = containerView as? UIView {
            self.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        miniLabel1.textColor = UIColor.init(dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.init(red: 0.49, green: 0.49, blue: 0.51, alpha: 1.0)
            } else {
                return UIColor.init(red: 0.59, green: 0.59, blue: 0.61, alpha: 1.0)
            }
        })
        miniLabel2.textColor = miniLabel1.textColor
    }
    
    // MARK: - UNAVAILABLE
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
