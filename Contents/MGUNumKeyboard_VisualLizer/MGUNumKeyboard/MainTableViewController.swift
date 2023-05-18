//
//  ViewController.swift
//  MGUNumKeyboard
//
//  Created by Kwan Hyun Son on 2022/10/08.
//

import UIKit
import IosKit

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<String, Item> {
    // MARK: header/footer titles support
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allItems = ItemsForTableView.shared.allItems
        return allItems[section].sectionTitle
    }
}

final class MainTableViewController: UIViewController {
    
    var dataSource : TableViewDiffableDataSource?
    var currentSnapshot : NSDiffableDataSourceSnapshot<String, Item>?
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MGUNumKeyboard"
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //! 현재 컨트롤러가 UITableViewController 가 아니므로, clearsSelectionOnViewWillAppear가 없다.
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at:indexPath, animated:true)  // 원래 뷰로 돌아 올때, 셀렉션을 해제시킨다. 이게 더 멋지다.
        }
    }
}

extension MainTableViewController {
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:NSStringFromClass(UITableViewCell.self))
        tableView.delegate = self
    }
    
    func configureDataSource() {
        
        dataSource =
        TableViewDiffableDataSource (tableView: tableView) {
             (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier:NSStringFromClass(UITableViewCell.self),
                for: indexPath)
            
            
            cell.accessoryType = .disclosureIndicator
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.detailText
            
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top:8.0, leading:8.0, bottom:8.0, trailing:8.0)
            content.textToSecondaryTextVerticalPadding = 5.0
            cell.contentConfiguration = content
            return cell
        }

        dataSource?.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<String, Item>()
        let allItems = ItemsForTableView.shared.allItems
        for i in 0..<allItems.count {
            let section = allItems[i]
            let sectionTitle = section.sectionTitle
            let items = section.items
            
            currentSnapshot?.appendSections([sectionTitle])
            currentSnapshot?.appendItems(items, toSection:sectionTitle)
        }
        
        dataSource?.apply(currentSnapshot!, animatingDifferences: animated)
    }
}

// MARK: - UITableViewDelegate
extension MainTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController? = nil
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                viewController = ViewControllerA()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                viewController = ViewControllerB()
            } else if indexPath.row == 1 {
                viewController = ViewControllerC()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                viewController = ViewControllerD()
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                viewController = ViewControllerE()
            }
        }
        
        if let viewController = viewController {
            navigationController?.pushViewController(viewController, animated:true)
        }
    }
}
