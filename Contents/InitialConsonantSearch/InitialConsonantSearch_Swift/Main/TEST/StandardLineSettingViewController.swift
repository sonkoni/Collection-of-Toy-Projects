//
//  ChartSettingViewController.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit
import IosKit

final class StandardLineSettingViewController: UIViewController {
    
    // MARK: - Property
    
    var viewModel = StandardLineSettingViewModel()
    
    @IBOutlet weak private var topTableView: UITableView!
    @IBOutlet weak private var bottomTableView: UITableView!
    @IBOutlet weak private var segmentedControlContainer: UIView!
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet private var dividerlayoutConstraint: NSLayoutConstraint!
    
    private var underLineView: UIView!
    private var underLineLeadingConstraint: NSLayoutConstraint!
    
    private var colorPickerViewController: UIColorPickerViewController!
    private var colorPickerCompletion: ((UIColor) -> Void)?
    
    private var isShowKeyboard = false
    private var showObserver: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var currentTextField: UITextField?
    
    private var previousNotificationName: NSNotification.Name?
    private var previousKeyboardHeight: CGFloat?
    
    // MARK: - Override
    
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
        setupKeyboardObserver()
        setupTableView()
        setupSegmentedControl()
        setupColorPickerViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.updateUnderLineLeadingConstraint()
        }, completion: { _ in })
        if isShowKeyboard {
            view.endEditing(true)
        }
    }
    
    // MARK: - 생성 & 소멸
    
    private func setupKeyboardObserver() {
        let nc = NotificationCenter.default
        showObserver = nc.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] note in
            self?.isShowKeyboard = true
            self?.handleKeyboardNotification(note)
        }
        
        hideObserver = nc.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] note in
            self?.isShowKeyboard = false
            self?.handleKeyboardNotification(note)
        }
    }
    
    private func setupTableView() {
        let identifier = String(describing: ConfigCommonHeaderCell.self)
        let tableHeaderNib = UINib(nibName: identifier, bundle: Bundle.main)
        bottomTableView.register(tableHeaderNib, forHeaderFooterViewReuseIdentifier: identifier)

        for tableView in [topTableView, bottomTableView] {
            tableView?.contentInsetAdjustmentBehavior = .never
            tableView?.contentInset = .zero
            tableView?.sectionHeaderTopPadding = 0.0
            tableView?.rowHeight = UITableView.automaticDimension
            tableView?.estimatedRowHeight = 100.0
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    private func setupSegmentedControl() {
        segmentedControlContainer.backgroundColor = .white
        dividerlayoutConstraint.constant = 1.0 / UIScreen.main.scale
                
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
                
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
            .foregroundColor: UIColor.systemGray
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .heavy),
            .foregroundColor: UIColor.black
        ]
                
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        underLineView = UIView()
        underLineView.backgroundColor = .black
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        
        underLineLeadingConstraint = underLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        
        segmentedControlContainer.addSubview(underLineView)
        underLineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        underLineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        underLineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0/3.0).isActive = true
        underLineLeadingConstraint.isActive = true
    }
    
    private func setupColorPickerViewController() {
        colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .popover
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateUnderLineLeadingConstraint()
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.optionalTableType = .yesterdayToday
        case 1:
            viewModel.optionalTableType = .pivotDemark
        case 2:
            viewModel.optionalTableType = .custom
        default:
            assertionFailure("Unexpected index")
        }
        bottomTableView.setContentOffset(.zero, animated: false)
        view.endEditing(true)
        bottomTableView.reloadData()
    }
    
    @IBAction func titleButtonClicked(_ sender: UIButton) {
        if let data = dataForSender(sender) {
            data.isSelected.toggle()
            if let cell = cellForSender(sender) {
                cell.data = data
            }
        }
    }
    
    @IBAction func dropdownBtnValueChanged(_ sender: SKUDropdownButton) {
        if let data = dataForSender(sender) {
            data.dropBtnSelectedIndex = sender.selectedIndex
        }
    }
    
    @IBAction func colorButtonClicked(_ sender: UIButton) {
        if let data = dataForSender(sender) {
            colorPickerCompletion = { selectedColor in
                sender.backgroundColor = selectedColor
                data.color = selectedColor
            }
            colorPickerViewController.selectedColor = sender.backgroundColor ?? .clear
            if viewModel.optionalTableType != .custom {
                colorPickerViewController.title = data.title
            } else {
                if let textFieldTitle = data.textFieldTitle, !textFieldTitle.isEmpty {
                    colorPickerViewController.title = textFieldTitle
                } else {
                    colorPickerViewController.title = data.textFieldPlaceHolderTitle
                }
            }
            if let popoverPresentationController = colorPickerViewController.popoverPresentationController {
                popoverPresentationController.sourceView = sender
                present(colorPickerViewController, animated: true)
            }
        }
    }
    
    @IBAction func ratioButtonClicked(_ sender: UIButton) {
        if let data = dataForSender(sender) {
            data.isRatio.toggle()
            if let cell = cellForSender(sender) {
                cell.data = data
            }
        }
    }
    
    @IBAction func endEditClicked(_ sender: Any) {
        if isShowKeyboard {
            view.endEditing(true)
        }
    }
    
    private func handleKeyboardNotification(_ notification: Notification) {
        let previousNotificationName = self.previousNotificationName
        let previousKeyboardHeight = self.previousKeyboardHeight
        let name = notification.name
        self.previousNotificationName = name
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.size.height
        self.previousKeyboardHeight = keyboardHeight
        if previousNotificationName == name && previousKeyboardHeight == keyboardHeight {
            return;
        }
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 7
        let options = UIView.AnimationOptions(rawValue: animationCurve)
        
        if name == UIResponder.keyboardWillHideNotification {
            let originalMaxOffsetY = bottomTableView.skhMaxOffset().y - bottomTableView.contentInset.bottom
            if originalMaxOffsetY < bottomTableView.contentOffset.y {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: 0.0,
                    options: options,
                    animations: {
                        self.bottomTableView.contentOffset = CGPoint(x: 0.0, y: originalMaxOffsetY)
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.bottomTableView.contentInset = .zero
                        self.bottomTableView.scrollIndicatorInsets = .zero
                    }
            } else {
                bottomTableView.contentInset = .zero
                bottomTableView.scrollIndicatorInsets = .zero
            }
            return  //! return 해야한다.
        }
        
        if name == UIResponder.keyboardWillShowNotification {
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
            bottomTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
            bottomTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        }
        
        if let textField = currentTextField, let window = textField.window {
            let rect = textField.convert(textField.bounds, to: window)
            let upLength = rect.origin.y + rect.size.height + 4.0
            let total = upLength + keyboardHeight
            var movingOffset = bottomTableView.contentOffset
                    
            if total > window.bounds.size.height {
                let move = abs(window.bounds.size.height - total)
                movingOffset = CGPoint(x: movingOffset.x, y: movingOffset.y + move)
            }
                    
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: duration,
                delay: 0.0,
                options: options,
                animations: {
                    self.bottomTableView.contentOffset = movingOffset
                    self.view.layoutIfNeeded()
                },
                completion: nil
            )
        }
            
    }

    // MARK: - Private Helper
    
    private func cellForSender(_ sender: UIView) -> StandardLineSettingCell? {
        if sender.isDescendant(of: topTableView) {
            if let indexPath = topTableView.skhIndexPathOfCellWhereViewExists(view: sender) {
                return topTableView.cellForRow(at: indexPath) as? StandardLineSettingCell
            }
        } else if sender.isDescendant(of: bottomTableView) {
            if let indexPath = bottomTableView.skhIndexPathOfCellWhereViewExists(view: sender) {
                return bottomTableView.cellForRow(at: indexPath) as? StandardLineSettingCell
            }
        } else {
            assertionFailure("잘못된 아이템이 들어왔다")
        }
        return nil
    }
    
    private func dataForSender(_ sender: UIView) -> DTOStandardLineSetting? {
        if sender.isDescendant(of: topTableView) {
            if let indexPath = topTableView.skhIndexPathOfCellWhereViewExists(view: sender) {
                return viewModel.topCellModel(for: indexPath)
            }
        } else if sender.isDescendant(of: bottomTableView) {
            if let indexPath = bottomTableView.skhIndexPathOfCellWhereViewExists(view: sender) {
                return viewModel.bottomCellModel(for: indexPath)
            }
        } else {
            assertionFailure("잘못된 아이템이 들어왔다")
        }
        return nil
    }
    
    private func updateUnderLineLeadingConstraint() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        let segmentWidth = segmentedControl.frame.size.width / CGFloat(segmentedControl.numberOfSegments)
        underLineLeadingConstraint.constant = segmentWidth * CGFloat(selectedSegmentIndex)
    }
    
}

