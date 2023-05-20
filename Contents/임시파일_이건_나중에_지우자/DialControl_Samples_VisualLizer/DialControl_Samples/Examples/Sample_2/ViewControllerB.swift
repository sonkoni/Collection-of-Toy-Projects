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
    }
}
