//
//  IndicatorSettingViewModel.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import UIKit
import BaseKit
import IosKit

enum IndicatorSettingCellID: String {
    case section = "Section"
    case subPlus = "subPlus"
    case subMinus = "subMinus"
    case subNormal = "subNormal"
    case region = "region" // 현재까지는 subNormal과 같지만 바탕색이 white이고, 앞으로 변할 가능성이 높다
    
    case favorite = "favorite"
    case favoriteSub = "favoriteSub"
    case search = "search"
}

// MARK: - DTOIndicatorSetting 클래스
//! 주의사항: SKHOutlineItemContent 프로토콜은 아카이빙하지 않는다. 순환문제 생길 수 있다.

final class DTOIndicatorSetting: NSObject, Codable, NSCopying {

    // MARK: - Property
    
    var identifier: String
    var title: String
    var isSelected = false
    var isFavorite = false
    var mainCategory = IndiSetMainCategory.indicators // favorite 자체는 사용되지 않을 것이다
    weak var outlineItem: SKHOutlineItem<DTOIndicatorSetting>? // <SKHOutlineItemContent> 프로토콜
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case isFavorite
        case isSelected
        case mainCategory
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        title = try container.decode(String.self, forKey: .title)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        mainCategory = try container.decode(IndiSetMainCategory.self, forKey: .mainCategory)
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isSelected, forKey: .isSelected)
        try container.encode(mainCategory, forKey: .mainCategory)
    }
    
    public override var hash: Int {
        var hasher = Hasher()
        hasher.combine(identifier)
        hasher.combine(title)
        hasher.combine(isFavorite)
        hasher.combine(isSelected)
        hasher.combine(mainCategory)
        return hasher.finalize()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Self else {
            return false
        }
        if other === self {
            return true
        }
        
        return self.isEqual(to: other)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DTOIndicatorSetting(title: self.title, identifier: self.identifier)
        copy.isSelected = self.isSelected
        copy.isFavorite = self.isFavorite
        copy.mainCategory = self.mainCategory
        return copy
    }

    // MARK: - 생성 & 소멸
    
    init(title: String, identifier: String) {
        self.title = title
        self.identifier = identifier
        super.init()
    }
    
    // MARK: - Actions
    
    func compare(with element: DTOIndicatorSetting) -> ComparisonResult {
        return compareCategory(element)
    }

    private func compareCategory(_ element: DTOIndicatorSetting) -> ComparisonResult {
        if self.mainCategory == element.mainCategory {
            return .orderedSame
        }
        if self.mainCategory == .indicators {
            return .orderedAscending
        }
        if self.mainCategory == .signals {
            if element.mainCategory != .indicators {
                return .orderedAscending
            } else {
                return .orderedDescending
            }
        }
        if self.mainCategory == .patterns {
            if element.mainCategory == .ranges || element.mainCategory == .fill {
                return .orderedAscending
            } else {
                return .orderedDescending
            }
        }
        if self.mainCategory == .ranges {
            if element.mainCategory == .fill {
                return .orderedAscending
            } else {
                return .orderedDescending
            }
        }
        return .orderedDescending
    }

    // MARK: - Private
    
    func isEqual(to other: DTOIndicatorSetting) -> Bool {
        return self.isSelected == other.isSelected &&
            self.isFavorite == other.isFavorite &&
            self.title == other.title &&
            self.identifier == other.identifier &&
            self.mainCategory == other.mainCategory
    }
    
    // MARK: - UNAVAILABLE
    
    @available(*, unavailable)
    override init() {
        fatalError("init() has not been implemented")
    }
}

extension DTOIndicatorSetting: SKHOutlineItemContent {
    func outlineItem<T>(_ value: SKHOutlineItem<T>) where T : Decodable, T : Encodable {
        if let item = value as? SKHOutlineItem<DTOIndicatorSetting> {
            self.outlineItem = item
        }
    }
}

