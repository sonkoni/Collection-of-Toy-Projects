//
//  ViewControllerA.swift
//  DayNightSwitch_iOS
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerA: UIViewController {
    
    private var dayNightSwitch: MGUDNSwitch?
    private var largeDayNightSwitch: MGUDNSwitch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Day Night Switch"
        if #available(iOS 13, *) {
            view.backgroundColor = .init(dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    if traitCollection.userInterfaceLevel == .elevated {
                        return .blue
                    } else {
                        return .lightGray
                    }
                } else {
                    return .white
                }
            })
        } else {
            view.backgroundColor = .systemGroupedBackground
        }
        
        let dayNightSwitch = MGUDNSwitch(center: view.center, switchOn: true, configuration: nil)
        view.addSubview(dayNightSwitch)
        dayNightSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        dayNightSwitch.mgrPinCenterToSuperviewCenter()
        self.dayNightSwitch = dayNightSwitch
        
        let largeDayNightSwitch = MGUDNSwitch(center: view.center,
                                              switchOn: false,
                                              configuration: MGUDNSwitchConfiguration.defaultConfiguration2())
        view.addSubview(largeDayNightSwitch)
        largeDayNightSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        largeDayNightSwitch.translatesAutoresizingMaskIntoConstraints = false
        largeDayNightSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        largeDayNightSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200.0).isActive = true
        largeDayNightSwitch.widthAnchor.constraint(equalToConstant: 50.0*1.75).isActive = true
        largeDayNightSwitch.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        self.largeDayNightSwitch = largeDayNightSwitch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.overrideUserInterfaceStyle = .dark
    }
    
    // MARK: - Actions
    @objc private func switchChanged(_ sender: MGUDNSwitch) {
        print("들어왔어?", "\(sender)")
        if sender === largeDayNightSwitch {
            if largeDayNightSwitch?.switchOn == true {
                self.navigationController?.overrideUserInterfaceStyle = .light
            } else {
                self.navigationController?.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    @IBAction func onWithAnimated(_ sender: AnyObject) {
        self.dayNightSwitch?.setSwitchOn(true, withAnimated: true)
    }
    
    @IBAction func offWithAnimated(_ sender: AnyObject) {
        self.dayNightSwitch?.setSwitchOn(false, withAnimated: true)
    }
    
    @IBAction func onWithNoAnimated(_ sender: AnyObject) {
        self.dayNightSwitch?.setSwitchOn(true, withAnimated: false)
    }
    
    @IBAction func offWithNoAnimated(_ sender: AnyObject) {
        self.dayNightSwitch?.setSwitchOn(false, withAnimated: false)
    }
}
