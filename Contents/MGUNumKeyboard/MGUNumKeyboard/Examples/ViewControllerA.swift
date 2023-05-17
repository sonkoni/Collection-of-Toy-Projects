//
//  ViewControllerA.swift
//  MGURulerView
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit
import AudioKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
    var backgroundColor: UIColor?
    var rulerViewConfig: MGURulerViewConfig?
    var indicatorType: MGURulerViewIndicatorType?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var gotoTextField: UITextField!
    
    private var rulerView: MGURulerView?
    private var sound: MGOSoundRuler?
    @IBOutlet private weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sound = MGOSoundRuler.rulerSound
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = backgroundColor
        gotoTextField.keyboardType = .decimalPad
        gotoTextField.keyboardAppearance = .dark

        let values = ["0.0", "34.1", "58.8"]
        let randomValue = values[Int(arc4random_uniform(3))]
        let randomDoubleValue = Double(randomValue)
        
        guard let randomDoubleValue = randomDoubleValue,
            let indicatorType = indicatorType,
              let rulerViewConfig = rulerViewConfig else {
            return
        }
        rulerView = MGURulerView.init(frame: .zero,
                                      initialValue: randomDoubleValue,
                                      indicatorType: indicatorType,
                                      config: rulerViewConfig)
        
        guard let rulerView = rulerView else {
            return
        }
        rulerView.delegate = self
        containerView.addSubview(rulerView)
        rulerView.mgrPinEdgesToSuperviewEdges()
        rulerViewDidScroll(rulerView, currentDisplayValue: randomDoubleValue)
        
        rulerView.soundOn = true
        rulerView.normalSoundPlayBlock = sound?.playSoundTickHaptic()
        rulerView.skipSoundPlayBlock = sound?.playSoundRolling()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.subviews.forEach { view in
            if view is UITextField {
                view.resignFirstResponder()
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func leftClick(_ sender: UIButton) {
        rulerView?.moveToLeft()
    }
    @IBAction func rightClick(_ sender: UIButton) {
        rulerView?.moveToRight()
    }
    @IBAction func longLeftClick(_ sender: UIButton) {
        rulerView?.moveFarToLeft()
    }
    @IBAction func longRightClick(_ sender: UIButton) {
        rulerView?.moveFarToRight()
    }
    @IBAction func gotoClick(_ sender: UIButton) {
        rulerView?.go(toValue: Double(gotoTextField.text ?? "0.0") ?? 0.0, animated: true, notify: true)
    }
}


// MARK: - <MGURulerViewDelegate>
extension ViewControllerA: MGURulerViewDelegate {
    func rulerViewDidScroll(_ rulerView: MGURulerView, currentDisplayValue: CGFloat) {
        if let font = UIFont.init(name: "Menlo-Bold", size: 34.0) {
            label.attributedText = MGURulerViewMainLabelAttrStr(currentDisplayValue, font, .white)
        }
    }
}


// MARK: - <UITextFieldDelegate>
extension ViewControllerA: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
