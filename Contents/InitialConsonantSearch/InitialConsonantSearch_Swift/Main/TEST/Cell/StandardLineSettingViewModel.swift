//
//  ChartSettingViewModel.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit

enum StandardLineSettingCellID: String {
    // 상단 테이블뷰 셀 타입
    case toggleDrop = "ToggleDrop"
    case toggle = "Toggle"
    
    // 하단 테이블뷰 셀 타입
    case normal = "Normal"
    case user = "User"
}

enum StandardLineSettingTableID: String {
    // 상단 테이블뷰 타입
    case top = "Top"
    
    // 하단 테이블뷰 타입
    case yesterdayToday = "YesterdayToday"
    case pivotDemark = "PivotDemark"
    case custom = "Custom"
}

final class StandardLineSettingViewModel {
    
    // MARK: - Property
    
    var optionalTableType: StandardLineSettingTableID = .yesterdayToday {
        didSet {
            switch (optionalTableType) {
            case .yesterdayToday, .pivotDemark, .custom: break
            default:
                fatalError("잘못들어왔어.")
                break
            }
        }
    }
    
    var sectionTitles: [String] {
        switch (optionalTableType) {
        case .yesterdayToday:
            return ["전일", "당일"]
        case .pivotDemark:
            return ["Pivot", "Demark"]
        case .custom:
            return ["사용자 정의 기준선"]
        default:
            fatalError("잘못들어왔어.")
            break
        }
    }
    
    /// top
    private var topSettings: [DTOStandardLineSetting] = []
    
    /// bottoms
    private var yesterdaySettings: [DTOStandardLineSetting] = []
    private var todaySettings: [DTOStandardLineSetting] = []
    private var pivotSettings: [DTOStandardLineSetting] = []
    private var demarkSettings: [DTOStandardLineSetting] = []
    private var customSettings: [DTOStandardLineSetting] = []
    
    // MARK: - 생성 & 소멸
    
    init() {
        commonInit()
    }
        
    private func commonInit() {
        setupTopMockupSettings()
        setupBottomMockupSettings()
        setupTopRealSettings()
        setupBottomRealSettings()
    }
    
    private func setupTopMockupSettings() {
        let s0 = DTOStandardLineSetting(title: "수치 표시", identifier: StandardLineSettingCellID.toggleDrop.rawValue)
        s0.isToggleOn = true
        let s1 = DTOStandardLineSetting(title: "알람 / 메시지", identifier: StandardLineSettingCellID.toggle.rawValue)
        topSettings = [s0, s1]
    }
        
