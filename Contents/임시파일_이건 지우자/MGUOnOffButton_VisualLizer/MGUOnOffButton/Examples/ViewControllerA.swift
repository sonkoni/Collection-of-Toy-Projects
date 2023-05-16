//
//  ViewControllerA.swift
//  MGUOnOffButton
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var container1: UIView!
    @IBOutlet private weak var container2: UIView!
    @IBOutlet private weak var container3: UIView!
    @IBOutlet private weak var container4: UIView!
    private var button = MGUOnOffButton(frame: .zero, skinView: MMTMidButtonSkin())
    private var button2 = MGUOnOffButton(frame: .zero, skinView: MMTTopButtonSkin())
    private var button3 = MGUOnOffButton(frame: .zero, skinView: MMTBottomButtonSkin())
    private var button4 = MGUOnOffButton(frame: .zero, skinView: MGUOnOffButtonLockSkin())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MGUOnOffButton Samples"
        view.backgroundColor = .white
        
        let containers = [container1, container2, container3, container4]
        let buttons = [button, button2, button3, button4]
        for (container, button) in zip(containers, buttons) {
            container?.backgroundColor = .clear
            container?.addSubview(button)
            button.mgrPinEdgesToSuperviewEdges()
        }
    }
}
