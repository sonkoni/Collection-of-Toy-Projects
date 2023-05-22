//
//  ViewControllerA.swift
//  Stepper
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    @IBOutlet var steppers: [MGUStepper]!
    @IBOutlet private weak var appleStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MGUStepper - xib"
        for stepper in steppers {
            stepper.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
        }
        
        appleStepper.addTarget(self, action:#selector(appleStepperValueChanged), for: .valueChanged)
    }
    
    
    // MARK: - Actions
    @objc private func stepperValueChanged(_ sender: MGUStepper) {
        print("stepper.value \(sender.value)")
    }
    
    @objc private func appleStepperValueChanged(_ sender: UIStepper, forEvent event: UIEvent) {
        print("stepper.value \(sender.value)")
    }
}
