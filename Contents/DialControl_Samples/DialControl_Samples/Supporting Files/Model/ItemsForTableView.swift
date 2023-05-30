//
//  ItemsForTableView.swift
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
        let item1 = Item(title:"Sample 1", detailText:"IV-Drop에서 사용을 고려했지만, 사용하지는 않았다")
        let item2 = Item(title:"Sample 2", detailText:"Mini Timer앱에서 실제 사용한 다이얼 컨트롤")
        allItems = [(sectionTitle: "IV-Drop - DialControl", items: [item1]),
                    (sectionTitle: "Mini Timer - DialControl", items: [item2])]
    }
}
