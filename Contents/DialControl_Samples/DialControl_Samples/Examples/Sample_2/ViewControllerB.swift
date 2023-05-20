//
//  ViewControllerB.swift
//  DialControl_Samples
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import AudioKit
import IosKit

final class ViewControllerB: UIViewController {
    
    // MARK: - Property
    @IBOutlet weak var container: UIView!
    var sound: MGOSoundRuler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mini Timer - DialControl"
        sound = MGOSoundRuler.rulerSound
        view.backgroundColor = .white
        let dialControl = MMTDialControl()
        dialControl.normalSoundPlayBlock = sound?.playSoundTickHaptic()
        container.addSubview(dialControl)
        dialControl.mgrPinEdgesToSuperviewEdges()
        dialControl.addTarget(self, action:#selector(dialValueChanged(_:)), for: .valueChanged)
    }
    
    
    // MARK: - Actions
    @objc private func dialValueChanged(_ sender: MGRDialControl) {
        print("손가락이 떨어지고 최종적으로 액션이 종료되었음")
    }
}
