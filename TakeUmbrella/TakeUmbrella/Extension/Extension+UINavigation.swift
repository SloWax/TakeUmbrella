//
//  Extension+UINavigation.swift
//  ForPigPyo
//
//  Created by 표건욱 on 2022/07/29.
//  Copyright © 2022 SloWax. All rights reserved.
//

import UIKit

extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
