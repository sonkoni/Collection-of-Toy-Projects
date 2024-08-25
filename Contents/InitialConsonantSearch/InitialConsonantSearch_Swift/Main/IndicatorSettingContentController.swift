//
//  IndicatorSettingContentController.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit
import BaseKit
import IosKit

final class IndicatorSettingContentController: UIViewController {

    // MARK: - Property
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<String, SKHOutlineItem<DTOIndicatorSetting>>?
    var viewModel: IndicatorSettingViewModel?
    lazy var board: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }()
    lazy var detailController: IndicatorSettingDetailController = {
        let controller = board.instantiateViewController(withIdentifier: "IndicatorSettingDetailController") as! IndicatorSettingDetailController
//        controller.viewModel = self.viewModel
        return controller
    }()


    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44.0
        tableView.estimatedRowHeight = 44.0
        // tableView.contentInsetAdjustmentBehavior = .never
        // tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1000.0, right: 0.0)
        configureDataSource()
    }
    
    // MARK: - 생성 & 소멸
    
    private func configureDataSource() {
        tableView.dataSource = nil
        
        dataSource = UITableViewDiffableDataSource<String, SKHOutlineItem<DTOIndicatorSetting>>(
            tableView: tableView,
            cellProvider: { (tableView: UITableView, indexPath: IndexPath, outlineItem: SKHOutlineItem<DTOIndicatorSetting>) -> IndicatorSettingCell? in
                
                guard var identifier = outlineItem.contentItem?.identifier
                else {
                    return nil
                }
                if self.viewModel?.currentMainCategory == .favorites {
                    if identifier == IndicatorSettingCellID.subMinus.rawValue {
                        identifier = IndicatorSettingCellID.favoriteSub.rawValue
                    } else if identifier == IndicatorSettingCellID.subPlus.rawValue ||
                              identifier == IndicatorSettingCellID.subNormal.rawValue ||
                              identifier == IndicatorSettingCellID.region.rawValue {
                        identifier = IndicatorSettingCellID.favorite.rawValue
                    } else {
                        assertionFailure("예상치 못한 identifier이다.")
                    }
                }
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? IndicatorSettingCell
                else {
                    assertionFailure("Could not create new cell")
                    return nil
                }
                cell.selectionStyle = .none
                cell.data = outlineItem.contentItem
                return cell
            }
        )
        
        guard let dataSource = dataSource,
              let viewModel = viewModel
        else {
            return
        }
        dataSource.defaultRowAnimation = .fade
        dataSource.apply(viewModel.snapshotForCurrentState(), animatingDifferences: false)
    }
    
    // MARK: - Actions
    
    @IBAction func selectionButtonClicked(_ sender: UIButton) {
        guard let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender),
              let outlineItem = dataSource?.itemIdentifier(for: indexPath)
        else {
            return
        }

        outlineItem.contentItem?.isSelected.toggle()
        
        if let cell = tableView.cellForRow(at: indexPath) as? IndicatorSettingCell,
           let data = cell.data {
            cell.data = data
        }
        
        if let progenitor = outlineItem.progenitor,
           let progenitorPath = dataSource?.indexPath(for: progenitor),
           let progenitorCell = tableView.cellForRow(at: progenitorPath) as? IndicatorSettingCell {
            progenitorCell.data = progenitor.contentItem
        }
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        guard let outlineItem = outlineDataForSender(sender),
              let data = outlineItem.contentItem,
              let viewModel = viewModel
        else {
            return
        }

        data.isFavorite.toggle()
        if let cell = cellForSender(sender) {
            cell.data = data
        }
        
        if #available(iOS 13, *) {
            var completionClosure : (() -> Void)?
            if viewModel.currentMainCategory == .favorites {
                completionClosure = { [weak self, weak viewModel] () -> Void in
                    if let strongviewModel = viewModel {
                        self?.dataSource?.apply(
                            strongviewModel.snapshotForCurrentState(),
                            animatingDifferences: true,
                            completion: nil)
                    }
                }
            }
            viewModel.updateFavoriteItem(outlineItem, completion: completionClosure)
        }
    }
    
    @IBAction func plusButtonClicked(_ sender: UIButton) {
        guard let dataSource = dataSource,
              let viewModel = viewModel,
              let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender),
              let outlineItem = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        viewModel.addChildItem(for: outlineItem)
        dataSource.apply(viewModel.snapshotForCurrentState(), animatingDifferences: true, completion: nil)
    }
    
    @IBAction func minusButtonClicked(_ sender: UIButton) {
        guard let dataSource = dataSource,
              let viewModel = viewModel,
              let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender),
              let outlineItem = dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        let progenitor = outlineItem.progenitor // 반드시 먼저 잡아야한다
        viewModel.deleteItem(outlineItem)
        if let progenitor = progenitor,
           let progenitorPath = dataSource.indexPath(for: progenitor),
           let progenitorCell = tableView.cellForRow(at: progenitorPath) as? IndicatorSettingCell {
            progenitorCell.data = progenitor.contentItem
        }
        dataSource.apply(viewModel.snapshotForCurrentState(), animatingDifferences: true, completion: nil)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        if let navigationController = navigationController {
            var subString = IndiSetMainCategory.indicators.rawValue
            if viewModel?.currentMainCategory == .indicators {
                // 그대로
            } else if viewModel?.currentMainCategory == .signals {
                subString = IndiSetMainCategory.signals.rawValue
            } else if viewModel?.currentMainCategory == .patterns {
                subString = IndiSetMainCategory.patterns.rawValue
            } else if viewModel?.currentMainCategory == .ranges {
                subString = IndiSetMainCategory.ranges.rawValue
            } else if viewModel?.currentMainCategory == .fill {
                subString = IndiSetMainCategory.fill.rawValue
            } else if viewModel?.currentMainCategory == .favorites {
                subString = IndiSetMainCategory.favorites.rawValue
            } else {
                assertionFailure("예상치 못한 값이 들어왔다. 수정하라")
            }
            
            navigationController.topViewController?.navigationItem.backButtonTitle = "지표설정/" + subString
            navigationController.pushViewController(detailController, animated: true)
        }
    }
    
    func reloadData(completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            guard let dataSource = dataSource,
                  let viewModel = viewModel else {
                return
            }
            if #available(iOS 15.0, *) {
                dataSource.applySnapshotUsingReloadData(viewModel.snapshotForCurrentState()) {
                    completion?()
                }
            } else {
                dataSource.apply(viewModel.snapshotForCurrentState(), animatingDifferences: false) {
                    completion?()
                }
            }
        }
    }
    
    func scrollToRow(
        at item: SKHOutlineItem<DTOIndicatorSetting>,
        at scrollPosition: UITableView.ScrollPosition,
        animated: Bool) {
            if let index = dataSource?.snapshot().indexOfItem(item) {
                let indexPath = IndexPath.init(row: index, section: 0)
                tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
            }
    }
    
    // MARK: - Helper

    private func cellForSender(_ sender: UIView) -> IndicatorSettingCell? {
        if let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender) {
            return tableView.cellForRow(at: indexPath) as? IndicatorSettingCell
        }
        return nil
    }
    
    private func dataForSender(_ sender: UIView) -> DTOIndicatorSetting? {
        return outlineDataForSender(sender)?.contentItem
    }
    
    private func outlineDataForSender(_ sender: UIView) -> SKHOutlineItem<DTOIndicatorSetting>? {
        if #available(iOS 13.0, *) {
            if let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender),
               let outlineItem = dataSource?.itemIdentifier(for: indexPath) {
                return outlineItem
            }
        }
        return nil
    }
}

extension IndicatorSettingContentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let outlineItem = dataSource.itemIdentifier(for: indexPath),
              let cell = tableView.cellForRow(at: indexPath) as? IndicatorSettingCell else {
            return
        }
            
        if outlineItem.contentItem?.identifier == IndicatorSettingCellID.section.rawValue &&
           outlineItem.hasSubitem {
            outlineItem.isExpanded.toggle()
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0.0,
                options: [],
                animations: {
                    cell.data = cell.data
                },
                completion: { _ in }
            )
            if let viewModel = self.viewModel {
                self.dataSource?.apply(
                    viewModel.snapshotForCurrentState(),
                    animatingDifferences: true,
                    completion: {}
                )
            }
        }
    }
}

extension IndicatorSettingContentController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToolSettingCell", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
