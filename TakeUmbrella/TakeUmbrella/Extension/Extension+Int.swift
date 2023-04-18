//
//  Extension+Int.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/08/11.
//  Copyright © 2022 SloWax. All rights reserved.
//

import Foundation

extension Int {
    var comma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: self as NSNumber) ?? ""
    }
}
