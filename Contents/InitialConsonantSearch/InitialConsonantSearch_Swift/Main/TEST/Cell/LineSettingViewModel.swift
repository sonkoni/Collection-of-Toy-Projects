//
//  ChartSettingViewModel.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit

enum LineSettingCellID: String {
    case colorDrop       = "ColorDrop"
    case colorFill       = "ColorFill"
    case toggle          = "Toggle"
    case drop            = "Drop"
    case color           = "Color"
    case textInput       = "TextInput"
    case font            = "Font"
    case geometricShapes = "GeometricShapes"
}

final class LineSettingViewModel {
    
    // MARK: - Property
    
    var lineType: ToolSettingLineType
    var mainTitle: String {
        return "\(lineType.rawValue)"
    }
    var sectionTitles = ["기본설정", "세부설정"]
    
    private var basicSettings: [DTOLineSetting] = []
    private var detailSettings: [DTOLineSetting] = []
    private var requiredIndexesInBasicSettings: [Int] {
        
        switch lineType {
        case .baseline:
            return []
        case .straightTrendline:
            return [0, 16, 17, 8, 9]
        case .horizontalLine:
            return [0, 16, 8]
        case .verticalLine:
            return [0, 10]
        case .crossLine:
            return [0, 10, 3]
        case .diagonalLine:
            return [0, 2, 21]
        case .angleLine:
            return [0, 16, 13]
        case .priceDifference:
            return [0, 7, 5]
        case .priceChangeLine:
            return [0, 11, 1, 4, 5, 19]
        case .fibonacciArc:
            return [0, 16, 13]
        case .fibonacciFan:
            return [0, 16]
        case .fibonacciRetracement:
            return [0, 16, 17, 8, 9]
        case .fibonacciTimezone:
            return [0, 16]
        case .fibonacciTarget:
            return [0, 14, 6, 9]
        case .andrewsPitchfork:
            return [0]
        case .cycleRange:
            return [0]
        case .gannLine:
            return [0, 2]
        case .gannFan:
            return [0, 16]
        case .gannRetracement:
            return [0, 16, 17, 8, 9]
        case .accelerationResistanceLine:
            return [0, 16, 8, 13]
        case .accelerationResistanceFan:
            return [0, 16, 8]
        case .shapeRectangle, .shapeEllipse, .shapeTriangle:
            return [30, 0, 24]
        case .text:
            return [27, 25, 26, 18, 29]
        case .symbol:
            return [24, 28, 22, 23]
        case .elliottWave:
            return [0, 15]
        case .statisticalRegressionLine:
            return [0, 15, 17, 8, 9]
        case .statisticalRegressionChannel, .bisectorLine, .trisectorLine:
            return [0, 16, 17, 8, 9]
        case .candleLine:
            return [0, 8]
        case .automaticTrendline:
            return [0, 20, 12, 8, 9, 13]
        case .conversionLine:
            return [0, 20, 12, 8]
        case .targetENV, .targetNT:
            return [0, 16, 8]
        default:
            assertionFailure("적절한 타입이 들어오지 않았다.")
            return []
        }
    }
    
    // MARK: - 생성 & 소멸
    
    init(lineType: ToolSettingLineType) {
        self.lineType = lineType
        commonInit()
    }
    
    private func commonInit() {
        setupBasicSettings()
        setupDetailSettings()
    }
    
