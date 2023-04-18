//
//  Extension+CGFloat.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2023/04/04.
//  Copyright © 2023 SloWax. All rights reserved.
//

import Foundation

extension CGFloat {
    
    func aspectRatio(ratio denominator: CGFloat, _ numerator: CGFloat) -> CGFloat {
        let ratio = numerator / denominator
        return self * ratio
    }
}
