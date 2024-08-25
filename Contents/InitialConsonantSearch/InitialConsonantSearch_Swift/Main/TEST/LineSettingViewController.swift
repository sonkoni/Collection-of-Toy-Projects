//
//  ChartSettingViewController.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit
import IosKit

final class LineSettingViewController: UIViewController {
    
    // MARK: - Property
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: LineSettingViewModel? {
        didSet {
            navigationItem.title = viewModel?.mainTitle
        }
    }
    
    private var colorPickerViewController: UIColorPickerViewController!
    
    private var colorPickerCompletion: ((UIColor) -> Void)?

    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let identifier = String(describing: ConfigCommonHeaderCell.self)
        let tableHeaderNib = UINib(nibName: identifier, bundle: nil)
        tableView.register(tableHeaderNib, forHeaderFooterViewReuseIdentifier: identifier)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        tableView.sectionHeaderTopPadding = 0.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.dataSource = self
        tableView.delegate = self
        
        colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .popover
    }

    // MARK: - Actions
    
    @IBAction private func titleButtonClicked(_ sender: UIButton) {
        guard let data = dataForSender(sender)
        else {
            return
        }
        data.isSelected = !data.isSelected
        if let cell = cellForSender(sender) {
            cell.data = data
        }
        synchronize()
    }

    @IBAction private func colorButtonClicked(_ sender: UIButton) {
        guard let data = dataForSender(sender)
        else {
            return
        }
        colorPickerCompletion = { [weak self] selectedColor in
            sender.backgroundColor = selectedColor
            data.color = selectedColor
            self?.synchronize()
        }
        colorPickerViewController.selectedColor = sender.backgroundColor ?? UIColor.clear
        colorPickerViewController.title = data.title
        if let popoverPresentationController = colorPickerViewController.popoverPresentationController {
            popoverPresentationController.sourceView = sender
        }
        present(colorPickerViewController, animated: true, completion: nil)
    }

    @IBAction private func toggleValueChanged(_ sender: UISwitch) {
        guard let data = dataForSender(sender)
        else {
            return
        }
        data.isToggleOn = sender.isOn
    }

    @IBAction private func dropdownBtnValueChanged(_ sender: SKUDropdownButton) {
        guard let data = dataForSender(sender)
        else {
            return
        }
        data.dropBtnSelectedIndex = sender.selectedIndex
        synchronize()
    }

    @IBAction private func boldButtonClicked(_ sender: UIButton) {
        guard let data = dataForSender(sender)
        else {
            return
        }
        data.isBold = !data.isBold
        if let cell = cellForSender(sender) {
            cell.data = data
        }
    }

    private func synchronize() {
        let lineType = viewModel?.lineType
        if lineType == ToolSettingLineType.shapeEllipse ||
           lineType == ToolSettingLineType.shapeRectangle ||
           lineType == ToolSettingLineType.shapeTriangle {
            let indexPath = IndexPath(row: 0, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? LineSettingCell {
                viewModel?.synchronize { [weak self] in
                    let data = self?.viewModel?.cellModel(for: indexPath)
                    cell.data = data
                }
            }
        }
    }
    
    // MARK: - Helper

    private func cellForSender(_ sender: UIView) -> LineSettingCell? {
        if let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender) {
            return tableView.cellForRow(at: indexPath) as? LineSettingCell
        }
        return nil
    }

    private func dataForSender(_ sender: UIView) -> DTOLineSetting? {
        if let indexPath = tableView.skhIndexPathOfCellWhereViewExists(view: sender),
           let viewModel = viewModel {
            return viewModel.cellModel(for: indexPath)
        }
        return nil
    }
}

extension LineSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let setting = viewModel.cellModel(for: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: setting.identifier, for: indexPath) as? LineSettingCell {
            cell.data = setting
            return cell
        }
        return UITableViewCell()
    }
}

extension LineSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ConfigCommonHeaderCell.self)) as? ConfigCommonHeaderCell
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = .systemGray6
        header?.backgroundConfiguration = backgroundConfig
        header?.titleLabel.text = viewModel?.sectionTitles[section]
        return header
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

@available(iOS 14.0, *)
extension LineSettingViewController: UIColorPickerViewControllerDelegate {
    
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