// pretty name
extension DTOIndicatorSetting {
    static func prettyName(_ name: String) -> String {
        var result = name.skhSeparateCamelToString()
        
        // regularExpressionXXX 함수들의 호출 순서도 중요함
        /// Trix기준값하향돌파 => Trix 기준값 하향돌파
        var arr = [("기준값", "기준값"), ("&", "&")]
        for (replace, changed) in arr {
            result = result.skhInsertSpace(
                preExpression: SKHRegularExpStr.nonWhitespace,
                postExpression: SKHRegularExpStr.nonWhitespace,
                replace: replace,
                changed: changed
            )
        }
        
        /// 상승횡보후재상승 => 상승횡보 후 재상승
        arr = [("횡보후", "횡보 후"), ("조정후", "조정 후"), ("하락후", "하락 후"), ("상승후", "상승 후"), ("밀집후", "밀집 후"), ("기준선", "기준선"), ("일목균형지표", "일목균형지표"), ("전환선", "전환선"), ("심리도", "심리도"), ("비대칭", "비대칭")]
        
        for (replace, changed) in arr {
            result = result.skhInsertSpace(
                preExpression: nil,
                postExpression: SKHRegularExpStr.nonWhitespace,
                replace: replace,
                changed: changed
            )
        }
        
        /// AVG골든크로스 => AVG 골든크로스, 영어+한글
        arr = [("골", "골"), ("데", "데"), ("크", "크"), ("매", "매"), ("과매", "과매"), ("상승", "상승"), ("하락", "하락"), ("과열", "과열"), ("침체", "침체"), ("기준", "기준"), ("1차", "1차"), ("2차", "2차"), ("가격", "가격"), ("Oscillator", "Oscillator"), ("Midpoint", "Midpoint")]
        for (replace, changed) in arr {
            result = result.skhInsertSpace(
                preExpression: SKHRegularExpStr.alphabet,
                postExpression: nil,
                replace: replace,
                changed: changed
            )
        }
        
        arr = [("강세", "강세"), ("약세", "약세"), ("채움", "채움"), ("상향", "상향"), ("하향", "하향"), ("정배열", "정배열"), ("역배열", "역배열")]
        for (replace, changed) in arr {
            result = result.skhInsertSpace(
                preExpression: SKHRegularExpStr.nonWhitespace,
                postExpression: nil,
                replace: replace,
                changed: changed
            )
        }
        
        arr = [("ABRatio", "AB-Ratio"), ("OBVwith", "OBV with"), ("ADXGapper", "ADX Gapper"), ("MESAsinewave", "Mesa Sine Wave"), ("Zigzag", "Zig Zag"), ("7%", "7% "), ("10%", "10% "), ("Band%", "Band %"), ("RVIoriginal", "RVI Original"), ("_", " ")]
        for (replace, changed) in arr {
            result = result.replacingOccurrences(of: replace, with: changed)
        }
        
        return result
    }
}

final class IndicatorSettingViewModel {

    var currentMainCategory: IndiSetMainCategory = .indicators
    private var indicatorItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var signalItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var patternItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var regionItems = [SKHOutlineItem<DTOIndicatorSetting>]() // 강세/약세 구간
    private var fillItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var favoriteItems: [SKHOutlineItem<DTOIndicatorSetting>] {
        get {
            var result = [SKHOutlineItem<DTOIndicatorSetting>]()
            result.append(contentsOf: favoriteIndicatorItems)
            result.append(contentsOf: favoriteSignalItems)
            result.append(contentsOf: favoritePatternItems)
            result.append(contentsOf: favoriteRegionItems)
            result.append(contentsOf: favoriteFillItems)
            return result
        }
    }
    private var favoriteIndicatorItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var favoriteSignalItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var favoritePatternItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var favoriteRegionItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    private var favoriteFillItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    
    private var searchPoolItems = [SKHOutlineItem<DTOIndicatorSetting>]()
    
    var currentItems: [SKHOutlineItem<DTOIndicatorSetting>] {
        get {
            switch currentMainCategory {
            case .indicators:
                return indicatorItems
            case .signals:
                return signalItems
            case .patterns:
                return patternItems
            case .ranges:
                return regionItems
            case .fill:
                return fillItems
            case .favorites:
                return favoriteItems
            }
        }
      }
    
