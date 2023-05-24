//
//  File.swift
//  SwipeCellProject
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
        let item1 = Item(title:"MGUSwipeTableViewCell", detailText:"UITableViewStylePlain")
        let item2 = Item(title:"MGUSwipeTableViewCell", detailText:"UITableViewStyleGrouped")
        let item3 = Item(title:"MGUSwipeTableViewCell", detailText:"UITableViewStyleInsetGrouped")
        
        let item4 = Item(title:"MGUSwipeCollectionViewCell", detailText:"테이블뷰 스타일")
        let item5 = Item(title:"MGUSwipeCollectionViewCell", detailText:"일반 콜렉션뷰의 자유로운 스타일")
        let item6 = Item(title:"MGUSwipeCollectionViewCell", detailText:"Mini Timer 앱에서 사용한 스타일")
        
        
        allItems = [(sectionTitle: "UITableView", items: [item1, item2, item3]),
                    (sectionTitle: "UICollectionView", items: [item4, item5, item6])]
    }
}
