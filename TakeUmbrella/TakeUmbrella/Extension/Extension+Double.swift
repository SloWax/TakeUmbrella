//
//  Extension+Double.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/20.
//

import Foundation

extension Double {
    var toCelsius: Double {
        return self - 273.15
    }
    
    func toString(_ format: String) -> String {
        return String(format: format, self)
    }
}
