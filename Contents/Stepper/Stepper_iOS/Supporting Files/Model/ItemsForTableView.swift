//
//  ItemsForTableView.swift
//  MGUStepper
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
        
        let item1 = Item(title:"MGUStepper", detailText:"xib 및 수작업 설정으로 만들었다.")
        let item2 = Item(title:"MGUStepper", detailText:"코드와 configuration 객체 이용.")
        
        let item3 = Item(title:"MGUStepper", detailText:"서브클래싱 받지 않고 커스텀하기")
        
        let item4 = Item(title:"MGUStepper", detailText:"IV-Drop 앱에서 사용한 Stepper를 살펴보자.")

        allItems = [(sectionTitle: "Basic", items: [item1, item2]),
                    (sectionTitle: "advanced", items: [item3]),
                    (sectionTitle: "Using Sample", items: [item4])]
    }
}
