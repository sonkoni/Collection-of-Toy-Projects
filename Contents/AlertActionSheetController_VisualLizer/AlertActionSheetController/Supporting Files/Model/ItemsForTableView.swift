//
//  ItemsForTableView.swift
//  Alert & Action Sheet
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
        
        let item1 = Item(title:"No buttons", detailText:"Alert Style : 버튼이 없고 주변을 터치하면 dismiss 된다.")
        let item2 = Item(title:"1개 버튼", detailText:"Alert Style : 버튼 1개 샘플")
        let item3 = Item(title:"2개 버튼", detailText:"Alert Style : 버튼 2개 샘플")
        let item4 = Item(title:"3개 버튼", detailText:"Alert Style : 버튼 3개 샘플")
        let item5 = Item(title:"Text Fields", detailText:"Alert Style : 텍스트 필드 2개, 버튼 조건부 활성화")
        let item6 = Item(title:"Custom Fonts", detailText:"Alert Style : 커스텀 폰트 사용")
        let item7 = Item(title:"Long Message", detailText:"Alert Style : 긴 메시지 Alert")
        
        let item8 = Item(title:"Custom Content View1", detailText:"Alert Style : contentView (MKMapView)")
        let item9 = Item(title:"Custom Content View2", detailText:"Alert Style : contentView (UIImageView)")
        let item10 = Item(title:"Custom Content View3", detailText:"Alert Style : secondContentView (Dose Picker)")
        let item11 = Item(title:"Custom Content View4: IV-Drop에서 이용", detailText:"Alert Style : thirdContentView (Save & Alarm)")
        let item12 = Item(title:"Custom Content View5: IV-Drop에서 이용", detailText:"Alert Style : Full contentView (Onboarding)")
        
        let item13 = Item(title:"Dose Picker", detailText:"ActionSheet Style : ...")
        let item14 = Item(title:"Save & Alarm", detailText:"ActionSheet Style : ...")
        let item15 = Item(title:"Custom Content View", detailText:"ActionSheet Style : ...")
        let item16 = Item(title:"Ruler: IV-Drop에서 이용", detailText:"ActionSheet Style : ...")
        let item17 = Item(title:"Segment: IV-Drop에서 이용", detailText:"ActionSheet Style : ...")
        let item18 = Item(title:"keyboard: IV-Drop에서 이용", detailText:"ActionSheet Style : ...")
        let item19 = Item(title:"Stepper: IV-Drop에서 이용", detailText:"ActionSheet Style : ...")
        
        allItems = [(sectionTitle: "MGUAlertViewController - Basic", items: [item1, item2, item3, item4, item5, item6, item7]),
                    (sectionTitle: "MGUAlertViewController - Advanced", items: [item8, item9, item10, item11, item12]),
                    (sectionTitle: "MGUActionSheetController", items: [item13, item14, item15, item16, item17, item18, item19])]
    }
}
