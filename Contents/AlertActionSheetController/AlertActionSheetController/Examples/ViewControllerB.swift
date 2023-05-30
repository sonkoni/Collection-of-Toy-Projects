//
//  ViewControllerB.swift
//  Alert & Action Sheet
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import IosKit

final class ViewControllerB: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "IV-Drop 에서 사용"
        
        
        let config = MGUNeoSegConfiguration.forge()
        containerView.backgroundColor = config.backgroundColor
        let segmentedControl = MGUNeoSegControl.init(titles: self.dropTitleAndImageModels(),
                                                     selecedtitle: "chrome",
                                                     configuration: config)
        containerView.addSubview(segmentedControl)
        segmentedControl.mgrPinCenterToSuperviewCenter(withFix: CGSize(width: 300.0, height: 80.0))
        segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        segmentedControl.impactOff = false
    }
    
    
    // MARK: - Actions
    @objc private func valueChanged(_ sender: MGUNeoSegControl) {
        print("밸류가 바뀌었다. \(sender.selectedSegmentIndex)")
    }
    
    
    // MARK: - Make
    private func dropTitleAndImageModels() -> [MGUNeoSegModel] {
        let model1 = MGUNeoSegModel.segmentModel(withTitle: "10", imageName: "chamber_drop_10_size")
        let model2 = MGUNeoSegModel.segmentModel(withTitle: "15", imageName: "chamber_drop_15_size")
        let model3 = MGUNeoSegModel.segmentModel(withTitle: "20", imageName: "chamber_drop_20_size")
        let model4 = MGUNeoSegModel.segmentModel(withTitle: "60", imageName: "chamber_drop_60_size")
        return [model1, model2, model3, model4]
    }
}
