//
//  ChartSettingViewModel.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit

enum IndicatorSettingDetailCellID: String {
    case normal = "Normal"
    case description = "Description"
    case toggle = "Toggle"
    case color = "Color"
    case drop = "Drop"
    case dropLineStyle = "DropLineStyle"
    case dropLineWidth = "DropLineWidth"
    case dropFillExpression = "DropFillExpression"
    case dropFillType = "DropFillType"
}

enum IndicatorSettingDetailCategory: Int {
    case line = 0
    case conditions = 1
    case description = 2
}


final class IndicatorSettingDetailViewModel {
    
    // MARK: - Property
    
    var detailCategory: IndicatorSettingDetailCategory = .line
    
    var sectionTitles: [String] {
        switch (detailCategory) {
        case .line:
            return ["AAA", "BBB"]
        case .conditions:
            return ["CCCC", "DDDD"]
        case .description:
            return descriptionSettings.map {
                $0.sectionTitle
            }
        }
    }
    
    private var descriptionSettings: [DTOIndicatorDetailSetting] = []
    
    
    // MARK: - 생성 & 소멸
    
    init() {
        commonInit()
    }
        
    private func commonInit() {
        setupMockupSettings()
    }
    
    private func setupMockupSettings() {
        let dto1 = DTOIndicatorDetailSetting(
            identifier: IndicatorSettingDetailCellID.description.rawValue,
            title: "",
            sectionTitle: "[개요]"
        )
        let dto2 = DTOIndicatorDetailSetting(
            identifier: IndicatorSettingDetailCellID.description.rawValue,
            title: "",
            sectionTitle: "[해석]"
        )
        
        dto1.title = "- 시장은 추세적시장(Trend market)과 비추세적 시장(Non-trend market)으로 구분할 수 있다.\n\n- 추세적시장이란 시장이 강세 또는 약세라는 추세를 가지고 있는 시장으로 포지션을 다음날로 이월시키는 Position Trading에 의해 수익을 얻을 수 있으며,\n\n- 비추세적 시장이란 장중에 일정한 박스권내에서 매매하는 Day Trading에 적합한 상황을 말한다.\n\n- 따라서 현재의 시장이 추세적 시장인지 비추세적 시장인지 판단하는 것은 매우 중요하다.\n\n- DMI차트는 현재의 시장추세와 함께 그 추세의 강도까지 알려 주는 지표로 단기보다는 중장기 추세 판별에 적합한다.\n\n+DI는 실질적으로 상승하는 폭의 비율을 나타내며,\n\n-DI는 실질적으로 하락하는 폭의 비율을 의미한다."
        
        dto2.title = "- + DI와 -DI의 교차\n\n>+DI가 -DI보다 큰 국면은 상승추세, 작은 국면은 하락추세로 규정할 수 있다.\n\n>+DI가 -DI를 상향돌파 하는 시점에서 매수,  하향돌파 하는 시점에서 매도 포지션을 취한다.\n\n> +DI와 -DI의 교차를 매매신호로 이용할 때는 ADX를 같이 사용해야한다.\n\n즉 +DI와 -DI가 교차하는 시점에서 ADX가 20선 아래에서 진행되다가 다시 그 값이 커지거나 20선을 상향돌파 하는 시점에서 +DI와 -DI중 값이 큰 지표방향으로 매매하는 것이 정석입니다.\n\n즉 ADX값이 상승하는 것은 현재 +DI와 -DI중 위에 있는 지표의 방향대로 추세가 진행되며, 그 강도가 강화된다는 것을 의미한다."
        
        descriptionSettings = [dto1, dto2]
    }
        
    // MARK: - Actions
    
    func numberOfSections() -> Int {
        switch (detailCategory) {
        case .line:
            return 0
        case .conditions:
            return 0
        case .description:
            return 2
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch (detailCategory) {
        case .line:
            return 0
        case .conditions:
            return 0
        case .description:
            return 1
        }
    }
    
    func cellModel(for indexPath: IndexPath) -> DTOIndicatorDetailSetting? {
        let section = indexPath.section
        let index = indexPath.row
        switch (detailCategory) {
        case .line:
            break
        case .conditions:
            break
        case .description:
            return descriptionSettings[section]
        }
        fatalError("예상치 못한갓이 들어왔다.")
    }

}

//! MARK: - DTOIndicatorDetailSetting 클래스

final class DTOIndicatorDetailSetting {
    var identifier: String
    var title: String
    var sectionTitle: String

    init(identifier: String, title: String, sectionTitle: String) {
        self.identifier = identifier
        self.title = title
        self.sectionTitle = sectionTitle
    }
}
