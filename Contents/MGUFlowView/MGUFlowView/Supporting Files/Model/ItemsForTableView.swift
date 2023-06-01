//
//  ItemsForTableView.swift
//  MGUFlowView
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
        let item1 = Item(title:"Folding Style", detailText:"종이처럼 접히는 스타일")
        let item2 = Item(title:"Vega Style", detailText:"끝에서 잠기는 스타일")
        let item3 = Item(title:"Vega Style - Reverse", detailText:"아래에서부터 채울 수 있다.")
        
        let item4 = Item(title:"Mini Timer 에서 이용 1", detailText:"Mini Timer앱에서 실제 사용한 Flow View")
        let item5 = Item(title:"Mini Timer 에서 이용 2", detailText:"Mini Timer앱에서 실제 사용한 Flow View")
        
        let item6 = Item(title:"Swipe", detailText:"직접 만든 스와이프 CollectionView Cell과 함께 사용")
        let item7 = Item(title:"Swipe + Drag & Drop", detailText:"직접 만든 스와이프 CollectionView Cell + Drag&Drop 예")
        
        allItems = [(sectionTitle: "Basic", items: [item1, item2, item3]),
                    (sectionTitle: "Mini Timer 에서 사용한 예", items: [item4, item5]),
                    (sectionTitle: "Advanced", items: [item6, item7])]
    }
}
