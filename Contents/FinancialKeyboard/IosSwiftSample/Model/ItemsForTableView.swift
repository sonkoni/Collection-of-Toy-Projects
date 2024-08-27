//
//  ItemsForTableView.swift
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
        
        let item1 = Item(
            title:"프리셋 보기",
            detailText:"기본적인 템플릿 맛보기"
        )
        let item2 = Item(
            title:"ScrollView Inset - 애플 키보드",
            detailText:"키보드가 올라올 때, 반응성 보기"
        )
        let item3 = Item(
            title:"ScrollView Inset - FinancialKeyboard",
            detailText:"키보드가 올라올 때, 반응성 보기"
        )
        allItems = [(sectionTitle: "Basic", items: [item1]),
                    (sectionTitle: "Advanced", items: [item2, item3])]    
    }
}

