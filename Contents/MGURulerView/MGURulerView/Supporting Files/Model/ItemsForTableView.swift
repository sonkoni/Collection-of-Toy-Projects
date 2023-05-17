//
//  File.swift
//  MGURulerView
//
//  Created by Kwan Hyun Son on 2022/10/10.
//

import Foundation

typealias SectionItems = (sectionTitle: String, items: Array<Item>)

final class ItemsForTableView {
    
    // MARK: - Property
    static let shared = ItemsForTableView()
    private(set) var allItems : Array<SectionItems>
    
    // MARK: - 생성 & 소멸
    private init() {
        
        let item1 = Item(title:"Config : pricklyConfig", detailText:"...")
        let item2 = Item(title:"Config : defaultConfig", detailText:"...")
        let item3 = Item(title:"Config : forgeConfig", detailText:"...")
        allItems = [(sectionTitle: "Indicator Type - MGURulerViewIndicatorBallHeadType", items: [item1]),
                    (sectionTitle: "Indicator Type - MGURulerViewIndicatorWheelHeadType", items: [item2]),
                    (sectionTitle: "Indicator Type - MGURulerViewIndicatorLineType", items: [item3])]
    }
}
