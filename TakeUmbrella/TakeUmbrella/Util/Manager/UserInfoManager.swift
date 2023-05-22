//
//  UserInfoManager.swift
//  TakeUmbrella
//
//  Created by 표건욱 on 2023/05/22.
//


import Foundation
import RxSwift
import RxCocoa
import RxOptional


class UserInfoManager: NSObject {
    
    enum UserDefaultKeys: String {
        case push     = "PUSH"
        case time     = "TIME"
        case launched = "LAUNCHED"
    }
    
    enum NotificationKeys {
        case pending
        case delivered
    }
    
    static let shared = UserInfoManager()
    
    private var nowData: NowWeatherModel?
    private var daysData: [DayWeatherModel] = []
    
    func setNow(_ data: NowWeatherModel) {
        nowData = data
    }
    
    func getNow() -> NowWeatherModel? {
        return nowData
    }
    
    func setDays(_ list: [DayWeatherModel]) {
        daysData = list
    }
    
    func getDays() -> [DayWeatherModel] {
        return daysData
    }
    
    func setUserDefault(_ value: Any?, key: UserDefaultKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getUserDefault<T>(key: UserDefaultKeys, type: T.Type) -> T {
        switch key {
        case .push, .launched:
            return UserDefaults.standard.bool(forKey: key.rawValue) as! T
        case .time:
            return UserDefaults.standard.integer(forKey: key.rawValue) as! T
        }
    }
    
    func addNotification(identifier: String, title: String, subtitle: String = "", badge: NSNumber = 1, timeInterval: TimeInterval, repeats: Bool = false) {
        let push =  UNMutableNotificationContent()
        
        push.title = title
        push.subtitle = subtitle
        push.badge = badge
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func removeAllNotification(_ key: NotificationKeys) {
        switch key {
        case .pending   : UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        case .delivered : UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
}
