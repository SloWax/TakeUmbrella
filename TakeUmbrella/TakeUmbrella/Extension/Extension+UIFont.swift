//
//  Extension+UIFont.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/13.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit
import SwiftUI

extension UIFont {
    // 폰트 설정
    class func setCustomUIFont(font: FontCode, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: font.rawValue, size: size) else { fatalError("Not found Font: \(font.rawValue)") }
        return font
    }
}

extension Font {
    static func setCustomFont(font: FontCode, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
    }
}

enum FontCode: String {
    case black   = "NotoSansKR-Black"
    case bold    = "NotoSansKR-Bold"
    case medium  = "NotoSansKR-Medium"
    case regular = "NotoSansKR-Regular"
    case light   = "NotoSansKR-Light"
}
