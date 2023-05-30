//
//  ItemsForTableView.swift
//  SevenSwitch_iOS
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
        
        let item1 = Item(title:"MGUSevenSwitch", detailText:"UISwitch와 같은 모양 연출가능하다.")
        let item2 = Item(title:"MGUSevenSwitch", detailText:"MGUSevenSwitch various examples")
        let item3 = Item(title:"Mini Timer 앱 사용예", detailText:"Mini Timer 앱에서 사용한 스위치를 살펴보자.")

        allItems = [(sectionTitle: "Basic", items: [item1]),
                    (sectionTitle: "advanced", items: [item2]),
                    (sectionTitle: "Using Sample", items: [item3])]
    }
}
