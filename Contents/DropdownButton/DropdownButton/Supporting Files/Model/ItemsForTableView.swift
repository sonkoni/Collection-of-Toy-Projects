//
//  ItemsForTableView.swift
//  MGUStepper
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
        
        let item1 = Item(title:"텍스트 컨텐츠", detailText:"SKUDropdownButton & MGUDropdownButton")
        let item2 = Item(title:"이미지 컨텐츠", detailText:"SKUDropdownButton & MGUDropdownButton")
        
        let item3 = Item(title:"Line Width 컨텐츠", detailText:"SKUDropdownButton & MGUDropdownButton")
        let item4 = Item(title:"Dashed Pattern 컨텐츠", detailText:"SKUDropdownButton & MGUDropdownButton")

        allItems = [(sectionTitle: "Basic", items: [item1, item2]),
                    (sectionTitle: "Templete", items: [item3, item4])]
    }
}