extension StandardLineSettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView === topTableView {
            return viewModel.numberOfTopSections()
        } else {
            return viewModel.numberOfBottomSections()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === topTableView {
            return viewModel.numberOfRowsInTopSection(section)
        } else {
            return viewModel.numberOfRowsInBottomSection(section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === topTableView {
            let setting = viewModel.topCellModel(for: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: setting.identifier, for: indexPath) as! StandardLineSettingCell
            cell.data = setting
            return cell
        }
        
        let setting = viewModel.bottomCellModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: setting.identifier, for: indexPath) as! StandardLineSettingCell
        cell.data = setting
        return cell
    }
    
}

extension StandardLineSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowKeyboard {
            view.endEditing(true)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === topTableView {
            return 0.0
        }
        return 44.0 // return 27.0 // 27.204081632653061
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === topTableView {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ConfigCommonHeaderCell.self)) as? ConfigCommonHeaderCell
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = UIColor.systemGray6
        header?.backgroundConfiguration = backgroundConfig
        header?.titleLabel.text = viewModel.sectionTitles[section]
        return header
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

@available(iOS 14.0, *)
extension StandardLineSettingViewController: UIColorPickerViewControllerDelegate {
    
    @available(iOS 15.0, *)
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        let chosenColor = viewController.selectedColor
        colorPickerCompletion?(chosenColor)
        
