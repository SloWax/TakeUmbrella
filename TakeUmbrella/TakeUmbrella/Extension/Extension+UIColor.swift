//
//  Extension+UIColor.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/13.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    func toImage(width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage {
        let size = CGSize(width: width, height: height)
        
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    class func setCustomColor(_ code: ColorCode, alpha: CGFloat = 1) -> UIColor {
        guard let color = UIColor(named: code.rawValue) else { fatalError("Not found color: \(code.rawValue)") }
        
        return color.withAlphaComponent(alpha)
    }
}

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    static func setCustomColor(_ code: ColorCode, alpha: CGFloat = 1) -> Color {
        return Color(hex: code.rawValue)
    }
}

enum ColorCode: String {

    // primary
//    case primaryRed            = "#ED6363"
//    case primaryYellow         = "#FFD100"
    case primaryBlue           = "#68B4D1"
    
    // Grays
    case white                 = "#FFFFFF"
    case gray1                 = "#F5F5F5"
    case gray2                 = "#DBDBDB"
    case gray4                 = "#B8B8B8"
    case gray6                 = "#808080"
    case gray8                 = "#555555"
    case gray10                = "#393939"
    case black                 = "#000000"
}