    init() {
        commonInit()
    }
    
    private func commonInit() {
        ///setupMockupSettings()
        loadData()
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<String, SKHOutlineItem<DTOIndicatorSetting>> {
        var snapshot = NSDiffableDataSourceSnapshot<String, SKHOutlineItem<DTOIndicatorSetting>>()
        snapshot.appendSections(["mainSection"])
        func addItems(_ menuItem: SKHOutlineItem<DTOIndicatorSetting>) {
            snapshot.appendItems([menuItem])
            if menuItem.isExpanded {
                menuItem.subitems?.forEach { addItems($0) }
            }
        }
        currentItems.forEach { addItems($0) }
        return snapshot
    }
    
    func snapshotForCurrentText(_ searchText: String) -> NSDiffableDataSourceSnapshot<String, SKHOutlineItem<DTOIndicatorSetting>> {
        var snapshot = NSDiffableDataSourceSnapshot<String, SKHOutlineItem<DTOIndicatorSetting>>()
        snapshot.appendSections(["mainSection"])
        
        var resultArray = [SKHOutlineItem<DTOIndicatorSetting>]()
        
        /// Filtering
        for outlineItem in self.searchPoolItems {
            if let poolTitle = outlineItem.contentItem?.title {
                let subRange = poolTitle.mgrRange(of: searchText, options: .caseInsensitive)
                if subRange.location != NSNotFound {
                    resultArray.append(outlineItem)
                }
            }
        }
        
        /// Sorting
        if resultArray.count > 0 {
            resultArray.sort { (obj1, obj2) in
                guard let contentItem1 = obj1.contentItem,
                      let contentItem2 = obj2.contentItem
                else {
                    return true
                }
                let result = contentItem1.compare(with: contentItem2)
                if result != .orderedSame {
                    return result == .orderedAscending
                }
                return contentItem1.title.compare(contentItem2.title, options: .caseInsensitive) == .orderedAscending
            }
            snapshot.appendItems(resultArray)
        }
        return snapshot
    }
    
    // 주어진 아이템의 차일드로 새로운 서브 아이템을 추가한다
    func addChildItem(for item: SKHOutlineItem<DTOIndicatorSetting>) {
        if item.subitems?.count ?? 0 > 9 {  // 10개로 제한하자
            return
            //
            // 제한 알림을 띄워주면 좋을 듯하다
        }
        let contentItem = item.contentItem
        var i = 1
        var title = "\(contentItem?.title ?? "") \(i)"
        
        if let subitems = item.subitems {
            let titles = subitems.compactMap {
                $0.contentItem?.title
            }
            while titles.contains(title) {
                i += 1
                title = "\(contentItem?.title ?? "") \(i)"
            }
        }
        
        let indicatorSetContentItem = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subMinus.rawValue)
        let resultOutlineItem = SKHOutlineItem(contentItem: indicatorSetContentItem, isFolder: false, subitems: nil)
        item.append([resultOutlineItem])
    }
    
    // 해당 아이템을 지운다
    func deleteItem(_ item: SKHOutlineItem<DTOIndicatorSetting>) {
        item.removeFromSuperitem()
    }
    
