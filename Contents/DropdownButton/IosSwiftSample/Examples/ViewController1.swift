//
//  ViewController1.swift
//  IosSwiftSample
//
//  Created by Kwan Hyun Son on 2023/02/10.
//

import UIKit
import IosKit

class ViewController1: UIViewController {
    
    var dropSegControl1 = SKUDropSegControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SKUDropSegControl"
        
        var seg0 = DTOSKUDropSeg(title: "일", extendedTitle: "일")
        var seg1 = DTOSKUDropSeg(title: "주", extendedTitle: "주")
        var seg2 = DTOSKUDropSeg(title: "월", extendedTitle: "월")
        var seg3 = DTOSKUDropSeg(title: "년", extendedTitle: "년")
        let manager0 = SKUDropSegManager(dropSegs: [seg0, seg1, seg2, seg3], selectedIndex: 0)

        seg0 = DTOSKUDropSeg(title: "1", extendedTitle: "1분")
        seg1 = DTOSKUDropSeg(title: "3", extendedTitle: "3분")
        seg2 = DTOSKUDropSeg(title: "5", extendedTitle: "5분")
        seg3 = DTOSKUDropSeg(title: "10", extendedTitle: "10분")
        var seg4 = DTOSKUDropSeg(title: "15", extendedTitle: "15분")
        var seg5 = DTOSKUDropSeg(title: "30", extendedTitle: "30분")
        var seg6 = DTOSKUDropSeg(title: "45", extendedTitle: "45분")
        var seg7 = DTOSKUDropSeg(title: "60", extendedTitle: "60분")
        var seg8 = DTOSKUDropSeg(title: "90", extendedTitle: "90분")
        var seg9 = DTOSKUDropSeg(title: "120", extendedTitle: "120분")
        let manager1 = SKUDropSegManager(dropSegs: [seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9], selectedIndex: 9)

        seg0 = DTOSKUDropSeg(title: "1", extendedTitle: "1틱")
        seg1 = DTOSKUDropSeg(title: "3", extendedTitle: "3틱")
        seg2 = DTOSKUDropSeg(title: "5", extendedTitle: "5틱")
        seg3 = DTOSKUDropSeg(title: "10", extendedTitle: "10틱")
        seg4 = DTOSKUDropSeg(title: "15", extendedTitle: "15틱")
        seg5 = DTOSKUDropSeg(title: "20", extendedTitle: "20틱")
        seg6 = DTOSKUDropSeg(title: "30", extendedTitle: "30틱")
        seg7 = DTOSKUDropSeg(title: "45", extendedTitle: "45틱")
        seg8 = DTOSKUDropSeg(title: "60", extendedTitle: "60틱")
        seg9 = DTOSKUDropSeg(title: "80", extendedTitle: "80틱")
        let manager2 = SKUDropSegManager(dropSegs: [seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8, seg9], selectedIndex: 9)

        dropSegControl1.itemHeight = 30.0
        dropSegControl1.cellClass = SKUDropSegTextCell.self
        dropSegControl1.subitemImage = UIImage(named: "more.item")?.withRenderingMode(.alwaysTemplate)
        dropSegControl1.data = [manager0, manager1, manager2]
        dropSegControl1.selectedIndexPath = IndexPath(row: 2, section: 2)
        dropSegControl1.addTarget(self, action: #selector(dropSegControlValueChanged), for: .valueChanged)
        view.addSubview(dropSegControl1)

        dropSegControl1.translatesAutoresizingMaskIntoConstraints = false
        dropSegControl1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropSegControl1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100.0).isActive = true
        dropSegControl1.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        dropSegControl1.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        if let manager = dropSegControl1.data?.first,
           let dtoDropSeg = manager.dtoDropSegs.last {
               print("==> \(dtoDropSeg.title)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dropSegControl1.selectedIndexPath = IndexPath(row: 2, section: 1)
        }
    }

    @objc func dropSegControlValueChanged(_ sender: SKUDropSegControl) {
        print("좆도 마키.... \(sender.selectedIndexPath.section) - \(sender.selectedIndexPath.row)")
    }
    
}
