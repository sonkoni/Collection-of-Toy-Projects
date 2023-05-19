//
//  ViewControllerC.swift
//  DialControl_Samples
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import AudioKit
import IosKit

final class ViewControllerC: UIViewController {
    
    // MARK: - Property
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var privateTextField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    var sound: MGOSoundKeyboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let stackView = privateTextField.superview as? UIStackView {
            stackView.setCustomSpacing(50.0, after: privateTextField)
        }
        
        navigationItem.title = "Layout Type - Standard2"
        sound = MGOSoundKeyboard.keyBoardSound
        
        view.backgroundColor = .mgrColor(withLightModeColor: .mgrColor(fromHexString: "D5D7DD"),
                                         darkModeColor: .mgrColor(fromHexString: "151515"),
                                         darkElevatedModeColor: nil)
        containerView.backgroundColor = .clear
        textLabel.layer.cornerRadius = 3.0
        textLabel.layer.borderColor = UIColor.black.cgColor
        textLabel.layer.borderWidth = 1.0
        
        let keyboard = MGUNumKeyboard(frame: .zero,
                                      locale: nil,
                                      layoutType: .standard2,
                                      configuration: MGUNumKeyboardConfiguration.forge())
        keyboard.specialKeyHandlerBlock = {
            print("specialKeyHandlerBlock !!!! 반응했다.")
        }
        
        keyboard.delegate = self
        keyboard.allowsDoneButton = true //! MGUNumKeyboardLayoutTypeStandard2에서는 아무런 효과가 없다.
        keyboard.roundedButtonShape = true
        keyboard.normalSoundPlayBlock = sound?.playSoundKeyPress
        keyboard.deleteSoundPlayBlock = sound?.playSoundKeyDelete
        
        keyboard.keyInput = privateTextField // self.textField.inputView = keyboard; 이렇게 설정 금지.
        self.privateTextField.isUserInteractionEnabled = false
        //! self.textField.alpha = 0.0f; <- 이렇게 실전에서는 처리할 것이다.
        keyboard.soundOn = true
        privateTextField.addTarget(self, action:#selector(textFieldDidChange(_:)), for: .editingChanged)
        containerView.addSubview(keyboard)
        keyboard.mgrPinEdgesToSuperviewEdges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        privateTextField.text = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    //! 여기서는 다른 곳이 터치되었을 때, 키보드를 내리는 역할을 할것이다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        //
        // UIResponder의 메서드로써 responder chain을 타고 올라간다. 우선은 view에 갔다가 컨트롤러(next responder- 여기서는 self)로 온 것이다.
        // 자세한 설명은 위키의 Api:UIKit/UIResponder/- touchesBegan:withEvent:‎과 Api:UIKit/UIResponder/nextResponder‎를 참고하면된다.
    }
    
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if sender.text?.contains(".") == true { // 존재한다면
            let strArr = sender.text?.components(separatedBy: ".")
            let floatString = strArr?.last

            if floatString?.count ?? 0 >= 3 {
                let formatter = NumberFormatter()
                formatter.numberStyle = .none
                formatter.roundingMode = .floor
                formatter.maximumFractionDigits = 2
                formatter.minimumFractionDigits = 2
                if let doubleValue = Double(sender.text ?? ""),
                    let cutNumString = formatter.string(from: NSNumber(value: doubleValue)) {
                    sender.text = cutNumString
                }
            }
        } else { // 정수에서(.가 없을 때) 맥시멈 초과가 발생할 수 있다.
            if let number = Int(sender.text ?? ""), number >= 100000000 { // 1억
                let updatedNumber = number / 10
                sender.text = "\(updatedNumber)"
            }
        }
        
        textLabel.text = transformString(sender.text)
    }
    
    private func transformString(_ str: String?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if str?.contains(".") == true { // 존재한다면
            formatter.alwaysShowsDecimalSeparator = true
            let floatStr = str?.components(separatedBy: ".").last
            if floatStr == nil || floatStr?.count == 0 {
                formatter.minimumFractionDigits = 0
            } else if floatStr?.count == 1 {
                formatter.minimumFractionDigits = 1
            } else if floatStr?.count == 2 {
                formatter.minimumFractionDigits = 2
            }
        } else {
            formatter.alwaysShowsDecimalSeparator = false
        }
        
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: Double(str ?? "0.0") ?? 0.0))
    }
}


// MARK: - <MGUNumKeyboardDelegate>
extension ViewControllerC: MGUNumKeyboardDelegate {
    //! 구현 자체를 안하면 YES를 반환하는 것과 동일한 효과이다. 딱히 구현할 필요가 없다.
    func number(_ numberKeyboard: MGUNumKeyboard, shouldInsertText text: String) -> Bool {
        return true
    }
    func numberKeyboardShouldReturn(_ numberKeyboard: MGUNumKeyboard) -> Bool {
        return true
    }
    func numberKeyboardShouldDeleteBackward(_ numberKeyboard: MGUNumKeyboard) -> Bool {
        return true
    }
}


// MARK: - <UITextFieldDelegate>
extension ViewControllerC: UITextFieldDelegate {
    //! keyboard에서 retrun을 했을 때, 일어나는 반응을 컨트롤한다!!!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        //
        // <UITextFieldDelegate> 메서드에 해당하는 것으로 delegate 설정을 반드시 해야한다!! 자꾸 까먹는듯.
    }
}
