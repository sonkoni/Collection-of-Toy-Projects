//
//  ViewControllerC.swift
//  SevenSwitch_iOS
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import BaseKit
import GraphicsKit
import IosKit

final class ViewControllerC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mini Timer iPad 에서 사용"
        view.backgroundColor = .systemBackground
        
        let sevenSwitchBig = makeSwitch(true)
        let sevenSwitch = makeSwitch(false)
        view.addSubview(sevenSwitchBig)
        view.addSubview(sevenSwitch)
        sevenSwitchBig.mgrPinCenterToSuperviewCenter(withFix: CGSize(width: 153.0, height: 93.0))
        sevenSwitch.mgrPinFix(CGSize(width: 51.0, height: 31.0))
        sevenSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sevenSwitch.topAnchor.constraint(equalTo: sevenSwitchBig.bottomAnchor, constant: 30.0).isActive = true
    }
    
    
    // MARK: - Actions
    @objc private func switchChanged(_ sender: MGUSevenSwitch) {
        print("들어왔어?", "\(sender)")
    }
    
    private func makeSwitch(_ isBig: Bool) -> MGUSevenSwitch {
        
        let ratio = (isBig == false) ? 1.0 : 3.0
        
        let configuration = MGUSevenSwitchConfiguration.default()
        let knobAccessoryView = UIView()
        knobAccessoryView.backgroundColor = UIColor.clear
        knobAccessoryView.isUserInteractionEnabled = false
        let knobAccessoryBorderView = UIView()
        knobAccessoryBorderView.backgroundColor = UIColor.clear
        knobAccessoryBorderView.layer.borderColor = UIColor(white: 0.0, alpha: 0.04).cgColor
        knobAccessoryBorderView.layer.borderWidth = 0.5 * ratio
        knobAccessoryBorderView.layer.cornerRadius = 6.0 * ratio
        knobAccessoryView.addSubview(knobAccessoryBorderView)
        knobAccessoryBorderView.mgrPinCenterToSuperviewCenter()
        knobAccessoryBorderView.widthAnchor.constraint(equalTo: knobAccessoryView.widthAnchor, constant: 1.0 * ratio).isActive = true
        knobAccessoryBorderView.heightAnchor.constraint(equalTo: knobAccessoryView.heightAnchor, constant: 1.0 * ratio).isActive = true
        configuration.knobAccessoryView = knobAccessoryView

        let innerShadowLayer = MGEInnerShadowLayer(innerShadowColor: UIColor(white: 0.0, alpha: 0.5).cgColor,
                                                   innerShadowOffset: CGSize(width: -1.0 * ratio, height: 1.0 * ratio),
                                                   innerShadowBlurRadius: 3.0 * ratio)
        innerShadowLayer.frame = CGRect(x: 0.0, y: 0.0, width: 51.0 * ratio, height: 31.0 * ratio)
        innerShadowLayer.cornerRadius = 6.0 * ratio
        innerShadowLayer.contentsScale = UIScreen.main.scale
        configuration.backAccessoryView = UIView()
        configuration.backAccessoryView?.layer.addSublayer(innerShadowLayer)

        let color = UIColor.white.mgrColorWithNoise(withOpacity: 0.05, andBlendMode: .normal)
        configuration.onThumbTintColor = color
        configuration.offThumbTintColor = color
        configuration.onTintColor = UIColor.systemYellow
        configuration.offTintColor = UIColor.mgrColor(fromHexString: "434343")
        configuration.onBorderColor = UIColor.clear
        configuration.offBorderColor = UIColor.clear
        configuration.decoViewColor = UIColor.clear
        configuration.cornerRadius = MGUSevenSwitchCornerRadius(6.0 * ratio)
        configuration.knobRatio = MGUSevenSwitchKnobRatio(12.0 / 27.0)
        let sevenSwitch = MGUSevenSwitch(center: CGPoint.zero, switchOn: isBig, configuration: configuration)
        sevenSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        return sevenSwitch
    }
    
}
