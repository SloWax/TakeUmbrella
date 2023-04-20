//
//  AppDelegate.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/04/18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
//        window?.rootViewController = WeatherCasterViewController()
        window?.rootViewController = WeatherVC()
        window?.makeKeyAndVisible()
        
        return true
    }
}

