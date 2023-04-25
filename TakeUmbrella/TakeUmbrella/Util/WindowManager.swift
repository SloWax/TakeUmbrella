//
//  WindowManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation
import UIKit

class WindowManager {
    
    enum Path: String {
        case splash
        case weather
        
        var vc: UIViewController {
            switch self {
            case .splash    : return SplashVC()
            case .weather   : return WeatherVC()
            }
        }
    }
    
    static func change(_ path: Path) {
        UIApplication.shared.windows.first?.rootViewController = path.vc
    }
    
    static func exit() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
}
