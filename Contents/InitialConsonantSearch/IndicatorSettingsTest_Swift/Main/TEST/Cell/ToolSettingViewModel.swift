//
//  ChartTypeViewModel.swift
//  ChartType_Swift
//
//  Created by Kwan Hyun Son on 2023/09/08.
//

import UIKit

enum ToolSettingLineType: String {
    case baseline                     = "기준선"
    case deleteAllTrendlines          = "추세선 모두 삭제"
    case deleteTrendline              = "추세선 삭제"
    case straightTrendline            = "직선추세선"
    case horizontalLine               = "수평선"
    case verticalLine                 = "수직선"
    case crossLine                    = "십자선"
    case diagonalLine                 = "대각선"
    case angleLine                    = "각도선"
    case priceDifference              = "가격-차이"
    case priceChangeLine              = "가격-변화선"
    case fibonacciArc                 = "피보나치-아크"
    case fibonacciFan                 = "피보나치-팬"
    case fibonacciRetracement         = "피보나치-수평조정대"
    case fibonacciTimezone            = "피보나치-시간간격"
    case fibonacciTarget              = "피보나치-목표치"
    case andrewsPitchfork             = "앤드류피치포크"
    case cycleRange                   = "사이클구간"
    case gannLine                     = "갠-라인"
    case gannFan                      = "갠-팬"
    case gannRetracement              = "갠-조정대"
    case accelerationResistanceLine   = "가속저항-호"
    case accelerationResistanceFan    = "가속저항-팬"
    case shapeRectangle               = "도형-사각형"
    case shapeEllipse                 = "도형-타원"
    case shapeTriangle                = "도형-삼각형"
    case text                         = "텍스트"
    case symbol                       = "심볼"
    case elliottWave                  = "엘리엇파동"
    case statisticalRegressionLine    = "통계-직선회귀선"
    case statisticalRegressionChannel = "통계-직선회귀채널"
    case bisectorLine                 = "사등분선"
    case trisectorLine                = "삼등분선"
    case candleLine                   = "캔들라인"
    case automaticTrendline           = "자동추세선"
    case conversionLine               = "전환선"
    case targetENV                    = "목표치-ENV"
    case targetNT                     = "목표치-NT"
}

final class ToolSettingViewModel {
    
    // MARK: - Property
    
    var lineTypes: [ToolSettingLineType]
    
    // MARK: - 생성 & 소멸
    
    init() {
        lineTypes = defaultAllToolSettingLineType()
    }
    
    // MARK: - Actions
    
    func numberOfRows(in section: Int) -> Int {
        return lineTypes.count
    }
    
    func chartLineType(for indexPath: IndexPath) -> ToolSettingLineType {
        let row = indexPath.row
        return lineTypes[row]
    }
    
    func lineSettingViewModel(for indexPath: IndexPath) -> LineSettingViewModel? {
        return testArr[indexPath.row]
        //
        // FIXME: - 저장 메커니즘 확인을 위해 잠시 잠군다
        // let selectedLineType = lineTypes[indexPath.row]
        // return LineSettingViewModel.init(lineType: selectedLineType)
    }
    
    
    // MARK: - DEBUG
    
    private lazy var testArr: [LineSettingViewModel] = {
        var arr: [LineSettingViewModel] = []
        for (index, selectedLineType) in lineTypes.enumerated() {
            if index < 3 {
                arr.append(LineSettingViewModel(lineType: .targetNT))
            } else {
                let model = LineSettingViewModel(lineType: selectedLineType)
                arr.append(model)
            }
        }
        return arr
    }()
}

private func defaultAllToolSettingLineType() -> [ToolSettingLineType] {
    return [.baseline, .deleteAllTrendlines, .deleteTrendline, .straightTrendline, .horizontalLine, .verticalLine, .crossLine, .diagonalLine, .angleLine, .priceDifference, .priceChangeLine, .fibonacciArc, .fibonacciFan, .fibonacciRetracement, .fibonacciTimezone, .fibonacciTarget, .andrewsPitchfork, .cycleRange, .gannLine, .gannFan, .gannRetracement, .accelerationResistanceLine, .accelerationResistanceFan, .shapeRectangle, .shapeEllipse, .shapeTriangle, .text, .symbol, .elliottWave, .statisticalRegressionLine, .statisticalRegressionChannel, .bisectorLine, .trisectorLine, .candleLine, .automaticTrendline, .conversionLine, .targetENV, .targetNT]
}
