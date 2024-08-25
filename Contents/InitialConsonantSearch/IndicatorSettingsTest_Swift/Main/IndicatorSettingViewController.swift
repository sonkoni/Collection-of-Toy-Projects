//
//  IndicatorSettingViewController.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit
import IosKit

final class IndicatorSettingViewController: UIViewController {
    
    // MARK: - Property
    
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dividerHeightConstraint: NSLayoutConstraint!
    var underLineView: UIView!
    var underLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var searchResultContainer: UIView!
    var lastOffsets: [CGPoint] = {
        return [.zero, .zero, .zero, .zero, .zero, .zero]
    }()
    public var viewModel = IndicatorSettingViewModel()
    lazy var board: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }()
    lazy var contentController: IndicatorSettingContentController = {
        let controller = board.instantiateViewController(withIdentifier: "IndicatorSettingContentController") as! IndicatorSettingContentController
        controller.viewModel = self.viewModel
        return controller
    }()
    lazy var searchController: IndicatorSettingSearchController = {
        let controller = board.instantiateViewController(withIdentifier: "IndicatorSettingSearchController") as! IndicatorSettingSearchController
        controller.viewModel = viewModel
        // controller.isDebounceEnabled = false // 디폴트 true
        return controller
        //
        // Debounce 효과를 없애고 싶다면 false 하라.
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] context in
            self.updateCurrentIndex(segmentedControl.selectedSegmentIndex)
        }, completion: { context in
            // Completion code here
        })
    }

    // MARK: - 생성 & 소멸
    
    private func commonInit() {
        dividerHeightConstraint.constant = 1.0 / UIScreen.main.scale
        underLineView = UIView()
        underLineView.backgroundColor = UIColor.black
        segmentContainer.addSubview(underLineView)
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        underLineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        underLineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        let segmentWidth = segmentedControl.frame.size.width / CGFloat(segmentedControl.numberOfSegments)
        underLineLeadingConstraint = underLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        underLineLeadingConstraint.constant = segmentWidth * CGFloat(segmentedControl.selectedSegmentIndex)
        underLineLeadingConstraint.isActive = true
        setupSearhControl()
        setupSegmentedControl()
        skhAddChildViewController(contentController, targetView: contentContainer)
    }

    private func setupSearhControl() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        definesPresentationContext = true
        searchBar.delegate = self
        searchBar.tintColor = UIColor.systemBlue
        searchBar.autocorrectionType = .no
        searchBar.spellCheckingType = .no
        searchBar.returnKeyType = .done
        searchResultContainer.isHidden = true
        skhAddChildViewController(searchController, targetView: searchResultContainer)
        setupJointAction()
        
        // MARK: - 디버깅을 위해서는 아래의 코드를 주석처리하면 좀 더 편리하게 관찰할 수 있다.
        searchResultContainer.backgroundColor = .clear
    }
    
    private func setupSegmentedControl() {
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .semibold),
            .foregroundColor: UIColor.systemGray
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .heavy),
            .foregroundColor: UIColor.black
        ]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    func setupJointAction() {
        
        let selectBlock = { [weak self] (item: SKHOutlineItem<DTOIndicatorSetting>) in
            
            guard let contentItem = item.contentItem
            else {
                return
            }
            var index = 0
            
            if contentItem.mainCategory == .indicators {
                
            } else if contentItem.mainCategory == .signals {
                index = 1
            } else if contentItem.mainCategory == .patterns {
                index = 2
            } else if contentItem.mainCategory == .ranges {
                index = 3
            } else if contentItem.mainCategory == .fill {
                index = 4
            }
            
            self?.segmentedControl.selectedSegmentIndex = index
            self?.updateCurrentIndex(index)  // model 분류 작업
            
            if let superItem = item.superitem {
                superItem.isExpanded = true // 닫혔으면 열어야지.
                // 구간과 즐겨찾기를 제외한 나머지 카테고리
                
                // 선택한 아이템을 맨 상단으로 올리려면 offset이 부족할 수도 있는 상황을 대비해야한다
                if let currentItems = self?.viewModel.currentItems,
                   let itemIndex = currentItems.firstIndex(of: superItem) {
                    if itemIndex < (currentItems.count - 1) {
                        for i in (itemIndex + 1)..<(currentItems.count) {
                            let nextItem = currentItems[i]
                            if let subitems = nextItem.subitems,
                               subitems.count > 0,
                               nextItem.isExpanded == false {
                               nextItem.isExpanded = true
                            }
                        }
                    }
                }
            }

            self?.contentController.reloadData(completion: {
                self?.contentController.scrollToRow(at: item, at: .top, animated: false)
                self?.view.endEditing(true)
            })
        }
        
        searchController.selectItemCompletion = selectBlock
        // searchController 생성 시 작동한다
    }
    
    // MARK: - Actions
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        updateCurrentIndex(sender.selectedSegmentIndex) // 여기서 viewModel도 index에 맞게 분류됨
        var targetOffset = lastOffsets[sender.selectedSegmentIndex]
        contentController.reloadData { [weak self] in
            if let strongSelf = self {
                let maxOffset = strongSelf.contentController.tableView.skhMaxOffset()
                targetOffset = CGPoint(x: min(maxOffset.x, targetOffset.x),
                                       y: min(maxOffset.y, targetOffset.y))
                strongSelf.contentController.tableView.contentOffset = targetOffset
            }
        }
    }
    
    // MARK: - Helper
    
    private func updateUnderLineLeadingConstraint(with index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        underLineLeadingConstraint.constant = segmentWidth * CGFloat(index)
    }
    
    private func updateCurrentIndex(_ index: Int) {
        updateUnderLineLeadingConstraint(with: index)
        // 기존(현재) 인덱스의 lastOffsets 저장
        if viewModel.currentMainCategory == .indicators {
            lastOffsets[0] = contentController.tableView.contentOffset
        } else if viewModel.currentMainCategory == .signals {
            lastOffsets[1] = contentController.tableView.contentOffset
        } else if viewModel.currentMainCategory == .patterns {
            lastOffsets[2] = contentController.tableView.contentOffset
        } else if viewModel.currentMainCategory == .ranges {
            lastOffsets[3] = contentController.tableView.contentOffset
        } else if viewModel.currentMainCategory == .fill {
            lastOffsets[4] = contentController.tableView.contentOffset
        } else if viewModel.currentMainCategory == .favorites {
            lastOffsets[5] = contentController.tableView.contentOffset
        }
        // 현재 index로 viewModel 설정
        if index == 0 {
            viewModel.currentMainCategory = .indicators
        } else if index == 1 {
            viewModel.currentMainCategory = .signals
        } else if index == 2 {
            viewModel.currentMainCategory = .patterns
        } else if index == 3 {
            viewModel.currentMainCategory = .ranges
        } else if index == 4 {
            viewModel.currentMainCategory = .fill
        } else if index == 5 {
            viewModel.currentMainCategory = .favorites
        }
    }
}


extension IndicatorSettingViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool { // first responder가 되지 않으려면 NO를 반환한다
        searchBar.setShowsCancelButton(true, animated: true)
        _ = searchController.searchBarShouldBeginEditing(searchBar)
        searchResultContainer.isHidden = false
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { // 텍스트 편집이 시작될 때 호출된다
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool { // first responder 사임하지 않으려면 NO를 반환한다
        searchResultContainer.isHidden = true
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { // 텍스트 편집이 끝나면 호출된다
        searchBar.text = nil
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // 텍스트가 변경되면 호출된다(`clear` 포함)
        searchController.searchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // 키보드 검색(완료) 버튼을 눌렀을 때 호출됨
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { // 취소버튼 눌렀을 시
        searchBar.resignFirstResponder()
    }
    
    // func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {} called when bookmark button pressed
    // func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {} called when search results button pressed
    // func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {} // 네비게이션바 사용시 제공되는 세그먼트 버튼을 누를 때 호출된다.
}
