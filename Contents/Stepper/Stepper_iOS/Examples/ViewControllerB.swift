//
//  ViewControllerB.swift
//  MGUNeoSegControl
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerB: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var containerView1: UIView!
    @IBOutlet private weak var containerView2: UIView!
    @IBOutlet private weak var containerView3: UIView!
    @IBOutlet private weak var containerView4: UIView!
    @IBOutlet private weak var containerView5: UIView!
    
    private var stepper1 : MGUStepper?
    private var stepper2 : MGUStepper?
    private var stepper3 : MGUStepper?
    private var stepper4 : MGUStepper?
    private var stepper5 : MGUStepper?
    private var steppers : Array<MGUStepper>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MGUStepper - code & config"
        steppers = []
        stepper1 = MGUStepper(configuration: MGUStepperConfiguration.iOS13())
        if let stepper1 = stepper1 {
            containerView1.addSubview(stepper1) // intrinsicContentSize 설정됨
            stepper1.mgrPinCenterToSuperviewCenter()
            stepper1.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
            steppers?.append(stepper1)
        }
        
        stepper2 = MGUStepper(configuration: MGUStepperConfiguration.iOS7())
        if let stepper2 = stepper2 {
            containerView2.addSubview(stepper2) // intrinsicContentSize 설정됨
            stepper2.mgrPinCenterToSuperviewCenter()
            stepper2.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
            steppers?.append(stepper2)
        }
        
        stepper3 = MGUStepper(configuration: MGUStepperConfiguration.forgeDrop())
        if let stepper3 = stepper3 {
            containerView3.addSubview(stepper3) // intrinsicContentSize 설정됨
            stepper3.mgrPinCenterToSuperviewCenter()
            stepper3.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
            steppers?.append(stepper3)
        }
        
        stepper4 = MGUStepper()
        if let stepper4 = stepper4 {
            containerView4.addSubview(stepper4) // intrinsicContentSize 설정됨
            stepper4.mgrPinCenterToSuperviewCenter()
            stepper4.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
            steppers?.append(stepper4)
        }
        
        let config = MGUStepperConfiguration.forgeDropConfiguration2()
        config.items = ["H"]
        stepper5 = MGUStepper(configuration: config)
        if let stepper5 = stepper5 {
            containerView5.addSubview(stepper5) // intrinsicContentSize 설정됨
            stepper5.mgrPinCenterToSuperviewCenter()
            stepper5.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
            steppers?.append(stepper5)
        }
        
        let enableSwitch = UISwitch()
        enableSwitch.isOn = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enableSwitch)
        enableSwitch.addTarget(self, action:#selector(enableSwitchClick(_:)), for: .valueChanged)
    }
    
    
    // MARK: - Actions
    @objc private func stepperValueChanged(_ sender: MGUStepper) {
        print("stepper.value \(sender.value)")
    }
    
    @objc private func enableSwitchClick(_ sender: UISwitch) {
        if let steppers = steppers {
            for case let stepper in steppers {
                stepper.isEnabled = sender.isOn
            }
        }        
    }
}
