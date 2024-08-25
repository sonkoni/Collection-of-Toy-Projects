//
//  ChartTypeViewController.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit
import IosKit

private final class AccessoryView: UIImageView {
    
    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 56.0, height: 28.0)
    }
    
    // MARK: - 생성 & 소멸

    private func commonInit() {
        if let settingButtonImage = UIImage(named: "settingGo") {
            let templateImage = settingButtonImage.withRenderingMode(.alwaysTemplate)
            image = templateImage
        }
        contentMode = .center
        isUserInteractionEnabled = false
        tintColor = UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        // tintColor = UIColor(white: 0.4, alpha: 1.0)
    }
}

final class ToolSettingViewController: UIViewController {
    
    // MARK: - Property
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ToolSettingViewModel?
    private var board: UIStoryboard = {
        let board = UIStoryboard(name: "Main", bundle: Bundle.main)
        return board
    }()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupToolbar()
    }
    
    // MARK: - 생성 & 소멸
    
    private func commonInit() {
        viewModel = ToolSettingViewModel()
        
        let identifier = String(describing: ConfigCommonHeaderCell.self)
        let tableHeaderNib = UINib(nibName: identifier, bundle: Bundle.main)
        tableView.register(tableHeaderNib, forHeaderFooterViewReuseIdentifier: identifier)
        
        title = "Tool Setting 목업 테스트"
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        tableView.sectionHeaderTopPadding = 0.0
        tableView.rowHeight = 44.0
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupToolbar() {
        navigationController?.isToolbarHidden = false
        let appearance = UIToolbarAppearance()
        let plainBarButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        plainBarButtonItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        appearance.buttonAppearance = plainBarButtonItemAppearance
        let doneBarButtonItemAppearance = UIBarButtonItemAppearance(style: .done)
        doneBarButtonItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.doneButtonAppearance = doneBarButtonItemAppearance
        
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        if #available(iOS 15, *) {
            navigationController?.toolbar.scrollEdgeAppearance = appearance
            navigationController?.toolbar.compactScrollEdgeAppearance = appearance
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        navigationController?.toolbar.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true
        separator.centerXAnchor.constraint(equalTo: separator.superview!.centerXAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: separator.superview!.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: separator.superview!.bottomAnchor, constant: 50.0).isActive = true
    }
    
    // MARK: - Actions
    
    private func settingViewController(for indexPath: IndexPath) -> UIViewController {
        if (indexPath.section == 0 && indexPath.row == 0) {
            guard let standardLineSettingViewController = board.instantiateViewController(withIdentifier: "StandardLineSettingViewController") as? StandardLineSettingViewController else {
                return UIViewController()
            }
            
            if let viewModel = viewModel {
                let title = viewModel.chartLineType(for: indexPath)
                standardLineSettingViewController.title = title.rawValue
            }
            return standardLineSettingViewController
        }
        
        guard let settingViewController = board.instantiateViewController(withIdentifier: "LineSettingViewController") as? LineSettingViewController else {
            return UIViewController()
        }
        
        if let viewModel = viewModel {
            let settingViewModel = viewModel.lineSettingViewModel(for: indexPath)
            let title = viewModel.chartLineType(for: indexPath)
            settingViewController.title = title.rawValue
            settingViewController.viewModel = settingViewModel
        }
        return settingViewController
    }
}

extension ToolSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToolSettingCell", for: indexPath) as? ToolSettingCell,
              let viewModel = viewModel
        else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.title = viewModel.chartLineType(for: indexPath).rawValue
        if indexPath.row == 1 || indexPath.row == 2 {
            cell.accessoryView = nil
            cell.editingAccessoryView = nil
        } else {
            let accessoryView = AccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 43.0, height: 28.0))
            cell.accessoryView = accessoryView
            let editingAccessoryView = AccessoryView(frame: CGRect(x: 0.0, y: 0.0, width: 43.0, height: 28.0))
            cell.editingAccessoryView = editingAccessoryView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath != destinationIndexPath && destinationIndexPath.row > 2 {
            let index = sourceIndexPath.row
            guard let viewModel = viewModel
            else {
                return
            }
            let object = viewModel.lineTypes[index]
            viewModel.lineTypes.remove(at: index)
            viewModel.lineTypes.insert(object, at: destinationIndexPath.row)
        }
    }
}

extension ToolSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FIXME: - 테스트 코드 : 나중에 지워라.
        /// if indexPath.section == 0 && indexPath.row == 0 {
        ///     let viewController = UIViewController()
        ///     viewController.view.backgroundColor = UIColor.white
        ///     navigationController?.pushViewController(viewController, animated: true)
        ///     return
        /// }
        
        guard let viewModel = viewModel
        else {
            return
        }
        let lineType = viewModel.chartLineType(for: indexPath)
        if lineType == ToolSettingLineType.deleteAllTrendlines ||
           lineType == ToolSettingLineType.deleteTrendline {
            return
        }
        let vc = settingViewController(for: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section == 0 &&
            (proposedDestinationIndexPath.row == 0 ||
             proposedDestinationIndexPath.row == 1 ||
             proposedDestinationIndexPath.row == 2) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}
