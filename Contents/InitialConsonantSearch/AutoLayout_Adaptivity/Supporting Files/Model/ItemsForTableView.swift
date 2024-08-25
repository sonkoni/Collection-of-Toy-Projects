//
//  File.swift
//  AutoLayout_Adaptivity
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
        let item1 = Item(title:"Swift Sample", detailText:"Interface Builder 이용하여 Regular, Compact 대응")
        let item2 = Item(title:"Objective-C Sample", detailText:"Device의 Orientation에 따라 present, dimiss")
        allItems = [(sectionTitle: "Basic", items: [item1, item2])]
    }
}
