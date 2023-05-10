//
//  ViewControllerA.swift
//  AutoLayout_Adaptivity
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    // @IBOutlet private weak var targetView: UIView!
    // @IBOutlet private var centerXConstraint: NSLayoutConstraint! // strong으로 잡아야 active 전환에서 문제를 방지한다.
    // @IBOutlet private var centerYConstraint: NSLayoutConstraint!
    // @IBOutlet private var widthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        targetView.translatesAutoresizingMaskIntoConstraints = false
//        targetView.layer.cornerRadius = 25.0
//        
//        let mySwitch = UISwitch()
//        mySwitch.onTintColor = .tintColor
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mySwitch)
//        mySwitch.addTarget(self, action:#selector(switchToggled(_:)), for: .valueChanged)
    }
    
    
    // MARK: - Action
//    @objc private func switchToggled(_ sender: UISwitch) {
//        sender.isEnabled = false
//        centerYConstraint.isActive = false
//        if sender.isOn == true {
//            centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            widthConstraint.constant = 100.0
//        } else {
//            centerYConstraint = targetView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0)
//            widthConstraint.constant = 50.0
//        }
//        centerYConstraint.isActive = true
//
//        let animator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) {
//            self.view.layoutIfNeeded() // 애니메이션 블락 안에서 layoutIfNeeded 메서드를 호출해야한다.
//        }
//        animator.addCompletion { _ in
//            sender.isEnabled = true
//        }
//        animator.startAnimation()
//    }
}