    private func setupBottomMockupSettings() {
        let y0 = DTOStandardLineSetting(title: "전일 시가", identifier: StandardLineSettingCellID.normal.rawValue)
        let y1 = DTOStandardLineSetting(title: "전일 고가", identifier: StandardLineSettingCellID.normal.rawValue)
        let y2 = DTOStandardLineSetting(title: "전일 저가", identifier: StandardLineSettingCellID.normal.rawValue)
        let y3 = DTOStandardLineSetting(title: "전일 종가", identifier: StandardLineSettingCellID.normal.rawValue)
        y0.color = UIColor.black
        y1.color = UIColor.systemRed
        y2.color = UIColor.systemGreen
        y3.color = UIColor.systemPink
        yesterdaySettings = [y0, y1, y2, y3]
        
        let t0 = DTOStandardLineSetting(title: "당일 시가", identifier: StandardLineSettingCellID.normal.rawValue)
        let t1 = DTOStandardLineSetting(title: "당일 고가", identifier: StandardLineSettingCellID.normal.rawValue)
        let t2 = DTOStandardLineSetting(title: "당일 저가", identifier: StandardLineSettingCellID.normal.rawValue)
        let t3 = DTOStandardLineSetting(title: "당일 종가", identifier: StandardLineSettingCellID.normal.rawValue)
        let t4 = DTOStandardLineSetting(title: "(시 + 고 + 저)/3", identifier: StandardLineSettingCellID.normal.rawValue)
        let t5 = DTOStandardLineSetting(title: "상한가", identifier: StandardLineSettingCellID.normal.rawValue)
        let t6 = DTOStandardLineSetting(title: "하한가", identifier: StandardLineSettingCellID.normal.rawValue)
        t0.color = UIColor.systemBlue
        t1.color = UIColor.systemTeal
        t2.color = UIColor.systemCyan
        t3.color = UIColor.systemPink
        t4.color = UIColor.systemIndigo
        t5.color = UIColor.systemGray
        t6.color = UIColor.systemBrown
        todaySettings = [t0, t1, t2, t3, t4, t5, t6]
        
        let p0 = DTOStandardLineSetting(title: "기준선", identifier: StandardLineSettingCellID.normal.rawValue)
        let p1 = DTOStandardLineSetting(title: "1차 저항", identifier: StandardLineSettingCellID.normal.rawValue)
        let p2 = DTOStandardLineSetting(title: "2차 저항", identifier: StandardLineSettingCellID.normal.rawValue)
        let p3 = DTOStandardLineSetting(title: "1차 지지", identifier: StandardLineSettingCellID.normal.rawValue)
        let p4 = DTOStandardLineSetting(title: "2차 지지", identifier: StandardLineSettingCellID.normal.rawValue)
        p0.color = UIColor.systemGreen
        p1.color = UIColor.black
        p2.color = UIColor.systemRed
        p3.color = UIColor.systemGreen
        p4.color = UIColor.systemPink
        pivotSettings = [p0, p1, p2, p3, p4]
        
        let d0 = DTOStandardLineSetting(title: "기준선", identifier: StandardLineSettingCellID.normal.rawValue)
        let d1 = DTOStandardLineSetting(title: "목표 고가", identifier: StandardLineSettingCellID.normal.rawValue)
        let d2 = DTOStandardLineSetting(title: "목표 저가", identifier: StandardLineSettingCellID.normal.rawValue)
        d0.color = UIColor.black
        d1.color = UIColor.systemRed
        d2.color = UIColor.systemBlue
        demarkSettings = [d0, d1, d2]
        
        let u0 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u1 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u2 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u3 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u4 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u5 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u6 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        let u7 = DTOStandardLineSetting(title: "", identifier: StandardLineSettingCellID.user.rawValue)
        u0.color = UIColor.systemGreen
        u1.color = UIColor.black
        u2.color = UIColor.systemRed
        u3.color = UIColor.systemGreen
        u4.color = UIColor.systemYellow
        u5.color = UIColor.systemGray
        u6.color = UIColor.systemBrown
        u7.color = UIColor.systemTeal
        u0.textInputBtnTitle = "0"
        u1.textInputBtnTitle = "0"
        u2.textInputBtnTitle = "0"
        u3.textInputBtnTitle = "0"
        u4.textInputBtnTitle = "0"
        u5.textInputBtnTitle = "0"
        u6.textInputBtnTitle = "0"
        u7.textInputBtnTitle = "0"
        customSettings = [u0, u1, u2, u3, u4, u5, u6, u7]
        
        for i in 0..<customSettings.count {
            let title = "사용자 \(i + 1)"
            customSettings[i].textFieldPlaceHolderTitle = title
        }
    }
    
    private func setupTopRealSettings() {}
    
    private func setupBottomRealSettings() {}
    
    // MARK: - Actions
    
    func numberOfTopSections() -> Int {
        return 1
    }
    
    func numberOfBottomSections() -> Int {
        switch (optionalTableType) {
        case .yesterdayToday, .pivotDemark:
            return 2
        case .custom:
            return 1
        default:
            fatalError("잘못들어왔어.")
            break
        }
    }
    
    func numberOfRowsInTopSection(_ topSection: Int) -> Int {
        return topSettings.count
    }
    
    func numberOfRowsInBottomSection(_ bottomSection: Int) -> Int {
        switch (optionalTableType) {
        case .yesterdayToday:
            return bottomSection == 0 ? yesterdaySettings.count : todaySettings.count
        case .pivotDemark:
            return bottomSection == 0 ? pivotSettings.count : demarkSettings.count
        case .custom:
            return customSettings.count
        default:
            fatalError("잘못들어왔어.")
            break
        }
    }
    
    func topCellModel(for indexPath: IndexPath) -> DTOStandardLineSetting {
        return topSettings[indexPath.row]
    }
    
    func bottomCellModel(for indexPath: IndexPath) -> DTOStandardLineSetting {
        switch (optionalTableType) {
        case .yesterdayToday:
            return indexPath.section == 0 ? yesterdaySettings[indexPath.row] : todaySettings[indexPath.row]
        case .pivotDemark:
            return indexPath.section == 0 ? pivotSettings[indexPath.row] : demarkSettings[indexPath.row]
        case .custom:
            return customSettings[indexPath.row]
        default:
            fatalError("잘못들어왔어.")
            break
        }
    }
}

//! MARK: - DTOStandardLineSetting 클래스

final class DTOStandardLineSetting {
    var identifier: String
    var title: String
    var isSelected = false
    var isRatio = false
    var color: UIColor?
    var dropBtnTitles: [String]?
    var dropBtnSelectedIndex: Int = 0
    var dropBtnHidden: Bool {
        if identifier == StandardLineSettingCellID.toggleDrop.rawValue && !isToggleOn {
            return true
        }
        return false
    }
    
    var isToggleOn = false
    var textFieldTitle: String?
    var textFieldPlaceHolderTitle = ""
    var textInputBtnTitle = ""

    init(title: String, identifier: String) {
        self.title = title
        self.identifier = identifier
    }
}
