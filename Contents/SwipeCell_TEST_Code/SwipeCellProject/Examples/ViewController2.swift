//
//  File.swift
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2023/05/26.
//

import UIKit
import IosKit


final class ViewController2: UIViewController {
    
    var dataSource : UITableViewDiffableDataSource<String, String>?
    var currentSnapshot : NSDiffableDataSourceSnapshot<String, String>?
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var items = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.isToolbarHidden = true
    }
}

extension ViewController2 {
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        tableView.register(MGUSwipeTableViewCell.self, forCellReuseIdentifier:NSStringFromClass(MGUSwipeTableViewCell.self))
        tableView.delegate = self
    }
    
    func configureDataSource() {
        
        dataSource =
        UITableViewDiffableDataSource (tableView: tableView) {
             (tableView: UITableView, indexPath: IndexPath, item: String) -> MGUSwipeTableViewCell? in
            
           guard let cell = tableView.dequeueReusableCell(
                withIdentifier:NSStringFromClass(MGUSwipeTableViewCell.self),
                for: indexPath) as? MGUSwipeTableViewCell else {
               
               return MGUSwipeTableViewCell()
           }
            
            cell.accessoryType = .disclosureIndicator
            var content = cell.defaultContentConfiguration()
            content.text = item
            content.directionalLayoutMargins = NSDirectionalEdgeInsets(top:8.0, leading:8.0, bottom:8.0, trailing:8.0)
            content.textToSecondaryTextVerticalPadding = 5.0
            cell.contentConfiguration = content
            cell.delegate = self;
            return cell
        }

        dataSource?.defaultRowAnimation = .fade
    }
    
    func updateUI(animated: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<String, String>()
        currentSnapshot?.appendSections(["0"])
        currentSnapshot?.appendItems(items, toSection:"0")
        dataSource?.apply(currentSnapshot!, animatingDifferences: animated)
    }
}

// MARK: - UITableViewDelegate
extension ViewController2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let maskView = cell.mask {
            maskView.frame = cell.bounds
        }
    }
}

extension ViewController2: MGUSwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, leading_SwipeActionsConfigurationForRowAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailing_SwipeActionsConfigurationForRowAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
        let deleteAction = MGUSwipeAction.init(style: .destructive, title: nil) {[weak self] action, sourceView, completionHandler in
            if let items = [self?.items[indexPath.row]] as? [String],
               var snapshot = self?.dataSource?.snapshot() as? NSDiffableDataSourceSnapshot<String, String>{
                snapshot.deleteItems(items)
                self?.items.remove(at: indexPath.row)
                self?.dataSource?.apply(snapshot, animatingDifferences:true, completion: nil)
            }
        }
        let image = UIImage.init(systemName: "trash")
        deleteAction.image = image?.mgrImage(with: .white)
        let configuration = MGUSwipeActionsConfiguration.init(actions: [deleteAction])
        configuration.expansionStyle = .fill()
        configuration.transitionStyle = .reveal
        configuration.backgroundColor = .systemRed
        return configuration
    }
}