    // item 의 favorite이 업데이트 되었다.
    func updateFavoriteItem(
        _ item: SKHOutlineItem<DTOIndicatorSetting>,
        completion: (() -> Void)? = nil
    ) {
        guard let contentItem = item.contentItem
        else {
            return
        }
        
        if contentItem.mainCategory == .favorites {
            assertionFailure("있을 수 없다. 나는 이것을 의도적으로 비웠다.")
        }
        
        // 현재 Scene이 .favorites이면 else만 작동한다. 그 외에는 if 와 else 모두 갈 수 있다.
        if contentItem.isFavorite { // true, 추가한다, 현재 Scene이 favorite이 아닐 때에만 작동할 수 있다
            if contentItem.mainCategory == .indicators {
                favoriteIndicatorItems.removeAll()
            } else if contentItem.mainCategory == .signals {
                favoriteSignalItems.removeAll()
            } else if contentItem.mainCategory == .patterns {
                favoritePatternItems.removeAll()
            } else if contentItem.mainCategory == .ranges {
                favoriteRegionItems.removeAll()
            } else if contentItem.mainCategory == .fill {
                favoriteFillItems.removeAll()
            }
            
            weak var weakSelf = self
            DispatchQueue.global(qos: .default).async(execute: {
                func addItems(_ menuItem: SKHOutlineItem<DTOIndicatorSetting>) {
                    if let StrongSelf = weakSelf,
                       menuItem.contentItem?.isFavorite == true {
                        
                        if contentItem.mainCategory == .indicators {
                            StrongSelf.favoriteIndicatorItems.append(menuItem)
                        } else if contentItem.mainCategory == .signals {
                            StrongSelf.favoriteSignalItems.append(menuItem)
                        } else if contentItem.mainCategory == .patterns {
                            StrongSelf.favoritePatternItems.append(menuItem)
                        } else if contentItem.mainCategory == .ranges {
                            StrongSelf.favoriteRegionItems.append(menuItem)
                        } else if contentItem.mainCategory == .fill {
                            StrongSelf.favoriteFillItems.append(menuItem)
                        }
                        
                    }
                    menuItem.subitems?.forEach { addItems($0) }
                }
                self.currentItems.forEach { addItems($0) }
            })
            
        } else { // false, 현재 Scene이 favorite일 때도 작동할 수 있고 아닐 때도 작동할 수 있다
            if contentItem.mainCategory == .indicators {
                favoriteIndicatorItems.removeAll {
                    return ($0 == item)
                }
            } else if contentItem.mainCategory == .signals {
                favoriteSignalItems.removeAll {
                    return ($0 == item)
                }
            } else if contentItem.mainCategory == .patterns {
                favoritePatternItems.removeAll {
                    return ($0 == item)
                }
            } else if contentItem.mainCategory == .ranges {
                favoriteRegionItems.removeAll {
                    return ($0 == item)
                }
            } else if contentItem.mainCategory == .fill {
                favoriteFillItems.removeAll {
                    return ($0 == item)
                }
            }
        }
        
        completion?() // 현재 Scene이 favorite일 때만 작동한다.
    }
}

