//
//  IndicatorSettingDetailController.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/22/23.
//

import UIKit

import IosKit

class IndicatorSettingDetailController: UIViewController {
    
    // MARK: - Property
    
    @IBOutlet weak var segmentedControlContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var graphContainer: UIView!
    @IBOutlet weak var graphSceneContainer: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dividerlayoutConstraint: NSLayoutConstraint!

    var stockLineInfoView = SKUStockLineInfoView()
    var underLineView = UIView()
    var underLineLeadingConstraint: NSLayoutConstraint?
    var viewModel = IndicatorSettingDetailViewModel()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DMI"

        setupTableView()
        setupSegmentedControl()

        graphContainer.addSubview(stockLineInfoView)
        stockLineInfoView.skhPinEdgesToSuperviewEdges()

        let straightLine1 = SKUStockLine()
        straightLine1.lineWidth = 1.0
        straightLine1.lineColor = .systemBlue
        straightLine1.lineDashes = [5.0, 5.0]

        let straightLine2 = SKUStockLine()
        straightLine2.lineWidth = 1.0
        straightLine2.lineColor = UIColor.systemGray

        let curveLine1 = SKUStockLine()
        curveLine1.lineWidth = 5.0
        curveLine1.peakLineColor = .systemMint
        curveLine1.valleyLineColor = .systemBrown
        curveLine1.lineDashes = [0.0, 10.0]

        let curveLine2 = SKUStockLine()
        curveLine2.lineWidth = 2.0
        curveLine2.lineColor = .systemRed
        curveLine2.peakFillColor = UIColor(red: 232.0/255.0, green: 185.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        curveLine2.valleyFillColor = UIColor(red: 157.0/255.0, green: 214.0/255.0, blue: 234.0/255.0, alpha: 1.0)

        let curveLine3 = SKUStockLine()
        curveLine3.lineWidth = 0.0
        curveLine3.lineColor = .clear
        curveLine3.fillMode = .bar
        curveLine3.peakFillColor = .systemRed
        curveLine3.valleyFillColor = .systemBlue

        let info = SKUStockLineInfo()
        info.straightLines = [straightLine1, straightLine2]
        info.curveLines = [curveLine1, curveLine2, curveLine3]

        stockLineInfoView.lineInfo = info
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGraphSceneAppearance(
            selectedSegmentIndex: segmentedControl.selectedSegmentIndex,
            traitCollection: traitCollection
        )
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(
            to: size,
            with: coordinator
        )
        
        coordinator.animate(
            alongsideTransition: {
                context in self.updateUnderLineLeadingConstraint()
            },
            completion: { context in }
        )
    }
    
    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)
        updateGraphSceneAppearance(
            selectedSegmentIndex: segmentedControl.selectedSegmentIndex,
            traitCollection: newCollection
        )
    }

    
    // MARK: - 생성 & 소멸

    private func setupTableView() {
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
    }

    private func setupSegmentedControl() {
        segmentedControlContainer.backgroundColor = .white
        dividerlayoutConstraint.constant = 1.0 / UIScreen.main.scale

        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
            .foregroundColor: UIColor.systemGray
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .heavy),
            .foregroundColor: UIColor.black
        ]

        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)

        underLineView.backgroundColor = .black
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineLeadingConstraint = underLineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        segmentedControlContainer.addSubview(underLineView)
        if let underLineLeadingConstraint = underLineLeadingConstraint {
            NSLayoutConstraint.activate([
                underLineView.heightAnchor.constraint(equalToConstant: 1.0),
                underLineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
                underLineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1.0/3.0),
                underLineLeadingConstraint
            ])
        }
    }
    
    // MARK: - Actions

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        updateUnderLineLeadingConstraint()
        if sender.selectedSegmentIndex == 0 {
            viewModel.detailCategory = .line
            viewModel.detailCategory = .line
        } else if sender.selectedSegmentIndex == 1 {
            viewModel.detailCategory = .conditions
        } else if sender.selectedSegmentIndex == 2 {
            viewModel.detailCategory = .description
        } else {
            assertionFailure("Unexpected index")
        }

        tableView.setContentOffset(.zero, animated: false)
        view.endEditing(true)
        tableView.reloadData()

        updateGraphSceneAppearance(selectedSegmentIndex: selectedSegmentIndex, traitCollection: traitCollection)
    }
    
    private func updateGraphSceneAppearance(selectedSegmentIndex: Int, traitCollection: UITraitCollection) {
        if selectedSegmentIndex == 0 {
            if traitCollection.verticalSizeClass == .compact {
                if !graphSceneContainer.isHidden {
                    graphSceneContainer.isHidden = true
                }
            } else if traitCollection.verticalSizeClass == .regular {
                if graphSceneContainer.isHidden != false {
                    graphSceneContainer.isHidden = false
                }
            }
        } else {
            if graphSceneContainer.isHidden != true {
                graphSceneContainer.isHidden = true
            }
        }
    }

    private func updateUnderLineLeadingConstraint() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        let segmentWidth = segmentedControl.frame.size.width / CGFloat(segmentedControl.numberOfSegments)
        underLineLeadingConstraint?.constant = segmentWidth * CGFloat(selectedSegmentIndex)
    }
}

extension IndicatorSettingDetailController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = viewModel.cellModel(for: indexPath)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: IndicatorSettingDetailCellID.description.rawValue,
            for: indexPath) as! IndicatorSettingDetailCell
        cell.data = setting
        return cell
    }
    
}

extension IndicatorSettingDetailController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: ConfigCommonHeaderCell.self)) as? ConfigCommonHeaderCell
        else {
            return nil
        }
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = UIColor.systemGray6
        header.backgroundConfiguration = backgroundConfig
        header.titleLabel.text = viewModel.sectionTitles[section]
        return header
    }
    
}
