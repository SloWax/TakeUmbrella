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
        case weather(nowWeather: NowWeatherModel, daysWeather: [DayWeatherModel])
        
        var vc: UIViewController {
            switch self {
            case .splash:
                return SplashVC()
            case .weather(let now, let days):
                let vc = WeatherVC(nowWeather: now, daysWeather: days)
                let navi = BaseNC(rootViewController: vc)
                return navi
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