private extension IndicatorSettingViewModel {
    func setupMockupSettings() {
        // Section - DTO
        var sectionDTOs: [DTOIndicatorSetting] = []
        let sectionTitles: [String] = ["추세지표", "변동성지표", "모멘텀지표", "시장강도지표", "가격지표", "거래량지표", "모바일전용", "기타지표"]
        for title in sectionTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.section.rawValue)
            dto.mainCategory = .indicators
            sectionDTOs.append(dto)
        }
        
        // Section - OutlineItem
        var mainItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for sectionDTO in sectionDTOs {
            let item = SKHOutlineItem(contentItem: sectionDTO, isFolder: true, subitems: nil)
            mainItems.append(item)
        }
        
        // 추세지표
        // 추세지표 - DTO
        var trendDTOs: [DTOIndicatorSetting] = []
        let trendTitles: [String] = ["ADX", "CCI", "DMI"]
        
        for title in trendTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            dto.isSelected = true
            trendDTOs.append(dto)
        }
        
        // 추세지표 - OutlineItem
        var trendItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for trendDTO in trendDTOs {
            let item = SKHOutlineItem(contentItem: trendDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            trendItems.append(item)
        }
        
        mainItems[0].append(trendItems)
        mainItems[0].isExpanded = true

        //++ 테스트 코드
        let dto = DTOIndicatorSetting(title: "ADX 1", identifier: IndicatorSettingCellID.subMinus.rawValue)
        dto.mainCategory = .indicators
        let item = SKHOutlineItem(contentItem: dto, isFolder: false, subitems: nil)
        trendItems[0].append([item])
        
        // 변동성지표
        // 변동성지표 - DTO
        var volatilityDTOs: [DTOIndicatorSetting] = []
        let volatilityTitles: [String] = ["Average True Range", "BWI", "RVI(Relative Volatility Index)", "Sigma"]
        
        for title in volatilityTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            volatilityDTOs.append(dto)
        }
        
        // 변동성지표 - OutlineItem
        var volatilityItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for volatilityDTO in volatilityDTOs {
            let item = SKHOutlineItem(contentItem: volatilityDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            volatilityItems.append(item)
        }
        mainItems[1].append(volatilityItems)
        mainItems[1].isExpanded = false
        
        // 모멘텀지표
        // 모멘텀지표 - DTO
        var momentumDTOs: [DTOIndicatorSetting] = []
        let momentumTitles: [String] = ["Breath Trust", "ABI", "ADL", "ADR(코스닥)", "ADR(코스피)"]
        
        for title in momentumTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            momentumDTOs.append(dto)
        }
        
        // 모멘텀지표 - OutlineItem
        var momentumItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for momentumDTO in momentumDTOs {
            let item = SKHOutlineItem(contentItem: momentumDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            momentumItems.append(item)
        }
        mainItems[2].append(momentumItems)
        mainItems[2].isExpanded = false
        
        // 시장강도지표
        // 시장강도지표 - DTO
        var marketStrengthDTOs: [DTOIndicatorSetting] = []
        let marketStrengthTitles: [String] = ["투자심리선", "신심리도", "Accumulation_Distribution", "Binary Wave", "BPDL Short trend", "BPDL Stochastic"]
        
        for title in marketStrengthTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            marketStrengthDTOs.append(dto)
        }
        
        // 시장강도지표 - OutlineItem
        var marketStrengthItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for marketStrengthDTO in marketStrengthDTOs {
            let item = SKHOutlineItem(contentItem: marketStrengthDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            marketStrengthItems.append(item)
        }
        
        mainItems[3].append(marketStrengthItems)
        mainItems[3].isExpanded = false
        
        // 가격지표
        // 가격지표 - DTO
        var priceDTOs: [DTOIndicatorSetting] = []
        let priceTitles: [String] = ["가격 이동평균", "시고저라인", "Bollinger Bands", "매물대차트", "가격박스"]
        
        for title in priceTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            priceDTOs.append(dto)
        }
        
        // 가격지표 - OutlineItem
        var priceItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for priceDTO in priceDTOs {
            let item = SKHOutlineItem(contentItem: priceDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            priceItems.append(item)
        }
        mainItems[4].append(priceItems)
        mainItems[4].isExpanded = false
        
        // 거래량지표
        // 거래량지표 - DTO
        var volumeDTOs: [DTOIndicatorSetting] = []
        let volumeTitles: [String] = ["거래량", "거래량(매수/매도)", "거래량가격대비", "거래량전일비교"]
        
        for title in volumeTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            volumeDTOs.append(dto)
        }
        
        // 거래량지표 - OutlineItem
        var volumeItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for volumeDTO in volumeDTOs {
            let item = SKHOutlineItem(contentItem: volumeDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            volumeItems.append(item)
        }
        mainItems[5].append(volumeItems)
        mainItems[5].isExpanded = false
        
        // 모바일전용
        // 모바일전용 - DTO
        var mobileDTOs: [DTOIndicatorSetting] = []
        let mobileTitles: [String] = ["CMO", "RCI", "Qstick"]
        
        for title in mobileTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            mobileDTOs.append(dto)
        }
            
        // 모바일전용 - OutlineItem
        var mobileItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for mobileDTO in mobileDTOs {
            let item = SKHOutlineItem(contentItem: mobileDTO, isFolder: true, subitems: nil)
            item.isExpanded = true // 언제나
            mobileItems.append(item)
        }
        mainItems[6].append(mobileItems)
        mainItems[6].isExpanded = false
        
        // 기타지표
        // 기타지표 - DTO
        var otherDTOs: [DTOIndicatorSetting] = []
        let otherTitles: [String] = ["거래대금", "뉴스", "공시", "외국인보유비중"]
        
        for title in otherTitles {
            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
            dto.mainCategory = .indicators
            otherDTOs.append(dto)
        }
            
        // 기타지표 - OutlineItem
        var otherItems: [SKHOutlineItem<DTOIndicatorSetting>] = []
        for otherDTO in otherDTOs {
            let item = SKHOutlineItem(contentItem: otherDTO, isFolder: true, subitems: nil)
            item.isExpanded = true
            otherItems.append(item)
        }
        mainItems[7].append(otherItems)
        mainItems[7].isExpanded = false
        
        self.indicatorItems = mainItems
    }
}

