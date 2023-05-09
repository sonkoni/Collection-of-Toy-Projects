//
//  ViewControllerA.swift
//  AutoLayout_Animation
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var targetView: UIView!
    @IBOutlet private var centerXConstraint: NSLayoutConstraint!
    @IBOutlet private var centerYConstraint: NSLayoutConstraint!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.targetView.translatesAutoresizingMaskIntoConstraints = false
        self.targetView.layer.cornerRadius = 25.0
    }
    

    // MARK: - Action
    @IBAction func buttonClicked(_ sender: UISwitch) {
        sender.isEnabled = false
        
        self.centerYConstraint.isActive = false
        if sender.isOn == true {
            self.centerYConstraint = self.targetView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            self.widthConstraint.constant = 100.0
        } else {
            self.centerYConstraint = self.targetView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
            self.widthConstraint.constant = 50.0
        }
        self.centerYConstraint.isActive = true
        
        let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) {
            self.view.layoutIfNeeded()
        }
        animator.addCompletion {_ in
            sender.isEnabled = true
        }
        animator.startAnimation()
    }
}