    private func setupBasicSettings() {
        let set0 = DTOLineSetting(title: "선 색상/굵기", identifier: .colorDrop)
        
        let set1 = DTOLineSetting(title: "가격표시", identifier: .toggle)
        let set2 = DTOLineSetting(title: "각도(숫자로 표시)", identifier: .toggle)
        let set3 = DTOLineSetting(title: "값", identifier: .toggle)
        let set4 = DTOLineSetting(title: "거래량정보", identifier: .toggle)
        let set5 = DTOLineSetting(title: "대등수치", identifier: .toggle)
        let set6 = DTOLineSetting(title: "목표치", identifier: .toggle)
        let set7 = DTOLineSetting(title: "수치표시", identifier: .toggle)
        let set8 = DTOLineSetting(title: "우측가격", identifier: .toggle)
        let set9 = DTOLineSetting(title: "우측연장", identifier: .toggle)
        let set10 = DTOLineSetting(title: "일시", identifier: .toggle)
        let set11 = DTOLineSetting(title: "일자표시", identifier: .toggle)
        let set12 = DTOLineSetting(title: "일시표시", identifier: .toggle)
        let set13 = DTOLineSetting(title: "전체영역", identifier: .toggle)
        let set14 = DTOLineSetting(title: "전환가격", identifier: .toggle)
        let set15 = DTOLineSetting(title: "좌측가격", identifier: .toggle)
        let set16 = DTOLineSetting(title: "좌측비율", identifier: .toggle)
        let set17 = DTOLineSetting(title: "좌측연장", identifier: .toggle)
        let set18 = DTOLineSetting(title: "특정일 라인 표시", identifier: .toggle)
        let set19 = DTOLineSetting(title: "H/L비율", identifier: .toggle)
        
        let set20 = DTOLineSetting(title: "비율", identifier: .textInput)
        
        let set21 = DTOLineSetting(title: "각도", identifier: .drop)
        let set22 = DTOLineSetting(title: "스타일", identifier: .drop)
        let set23 = DTOLineSetting(title: "크기", identifier: .drop)
        
        let set24 = DTOLineSetting(title: "채우기", identifier: .colorFill)
        let set25 = DTOLineSetting(title: "테두리", identifier: .colorFill)
        let set26 = DTOLineSetting(title: "배경색", identifier: .colorFill)
        
        let set27 = DTOLineSetting(title: "글자색", identifier: .color)
        let set28 = DTOLineSetting(title: "색상", identifier: .color)
        
        let set29 = DTOLineSetting(title: "폰트 설정", identifier: .font)
        
        let set30 = DTOLineSetting(title: "도형 선택", identifier: .geometricShapes)
            
        set0.color = .systemTeal
        set24.color = .cyan
        set25.color = .systemRed
        set26.color = .white
        set27.color = .black
        set28.color = .systemYellow
            
        if lineType == .horizontalLine {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .verticalLine {
            set10.isToggleOn = true
        } else if self.lineType == .crossLine {
            set10.isToggleOn = true
            set3.isToggleOn = true
        } else if self.lineType == .diagonalLine {
            set2.isToggleOn = true
            set21.dropBtnTitles = ["30º", "45º", "60º", "330º", "315º", "300º"]
        } else if self.lineType == .angleLine {
            set16.isToggleOn = true
        } else if self.lineType == .priceDifference {
            set7.isToggleOn = true
            set5.isToggleOn = true
        } else if self.lineType == .priceChangeLine {
            set11.isToggleOn = true
        } else if self.lineType == .fibonacciArc {
            set16.isToggleOn = true
        } else if self.lineType == .fibonacciFan {
            set16.isToggleOn = true
        } else if self.lineType == .fibonacciRetracement {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .fibonacciTarget {
            set6.isToggleOn = true
        } else if self.lineType == .gannLine {
            set2.isToggleOn = true
        } else if self.lineType == .gannFan {
            set16.isToggleOn = true
        } else if self.lineType == .gannRetracement {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .accelerationResistanceLine {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .accelerationResistanceFan {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .text {
            set26.isSelected = true
        } else if self.lineType == .symbol {
            set24.isSelected = true
            set22.dropBtnTitles = ["보통", "굵게"]
            set22.dropBtnSelectedIndex = 0
            var dropdownData: [String] = []
            for i in 10...50 {
                dropdownData.append("\(i)")
            }
            set23.dropBtnTitles = dropdownData
            set23.dropBtnSelectedIndex = 7
        } else if self.lineType == .elliottWave {
            set15.isToggleOn = true
        } else if self.lineType == .statisticalRegressionLine {
            set15.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .statisticalRegressionChannel ||
                  self.lineType == .bisectorLine ||
                  self.lineType == .trisectorLine {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .candleLine {
            set8.isToggleOn = true
        } else if self.lineType == .automaticTrendline {
            set9.isToggleOn = true
            set12.isToggleOn = true
            set20.textInputBtnTitle = "0.05"
        } else if self.lineType == .conversionLine {
            set20.textInputBtnTitle = "0.05"
        } else if self.lineType == .targetENV || self.lineType == .targetNT {
            set16.isToggleOn = true
            set8.isToggleOn = true
        } else if self.lineType == .shapeRectangle ||
                  self.lineType == .shapeEllipse ||
                  self.lineType == .shapeTriangle {
            if self.lineType == .shapeRectangle {
                set30.geometricShapesType = .rectangle
            } else if self.lineType == .shapeEllipse {
                set30.geometricShapesType = .ellipse
            } else if self.lineType == .shapeTriangle {
                set30.geometricShapesType = .triangle
            } else {
                assertionFailure("잘못된 타입이 들어왔다.")
            }
            set24.isSelected = true
            set0.color = .systemRed
            set24.color = .systemYellow
            set0.dropBtnSelectedIndex = 9
            set30.geometricShapesBackColor = set24.isSelected ? set24.color : .clear
            set30.geometricShapesBorderColor = set0.color
            set30.geometricShapesBorderWidth = CGFloat(set0.dropBtnSelectedIndex + 1)
        }
        
        basicSettings = [set0, set1, set2, set3, set4, set5, set6, set7, set8, set9, set10, set11, set12, set13, set14, set15, set16, set17, set18, set19, set20, set21, set22, set23, set24, set25, set26, set27, set28, set29, set30]
        var filteredBasicSettings: [DTOLineSetting] = []
            
        for index in requiredIndexesInBasicSettings {
            if index < basicSettings.count {
                filteredBasicSettings.append(basicSettings[index])
            }
        }
            
        basicSettings = filteredBasicSettings
    }
    
    private func setupDetailSettings() {
    }
    
    // MARK: - Actions
    
    func numberOfSections() -> Int {
        return detailSettings.isEmpty ? 1 : 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        return section == 0 ? basicSettings.count : detailSettings.count
    }
    
    func cellModel(for indexPath: IndexPath) -> DTOLineSetting {
        if indexPath.section == 0 {
            return basicSettings[indexPath.row]
        } else if indexPath.section == 1 {
            return detailSettings[indexPath.row]
        } else {
            fatalError("Invalid section")
        }
    }
    
    func synchronize(completionHandler: (() -> Void)?) {
        let lineType = self.lineType
        if lineType == ToolSettingLineType.shapeRectangle ||
           lineType == ToolSettingLineType.shapeEllipse ||
           lineType == ToolSettingLineType.shapeTriangle {
            
            let targetDTO = cellModel(for: IndexPath(row: 0, section: 0))
            let borderDTO = cellModel(for: IndexPath(row: 1, section: 0))
            let backColorDTO = cellModel(for: IndexPath(row: 2, section: 0))
            
            targetDTO.geometricShapesBackColor = backColorDTO.isSelected ? backColorDTO.color : UIColor.clear
            targetDTO.geometricShapesBorderColor = borderDTO.color
            targetDTO.geometricShapesBorderWidth = CGFloat(borderDTO.dropBtnSelectedIndex + 1)
        }
        completionHandler?()
    }

}

final class DTOLineSetting {
    var identifier: String
    var title: String
    var isSelected: Bool = false
    var geometricShapesType: GeometricShapesView.Kind = .ellipse
    var geometricShapesBorderColor: UIColor?
    var geometricShapesBorderWidth: CGFloat = 0.0
    var geometricShapesBackColor: UIColor?
    var isBold: Bool = false
    var color: UIColor?
    var dropBtnTitles: [String]?
    var dropBtnSelectedIndex: Int = 0
    var isToggleOn: Bool = false
    var textInputBtnTitle: String?
    
    init(title: String, identifier: LineSettingCellID) {
        self.title = title
        self.identifier = identifier.rawValue
    }
}
