//
//  ViewControllerA.swift
//  MGUFlatSwitch
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var flatSwitch: MGUFlatSwitch!
    private var flatSwitch2 = MGUFlatSwitch(frame: CGRectMake(0.0, 0.0, 100.0, 100.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MGUFlatSwitch Samples"
        flatSwitch.addTarget(self, action:#selector(switchClicked(_:)), for: .valueChanged)
        
        flatSwitch2.lineWidth = 9.0
        
        let baseCircleStrokeColor =
        UIColor.mgrColor(withLightModeColor: UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 0.5),
                         darkModeColor: UIColor.red.withAlphaComponent(0.5),
                         darkElevatedModeColor: nil)
        flatSwitch2.baseCircleStrokeColor = baseCircleStrokeColor
        
        let checkMarkNCircleStrokeColor =
        UIColor.mgrColor(withLightModeColor: UIColor(red: 0.3, green: 0.3, blue: 0.6, alpha: 1.0),
                         darkModeColor: .red,
                         darkElevatedModeColor: nil)
        flatSwitch2.checkMarkNCircleStrokeColor = checkMarkNCircleStrokeColor
        view.addSubview(flatSwitch2)
        flatSwitch2.mgrPinCenterToSuperviewCenter(withFix: CGSizeMake(150.0, 150.0))
        
        let flatSwitch3 = MGUFlatSwitch(frame: CGRectMake(0.0, 0.0, 50.0, 50.0))
        flatSwitch3.lineWidth = 3.0
        flatSwitch3.baseCircleStrokeColor = baseCircleStrokeColor
        flatSwitch3.checkMarkNCircleStrokeColor = checkMarkNCircleStrokeColor
        view.addSubview(flatSwitch3)
        flatSwitch3.mgrPinFix(CGSize(width: 50.0, height: 50.0))
        flatSwitch3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        flatSwitch3.topAnchor.constraint(equalTo: flatSwitch2.bottomAnchor, constant: 50.0).isActive = true
        
    }
    
    @objc private func switchClicked(_ sender: MGUFlatSwitch) {
        print("터치", "\(sender.isSelected)")
    }

}
