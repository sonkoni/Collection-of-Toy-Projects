//
//  File.swift
//  DialControl_Samples
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
        
        let item1 = Item(title:"Config : darkBlueConfiguration", detailText:"Done button을 감출 수도 있고, 보일 수도 있다.")
        
        let item2 = Item(title:"Config : darkBlueConfiguration", detailText:"Layout 고정: Done button을 감추는 선택을 할 수 없다.")
        let item3 = Item(title:"Config : forgeConfiguration", detailText:"Layout 고정: Done button을 감추는 선택을 할 수 없다.")
        
        let item4 = Item(title:"Config : darkBlueConfiguration", detailText:"Layout 고정: 무조건 스페셜 키만 감춰진다.")
        
        let item5 = Item(title:"Config : forgeConfiguration", detailText:"Layout 고정: 무조건 스페셜과 Done 버튼이 감춰진다.")
        
        allItems = [(sectionTitle: "Layout Type - Standard1", items: [item1]),
                    (sectionTitle: "Layout Type - Standard2", items: [item2, item3]),
                    (sectionTitle: "Layout Type - LowHeightStyle1", items: [item4]),
                    (sectionTitle: "Layout Type - LowHeightStyle2", items: [item5])]
    }
}