        if !continuously {
            if traitCollection.horizontalSizeClass != .compact {
                viewController.dismiss(animated: true) {
                    print("chosenColor \(chosenColor)")
                }
            }
        }
    }
    
    
    // 명시적으로 X 버튼을 눌렀을 때, 실행된다.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {}

    /// iOS 14.0에서 Deprecated - 본 프로젝트는 최소 지원버전이 iOS 12.0
    @available(iOS, introduced: 14.0, deprecated: 15.0)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let chosenColor = viewController.selectedColor
        colorPickerCompletion?(chosenColor)
        if traitCollection.horizontalSizeClass != .compact {
            viewController.dismiss(animated: true) {
                print("chosenColor \(chosenColor)")
            }
        }
    }
}

extension StandardLineSettingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        //
        // <UITextFieldDelegate> 메서드에 해당하는 것으로 delegate 설정을 반드시 해야합니다. 자주 잊어버리는 부분입니다.
        // 키보드에서 Return 키를 눌렀을 때 발생하는 동작을 제어합니다.
    }

    //! 처음 커서 1
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        print("textFieldShouldBeginEditing:")
        return true
    }

    //! 처음 커서 2
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing:")
    }

    //!- 글자를 칠때 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("textField:shouldChangeCharactersInRange:replacementString:")
        return true
    }

    //!- 글자를 칠때 2
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection: -- \(textField.text ?? "")")
        if let model = dataForSender(textField) {
            model.textFieldTitle = textField.text
        }
    }

    //! - 종료
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing:reason:")
    }

}
