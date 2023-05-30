//
//  ItemsForTableView.swift
//  HexagonalWallpaper
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
        let item1 = Item(title:"기본 예시", detailText:"기본 예시를 보이겠다.")
        let item2 = Item(title:"동적 확인", detailText:"움직여보자.")
        
        let item3 = Item(title:"Hexagonal WallPaper", detailText:"Hexagonal WallPaper")
        let item4 = Item(title:"Hexagonal WallPaper 동적", detailText:"Hexagonal WallPaper를 동적으로 움직여보자.")
        let item5 = Item(title:"Hexagonal WallPaper Info Object", detailText:"Info Object를 적용해보자.")
        
        let item6 = Item(title:"IV Drop 사용예", detailText:"IV Drop 앱에서 사용한 WallPaper를 살펴보자.")
        
        allItems = [(sectionTitle: "Basic", items: [item1, item2]),
                    (sectionTitle: "advanced", items: [item3, item4, item5]),
                    (sectionTitle: "Using Sample", items: [item6])]
    }
}
