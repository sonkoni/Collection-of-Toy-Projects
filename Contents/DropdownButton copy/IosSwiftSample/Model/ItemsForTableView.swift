//
//  File.swift
//  EmptyProject
//
//  Created by Kwan Hyun Son on 2022/10/10.
//

import Foundation

final class ItemsForTableView {
    
    // MARK: - Property
    
    static let shared = ItemsForTableView()
    private(set) var allItems : Array<Dictionary<String, Array<Item>>>
    
    // MARK: - 생성 & 소멸
    
    private init() {
        let item0 = Item(title:"SKUDropdownButton Class", detailText:"차트연구소 프로젝트를 위해 만듬.")
        let item1 = Item(title:"SKUDropSegControl Class", detailText:"차트연구소 프로젝트를 위해 만듬.")
        
        let section0 = ["SKUDropdownButton Class 섹션" : [item0]]
        let section1 = ["SKUDropSegControl Class 섹션" : [item1]]
        
        allItems = [section0, section1]
    }
}
