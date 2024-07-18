//
//  ViewController.swift
//  DropdownButton
//
//  Created by Kwan Hyun Son on 11/26/23.
//

import UIKit
import IosKit

enum SampleType {
    case text
    case subPlus
    case subMinus
    case subNormal
    case favorite
    case favoriteSub
    case search
}

final class ViewController: UIViewController {
    
    // MARK: - Property
    
    var sampleType: SampleType?
    
    var dataSource: UITableViewDiffableDataSource<String, [[String]]>?
    var currentSnapshot: NSDiffableDataSourceSnapshot<String, [[String]]>?
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sampleType == .text {
            navigationItem.title = "텍스트 컨텐츠"
        }
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
//        let var1 = SKUDropdownButton()
//        let var2 = MGUDropdownButton()
//        for stepper in steppers {
//            stepper.addTarget(self, action:#selector(stepperValueChanged(_:)), for: .valueChanged)
//        }
//
//        appleStepper.addTarget(self, action:#selector(appleStepperValueChanged), for: .valueChanged)
    }
    
    // MARK: - 생성 & 소멸
    
    
    
    // MARK: - Actions
    @objc private func stepperValueChanged(_ sender: MGUStepper) {
        print("stepper.value \(sender.value)")
    }
    
    @objc private func appleStepperValueChanged(_ sender: UIStepper, forEvent event: UIEvent) {
        print("stepper.value \(sender.value) [\(event)]")
    }
    
    @objc private func test(_ sender: UIControl, forEvent event: UIEvent) {
        print("test \(sender) SON[\(event)]SON")
    }
}

extension ViewController {
    func configureTableView() {
        tableView.rowHeight = 44.0
        tableView.delegate = self
    }
    
    func configureDataSource() {
        
        dataSource =
        UITableViewDiffableDataSource (tableView: tableView) {
             (tableView: UITableView, indexPath: IndexPath, item: [[String]]) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier:TableViewCellID.text.rawValue,
                for: indexPath)
            
            
//            cell.accessoryType = .disclosureIndicator
//            var content = cell.defaultContentConfiguration()
//            content.text = "item.title"
//            content.secondaryText = "item.detailText"
//
//            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top:8.0, leading:8.0, bottom:8.0, trailing:8.0)
//            content.textToSecondaryTextVerticalPadding = 5.0
//            cell.contentConfiguration = content
            return cell
        }

        dataSource?.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<String, [[String]]>()
//        let allItems = ItemsForTableView.shared.allItems
//        for i in 0..<allItems.count {
//            let section = allItems[i]
//            let sectionTitle = section.sectionTitle
//            let items = section.items
//
//            currentSnapshot?.appendSections([sectionTitle])
//            currentSnapshot?.appendItems(items, toSection:sectionTitle)
//        }
        
        
        currentSnapshot?.appendSections(["sectionTitle"])
        currentSnapshot?.appendItems([[["AAA", "BBB", "CCC"], ["444", "444", "444"]], [["555", "555", "555"]], [["666", "666", "666"]] ], toSection:"sectionTitle")
        
        dataSource?.apply(currentSnapshot!, animatingDifferences: animated)
    }
}

extension ViewController: UITableViewDelegate {
    
}
