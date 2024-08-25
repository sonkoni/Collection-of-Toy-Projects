//
//  IndicatorSettingSearchController.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/18/23.
//

import UIKit
import BaseKit
import IosKit

final class IndicatorSettingSearchController: UIViewController {
    
    // MARK: - Property
    
    var viewModel: IndicatorSettingViewModel?
    var emptyStringMode = true {
        didSet {
            if emptyStringMode {
                if tableView.alpha != 0.0 {
                    tableView.alpha = 0.0
                    noSearchResultView.isHidden = true // debounce 때문에 여기서만 hidden 처리
                    dataSource?.apply( // debounce 때문에 바로 처리
                        NSDiffableDataSourceSnapshot(),
                        animatingDifferences: false)
                    debounceClosure(0.0) {} // 기존 디바운스 예약을 무력화 시킨다
                }
            } else {
                if tableView.alpha != 1.0 {
                    tableView.alpha = 1.0
                    // self.noSearchResultView.hidden = NO; // debounce 때문에 여기서는 이 라인을 실행해서는 안된다
                }
            }
        }
    }
    var selectItemCompletion: ((SKHOutlineItem<DTOIndicatorSetting>) -> Void)?
    @IBOutlet weak var tableView: UITableView!
    var noSearchResultView: SKUNOSearchResultView = SKUNOSearchResultView()
    var dataSource: UITableViewDiffableDataSource<String, SKHOutlineItem<DTOIndicatorSetting>>?
    var debounceClosure = SKHDispatchDebounceMake()
    var isShowKeyboard = false
    var showObserver: NSObjectProtocol?
    var hideObserver: NSObjectProtocol?
    var previousNotificationName: NSNotification.Name?
    var previousKeyboardHeight: CGFloat = 0
    var isDebounceEnabled = true // Debounce 효과를 없애고 싶다면 false 하라. IndicatorSettingViewController에서 false 하라.
    
    // MARK: - Override
    
    deinit {
        if let showObserver = showObserver {
            NotificationCenter.default.removeObserver(showObserver)
        }
        if let hideObserver = showObserver {
            NotificationCenter.default.removeObserver(hideObserver)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endSearchMode(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(endSearchMode(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        noSearchResultView.imageType = .dynamic
        noSearchResultView.isHidden = true
        
        backgroundView.addSubview(noSearchResultView)
        noSearchResultView.skhPinHorizontalEdgesToSuperviewEdges()
        noSearchResultView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20.0).isActive = true
        tableView.backgroundView = backgroundView
        
        // 디퍼블을 이용하느냐 마느냐.
        configureDataSource()
        setupKeyboardObserver()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { context in
        } completion: { context in
        }
        if isShowKeyboard {
            view.endEditing(true)
        }
    }
    
    // MARK: - 생성 & 소멸
    
    func configureDataSource() {
        tableView.dataSource = nil
        dataSource = UITableViewDiffableDataSource<String, SKHOutlineItem<DTOIndicatorSetting>>(
            tableView: tableView) { (tableView: UITableView, 
                                     indexPath: IndexPath,
                                     outlineItem: SKHOutlineItem<DTOIndicatorSetting>
            ) -> IndicatorSettingCell? in
                
                let identifier = IndicatorSettingCellID.search.rawValue
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: identifier,
                    for: indexPath
                ) as? IndicatorSettingCell else {
                    assertionFailure("IndicatorSettingCell 이 아니다 ")
                    return IndicatorSettingCell()
                }
                cell.selectionStyle = .none
                cell.data = outlineItem.contentItem
                return cell
        }
        dataSource?.defaultRowAnimation = .fade
    }
    
    func setupKeyboardObserver() {
        let nc = NotificationCenter.default
        showObserver = nc.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.isShowKeyboard = true
            self.handleKeyboardNotification(notification)
        }
        
        hideObserver = nc.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.isShowKeyboard = false
            self.handleKeyboardNotification(notification)
        }
    }
    
    // MARK: - Actions
    
    func handleKeyboardNotification(_ notification: Notification) {
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
            let originalMaxOffsetY = tableView.skhMaxOffset().y - tableView.contentInset.bottom
            if originalMaxOffsetY < tableView.contentOffset.y {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: duration,
                    delay: 0.0,
                    options: options,
                    animations: {
                        self.tableView.contentOffset = CGPoint(x: 0.0, y: originalMaxOffsetY)
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.tableView.contentInset = .zero
                        self.tableView.scrollIndicatorInsets = .zero
                    }
            } else {
                tableView.contentInset = .zero
                tableView.scrollIndicatorInsets = .zero
            }
            return  //! return 해야한다.
        }
        
        if name == UIResponder.keyboardWillShowNotification {
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
            tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        }
        
        guard let window = view.window else {
            return
        }
        
        let rect = view.convert(view.bounds, to: window)
        let upLength = rect.origin.y + rect.size.height + 4.0
        let total = upLength + keyboardHeight
        var movingOffset = tableView.contentOffset
           
        if total > window.bounds.height {
            let move = abs(window.bounds.height - total)
            movingOffset = CGPoint(x: movingOffset.x, y: movingOffset.y + move)
        }
                
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0.0,
            options: options,
            animations: {
                self.tableView.contentOffset = movingOffset
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func updateEmptyStringModeForText(_ searchText: String) {
        if searchText.isEmpty {
            emptyStringMode = true
        } else {
            emptyStringMode = false
        }
    }
}

extension IndicatorSettingSearchController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        updateEmptyStringModeForText(searchBar.text ?? "")
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateEmptyStringModeForText(searchText)
        if emptyStringMode == false {
            if isDebounceEnabled {
                debounceClosure(0.2) { [weak self] in
                    self?.updateSearchResult(searchBar, currentText: searchText)
                }
            } else {
                updateSearchResult(searchBar, currentText: searchText)
            }
        }
    }
    
    // MARK: - private Helper
    
    /// 디바운스(debounce) 효과가 부담스럽다면 디바운스만 제거하고 실행 Closure를 그냥 실행하면된다
    private func updateSearchResult(_ searchBar: UISearchBar, currentText: String) {
        guard let viewModel = viewModel,
              let dataSource = dataSource
        else {
            return
        }
        let snp = viewModel.snapshotForCurrentText(currentText)
        if snp.numberOfItems == 0 {
            self.noSearchResultView.searchText = currentText
            self.noSearchResultView.isHidden = false
            dataSource.apply(NSDiffableDataSourceSnapshot(), animatingDifferences: false)
        } else {
            self.noSearchResultView.isHidden = true
            self.tableView.contentOffset = .zero
            dataSource.apply(snp, animatingDifferences: false)
        }
    }
}

extension IndicatorSettingSearchController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension IndicatorSettingSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let outlineItem = dataSource?.itemIdentifier(for: indexPath) {
            selectItemCompletion?(outlineItem)
        }
    }
}

extension IndicatorSettingSearchController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        if tableView.indexPathForRow(at: location) != nil && !emptyStringMode {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - private Helper
    
    @objc func endSearchMode(_ sender: UIGestureRecognizer) {
        view.window?.endEditing(true)
    }
}
