//
//  File.swift
//  IndicatorSettingsTest_Swift
//
//  Created by Kwan Hyun Son on 10/12/23.
//

import Foundation


import UIKit

typealias DefinesImageName = String
extension DefinesImageName {
    static let checkmarkCircleFill = "checkmark.circle.fill"
    static let checkmarkCircle = "checkmark.circle"
    static let chevronForward = "chevron.forward"
    static let gearshape = "gearshape"
    static let indent = "indent"
    static let minus = "minus"
    static let plus = "plus"
    static let radioFill = "radio.fill"
    static let radio = "radio"
    static let settingGo = "settingGo"
    static let starFill = "star.fill"
    static let star = "star"
    static let uncheckmarkCircle = "uncheckmark.circle"
    static let uncheckmarkCircleOpaque = "uncheckmark.circle.opaque"
    static let xmark = "xmark"
}

class Defines {
    class func imageNamed(_ imageName: DefinesImageName, renderingMode: UIImage.RenderingMode) -> UIImage? {
        let designTimeBundle = Bundle(for: Defines.self)
        var result = UIImage(named: imageName, in: designTimeBundle, compatibleWith: nil)
        result = result?.withRenderingMode(renderingMode)
        return result
    }
}
