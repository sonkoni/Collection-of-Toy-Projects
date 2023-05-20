//
//  ViewControllerA.swift
//  DialControl_Samples
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import AudioKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    var dialControl: MGRDialControl?
    var sound: MGOSoundDefault?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "IV-Drop - DialControl"
        sound = MGOSoundDefault.defaultSound
        view.backgroundColor = .init(red: 19.0/255.0, green: 86.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        
        dialControl = MGRDialControl()
        guard let dialControl = dialControl else {
            return
        }
        dialControl.delegate = self
        dialControl.normalSoundPlayBlock = sound?.playSoundTink
        view.addSubview(dialControl)
  
        let length = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 10.0
        dialControl.mgrPinCenterToSuperviewCenter(withFix: CGSize(width: length, height: length))

        let animationAction = UIAction(title: "Animation") { [weak self] _ in
            self?.dialControl?.beginningAnimation()
        }
        let rightBarButtonItem = UIBarButtonItem(primaryAction: animationAction)

        rightBarButtonItem.tintColor = .systemRed
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension ViewControllerA : MGRDialControlDelegate {}
