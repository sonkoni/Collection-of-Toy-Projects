//
//  File.swift
//  SwipeCellProject
//
//  Created by Kwan Hyun Son on 2023/05/26.
//

import UIKit
import IosKit

final class ViewController2: UIViewController, UICollectionViewDelegate {
    var dataSource: UICollectionViewDiffableDataSource<String, EmailCellModel>?
    var collectionView: UICollectionView?
    var emails = EmailCellModel.mockEmails()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "타이틀"
        view.backgroundColor = .systemGroupedBackground
        configureTableView()
        configureDataSource()
        updateUI(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.isToolbarHidden = true
    }
}

extension ViewController2 {
    func configureTableView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.decelerationRate = .normal
        collectionView.allowsMultipleSelection = false
        collectionView.register(CollectionViewEmailCell.self,
                                forCellWithReuseIdentifier: NSStringFromClass(CollectionViewEmailCell.self))
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        self.collectionView = collectionView
    }
    
    func configureDataSource() {
        guard let collectionView = self.collectionView else {
            return
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider: { (collectionView: UICollectionView,
                                                                         indexPath: IndexPath,
                                                                         cellModel: EmailCellModel) -> MGUSwipeCollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CollectionViewEmailCell.self), for: indexPath) as? CollectionViewEmailCell else {
                return MGUSwipeCollectionViewCell()
             }
            cell.setData(cellModel)
            cell.delegate = self;
            return cell
        })
    }
    
    func updateUI(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<String, EmailCellModel>()
        snapshot.appendSections(["0"])
        snapshot.appendItems(emails, toSection:"0")
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let maskView = cell.mask {
            maskView.frame = cell.bounds
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 98.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension ViewController2: MGUSwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, leading_SwipeActionsConfigurationForItemAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, trailing_SwipeActionsConfigurationForItemAt indexPath: IndexPath) -> MGUSwipeActionsConfiguration? {
        let deleteAction = MGUSwipeAction.init(style: .destructive, title: nil) {[weak self] action, sourceView, completionHandler in
            if let items = [self?.emails[indexPath.row]] as? [EmailCellModel],
               var snapshot = self?.dataSource?.snapshot() {
                snapshot.deleteItems(items)
                self?.emails.remove(at: indexPath.row)
                self?.dataSource?.mgrSwipeApply(snapshot, collectionView: collectionView)
                //! 중요: MGUSwipeCollectionViewCell를 사용하여 스와이프로 삭제할 때는 내가 만든 메서드를 사용해야한다. ∵ 애니메이션 효과 때문에
            }
        }
        let image = UIImage.init(systemName: "trash")
        deleteAction.image = image?.mgrImage(with: .white)
        deleteAction.title = "Trash"
        let configuration = MGUSwipeActionsConfiguration.init(actions: [deleteAction])
        configuration.expansionStyle = .fill()
        configuration.transitionStyle = .reveal
        configuration.backgroundColor = .systemRed
        print(configuration)
        return configuration
    }
    
    func visibleRect(for collectionView: UICollectionView) -> CGRect {
        return .null
    }
}
