//
//  ViewController.swift
//  MGUNeoSegControl
//
//  Created by Kwan Hyun Son on 2022/10/08.
//

import UIKit
import BaseKit
import IosKit

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<String, Item> {
    // MARK: header/footer titles support
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allItems = ItemsForTableView.shared.allItems
        return allItems[section].sectionTitle
    }
}

final class MainTableViewController: UIViewController {
    
    private var dataSource : TableViewDiffableDataSource?
    private var currentSnapshot: NSDiffableDataSourceSnapshot<String, Item>?
    
    private lazy var tableView = {
        return UITableView(frame: .zero, style: .insetGrouped)
    }()
    
    private var iOSBundle: Bundle? = {
        return Bundle.skhIosRes
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Financial Keyboard"
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainTableViewController {
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = TableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in

            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: UITableViewCell.self),
                for: indexPath
            )

            if indexPath.section == 1 {
                cell.accessoryType = .disclosureIndicator
            }

            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                content.secondaryText = item.detailText
                content.textProperties.color = .label
                // content.textProperties.font = .boldSystemFont(ofSize: 13.0)
                content.secondaryTextProperties.color = .secondaryLabel
                // content.secondaryTextProperties.font = .systemFont(ofSize: 12.0)
                content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
                content.textToSecondaryTextVerticalPadding = 5.0
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.detailText
            }

            return cell
        }
        self.dataSource?.defaultRowAnimation = .fade
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
        tableView.deselectRow(at: indexPath, animated: true)
        var viewController: UIViewController?
        if indexPath.section == 0 {
        viewController = ViewControllerA()
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let board = UIStoryboard(name: "ViewControllerB", bundle: nil)
                viewController = board.instantiateViewController(withIdentifier: "ViewControllerB")
            } else if indexPath.row == 1 {
                let board = UIStoryboard(name: "ViewControllerF", bundle: nil)
                viewController = board.instantiateViewController(withIdentifier: "ViewControllerF")
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            ///case 0: viewController = ViewController3.init()
            ///case 1: viewController = ViewController4.init()
            default: break
            }
        }
        
        if let viewController = viewController {
            let allItems = ItemsForTableView.shared.allItems
            let section = allItems[indexPath.section]
            let title = section.items[indexPath.row].title
            viewController.navigationItem.title = title
            navigationController?.pushViewController(viewController, animated:true)
        }
    }
}
