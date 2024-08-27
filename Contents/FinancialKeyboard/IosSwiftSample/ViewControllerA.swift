//
//  ViewController.swift
//  IosSwiftEmpty
//
//  Created by Kiro on 2022/11/16.
//

import UIKit
import BaseKit
import IosKit

class ViewControllerA: UIViewController {

    @IBOutlet private weak var textField1: SKUFinancialTextField!
    @IBOutlet private weak var textField2: SKUFinancialTextField!
    @IBOutlet private weak var textField3: SKUFinancialTextField!
    @IBOutlet private weak var textField4: SKUFinancialTextField!
    
    @IBOutlet private weak var appleTextField: UITextField!
    
    private var isShowKeyboard = false
    private var showObserver: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    deinit {
        if let showObserver = showObserver {
            NotificationCenter.default.removeObserver(showObserver)
        }
        if let hideObserver = hideObserver {
            NotificationCenter.default.removeObserver(hideObserver)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField1.buttonOptions = .none
        textField2.buttonOptions = .dot
        textField3.buttonOptions = .dotPm
        textField4.buttonOptions = .pm
        
        textField1.maxDataValue = 3000.0
        textField1.alertMessage = "1 이상 3,000 이하의 숫자만 유효합니다."
        textField1.completionClosure = { [weak self] (dataValue: Double) -> Void in
            let result = min(max(1.0, dataValue), 3000.0)
            let finalResult = lround(result)
            self?.textField1.dataValue = result; // 실제 사용되는 숫자로 바꿔줘야할 필요가 있을 수 있다
            print("finalResult ==> \(finalResult)")
        }
        textField1.dataValue = 50.0
        
        textField2.maxDataValue = 3000.0
        textField2.alertMessage = "0 이상 3,000 이하의 숫자만 유효합니다."
        textField2.dataValue = 0.0
        textField2.maximumFractionDigits = 4
        
        setupKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - 생성 & 소멸
    private func setupKeyboardObserver() {
        
        let nc = NotificationCenter.default
        showObserver = nc.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main) { [weak self] note in
            self?.isShowKeyboard = true
            self?.handleKeyboardNotification(note)
        }

        hideObserver = nc.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                        object: nil,
                                        queue: OperationQueue.main) { [weak self] note in
            self?.isShowKeyboard = false
            self?.handleKeyboardNotification(note)
        }
    }
    
    private func handleKeyboardNotification(_ notification: Notification?) {
        print("handleKeyboardNotification 반가워.!!!!")
        guard let userInfo = notification?.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height
        print("keyboardHeight \(keyboardHeight)")
    }
}

extension ViewControllerA: SKUFinancialKeyboardDelegate {
    func numberKeyboard(_ numberKeyboard: SKUFinancialKeyboard, shouldInsertText text: String) -> Bool {
        return true
    }
    func numberKeyboardShouldReturn(_ numberKeyboard: SKUFinancialKeyboard) -> Bool {
        return true
    }
    func numberKeyboardShouldDeleteBackward(_ numberKeyboard: SKUFinancialKeyboard) -> Bool {
        return true
    }
}
