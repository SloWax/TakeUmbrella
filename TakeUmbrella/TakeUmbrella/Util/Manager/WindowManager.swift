//
//  WindowManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/26.
//

import Foundation
import UIKit

class WindowManager {
    
    enum Path {
        case splash
        case weather
        
        var vc: UIViewController {
            switch self {
            case .splash:
                return SplashVC()
            case .weather:
                let vc = WeatherVC()
                let navi = BaseNC(rootViewController: vc)
                return navi
            }
        }
    }
    
    static func change(_ path: Path) {
         UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController = path.vc
    }
    
    static func exit() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
}
