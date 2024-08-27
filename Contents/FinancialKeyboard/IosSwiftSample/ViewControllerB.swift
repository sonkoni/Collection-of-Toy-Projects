//
//  File.swift
//  IosSwiftFinancialKeyboard
//
//  Created by Kwan Hyun Son on 1/10/24.
//

import UIKit

class ViewControllerB: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var testView: TableViewHeaderFooterView!

    var minDataArr: [DTOMinTick] = []
    var tickDataArr: [DTOMinTick] = []

    var showKeyboard: Bool = false
    var showObserver: NSObjectProtocol?
    var hideObserver: NSObjectProtocol?

    var currentTextField: UITextField?
    var previousNotificationName: NSNotification.Name?
    var previousKeyboardHeight: CGFloat = 0.0

    // MARK: - Override

    deinit {
        NotificationCenter.default.removeObserver(showObserver as Any)
        NotificationCenter.default.removeObserver(hideObserver as Any)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "분/틱 목업 테스트"
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        tableView.sectionHeaderTopPadding = 0.0

        minDataArr = [
            DTOMinTick.dto(with: 1, selected: true),
            DTOMinTick.dto(with: 3, selected: true),
            DTOMinTick.dto(with: 5, selected: true),
            DTOMinTick.dto(with: 10, selected: true),
            DTOMinTick.dto(with: 15, selected: true),
            DTOMinTick.dto(with: 30, selected: true),
            DTOMinTick.dto(with: 45, selected: true),
            DTOMinTick.dto(with: 60, selected: true),
            DTOMinTick.dto(with: 90, selected: true),
            DTOMinTick.dto(with: 120, selected: true)
        ]

        tickDataArr = [
            DTOMinTick.dto(with: 1, selected: true),
            DTOMinTick.dto(with: 3, selected: true),
            DTOMinTick.dto(with: 5, selected: true),
            DTOMinTick.dto(with: 10, selected: true),
            DTOMinTick.dto(with: 15, selected: true),
            DTOMinTick.dto(with: 20, selected: true),
            DTOMinTick.dto(with: 30, selected: true),
            DTOMinTick.dto(with: 45, selected: true),
            DTOMinTick.dto(with: 60, selected: true),
            DTOMinTick.dto(with: 80, selected: true)
        ]

        setupKeyboardObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupToolbar()
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: { context in
            self.navigationController?.navigationBar.sizeToFit()
        }, completion: nil
        )
    }
    
    // MARK: - 생성 & 소멸

    func setupToolbar() {
        navigationController?.isToolbarHidden = false
        let appearance = UIToolbarAppearance()
        let plainBarButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        plainBarButtonItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        appearance.buttonAppearance = plainBarButtonItemAppearance
        let doneBarButtonItemAppearance = UIBarButtonItemAppearance(style: .done)
        doneBarButtonItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.doneButtonAppearance = doneBarButtonItemAppearance

        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        if #available(iOS 15, *) {
            navigationController?.toolbar.scrollEdgeAppearance = appearance
            navigationController?.toolbar.compactScrollEdgeAppearance = appearance
        }

        let separator = UIView()
        separator.backgroundColor = .separator
        navigationController?.toolbar.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            separator.centerXAnchor.constraint(equalTo: separator.superview!.centerXAnchor),
            separator.topAnchor.constraint(equalTo: separator.superview!.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separator.superview!.bottomAnchor, constant: 50.0)
        ])
    }

    func setupKeyboardObserver() {
        let nc = NotificationCenter.default
        weak var weakSelf = self
        showObserver = nc.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                      object: nil,
                                      queue: OperationQueue.main) { note in
            weakSelf?.showKeyboard = true
            weakSelf?.handleKeyboardNotification(note)
        }

        hideObserver = nc.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                      object: nil,
                                      queue: OperationQueue.main) { note in
            weakSelf?.showKeyboard = false
            weakSelf?.handleKeyboardNotification(note)
        }
    }

    // MARK: - Actions

    @IBAction func clickedMinuteCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        let index = sender.tag
        minDataArr[index].selected = sender.isSelected
    }

    @IBAction func clickedTickCheckButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        let index = sender.tag
        tickDataArr[index].selected = sender.isSelected
    }

    // MARK: - Helper Methods

    func handleKeyboardNotification(_ notification: Notification?) {
        guard let notification = notification else { return }
        let previousNotificationName = self.previousNotificationName
        let previousKeyboardHeight = self.previousKeyboardHeight
        self.previousNotificationName = notification.name
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        self.previousKeyboardHeight = keyboardHeight

        if previousNotificationName == notification.name && previousKeyboardHeight == keyboardHeight {
            return
        }
        
        guard let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
              else {
                  return
        }

        let options = UIView.AnimationOptions(rawValue: animationCurve << 16) // Convert the animation

        if notification.name == UIResponder.keyboardWillHideNotification {
            let originalMaxOffsetY = self.tableView.skhMaxOffset().y - self.tableView.contentInset.bottom
            let originalMaxOffsetYClamped = max(0.0, originalMaxOffsetY)
            if originalMaxOffsetYClamped < self.tableView.contentOffset.y {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: 0.0,
                    options: options,
                    animations: {
                    self.tableView.setContentOffset(CGPoint(x: 0.0, y: originalMaxOffsetYClamped), animated: false)
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.tableView.contentInset = .zero
                    self.tableView.scrollIndicatorInsets = .zero
                })
            } else {
                self.tableView.contentInset = .zero
                self.tableView.scrollIndicatorInsets = .zero
            }
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification {
            let bottomInset = keyboardHeight - self.view.safeAreaInsets.bottom
            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        }

        if let textField = currentTextField,
           let window = textField.window {
            let rect = textField.convert(textField.bounds, to: window)
            let upLength = rect.origin.y + rect.size.height + 4.0
            let total = upLength + keyboardHeight
            var movingOffset = self.tableView.contentOffset
            if total > window.bounds.size.height {
                let move = abs(window.bounds.size.height - total)
                movingOffset = CGPoint(x: movingOffset.x, y: movingOffset.y + move)
            }

            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0.0, options: options, animations: {
                self.tableView.setContentOffset(movingOffset, animated: false)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

extension ViewControllerB: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 31
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = testView
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = UIColor.systemGray6
        header?.backgroundConfiguration = backgroundConfig
        return header
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // Do nothing
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = cell as? FTableViewCell {
                cell.minCheckBtn.isHidden = true
                cell.tickCheckBtn.isHidden = true
            }
        } else {
            if let cell = cell as? FTableViewCell {
                cell.minCheckBtn.isHidden = false
                cell.tickCheckBtn.isHidden = false
            }
        }
    }
}

extension ViewControllerB: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? FTableViewCell else {
            return UITableViewCell()
        }

        let index = indexPath.row
        let minData = minDataArr[index]
        let tickData = tickDataArr[index]

        cell.minTextField.text = "\(minData.cycle)"
        cell.tickModifyBtn.setTitle("\(tickData.cycle)", for: .normal)
        cell.minCheckBtn.isSelected = minData.selected
        cell.tickCheckBtn.isSelected = tickData.selected

        for button in [cell.minTextField, cell.tickModifyBtn, cell.minCheckBtn, cell.tickCheckBtn] {
            button?.tag = index
        }

        return cell
    }

}

extension ViewControllerB: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        print("textFieldShouldBeginEditing:")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing:")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textField:shouldChangeCharactersInRange:replacementString: -- \(textField.text ?? "")")
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection: -- \(textField.text ?? "")")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing:reason:")
    }

}
