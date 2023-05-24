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
    class func setCustomUIFont(font: Name, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: font.rawValue, size: size) else { fatalError("Not found Font: \(font.rawValue)") }
        return font
    }
    
    class func setCustomFont(font: Name, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
    }
    
    // 폰트 굵기
    enum Name: String {
        case black   = "NotoSansKR-Black"
        case bold    = "NotoSansKR-Bold"
        case medium  = "NotoSansKR-Medium"
        case regular = "NotoSansKR-Regular"
        case light   = "NotoSansKR-Light"
    }
}
