//
//  ItemsForTableView.swift
//  DayNightSwitch_iOS
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
        let item1 = Item(title:"MGUDNSwitch", detailText:"낮과 밤을 표현하는 스위치")
        allItems = [(sectionTitle: "Sample", items: [item1])]
    }
}