private extension IndicatorSettingViewModel {
    func loadData() {
        
        loadIndicatorData()
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            self.loadIndicatorSubData()
            self.loadSignalData()
            self.loadPatternData()
            self.loadRegionData()
            self.loadFillData()
        })
    }
    
    func loadIndicatorData() {
        // Section - DTO
        var sectionDTOs: [DTOIndicatorSetting] = []
        let sectionTitles = ["가격지표", "모멘텀지표", "변동성지표", "채널지표", "추세지표", "시장강도지표", "거래량지표", "기타지표", "투자자지표"]
        for title in sectionTitles {
            sectionDTOs.append(DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.section.rawValue))
        }

        // Section - OutlineItem
        for sectionDTO in sectionDTOs {
            let item = SKHOutlineItem(contentItem: sectionDTO, isFolder: true, subitems: nil)
            self.indicatorItems.append(item)
        }
    }
    
    func loadIndicatorSubData() {
        if let url = Bundle.main.url(forResource: "indica", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let titlesArr = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]]

                if let titlesArr = titlesArr {
                    // 자료가 빵구다.
                    for i in 0..<self.indicatorItems.count - 1 {
                        let item = self.indicatorItems[i]
                        let titles = titlesArr[i]
                        var subitems: [SKHOutlineItem<DTOIndicatorSetting>] = []

                        for title in titles {
                            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subPlus.rawValue)
                            dto.mainCategory = .indicators
                            let subitem = SKHOutlineItem(contentItem: dto, isFolder: true, subitems: nil)
                            subitem.isExpanded = true // 무조건 열린 상태
                            searchPoolItems.append(subitem) // SubPlus만 담는다
                            
                            // TODO: - 제대로 된 데이터로 설정이 되어야합니다.
                            // 데이터에서 favorite 정보를 가져와야합니다.
                            /// <- 설정이 먼저 이루어져야합니다.
                            if dto.isFavorite {
                                self.favoriteIndicatorItems.append(subitem)
                            }
                            subitems.append(subitem)
                        }

                        item.append(subitems)
                    }
                }
            } catch {
                // Handle error
            }
        }
        
    }

    func loadSignalData() {
        // Section - DTO
        var sectionDTOs: [DTOIndicatorSetting] = []
        let sectionTitles = ["분석신호", "매매신호"]
        for title in sectionTitles {
            sectionDTOs.append(DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.section.rawValue))
        }

        // Section - OutlineItem
        for sectionDTO in sectionDTOs {
            let item = SKHOutlineItem(contentItem: sectionDTO, isFolder: true, subitems: nil)
            self.signalItems.append(item)
        }
        
        if let url = Bundle.main.url(forResource: "signal", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let titlesArr = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                    // 자료가 빵구다.
                    for i in 0..<self.signalItems.count {
                        let item = self.signalItems[i]
                        let titles = titlesArr[i]
                        var subitems: [SKHOutlineItem<DTOIndicatorSetting>] = []
                        
                        for title in titles {
                            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subNormal.rawValue)
                            dto.mainCategory = .signals
                            let subitem = SKHOutlineItem(contentItem: dto, isFolder: false, subitems: nil)
                            searchPoolItems.append(subitem) // SubNormal만 담는다
                            
                            // TODO: - 제대로 된 데이터로 설정이 되어야합니다.
                            // 데이터에서 favorite 정보를 가져와야합니다.
                            /// <- 설정이 먼저 이루어져야합니다.
                            if dto.isFavorite {
                                self.favoriteSignalItems.append(subitem)
                            }
                            subitems.append(subitem)
                        }
                        item.append(subitems)
                    }
                }
            } catch {
                // Handle error
            }
        }
    }
    
    func loadPatternData() {
        // Section - DTO
        var sectionDTOs: [DTOIndicatorSetting] = []
        let sectionTitles = ["상승반전패턴", "상승지속패턴", "하락반전패턴", "하락지속패턴", "횡보구간패턴", "박스장세패턴", "추세패턴"]
        for title in sectionTitles {
            sectionDTOs.append(DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.section.rawValue))
        }

        // Section - OutlineItem
        for sectionDTO in sectionDTOs {
            let item = SKHOutlineItem(contentItem: sectionDTO, isFolder: true, subitems: nil)
            self.patternItems.append(item)
        }

        if let url = Bundle.main.url(forResource: "pattern", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let titlesArr = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                    for i in 0..<self.patternItems.count - 2 {
                        // 자료가 빵구다.
                        var item = self.patternItems[i]
                        if i == (patternItems.count - 3) {
                            item = patternItems[(patternItems.count-1)]
                        }
                        
                        let titles = titlesArr[i]
                        
                        var subitems: [SKHOutlineItem<DTOIndicatorSetting>] = []
                            
                        for title in titles {
                            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subNormal.rawValue)
                            dto.mainCategory = .patterns
                            let subitem = SKHOutlineItem(contentItem: dto, isFolder: false, subitems: nil)
                            searchPoolItems.append(subitem) // SubNormal만 담는다
                            
                            // TODO: - 제대로 된 데이터로 설정이 되어야합니다.
                            // 데이터에서 favorite 정보를 가져와야합니다.
                            /// <- 설정이 먼저 이루어져야합니다.
                            if dto.isFavorite {
                                self.favoritePatternItems.append(subitem)
                            }
                            subitems.append(subitem)
                        }
                        item.append(subitems)
                    }
                }
            } catch {
                // Handle error
            }
        }
    }
    
    func loadRegionData() {
        if let url = Bundle.main.url(forResource: "region", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let titles = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    for title in titles {
                        let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.region.rawValue)
                        dto.mainCategory = .ranges
                        let item = SKHOutlineItem(contentItem: dto, isFolder: false, subitems: nil)
                        searchPoolItems.append(item) // Region만 담는다
                        
                        // TODO: - 제대로 된 데이터로 설정이 되어야합니다.
                        // 데이터에서 favorite 정보를 가져와야합니다.
                        /// <- 설정이 먼저 이루어져야합니다.
                        if dto.isFavorite {
                            self.favoriteRegionItems.append(item)
                        }
                        self.regionItems.append(item)
                    }
                }
            } catch {
                // Handle error
            }
        }
    }

    func loadFillData() {
        // Section - DTO
        var sectionDTOs: [DTOIndicatorSetting] = []
        let sectionTitles = ["가격영역채움", "거래량영역채움", "분석영역채움"]
        for title in sectionTitles {
            sectionDTOs.append(DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.section.rawValue))
        }

        // Section - OutlineItem
        for sectionDTO in sectionDTOs {
            let item = SKHOutlineItem(contentItem: sectionDTO, isFolder: true, subitems: nil)
            self.fillItems.append(item)
        }
        
        if let url = Bundle.main.url(forResource: "fill", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let titlesArr = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                    for i in 0..<self.fillItems.count {
                        let item = self.fillItems[i]
                        let titles = titlesArr[i]
                        var subitems: [SKHOutlineItem<DTOIndicatorSetting>] = []
                        
                        for title in titles {
                            let dto = DTOIndicatorSetting(title: title, identifier: IndicatorSettingCellID.subNormal.rawValue)
                            dto.mainCategory = .fill
                            let subitem = SKHOutlineItem(contentItem: dto, isFolder: false, subitems: nil)
                            searchPoolItems.append(subitem) // SubNormal만 담는다
                            
                            // TODO: - 제대로 된 데이터로 설정이 되어야합니다.
                            // 데이터에서 favorite 정보를 가져와야합니다.
                            /// <- 설정이 먼저 이루어져야합니다.
                            if dto.isFavorite {
                                self.favoriteFillItems.append(subitem)
                            }
                            subitems.append(subitem)
                        }
                        
                        item.append(subitems)
                    }
                }
            } catch {
                // Handle error
            }
        }
    }
}
