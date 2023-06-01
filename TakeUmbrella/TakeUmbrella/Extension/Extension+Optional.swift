//
//  Extension+Optional.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/08/04.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit

protocol OptionalCheck { }
extension Int: OptionalCheck { }
extension String: OptionalCheck { }
extension UIImage: OptionalCheck { }

extension Optional where Wrapped: OptionalCheck {
    var isEmptyString: Bool {
        return ((self as? String) ?? "").isEmpty
    }
    
    var isNil: Bool {
        guard case Optional.none = self else { return false }
        return true
    }
    
    var isSome: Bool {
        return !self.isNil
    }
}
