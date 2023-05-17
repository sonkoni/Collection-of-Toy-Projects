//
//  File.swift
//  MGUNeoSegControl
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
        
        let item1 = Item(title:"MGUNeoSegControl", detailText:"UISegmentedControl 보다 풍부한 디자인의 다양한 예")
        let item2 = Item(title:"IV-Drop, Mini Timer 앱 사용예", detailText:"실전 앱에서 사용한 예제")
        allItems = [(sectionTitle: "Basic", items: [item1]),
                    (sectionTitle: "advanced", items: [item2])]
    }
}
